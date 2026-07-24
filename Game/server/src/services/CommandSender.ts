import { GameClient, GameServer } from '../socket/GameServer';
import { FieldUnit } from '../models/GameModels';

// Server -> Client command sender
// These are COMMAND messages (type=4) that the server pushes to the client
// They are dispatched via ComponentLocator.call(service, method, params)

export class CommandSender {
  constructor(private client: GameClient, private server: GameServer) {}

  // === Field Commands (field service - FieldManager registers as ComponentLocator.FIELD = "field") ===

  createUnit(unit: FieldUnit): void {
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

  removeUnit(id: string): void {
    this.server.sendCommand(this.client, 'field', 'removeUnit', id);
  }

  updateUnit(unit: FieldUnit): void {
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

  moveTo(id: string, x: number, y: number, duration: number, movementMode: string = ''): void {
    this.server.sendCommand(this.client, 'field', 'moveTo', id, x, y, duration, movementMode);
  }

  stand(id: string): void {
    this.server.sendCommand(this.client, 'field', 'stand', id);
  }

  turnTo(id: string, x: number, y: number): void {
    this.server.sendCommand(this.client, 'field', 'turnTo', id, x, y);
  }

  stopAt(id: string, x: number, y: number): void {
    this.server.sendCommand(this.client, 'field', 'stopAt', id, x, y);
  }

  startCast(id: string, castType: string, x: number, y: number, duration: number = 0): void {
    this.server.sendCommand(this.client, 'field', 'startCast', id, castType, x, y, duration);
  }

  instantCast(id: string, castType: string, x: number, y: number): void {
    this.server.sendCommand(this.client, 'field', 'instantCast', id, castType, x, y);
  }

  stopCast(id: string): void {
    this.server.sendCommand(this.client, 'field', 'stopCast', id);
  }

  shootAt(srcId: string, x: number, y: number, visualId: string, duration: number): void {
    this.server.sendCommand(this.client, 'field', 'shootAt', srcId, x, y, visualId, duration);
  }

  playEffect(id: string, effectId: string, effectLocation: string): void {
    this.server.sendCommand(this.client, 'field', 'playEffect', id, effectId, effectLocation);
  }

  changeStats(id: string, sourceId: string, statType: string, sourceType: string, amount: number, critical: boolean = false, absorb: number = 0): void {
    this.server.sendCommand(this.client, 'field', 'changeStats', id, sourceId, statType, sourceType, amount, critical, absorb);
  }

  setStats(id: string, statType: string, amount: number): void {
    this.server.sendCommand(this.client, 'field', 'setStats', id, statType, amount);
  }

  missed(id: string, sourceId: string): void {
    this.server.sendCommand(this.client, 'field', 'missed', id, sourceId);
  }

  immune(id: string, sourceId: string, element: string = ''): void {
    this.server.sendCommand(this.client, 'field', 'immune', id, sourceId, element);
  }

  die(id: string): void {
    this.server.sendCommand(this.client, 'field', 'die', id);
  }

  resurrect(id: string): void {
    this.server.sendCommand(this.client, 'field', 'resurrect', id);
  }

  setEffects(id: string, effects: any[]): void {
    this.server.sendCommand(this.client, 'field', 'setEffects', id, effects);
  }

  createObject(cfg: any, tooltipId: string = ''): void {
    this.server.sendCommand(this.client, 'field', 'createObject', cfg, tooltipId);
  }

  removeObject(id: string): void {
    this.server.sendCommand(this.client, 'field', 'removeObject', id);
  }

  setPhase(id: string, phase: string): void {
    this.server.sendCommand(this.client, 'field', 'setPhase', id, phase);
  }

  setActive(id: string, value: boolean): void {
    this.server.sendCommand(this.client, 'field', 'setActive', id, value);
  }

  setObjective(id: string, value: boolean): void {
    this.server.sendCommand(this.client, 'field', 'setObjective', id, value);
  }

  setQuestStatus(id: string, status: string): void {
    this.server.sendCommand(this.client, 'field', 'setQuestStatus', id, status);
  }

  speak(id: string, text: string, type: string): void {
    this.server.sendCommand(this.client, 'field', 'speak', id, text, type);
  }

  changeQuestDetails(questDetails: any[]): void {
    this.server.sendCommand(this.client, 'field', 'changeQuestDetails', questDetails);
  }

  // === Character Commands (character service) ===

  initBeltActions(belt: any[]): void {
    this.server.sendCommand(this.client, 'character', 'initBeltActions', belt);
  }

  initQuiver(quiver: any[]): void {
    this.server.sendCommand(this.client, 'character', 'initQuiver', quiver);
  }

  initAbilityActions(slots: any[]): void {
    this.server.sendCommand(this.client, 'character', 'initAbilityActions', slots);
  }

  selectRun(value: boolean): void {
    this.server.sendCommand(this.client, 'character', 'selectRun', value);
  }

  selectAttack(value: boolean): void {
    this.server.sendCommand(this.client, 'character', 'selectAttack', value);
  }

  selectFightMode(value: boolean): void {
    this.server.sendCommand(this.client, 'character', 'selectFightMode', value);
  }

  selectAlternative(index: number): void {
    this.server.sendCommand(this.client, 'character', 'selectAlternative', index);
  }

  selectAmmoIndex(index: number): void {
    this.server.sendCommand(this.client, 'character', 'selectAmmoIndex', index);
  }

  // === Combat Commands (combat service) ===

  combatInit(records: any[], enabled: boolean): void {
    this.server.sendCommand(this.client, 'combat', 'init', records, enabled);
  }

  combatSetEnabled(value: boolean): void {
    this.server.sendCommand(this.client, 'combat', 'setEnabled', value);
  }

  combatDamage(record: any): void {
    this.server.sendCommand(this.client, 'combat', 'damage', record);
  }

  combatHeal(record: any): void {
    this.server.sendCommand(this.client, 'combat', 'heal', record);
  }

  combatKill(record: any): void {
    this.server.sendCommand(this.client, 'combat', 'kill', record);
  }

  combatMiss(record: any): void {
    this.server.sendCommand(this.client, 'combat', 'miss', record);
  }

  combatExperience(record: any): void {
    this.server.sendCommand(this.client, 'combat', 'experience', record);
  }

  // === Game Commands (game service) ===

  showInteraction(interactionType: string, modal: boolean = false): void {
    this.server.sendCommand(this.client, 'game', 'showInteraction', interactionType, modal);
  }

  closeInteraction(): void {
    this.server.sendCommand(this.client, 'game', 'closeInteraction');
  }

  showMessage(msg: any): void {
    this.server.sendCommand(this.client, 'game', 'showMessage', msg);
  }

  closeMessage(messageId: string): void {
    this.server.sendCommand(this.client, 'game', 'closeMessage', messageId);
  }

  changeMode(mode: string): void {
    this.server.sendCommand(this.client, 'game', 'changeMode', mode);
  }

  updateAbilityBook(abilities: any[]): void {
    this.server.sendCommand(this.client, 'game', 'updateAbilityBook', abilities);
  }

  updateAbilityCache(cache: any[]): void {
    this.server.sendCommand(this.client, 'game', 'updateAbilityCache', cache);
  }
}
