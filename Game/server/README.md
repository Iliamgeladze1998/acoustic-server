# Shards of the Dreams - Server Emulator

A server emulator for the Flash-based MMORPG "Shards of the Dreams" by Ambergames.

## Architecture

### Login Server (HTTP)
- Port: 9090 (configurable via `LOGIN_PORT` env var)
- Endpoint: `POST /offline`
- Actions: `login`, `getServers`, `getServerCharacters`, `getToken`

### Game Server (TCP)
- Port: 1234 (configurable via `GAME_PORT` env var)
- Binary protocol with 4-byte length prefix
- Message types: PING/PONG, AUTH, RPC, COMMAND
- AMF3 serialization for object payloads

## Test Credentials
- Email: `test@test.com`
- Password: `test`

## Running

```bash
npm install
npm run build
LOGIN_PORT=9090 GAME_PORT=1234 npm start
```

## Protocol Summary

### Login Flow (HTTP POST to /offline)
1. `act=login&user=<email>&password=<password>` → session string
2. `act=getServers&session=<session>` → XML with server list
3. `act=getServerCharacters&session=<session>&serverId=<id>` → XML with characters
4. `act=getToken&session=<session>&serverId=<id>&characterId=<id>` → auth token

### Game Connection (TCP)
1. Connect to game server host on port 1234
2. Send PING → receive PONG (handshake)
3. Send AUTH_REQUEST with token → receive AUTH_RESPONSE
4. Send RPC_REQUEST (service, method, args) → receive RPC_RESPONSE
5. Server pushes COMMAND messages (service, method, params)

### RPC Services Implemented
- `gameService` - Game initialization
- `rtmService` - Real-time map (movement, combat, abilities)
- `characterService` - Character management
- `combatService` - Combat log
- `inventoryService` - Inventory operations
- `chatService` - Chat
- 20+ additional service stubs

## Project Structure
```
server/
├── src/
│   ├── amf/          - AMF3 serialization
│   ├── login/        - HTTP login server
│   ├── socket/       - TCP game server + protocol
│   ├── services/     - RPC service handlers
│   ├── models/       - Game data models
│   ├── world/        - World state manager
│   └── index.ts      - Entry point
├── package.json
└── tsconfig.json
```
