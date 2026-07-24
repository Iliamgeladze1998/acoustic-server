# Shards of the Dreams - Server Protocol Documentation

## Overview
This document describes the client-server protocol extracted from the decompiled SWF client (`soul_client.swf`, version 0.90.3).

## Login Flow (HTTP)

The login server uses HTTP POST requests to `http://<loginServer>/offline`:

### 1. Login
```
POST /offline
act=login&user=<email>&password=<password>
```
Response: session string (or `fail<errorCode>`)

### 2. Get Servers
```
POST /offline
act=getServers&session=<session>
```
Response: XML with ServerInfo elements:
```xml
<ServerInfo id="..." name="..." host="..." online="true" characters="..." version="..."/>
```

### 3. Get Characters
```
POST /offline
act=getServerCharacters&session=<session>&serverId=<serverId>
```
Response: XML with CharacterInfo elements:
```xml
<CharacterInfo id="..." name="..." serverId="..." disposition="..." sex="..." level="..." side="..." location="..." avatar="..."/>
```

### 4. Get Token
```
POST /offline
act=getToken&session=<session>&serverId=<serverId>&characterId=<characterId>
```
Response: token string

## Game Server Connection (TCP Socket)

### Connection
- Host: from ServerInfo.host
- Ports tried: [1234, 5190, 110, 443, 147, 25, 80]
- Protocol: TCP socket with binary messages

### Message Format
Each message is prefixed with a 4-byte unsigned int length, then:
```
[1 byte: messageType] [4 bytes: messageId] [payload...]
```

### Message Types
| Type | Value | Direction | Description |
|------|-------|-----------|-------------|
| PING | 0 | C->S | Ping |
| PONG | 1 | S->C | Pong response |
| AUTH_REQUEST | 2 | C->S | Authentication |
| AUTH_RESPONSE | 3 | S->C | Auth result |
| COMMAND | 4 | S->C | Server command to client |
| RPC_REQUEST | 5 | C->S | RPC call |
| RPC_RESPONSE | 6 | S->C | RPC result |

### Auth Request Payload
```
[UTF string: token]
```

### Auth Response Payload
```
[1 byte: authResponseType]  // 0=SUCCESS, 1=FAIL, 2=ERROR
```

### RPC Request Payload
```
[UTF string: service] [UTF string: method] [AMF object: args[]]
```

### RPC Response Payload
```
[1 byte: rpcResponseType]  // 0=SUCCESS, 1=EXCEPTION, 2=BAD_REQUEST
[AMF object: result]       // optional
```

### Command (S->C) Payload
```
[UTF string: service] [UTF string: method] [AMF object: params[]]
```
The client dispatches this via `ComponentLocator.call(service, method, params)`.

## RPC Services

### gameService
- `componentReady` - Notify server that client is ready

### rtmService (Real-Time Map)
- `rtmReady` - Client ready for RTM
- `getCommonSprites` -> returns common sprite layouts
- `getMapData` -> returns MapData
- `getSectorData` -> returns sector data
- `getEdges` -> returns map edges
- `changeEdge` - Change map edge
- `fieldReady` - Field loaded
- `moveTo` - Move to coordinates
- `runTo` - Run to coordinates
- `stand` - Stop moving
- `selectTarget` - Select target unit
- `selectNextEnemy` - Select next enemy
- `selectRun` - Toggle run mode
- `selectAttack` - Toggle attack mode
- `setAlternativeIndex` - Switch alt mode
- `interact` - Interact with target
- `useObject` - Use map object
- `useAbilityOnUnit` - Cast ability on unit
- `useAbilityOnField` - Cast ability on ground
- `useAbilityHere` - Cast ability on self
- `useItemOnUnit` - Use item on unit
- `useItemOnField` - Use item on ground
- `useItem` - Use item on self

### characterService
- `addQuickSlotAbility` - Add ability to quick slot
- `addQuickSlotRune` - Add rune to quick slot
- `addQuickSlotAmmo` - Add ammo to quick slot
- `selectAmmoIndex` - Select ammo
- `buySubscription` - Buy subscription
- `setSubscriptionHidden` - Hide subscription
- `exchange` - Exchange currency
- `resurrect` - Resurrect character
- `getAbility` - Get ability data
- `getPaymentToken` - Get payment token

### inventoryService
- `encrust` - Encrust item with gem
- `getSockets` - Get item sockets
- `sum` - Stack items

