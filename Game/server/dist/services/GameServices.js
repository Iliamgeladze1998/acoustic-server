"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.registerGameServices = registerGameServices;
const CommandSender_1 = require("./CommandSender");
function registerGameServices(registry, world, gameServer) {
    const clients = new Map(); // characterId -> client
    // loggerService - called early by client
    registry.register('loggerService', 'report', (client, args) => {
        console.log('[loggerService] report:', JSON.stringify(args));
        return null;
    });
    // configurationService - called right after auth
    registry.register('configurationService', 'getGameCfg', (client, args) => {
        console.log('[configurationService] getGameCfg');
        const cfg = world.getGameCfg();
        return {
            __className: 'GameCfg',
            __sealed: true,
            exitTimeout: cfg.exitTimeout,
            serverTime: cfg.serverTime,
            coppersPerRuby: cfg.coppersPerRuby,
            subscriptions: cfg.subscriptions,
        };
    });
    // gameService
    registry.register('gameService', 'componentReady', (client, args) => {
        console.log('[gameService] Client ready');
        const char = world.getCharacter(client.characterId || 'admin_char');
        if (!char)
            return null;
        // Send CharacterData via COMMAND to game.init after a delay
        // (RPC response must be sent first, then COMMAND)
        const sender = new CommandSender_1.CommandSender(client, gameServer);
        const charData = {
            __className: 'CharacterData',
            __sealed: true,
            id: char.id,
            name: char.name,
            avatarImagePath: char.avatarImagePath || '',
            sex: char.sex || 'male',
            properties: {},
            params: {},
            side: char.side || 'light',
            race: char.race || 'human',
            dispositionGroup: char.dispositionGroup || 'knight',
            disposition: char.disposition || 'knight',
            reputations: [],
            mode: 'RTM',
            subscriptionType: '',
            subscriptionExpire: null,
            subscriptionRenew: false,
            subscriptionHidden: false,
            autoSlots: [],
            portalId: 0,
            currencies: { coppers: 100, rubies: 0 },
            abilityCache: [],
            abilityBook: [],
            abilitySlots: [],
            additionalPoints: {},
            alternativeIndex: 0,
            quiver: [],
            selectedAmmoIndex: 0,
            belt: [],
            runMode: false,
            attackMode: false,
            fightMode: false,
            messages: [],
            instanceRecords: [],
            resurrection: null,
            interaction: null,
        };
        // Delay to ensure RPC response is sent first
        setTimeout(() => {
            // Send game.init as a COMMAND with [charData] as params (must be an Array)
            // Client reads: params = ba.readObject(); ComponentLocator.call(service, method, params);
            // ComponentLocator.call does: func.apply(module, params) where params must be Array
            gameServer.sendCommand(client, 'game', 'init', charData);
            console.log('[gameService] Sent game.init COMMAND with CharacterData');
            sender.initBeltActions([]);
            sender.initQuiver([]);
            sender.initAbilityActions([]);
            console.log('[gameService] Sent initial character state via commands');
        }, 500);
        return null;
    });
    // rtmService - Real-Time Map
    registry.register('rtmService', 'rtmReady', (client, args) => {
        console.log('[rtmService] RTM ready');
        // After RTM ready, push initial map state via commands
        const sender = new CommandSender_1.CommandSender(client, gameServer);
        const char = world.getCharacter(client.characterId || 'admin_char');
        if (char) {
            // Create the player's unit on the map
            const unit = world.getUnit('unit_1');
            if (unit) {
                setTimeout(() => {
                    sender.createUnit(unit);
                    console.log('[rtmService] Sent createUnit for player');
                }, 50);
            }
        }
        return null;
    });
    registry.register('rtmService', 'getCommonSprites', (client, args) => {
        console.log('[rtmService] getCommonSprites');
        return {}; // empty Object - for each iterates nothing
    });
    registry.register('rtmService', 'getMapData', (client, args) => {
        console.log('[rtmService] getMapData');
        return {
            __className: 'MapData',
            __sealed: true,
            sectorId: 'start_town',
            mapId: 'start_town',
            mapLayout: {
                __className: 'MapLayoutCfg',
                __sealed: true,
                id: 'start_town',
                deepBackground: null,
                deepBgScrollSpeed: 0,
                background: {
                    __className: 'MapBackgroundCfg',
                    __sealed: true,
                    id: 'start_town',
                    library: 'common.swf',
                },
                borderPoints: [],
                fillZones: [],
                width: 2000,
                height: 1500,
                layer: {
                    __className: 'MapLayerCfg',
                    __sealed: true,
                    id: 'start_town',
                    objects: [],
                    triggerZones: [],
                    tracks: [],
                },
                lights: null,
            },
            effect: '',
            sprites: {},
            visuals: [],
            pvpState: 'PVE',
        };
    });
    registry.register('rtmService', 'getSectorData', (client, args) => {
        console.log('[rtmService] getSectorData');
        return { sectorId: 'start', maps: ['start_town'] };
    });
    registry.register('rtmService', 'getEdges', (client, args) => {
        console.log('[rtmService] getEdges');
        return [];
    });
    registry.register('rtmService', 'fieldReady', (client, args) => {
        console.log('[rtmService] fieldReady');
        return null;
    });
    registry.register('rtmService', 'moveTo', (client, args) => {
        const [x, y] = args;
        console.log(`[rtmService] moveTo(${x}, ${y})`);
        return null;
    });
    registry.register('rtmService', 'runTo', (client, args) => {
        const [x, y] = args;
        console.log(`[rtmService] runTo(${x}, ${y})`);
        return null;
    });
    registry.register('rtmService', 'stand', (client, args) => {
        console.log('[rtmService] stand');
        return null;
    });
    registry.register('rtmService', 'selectTarget', (client, args) => {
        const [targetId] = args;
        console.log(`[rtmService] selectTarget(${targetId})`);
        return null;
    });
    registry.register('rtmService', 'selectNextEnemy', (client, args) => {
        console.log('[rtmService] selectNextEnemy');
        return null;
    });
    registry.register('rtmService', 'selectRun', (client, args) => {
        const [flag] = args;
        console.log(`[rtmService] selectRun(${flag})`);
        return null;
    });
    registry.register('rtmService', 'selectAttack', (client, args) => {
        const [flag] = args;
        console.log(`[rtmService] selectAttack(${flag})`);
        return null;
    });
    registry.register('rtmService', 'setAlternativeIndex', (client, args) => {
        const [index] = args;
        console.log(`[rtmService] setAlternativeIndex(${index})`);
        return null;
    });
    registry.register('rtmService', 'interact', (client, args) => {
        console.log('[rtmService] interact');
        return null;
    });
    registry.register('rtmService', 'useObject', (client, args) => {
        const [objectId] = args;
        console.log(`[rtmService] useObject(${objectId})`);
        return null;
    });
    registry.register('rtmService', 'useAbilityOnUnit', (client, args) => {
        const [targetId, abilityId] = args;
        console.log(`[rtmService] useAbilityOnUnit(${targetId}, ${abilityId})`);
        return null;
    });
    registry.register('rtmService', 'useAbilityOnField', (client, args) => {
        const [x, y, abilityId] = args;
        console.log(`[rtmService] useAbilityOnField(${x}, ${y}, ${abilityId})`);
        return null;
    });
    registry.register('rtmService', 'useAbilityHere', (client, args) => {
        const [abilityId] = args;
        console.log(`[rtmService] useAbilityHere(${abilityId})`);
        return null;
    });
    registry.register('rtmService', 'useItemOnUnit', (client, args) => {
        const [targetId, templateId] = args;
        console.log(`[rtmService] useItemOnUnit(${targetId}, ${templateId})`);
        return null;
    });
    registry.register('rtmService', 'useItemOnField', (client, args) => {
        console.log('[rtmService] useItemOnField');
        return null;
    });
    registry.register('rtmService', 'useItem', (client, args) => {
        const [templateId] = args;
        console.log(`[rtmService] useItem(${templateId})`);
        return null;
    });
    registry.register('rtmService', 'changeEdge', (client, args) => {
        const [edgeId] = args;
        console.log(`[rtmService] changeEdge(${edgeId})`);
        return null;
    });
    // characterService
    registry.register('characterService', 'componentReady', (client, args) => {
        console.log('[characterService] componentReady');
        return null;
    });
    registry.register('characterService', 'addQuickSlotAbility', (client, args) => {
        const [abilityId, index] = args;
        console.log(`[characterService] addQuickSlotAbility(${abilityId}, ${index})`);
        return null;
    });
    registry.register('characterService', 'addQuickSlotRune', (client, args) => {
        const [runeId, index] = args;
        console.log(`[characterService] addQuickSlotRune(${runeId}, ${index})`);
        return null;
    });
    registry.register('characterService', 'addQuickSlotAmmo', (client, args) => {
        const [ammoId, index] = args;
        console.log(`[characterService] addQuickSlotAmmo(${ammoId}, ${index})`);
        return null;
    });
    registry.register('characterService', 'selectAmmoIndex', (client, args) => {
        const [index] = args;
        console.log(`[characterService] selectAmmoIndex(${index})`);
        return null;
    });
    registry.register('characterService', 'buySubscription', (client, args) => {
        console.log('[characterService] buySubscription');
        return null;
    });
    registry.register('characterService', 'setSubscriptionHidden', (client, args) => {
        const [hidden] = args;
        console.log(`[characterService] setSubscriptionHidden(${hidden})`);
        return null;
    });
    registry.register('characterService', 'exchange', (client, args) => {
        console.log('[characterService] exchange');
        return null;
    });
    registry.register('characterService', 'resurrect', (client, args) => {
        console.log('[characterService] resurrect');
        return null;
    });
    registry.register('characterService', 'getAbility', (client, args) => {
        const [abilityId] = args;
        console.log(`[characterService] getAbility(${abilityId})`);
        return null;
    });
    registry.register('characterService', 'getPaymentToken', (client, args) => {
        console.log('[characterService] getPaymentToken');
        return { token: 'payment_test' };
    });
    // combatService
    registry.register('combatService', 'componentReady', (client, args) => {
        console.log('[combatService] componentReady');
        return null;
    });
    registry.register('combatService', 'setEnabled', (client, args) => {
        const [enabled] = args;
        console.log(`[combatService] setEnabled(${enabled})`);
        return null;
    });
    // inventoryService
    registry.register('inventoryService', 'componentReady', (client, args) => {
        console.log('[inventoryService] componentReady');
        return null;
    });
    registry.register('inventoryService', 'encrust', (client, args) => {
        console.log('[inventoryService] encrust');
        return null;
    });
    registry.register('inventoryService', 'getSockets', (client, args) => {
        const [itemId] = args;
        console.log(`[inventoryService] getSockets(${itemId})`);
        return { sockets: [] };
    });
    registry.register('inventoryService', 'sum', (client, args) => {
        console.log('[inventoryService] sum');
        return null;
    });
    // chatService
    registry.register('chatService', 'componentReady', (client, args) => {
        console.log('[chatService] componentReady');
        return null;
    });
    // Generic componentReady for all services
    const services = [
        'achievementService', 'arenaService', 'auctionService', 'bankService',
        'barterService', 'clanService', 'cooldownService', 'craftService',
        'dashboardService', 'dialogService', 'groupService', 'itemInfoService',
        'lootService', 'mailService', 'questService', 'shopService',
        'socialService', 'talentService', 'templeService', 'workshopService',
        'charInfoService', 'battlegroundService', 'academyService',
        'testPvPStatisticService', 'fieldService', 'lfgService',
    ];
    for (const svc of services) {
        registry.register(svc, 'componentReady', (client, args) => {
            console.log(`[${svc}] componentReady`);
            return null;
        });
    }
    // arenaService.getArenas
    registry.register('arenaService', 'getArenas', (client, args) => {
        console.log('[arenaService] getArenas');
        return [];
    });
}
//# sourceMappingURL=GameServices.js.map