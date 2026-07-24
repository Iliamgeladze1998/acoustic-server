// Binary protocol constants extracted from decompiled client

export enum MessageType {
  PING = 0,
  PONG = 1,
  AUTH_REQUEST = 2,
  AUTH_RESPONSE = 3,
  COMMAND = 4,
  RPC_REQUEST = 5,
  RPC_RESPONSE = 6,
}

export enum AuthResponseType {
  SUCCESS = 0,
  FAIL = 1,
  ERROR = 2,
}

export enum RPCResponseType {
  SUCCESS = 0,
  EXCEPTION = 1,
  BAD_REQUEST = 2,
}

// Default ports the client tries to connect on
export const CLIENT_PORTS = [1234, 5190, 110, 443, 147, 25, 80];

// Message TTL in ms (from client: 30000)
export const MESSAGE_TTL = 30000;

// Max message ID before wrap (from client)
export const MAX_MESSAGE_ID = 0xFFFFFFFF;
