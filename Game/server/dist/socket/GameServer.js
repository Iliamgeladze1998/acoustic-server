"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.GameServer = void 0;
const net = __importStar(require("net"));
const AMF3_1 = require("../amf/AMF3");
const Protocol_1 = require("./Protocol");
class GameServer {
    constructor(port = 1234) {
        this.clients = new Set();
        this.tokenStore = new Map(); // token -> characterId
        this.registry = null;
        this.port = port;
        this.server = net.createServer((socket) => this.onConnection(socket));
    }
    setServiceRegistry(registry) {
        this.registry = registry;
    }
    registerToken(token, characterId) {
        this.tokenStore.set(token, characterId);
    }
    start() {
        this.server.listen(this.port, () => {
            console.log(`[GameServer] Listening on port ${this.port}`);
        });
    }
    onConnection(socket) {
        socket.setNoDelay(true);
        const client = {
            socket,
            authenticated: false,
            characterId: null,
            messageId: 0,
            responders: new Map(),
        };
        this.clients.add(client);
        console.log(`[GameServer] Client connected from ${socket.remoteAddress}`);
        let buffer = Buffer.alloc(0);
        let expectedLength = 0;
        socket.on('data', (data) => {
            console.log(`[GameServer] Raw data received: ${data.length} bytes: ${data.toString('hex')}`);
            buffer = Buffer.concat([buffer, data]);
            while (buffer.length > 0) {
                if (expectedLength === 0) {
                    if (buffer.length < 4)
                        break;
                    expectedLength = buffer.readUInt32BE(0);
                    buffer = buffer.subarray(4);
                }
                if (buffer.length < expectedLength)
                    break;
                const msgData = buffer.subarray(0, expectedLength);
                buffer = buffer.subarray(expectedLength);
                expectedLength = 0;
                this.parseMessage(client, msgData);
            }
        });
        socket.on('close', () => {
            console.log(`[GameServer] Client disconnected`);
            this.clients.delete(client);
        });
        socket.on('error', (err) => {
            console.error(`[GameServer] Socket error:`, err.message);
            this.clients.delete(client);
        });
    }
    parseMessage(client, data) {
        const reader = new AMF3_1.AMF3Reader(data);
        const msgType = reader.readUnsignedByte();
        const msgId = reader.readUnsignedInt();
        switch (msgType) {
            case Protocol_1.MessageType.PING:
                this.sendPong(client, msgId);
                break;
            case Protocol_1.MessageType.AUTH_REQUEST:
                this.handleAuth(client, msgId, reader);
                break;
            case Protocol_1.MessageType.RPC_REQUEST:
                this.handleRPC(client, msgId, reader);
                break;
            default:
                console.warn(`[GameServer] Unknown message type: ${msgType}`);
        }
    }
    sendPong(client, msgId) {
        const writer = new AMF3_1.AMF3Writer();
        writer.writeUnsignedByte(Protocol_1.MessageType.PONG);
        writer.writeUnsignedInt(msgId);
        this.sendMessage(client, writer.toBuffer());
    }
    handleAuth(client, msgId, reader) {
        const token = reader.readUTF();
        console.log(`[GameServer] Auth request with token: ${token}`);
        const characterId = this.tokenStore.get(token);
        const writer = new AMF3_1.AMF3Writer();
        if (characterId) {
            client.authenticated = true;
            client.characterId = characterId;
            writer.writeUnsignedByte(Protocol_1.MessageType.AUTH_RESPONSE);
            writer.writeUnsignedInt(msgId);
            writer.writeUnsignedByte(Protocol_1.AuthResponseType.SUCCESS);
            console.log(`[GameServer] Auth SUCCESS for character: ${characterId}`);
        }
        else {
            writer.writeUnsignedByte(Protocol_1.MessageType.AUTH_RESPONSE);
            writer.writeUnsignedInt(msgId);
            writer.writeUnsignedByte(Protocol_1.AuthResponseType.FAIL);
            console.log(`[GameServer] Auth FAIL - unknown token`);
        }
        this.sendMessage(client, writer.toBuffer());
    }
    handleRPC(client, msgId, reader) {
        const service = reader.readUTF();
        const method = reader.readUTF();
        const args = reader.readObject();
        console.log(`[GameServer] RPC: ${service}.${method}(${JSON.stringify(args)})`);
        // Route to service handler
        const result = this.dispatchRPC(client, service, method, args || []);
        this.sendRPCResponse(client, msgId, result);
    }
    dispatchRPC(client, service, method, args) {
        if (this.registry) {
            return this.registry.dispatch(service, method, client, args);
        }
        console.log(`[GameServer] No registry, cannot dispatch ${service}.${method}`);
        return null;
    }
    sendRPCResponse(client, msgId, result) {
        const writer = new AMF3_1.AMF3Writer();
        writer.writeUnsignedByte(Protocol_1.MessageType.RPC_RESPONSE);
        writer.writeUnsignedInt(msgId);
        writer.writeUnsignedByte(Protocol_1.RPCResponseType.SUCCESS);
        if (result !== null && result !== undefined) {
            writer.writeObject(result);
        }
        const buf = writer.toBuffer();
        console.log(`[GameServer] RPC response (msgId=${msgId}): ${buf.toString('hex')}`);
        this.sendMessage(client, buf);
    }
    sendCommand(client, service, method, ...params) {
        const writer = new AMF3_1.AMF3Writer();
        writer.writeUnsignedByte(Protocol_1.MessageType.COMMAND);
        writer.writeUnsignedInt(client.messageId++);
        writer.writeUTF(service);
        writer.writeUTF(method);
        // Client reads: params = ba.readObject(); ComponentLocator.call(service, method, params);
        // ComponentLocator.call does: func.apply(module, params) where params must be an Array
        // params is already a rest-array, so write it directly as AMF3 array
        writer.writeObject(params);
        const buf = writer.toBuffer();
        console.log(`[GameServer] COMMAND ${service}.${method}: ${buf.toString('hex')}`);
        this.sendMessage(client, buf);
    }
    sendMessageRaw(client, data) {
        this.sendMessage(client, data);
    }
    sendMessage(client, data) {
        const header = Buffer.alloc(4);
        header.writeUInt32BE(data.length, 0);
        client.socket.write(Buffer.concat([header, data]));
    }
}
exports.GameServer = GameServer;
//# sourceMappingURL=GameServer.js.map