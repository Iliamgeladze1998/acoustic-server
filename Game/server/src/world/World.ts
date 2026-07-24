import { CharacterData, FieldUnit, GameCfg, Item, Ability } from '../models/GameModels';

export class World {
  private characters: Map<string, CharacterData> = new Map();
  private units: Map<string, FieldUnit> = new Map();
  private items: Map<string, Item> = new Map();
  private abilities: Map<string, Ability> = new Map();
  private nextUnitId: number = 1;

  constructor() {
    this.initTestData();
  }

  private initTestData(): void {
    // Create a test character
    const char: CharacterData = {
      id: 'char_1',
      name: 'Hero',
      avatarImagePath: 'knight/male/default.jpg',
      sex: 'male',
      properties: {},
      params: {
        STRENGTH: 10,
        DEXTERITY: 10,
        CONSTITUTION: 10,
        ACCURACY: 10,
        LUCK: 5,
        INTELLECT: 5,
        MAX_HP: 100,
        MAX_MP: 50,
        MAX_STAMINA: 100,
        SPEED: 5,
        HP_RECOVERY: 2,
        MP_RECOVERY: 1,
        STAMINA_RECOVERY: 3,
        RUN_STAMINA: 1,
        DAMAGE_PHYSICAL_MIN: 5,
        DAMAGE_PHYSICAL_MAX: 10,
        HIT_MELEE: 50,
        HIT_RANGE: 30,
        CRIT: 5,
        ANTICRIT: 0,
        DODGE: 5,
        AC: 10,
      },
      side: 'light',
      race: 'human',
      dispositionGroup: 'knight',
      disposition: 'knight',
      reputations: [],
      mode: 'RTM',
      subscriptionType: '',
      subscriptionExpire: null,
      subscriptionRenew: false,
      subscriptionHidden: false,
      autoSlots: [],
      level: 1,
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
      interaction: '' as string,
    };
    this.characters.set('char_1', char);

    // Create admin character with high stats
    const adminChar: CharacterData = {
      id: 'admin_char',
      name: 'ADMIN',
      avatarImagePath: 'knight/male/default.jpg',
      sex: 'male',
      properties: { isAdmin: true },
      params: {
        STRENGTH: 100,
        DEXTERITY: 100,
        CONSTITUTION: 100,
        ACCURACY: 100,
        LUCK: 100,
        INTELLECT: 100,
        MAX_HP: 10000,
        MAX_MP: 5000,
        MAX_STAMINA: 10000,
        SPEED: 15,
        HP_RECOVERY: 100,
        MP_RECOVERY: 50,
        STAMINA_RECOVERY: 100,
        RUN_STAMINA: 1,
        DAMAGE_PHYSICAL_MIN: 500,
        DAMAGE_PHYSICAL_MAX: 1000,
        HIT_MELEE: 100,
        HIT_RANGE: 100,
        CRIT: 50,
        ANTICRIT: 50,
        DODGE: 50,
        AC: 500,
      },
      side: 'light',
      race: 'human',
      dispositionGroup: 'knight',
      disposition: 'knight',
      reputations: [],
      mode: 'RTM',
      subscriptionType: '',
      subscriptionExpire: null,
      subscriptionRenew: false,
      subscriptionHidden: false,
      autoSlots: [],
      level: 60,
      portalId: 0,
      currencies: { coppers: 99999999, rubies: 99999 },
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
      interaction: '',
    };
    this.characters.set('admin_char', adminChar);

    // Create a test field unit for the character
    // FieldUnit extends BaseUnit - sealed properties must match client class definition
    // BaseUnit sealed: id, name, dead, avatarImagePath, effects, stats
    // FieldUnit sealed: x, y, objectId, visualId, hue, lightness, hsls, wardrobes, acceptsNegative, acceptsPositive, types, character, tradable, clan, questStatus, objective, difficulty, species, sightRange, castingTime
    const unit: FieldUnit = {
      id: 'unit_1',
      name: 'Hero',
      dead: false,
      avatarImagePath: 'knight/male/default.jpg',
      effects: [],
      stats: { HP: 100, MP: 50, STAMINA: 100, MAX_HP: 100, MAX_MP: 50, MAX_STAMINA: 100, LEVEL: 1, XP: 0 },
      x: 100,
      y: 100,
      objectId: null,
      visualId: 'knight',
      hue: 0,
      lightness: 0,
      hsls: null,
      wardrobes: null,
      acceptsNegative: true,
      acceptsPositive: true,
      types: [],
      character: true,
      tradable: false,
      clan: '',
      questStatus: '',
      objective: false,
      difficulty: '',
      species: 'player',
      sightRange: 10,
      castingTime: 0,
      level: 1,
      side: 'light',
      race: 'human',
      sex: 'male',
      hp: 100,
      mp: 50,
      maxHp: 100,
      maxMp: 50,
      movementSpeed: 5,
      attackSpeed: 1,
      unitProperties: { HP: 100, MP: 50, STAMINA: 100 },
    };
    this.units.set('unit_1', unit);
  }