### auctionService
- `getBrowseData` - Browse auctions
- `getLotData` - Get lot details
- `getBidData` - Get bid data
- `makeLot` - Create auction
- `makeBid` - Place bid
- `cancelLot` - Cancel auction
- `cancelBid` - Cancel bid

### clanService
- `getClanInfo` - Get clan info
- `getIcon` - Get clan icon

### craftService
- `craft` - Craft item
- `stopCraft` - Stop crafting

### dialogService
- `getDialog` - Get NPC dialog
- `answerOnDialog` - Answer dialog

### groupService
- `inviteMember` - Invite to group
- `removeMember` - Remove from group
- `promote` - Promote member
- `changeLootMining` - Change loot settings
- `getUnitCoordinates` - Get member coordinates

### questService
- `trackQuest` - Track quest
- `markHintRead` - Mark hint as read
- `reset` - Reset quests

### shopService
- `getShopData` - Get shop items
- `buyItem` - Buy item
- `sellItem` - Sell item

### mailService
- `sendMail` - Send mail
- `deleteMail` - Delete mail
- `markRead` - Mark as read
- `takeAttachment` - Take attachment

### lootService
- `takeLoot` - Take specific loot
- `takeAllLoot` - Take all loot
- `giveLoot` - Give loot to someone

### talentService
- `getPersonalityTalents` - Get talents
- `setTalents` - Set talent points
- `reset` - Reset talents

### battlegroundService
- `join` - Join battleground
- `leave` - Leave battleground
- `duel` - Start duel

### academyService
- `getAcademy` - Get academy info
- `changePresets` - Change presets

### templeService
- `getHealData` - Get heal info
- `castEffect` - Cast temple effect

### workshopService
- `getItems` - Get workshop items
- `repairItem` - Repair item

### itemInfoService
- `getItemInfo` - Get item details
- `getTemplateInfo` - Get template info

### charInfoService
- `getCharInfo` - Get character public info

### testPvPStatisticService
- `getStatistics` - Get PvP statistics

## Server -> Client Commands (via ComponentLocator)

The server pushes commands to the client using MessageType.COMMAND. These are dispatched to registered managers:

### RTM Manager (rtm)
- `createUnit(FieldUnit)` - Create unit on map
- `removeUnit(id)` - Remove unit
- `updateUnit(FieldUnit)` - Update unit
- `moveTo(id, x, y, duration, movementMode)` - Move unit
- `stand(id)` - Unit stops
- `turnTo(id, x, y)` - Unit turns
- `stopAt(id, x, y)` - Unit stops at
- `startCast(id, castType, x, y, duration)` - Start casting
- `instantCast(id, castType, x, y)` - Instant cast
- `stopCast(id)` - Stop casting
- `shootAt(srcId, x, y, visualId, duration)` - Projectile
- `playEffect(id, effectId, effectLocation)` - Play effect
- `changeStats(id, sourceId, statType, sourceType, amount, critical, absorb)` - Damage/heal
- `setStats(id, statType, amount)` - Set stat
- `missed(id, sourceId)` - Attack missed
- `immune(id, sourceId, element)` - Immune
- `die(id)` - Unit died
- `resurrect(id)` - Unit resurrected
- `setEffects(id, effects)` - Set effects
- `createObject(cfg, tooltipId)` - Create map object
- `removeObject(id)` - Remove map object
- `setPhase(id, phase)` - Set object phase
- `setActive(id, value)` - Set active state
- `setObjective(id, value)` - Set objective
- `setQuestStatus(id, status)` - Set quest giver status
- `speak(id, text, type)` - Unit speaks
- `changeQuestDetails(questDetails)` - Update quest details

### Character Manager (character)
- `initBeltActions(belt)` - Init belt
- `initQuiver(quiver)` - Init quiver
- `initAbilityActions(slots)` - Init ability slots
- `selectRun(value)` - Run mode
- `selectAttack(value)` - Attack mode
- `selectFightMode(value)` - Fight mode
- `selectAlternative(index)` - Alt mode
- `selectAmmoIndex(index)` - Ammo selection

### Combat Manager (combat)
- `init(records, enabled)` - Init combat log
- `setEnabled(value)` - Toggle combat log
- `miss(record)` - Miss event
- `immune(record)` - Immune event
- `status(record)` - Status event
- `damage(record)` - Damage event
- `heal(record)` - Heal event
- `kill(record)` - Kill event
- `experience(record)` - XP event
- `abilityApply(record)` - Ability applied
- `effectApply(record)` - Effect applied

## Data Models

