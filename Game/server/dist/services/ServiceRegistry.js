"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.ServiceRegistry = void 0;
class ServiceRegistry {
    constructor() {
        this.handlers = new Map();
    }
    register(service, method, handler) {
        if (!this.handlers.has(service)) {
            this.handlers.set(service, new Map());
        }
        this.handlers.get(service).set(method, handler);
    }
    dispatch(service, method, client, args) {
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
exports.ServiceRegistry = ServiceRegistry;
//# sourceMappingURL=ServiceRegistry.js.map