  getCharacter(charId: string): CharacterData | undefined {
    return this.characters.get(charId);
  }

  getUnit(unitId: string): FieldUnit | undefined {
    return this.units.get(unitId);
  }

  getGameCfg(): GameCfg {
    return {
      exitTimeout: 300000,
      serverTime: Date.now(),
      coppersPerRuby: 100,
      subscriptions: [],
    };
  }

  getAllCharacters(): CharacterData[] {
    return Array.from(this.characters.values());
  }

  updateCharacter(charId: string, updates: Partial<CharacterData>): boolean {
    const char = this.characters.get(charId);
    if (!char) return false;
    Object.assign(char, updates);
    return true;
  }

  setCharacterParams(charId: string, stats: Record<string, number>): boolean {
    const char = this.characters.get(charId);
    if (!char) return false;
    Object.assign(char.params, stats);
    return true;
  }

  addCurrency(charId: string, type: string, amount: number): boolean {
    const char = this.characters.get(charId);
    if (!char) return false;
    char.currencies[type] = (char.currencies[type] || 0) + amount;
    return true;
  }

  setLevel(charId: string, level: number): boolean {
    const char = this.characters.get(charId);
    if (!char) return false;
    char.level = level;
    char.params.LEVEL = level;
    char.params.MAX_HP = level * 500;
    char.params.MAX_MP = level * 250;
    char.params.MAX_STAMINA = level * 500;
    char.params.DAMAGE_PHYSICAL_MIN = level * 30;
    char.params.DAMAGE_PHYSICAL_MAX = level * 60;
    char.params.HIT_MELEE = Math.min(100, level * 2);
    char.params.HIT_RANGE = Math.min(100, level * 2);
    return true;
  }

  addItem(charId: string, item: Item): boolean {
    const char = this.characters.get(charId);
    if (!char) return false;
    // Add to inventory - currently belt is used for quick slots
    // For now, add to belt as a simple inventory representation
    char.belt.push(item);
    return true;
  }

  createPlayerCharacter(charId: string, name: string, level: number): void {
    const char: CharacterData = {
      id: charId,
      name: name,
      avatarImagePath: 'knight/male/default.jpg',
      sex: 'male',
      properties: {},
      params: {
        STRENGTH: 10,
        DEXTERITY: 10,
        CONSTITUTION: 10,
        ACCURACY: 10,
        LUCK: 5,
        INTELLECT: 5,
        MAX_HP: 100 + level * 50,
        MAX_MP: 50 + level * 25,
        MAX_STAMINA: 100 + level * 50,
        SPEED: 5,
        HP_RECOVERY: 2,
        MP_RECOVERY: 1,
        STAMINA_RECOVERY: 3,
        RUN_STAMINA: 1,
        DAMAGE_PHYSICAL_MIN: 5 + level * 3,
        DAMAGE_PHYSICAL_MAX: 10 + level * 6,
        HIT_MELEE: 50,
        HIT_RANGE: 30,
        CRIT: 5,
        ANTICRIT: 0,
        DODGE: 5,
        AC: 10 + level * 2,
      },
      side: 'light',
      race: 'human',
      dispositionGroup: 'knight',
      disposition: 'knight',
      reputations: [],
      mode: 'RTM',
      subscriptionType: '',
      subscriptionExpire: null,
      subscriptionRenew: false,
      subscriptionHidden: false,
      autoSlots: [],
      level: level,
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
      interaction: '',
    };
    this.characters.set(charId, char);
  }

  createUnit(name: string, x: number, y: number): FieldUnit {
    const id = 'unit_' + this.nextUnitId++;
    const unit: FieldUnit = {
      id,
      name,
      dead: false,
      avatarImagePath: '',
      effects: [],
      stats: { HP: 50, MP: 0, STAMINA: 50, MAX_HP: 50, MAX_MP: 0, MAX_STAMINA: 50, LEVEL: 1, XP: 0 },
      x, y,
      objectId: null,
      visualId: 'goblin',
      hue: 0,
      lightness: 0,
      hsls: null,
      wardrobes: null,
      acceptsNegative: true,
      acceptsPositive: false,
      types: [],
      character: false,
      tradable: false,
      clan: '',
      questStatus: '',
      objective: false,
      difficulty: 'easy',
      species: 'npc',
      sightRange: 8,
      castingTime: 0,
      level: 1,
      side: 'dark',
      race: 'goblin',
      sex: 'male',
      hp: 50,
      mp: 0,
      maxHp: 50,
      maxMp: 0,
      movementSpeed: 3,
      attackSpeed: 1,
      unitProperties: { HP: 50, MP: 0, STAMINA: 50 },
    };
    this.units.set(id, unit);
    return unit;
  }
}
