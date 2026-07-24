import { GameClient } from '../socket/GameServer';

export type RPCHandler = (client: GameClient, args: any[]) => any;

export class ServiceRegistry {
  private handlers: Map<string, Map<string, RPCHandler>> = new Map();

  register(service: string, method: string, handler: RPCHandler): void {
    if (!this.handlers.has(service)) {
      this.handlers.set(service, new Map());
    }
    this.handlers.get(service)!.set(method, handler);
  }

  dispatch(service: string, method: string, client: GameClient, args: any[]): any {
    const serviceHandlers = this.handlers.get(service);
    if (!serviceHandlers) {
      console.warn(`[ServiceRegistry] Unknown service: ${service}`);
      return null;
    }

    const handler = serviceHandlers.get(method);
    if (!handler) {
      console.warn(`[ServiceRegistry] Unknown method: ${service}.${method}`);
      return null;
    }

    return handler(client, args);
  }
}