### CharacterPublicData
- id, name, avatarImagePath, sex
- properties, params (objects)
- side, race, dispositionGroup, disposition
- reputations (array)
- mode, subscriptionType, subscriptionExpire
- autoSlots (array)

### CharacterData (extends CharacterPublicData)
- portalId, currencies, abilityCache, abilityBook
- abilitySlots, additionalPoints, alternativeIndex
- quiver, selectedAmmoIndex, belt
- runMode, attackMode, fightMode
- messages, instanceRecords, resurrection, interaction

### FieldUnit (extends BaseUnit)
- id, name, dead, avatarImagePath, effects, stats
- x, y, level, side, race, sex
- hp, mp, maxHp, maxMp
- movementSpeed, attackSpeed, castingTime
- sightRange, species, difficulty, objective
- unitProperties, target

### MapData
- sectorId, mapLayout (id, width, height, lights)
- pvpState

### Item
- templateId, itemId, name, type, subType
- class, bindingType, slots, stats

## Configuration
- staticServerURL: Base URL for images (items, maps, avatars, etc.)
- Image paths: `images/items/`, `images/maps/`, `images/avatar/`, `images/talent/`, etc.
- Game config: exitTimeout, serverTime, coppersPerRuby, subscriptions

## Ports
Client tries to connect on ports: 1234, 5190, 110, 443, 147, 25, 80
First successful connection wins.

## AMF Serialization
The client uses Flash AMF3 (Action Message Format 3) for object serialization in RPC payloads.
Server must implement AMF3 serialization compatible with Flash Player.

### AMF3 Class Registration
The client registers typed classes via `registerClassAlias()`. The server must send
typed AMF3 objects with matching class names. Key classes:

- `GameCfg` - Game configuration
- `CharacterData` - Full character state
- `CharacterPublicData` - Public character info
- `FieldUnit` - Unit on the map
- `Item` - Inventory item
- `Ability` - Skill/spell
- `MapData` - Map state
- `InvKey` - Inventory position (sack, slot)
- `CombatRecord` and subclasses (DamageRecord, HealRecord, KillRecord, etc.)
- 80+ additional classes (see RemoteClassRegister.as)

### Server→Client Commands
After RPC responses, the server pushes COMMAND messages (type=4) to the client.
These are dispatched via `ComponentLocator.call(service, method, params)` on the client.

Key command services and methods:
- **rtm**: createUnit, removeUnit, updateUnit, moveTo, stand, turnTo, stopAt,
  startCast, instantCast, stopCast, shootAt, playEffect, changeStats, setStats,
  missed, immune, die, resurrect, setEffects, createObject, removeObject,
  setPhase, setActive, setObjective, setQuestStatus, speak, changeQuestDetails
- **character**: initBeltActions, initQuiver, initAbilityActions, selectRun,
  selectAttack, selectFightMode, selectAlternative, selectAmmoIndex
- **combat**: init, setEnabled, damage, heal, kill, miss, experience
- **game**: showInteraction, closeInteraction, showMessage, closeMessage,
  changeMode, updateAbilityBook, updateAbilityCache

## Server Emulator Implementation
A working server emulator has been implemented in `/root/Game/server/` (Node.js + TypeScript).

### Structure
```
server/
├── src/
│   ├── amf/AMF3.ts          - AMF3 reader/writer
│   ├── login/LoginServer.ts - HTTP login server
│   ├── socket/GameServer.ts - TCP game server + binary protocol
│   ├── socket/Protocol.ts   - Message type constants
│   ├── services/ServiceRegistry.ts  - RPC dispatch
│   ├── services/GameServices.ts     - All RPC handlers
│   ├── services/CommandSender.ts    - Server→client commands
│   ├── models/GameModels.ts  - Game data models
│   ├── world/World.ts        - World state manager
│   └── index.ts              - Entry point
├── static/                   - Static game assets (images, sounds, fonts)
├── package.json
└── tsconfig.json
```

### Running
```bash
cd server && npm install && npm run build
LOGIN_PORT=9090 GAME_PORT=1234 npm start
```

### Test Credentials
- Email: `test@test.com`
- Password: `test`

### Verified Flow
1. HTTP login → session token
2. HTTP getServers → XML server list
3. HTTP getServerCharacters → XML character list
4. HTTP getToken → auth token
5. TCP connect + PING/PONG handshake
6. TCP AUTH_REQUEST with token → AUTH_RESPONSE SUCCESS
7. RPC configurationService.getGameCfg → GameCfg object
8. RPC gameService.componentReady → CharacterData object
9. Server pushes COMMAND messages (initBeltActions, etc.)
