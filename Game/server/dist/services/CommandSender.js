"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CommandSender = void 0;
// Server -> Client command sender
// These are COMMAND messages (type=4) that the server pushes to the client
// They are dispatched via ComponentLocator.call(service, method, params)
class CommandSender {
    constructor(client, server) {
        this.client = client;
        this.server = server;
    }
    // === Field Commands (field service - FieldManager registers as ComponentLocator.FIELD = "field") ===
    createUnit(unit) {
        // FieldUnit extends BaseUnit - sealed properties must be in exact order:
        // BaseUnit: id, name, dead, avatarImagePath, effects, stats
        // FieldUnit: x, y, objectId, visualId, hue, lightness, hsls, wardrobes, acceptsNegative, acceptsPositive, types, character, tradable, clan, questStatus, objective, difficulty, species, sightRange, castingTime
        this.server.sendCommand(this.client, 'field', 'createUnit', {
            __className: 'FieldUnit',
            __sealed: true,
            id: unit.id,
            name: unit.name,
            dead: unit.dead,
            avatarImagePath: unit.avatarImagePath,
            effects: unit.effects,
            stats: unit.stats,
            x: unit.x,
            y: unit.y,
            objectId: unit.objectId || null,
            visualId: unit.visualId || 'contour',
            hue: unit.hue || 0,
            lightness: unit.lightness || 0,
            hsls: unit.hsls || null,
            wardrobes: unit.wardrobes || null,
            acceptsNegative: unit.acceptsNegative ?? true,
            acceptsPositive: unit.acceptsPositive ?? true,
            types: unit.types || [],
            character: unit.character ?? false,
            tradable: unit.tradable ?? false,
            clan: unit.clan || '',
            questStatus: unit.questStatus || '',
            objective: unit.objective ?? false,
            difficulty: unit.difficulty || '',
            species: unit.species || '',
            sightRange: unit.sightRange || 0,
            castingTime: unit.castingTime || 0,
        });
    }
    removeUnit(id) {
        this.server.sendCommand(this.client, 'field', 'removeUnit', id);
    }
    updateUnit(unit) {
        this.server.sendCommand(this.client, 'field', 'updateUnit', {
            __className: 'FieldUnit',
            __sealed: true,
            id: unit.id,
            name: unit.name,
            dead: unit.dead,
            avatarImagePath: unit.avatarImagePath,
            effects: unit.effects,
            stats: unit.stats,
            x: unit.x,
            y: unit.y,
            objectId: unit.objectId || null,
            visualId: unit.visualId || 'contour',
            hue: unit.hue || 0,
            lightness: unit.lightness || 0,
            hsls: unit.hsls || null,
            wardrobes: unit.wardrobes || null,
            acceptsNegative: unit.acceptsNegative ?? true,
            acceptsPositive: unit.acceptsPositive ?? true,
            types: unit.types || [],
            character: unit.character ?? false,
            tradable: unit.tradable ?? false,
            clan: unit.clan || '',
            questStatus: unit.questStatus || '',
            objective: unit.objective ?? false,
            difficulty: unit.difficulty || '',
            species: unit.species || '',
            sightRange: unit.sightRange || 0,
            castingTime: unit.castingTime || 0,
        });
    }
    moveTo(id, x, y, duration, movementMode = '') {
        this.server.sendCommand(this.client, 'field', 'moveTo', id, x, y, duration, movementMode);
    }
    stand(id) {
        this.server.sendCommand(this.client, 'field', 'stand', id);
    }
    turnTo(id, x, y) {
        this.server.sendCommand(this.client, 'field', 'turnTo', id, x, y);
    }
    stopAt(id, x, y) {
        this.server.sendCommand(this.client, 'field', 'stopAt', id, x, y);
    }
    startCast(id, castType, x, y, duration = 0) {
        this.server.sendCommand(this.client, 'field', 'startCast', id, castType, x, y, duration);
    }
    instantCast(id, castType, x, y) {
        this.server.sendCommand(this.client, 'field', 'instantCast', id, castType, x, y);
    }
    stopCast(id) {
        this.server.sendCommand(this.client, 'field', 'stopCast', id);
    }
    shootAt(srcId, x, y, visualId, duration) {
        this.server.sendCommand(this.client, 'field', 'shootAt', srcId, x, y, visualId, duration);
    }
    playEffect(id, effectId, effectLocation) {
        this.server.sendCommand(this.client, 'field', 'playEffect', id, effectId, effectLocation);
    }
    changeStats(id, sourceId, statType, sourceType, amount, critical = false, absorb = 0) {
        this.server.sendCommand(this.client, 'field', 'changeStats', id, sourceId, statType, sourceType, amount, critical, absorb);
    }
    setStats(id, statType, amount) {
        this.server.sendCommand(this.client, 'field', 'setStats', id, statType, amount);
    }
    missed(id, sourceId) {
        this.server.sendCommand(this.client, 'field', 'missed', id, sourceId);
    }
    immune(id, sourceId, element = '') {
        this.server.sendCommand(this.client, 'field', 'immune', id, sourceId, element);
    }
    die(id) {
        this.server.sendCommand(this.client, 'field', 'die', id);
    }
    resurrect(id) {
        this.server.sendCommand(this.client, 'field', 'resurrect', id);
    }
    setEffects(id, effects) {
        this.server.sendCommand(this.client, 'field', 'setEffects', id, effects);
    }
    createObject(cfg, tooltipId = '') {
        this.server.sendCommand(this.client, 'field', 'createObject', cfg, tooltipId);
    }
    removeObject(id) {
        this.server.sendCommand(this.client, 'field', 'removeObject', id);
    }
    setPhase(id, phase) {
        this.server.sendCommand(this.client, 'field', 'setPhase', id, phase);
    }
    setActive(id, value) {
        this.server.sendCommand(this.client, 'field', 'setActive', id, value);
    }
    setObjective(id, value) {
        this.server.sendCommand(this.client, 'field', 'setObjective', id, value);
    }
    setQuestStatus(id, status) {
        this.server.sendCommand(this.client, 'field', 'setQuestStatus', id, status);
    }
    speak(id, text, type) {
        this.server.sendCommand(this.client, 'field', 'speak', id, text, type);
    }
    changeQuestDetails(questDetails) {
        this.server.sendCommand(this.client, 'field', 'changeQuestDetails', questDetails);
    }
    // === Character Commands (character service) ===
    initBeltActions(belt) {
        this.server.sendCommand(this.client, 'character', 'initBeltActions', belt);
    }
    initQuiver(quiver) {
        this.server.sendCommand(this.client, 'character', 'initQuiver', quiver);
    }
    initAbilityActions(slots) {
        this.server.sendCommand(this.client, 'character', 'initAbilityActions', slots);
    }
    selectRun(value) {
        this.server.sendCommand(this.client, 'character', 'selectRun', value);
    }
    selectAttack(value) {
        this.server.sendCommand(this.client, 'character', 'selectAttack', value);
    }
    selectFightMode(value) {
        this.server.sendCommand(this.client, 'character', 'selectFightMode', value);
    }
    selectAlternative(index) {
        this.server.sendCommand(this.client, 'character', 'selectAlternative', index);
    }
    selectAmmoIndex(index) {
        this.server.sendCommand(this.client, 'character', 'selectAmmoIndex', index);
    }
    // === Combat Commands (combat service) ===
    combatInit(records, enabled) {
        this.server.sendCommand(this.client, 'combat', 'init', records, enabled);
    }
    combatSetEnabled(value) {
        this.server.sendCommand(this.client, 'combat', 'setEnabled', value);
    }
    combatDamage(record) {
        this.server.sendCommand(this.client, 'combat', 'damage', record);
    }
    combatHeal(record) {
        this.server.sendCommand(this.client, 'combat', 'heal', record);
    }
    combatKill(record) {
        this.server.sendCommand(this.client, 'combat', 'kill', record);
    }
    combatMiss(record) {
        this.server.sendCommand(this.client, 'combat', 'miss', record);
    }
    combatExperience(record) {
        this.server.sendCommand(this.client, 'combat', 'experience', record);
    }
    // === Game Commands (game service) ===
    showInteraction(interactionType, modal = false) {
        this.server.sendCommand(this.client, 'game', 'showInteraction', interactionType, modal);
    }
    closeInteraction() {
        this.server.sendCommand(this.client, 'game', 'closeInteraction');
    }
    showMessage(msg) {
        this.server.sendCommand(this.client, 'game', 'showMessage', msg);
    }
    closeMessage(messageId) {
        this.server.sendCommand(this.client, 'game', 'closeMessage', messageId);
    }
    changeMode(mode) {
        this.server.sendCommand(this.client, 'game', 'changeMode', mode);
    }
    updateAbilityBook(abilities) {
        this.server.sendCommand(this.client, 'game', 'updateAbilityBook', abilities);
    }
    updateAbilityCache(cache) {
        this.server.sendCommand(this.client, 'game', 'updateAbilityCache', cache);
    }
}
exports.CommandSender = CommandSender;
//# sourceMappingURL=CommandSender.js.map