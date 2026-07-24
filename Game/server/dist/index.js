"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const LoginServer_1 = require("./login/LoginServer");
const GameServer_1 = require("./socket/GameServer");
const ServiceRegistry_1 = require("./services/ServiceRegistry");
const World_1 = require("./world/World");
const GameServices_1 = require("./services/GameServices");
const LOGIN_PORT = parseInt(process.env.LOGIN_PORT || '9090');
const GAME_PORT = parseInt(process.env.GAME_PORT || '1234');
console.log('=== Shards of the Dreams Server Emulator ===');
console.log(`Login server port: ${LOGIN_PORT}`);
console.log(`Game server port: ${GAME_PORT}`);
console.log('');
// Initialize world
const world = new World_1.World();
// Initialize game server (TCP)
const gameServer = new GameServer_1.GameServer(GAME_PORT);
// Initialize service registry
const registry = new ServiceRegistry_1.ServiceRegistry();
(0, GameServices_1.registerGameServices)(registry, world, gameServer);
gameServer.setServiceRegistry(registry);
// Initialize login server (HTTP)
const loginServer = new LoginServer_1.LoginServer(LOGIN_PORT, gameServer, world);
async function start() {
    await loginServer.init();
    // Start servers
    loginServer.start();
    gameServer.start();
    console.log('');
    console.log('Server started. Waiting for connections...');
    console.log('Test credentials: test@test.com / test');
    console.log('Admin credentials: ADMIN / Setembrini1');
}
start().catch(err => {
    console.error('Failed to start server:', err);
    process.exit(1);
});
//# sourceMappingURL=index.js.map