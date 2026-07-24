import { LoginServer } from './login/LoginServer';
import { GameServer } from './socket/GameServer';
import { ServiceRegistry } from './services/ServiceRegistry';
import { World } from './world/World';
import { registerGameServices } from './services/GameServices';

const LOGIN_PORT = parseInt(process.env.LOGIN_PORT || '9090');
const GAME_PORT = parseInt(process.env.GAME_PORT || '1234');

console.log('=== Shards of the Dreams Server Emulator ===');
console.log(`Login server port: ${LOGIN_PORT}`);
console.log(`Game server port: ${GAME_PORT}`);
console.log('');

// Initialize world
const world = new World();

// Initialize game server (TCP)
const gameServer = new GameServer(GAME_PORT);

// Initialize service registry
const registry = new ServiceRegistry();
registerGameServices(registry, world, gameServer);
gameServer.setServiceRegistry(registry);

// Initialize login server (HTTP)
const loginServer = new LoginServer(LOGIN_PORT, gameServer, world);

async function start(): Promise<void> {
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
