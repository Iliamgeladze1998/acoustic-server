import * as net from 'net';
import { AMF3Reader, AMF3Writer } from '../amf/AMF3';
import { MessageType, AuthResponseType, RPCResponseType } from './Protocol';
import { ServiceRegistry } from '../services/ServiceRegistry';

export interface GameClient {
  socket: net.Socket;
  authenticated: boolean;
  characterId: string | null;
  messageId: number;
  responders: Map<number, { resolve: Function; reject: Function }>;
}

export class GameServer {
  private server: net.Server;
  private clients: Set<GameClient> = new Set();
  private port: number;
  private tokenStore: Map<string, string> = new Map(); // token -> characterId
  private registry: ServiceRegistry | null = null;

  constructor(port: number = 1234) {
    this.port = port;
    this.server = net.createServer((socket) => this.onConnection(socket));
  }

  setServiceRegistry(registry: ServiceRegistry): void {
    this.registry = registry;
  }

  registerToken(token: string, characterId: string): void {
    this.tokenStore.set(token, characterId);
  }

  start(): void {
    this.server.listen(this.port, () => {
      console.log(`[GameServer] Listening on port ${this.port}`);
    });
  }

  private onConnection(socket: net.Socket): void {
    socket.setNoDelay(true);
    const client: GameClient = {
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

    socket.on('data', (data: Buffer) => {
      console.log(`[GameServer] Raw data received: ${data.length} bytes: ${data.toString('hex')}`);
      buffer = Buffer.concat([buffer, data]);

      while (buffer.length > 0) {
        if (expectedLength === 0) {
          if (buffer.length < 4) break;
          expectedLength = buffer.readUInt32BE(0);
          buffer = buffer.subarray(4);
        }

        if (buffer.length < expectedLength) break;

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

  private parseMessage(client: GameClient, data: Buffer): void {
    const reader = new AMF3Reader(data);
    const msgType = reader.readUnsignedByte();
    const msgId = reader.readUnsignedInt();

    switch (msgType) {
      case MessageType.PING:
        this.sendPong(client, msgId);
        break;

      case MessageType.AUTH_REQUEST:
        this.handleAuth(client, msgId, reader);
        break;

      case MessageType.RPC_REQUEST:
        this.handleRPC(client, msgId, reader);
        break;

      default:
        console.warn(`[GameServer] Unknown message type: ${msgType}`);
    }
  }

  private sendPong(client: GameClient, msgId: number): void {
    const writer = new AMF3Writer();
    writer.writeUnsignedByte(MessageType.PONG);
    writer.writeUnsignedInt(msgId);
    this.sendMessage(client, writer.toBuffer());
  }

  private handleAuth(client: GameClient, msgId: number, reader: AMF3Reader): void {
    const token = reader.readUTF();
    console.log(`[GameServer] Auth request with token: ${token}`);

    const characterId = this.tokenStore.get(token);
    const writer = new AMF3Writer();

    if (characterId) {
      client.authenticated = true;
      client.characterId = characterId;
      writer.writeUnsignedByte(MessageType.AUTH_RESPONSE);
      writer.writeUnsignedInt(msgId);
      writer.writeUnsignedByte(AuthResponseType.SUCCESS);
      console.log(`[GameServer] Auth SUCCESS for character: ${characterId}`);
    } else {
      writer.writeUnsignedByte(MessageType.AUTH_RESPONSE);
      writer.writeUnsignedInt(msgId);
      writer.writeUnsignedByte(AuthResponseType.FAIL);
      console.log(`[GameServer] Auth FAIL - unknown token`);
    }

    this.sendMessage(client, writer.toBuffer());
  }

  private handleRPC(client: GameClient, msgId: number, reader: AMF3Reader): void {
    const service = reader.readUTF();
    const method = reader.readUTF();
    const args = reader.readObject();

    console.log(`[GameServer] RPC: ${service}.${method}(${JSON.stringify(args)})`);

    // Route to service handler
    const result = this.dispatchRPC(client, service, method, args || []);
    this.sendRPCResponse(client, msgId, result);
  }

  private dispatchRPC(client: GameClient, service: string, method: string, args: any[]): any {
    if (this.registry) {
      return this.registry.dispatch(service, method, client, args);
    }
    console.log(`[GameServer] No registry, cannot dispatch ${service}.${method}`);
    return null;
  }

  private sendRPCResponse(client: GameClient, msgId: number, result: any): void {
    const writer = new AMF3Writer();
    writer.writeUnsignedByte(MessageType.RPC_RESPONSE);
    writer.writeUnsignedInt(msgId);
    writer.writeUnsignedByte(RPCResponseType.SUCCESS);
    if (result !== null && result !== undefined) {
      writer.writeObject(result);
    }
    const buf = writer.toBuffer();
    console.log(`[GameServer] RPC response (msgId=${msgId}): ${buf.toString('hex')}`);
    this.sendMessage(client, buf);
  }

  sendCommand(client: GameClient, service: string, method: string, ...params: any[]): void {
    const writer = new AMF3Writer();
    writer.writeUnsignedByte(MessageType.COMMAND);
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

  sendMessageRaw(client: GameClient, data: Buffer): void {
    this.sendMessage(client, data);
  }

  private sendMessage(client: GameClient, data: Buffer): void {
    const header = Buffer.alloc(4);
    header.writeUInt32BE(data.length, 0);
    client.socket.write(Buffer.concat([header, data]));
  }
}
