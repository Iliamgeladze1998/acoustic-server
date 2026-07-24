"use strict";
// Binary protocol constants extracted from decompiled client
Object.defineProperty(exports, "__esModule", { value: true });
exports.MAX_MESSAGE_ID = exports.MESSAGE_TTL = exports.CLIENT_PORTS = exports.RPCResponseType = exports.AuthResponseType = exports.MessageType = void 0;
var MessageType;
(function (MessageType) {
    MessageType[MessageType["PING"] = 0] = "PING";
    MessageType[MessageType["PONG"] = 1] = "PONG";
    MessageType[MessageType["AUTH_REQUEST"] = 2] = "AUTH_REQUEST";
    MessageType[MessageType["AUTH_RESPONSE"] = 3] = "AUTH_RESPONSE";
    MessageType[MessageType["COMMAND"] = 4] = "COMMAND";
    MessageType[MessageType["RPC_REQUEST"] = 5] = "RPC_REQUEST";
    MessageType[MessageType["RPC_RESPONSE"] = 6] = "RPC_RESPONSE";
})(MessageType || (exports.MessageType = MessageType = {}));
var AuthResponseType;
(function (AuthResponseType) {
    AuthResponseType[AuthResponseType["SUCCESS"] = 0] = "SUCCESS";
    AuthResponseType[AuthResponseType["FAIL"] = 1] = "FAIL";
    AuthResponseType[AuthResponseType["ERROR"] = 2] = "ERROR";
})(AuthResponseType || (exports.AuthResponseType = AuthResponseType = {}));
var RPCResponseType;
(function (RPCResponseType) {
    RPCResponseType[RPCResponseType["SUCCESS"] = 0] = "SUCCESS";
    RPCResponseType[RPCResponseType["EXCEPTION"] = 1] = "EXCEPTION";
    RPCResponseType[RPCResponseType["BAD_REQUEST"] = 2] = "BAD_REQUEST";
})(RPCResponseType || (exports.RPCResponseType = RPCResponseType = {}));
// Default ports the client tries to connect on
exports.CLIENT_PORTS = [1234, 5190, 110, 443, 147, 25, 80];
// Message TTL in ms (from client: 30000)
exports.MESSAGE_TTL = 30000;
// Max message ID before wrap (from client)
exports.MAX_MESSAGE_ID = 0xFFFFFFFF;
//# sourceMappingURL=Protocol.js.map