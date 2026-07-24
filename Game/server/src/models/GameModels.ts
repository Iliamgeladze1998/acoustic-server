// Game data models matching the decompiled client structure

export interface CharacterPublicData {
  id: string;
  name: string;
  avatarImagePath: string;
  sex: string;
  properties: Record<string, any>;
  params: Record<string, number>;
  side: string;
  race: string;
  dispositionGroup: string;
  disposition: string;
  reputations: any[];
  mode: string;
  subscriptionType: string;
  subscriptionExpire: Date | null;
  subscriptionRenew: boolean;
  subscriptionHidden: boolean;
  autoSlots: any[];
}

export interface CharacterData extends CharacterPublicData {
  level: number;
  portalId: number;
  currencies: Record<string, number>;
  abilityCache: any[];
  abilityBook: string[];
  abilitySlots: any[];
  additionalPoints: Record<string, number>;
  alternativeIndex: number;
  quiver: any[];
  selectedAmmoIndex: number;
  belt: any[];
  runMode: boolean;
  attackMode: boolean;
  fightMode: boolean;
  messages: any[];
  instanceRecords: any[];
  resurrection: any;
  interaction: string;
}

export interface GameCfg {
  exitTimeout: number;
  serverTime: number;
  coppersPerRuby: number;
  subscriptions: any[];
}

export interface FieldUnit {
  // BaseUnit sealed properties
  id: string;
  name: string;
  dead: boolean;
  avatarImagePath: string;
  effects: any[];
  stats: Record<string, number>;
  // FieldUnit sealed properties
  x: number;
  y: number;
  objectId: string | null;
  visualId: string;
  hue: number;
  lightness: number;
  hsls: any;
  wardrobes: any;
  acceptsNegative: boolean;
  acceptsPositive: boolean;
  types: any[];
  character: boolean;
  tradable: boolean;
  clan: string;
  questStatus: string;
  objective: boolean;
  difficulty: string;
  species: string;
  sightRange: number;
  castingTime: number;
  // Extra server-side properties
  level: number;
  side: string;
  race: string;
  sex: string;
  hp: number;
  mp: number;
  maxHp: number;
  maxMp: number;
  movementSpeed: number;
  attackSpeed: number;
  unitProperties: Record<string, number>;
}

export interface MapLayout {
  id: string;
  width: number;
  height: number;
  lights: any;
}

export interface MapData {
  sectorId: string;
  mapLayout: MapLayout;
  pvpState: string;
}

export interface Item {
  id: string;
  slot: string;
  type: string;
  bound: boolean;
  binding: string;
  templateId: string;
  imagePath: string;
  itemClass: string;
  count: number;
  durability: number;
  durabilityMaximum: number;
  usable: boolean;
  sockets: number;
  socketTypes: any[];
  subType: string;
  level: number;
  items: any[];
  autoAbilities: any[];
  equipped: boolean;
  bodySlot: number;
  locked: boolean;
}

export interface Ability {
  id: string;
  locId: string;
  imagePath: string;
  school: string;
  target: string;
  sign: string;
  distance: number;
  radius: number;
  level: number;
  costs: Record<string, number>;
  itemCosts: Record<string, number>;
  castTime: number;
  coolDown: number;
  groupCD: string;
  availableInFight: boolean;
  actions: any[];
  casterActions: any[];
  loading: boolean;
}

// Param types from client
export const ParamType = {
  STRENGTH: 'STRENGTH',
  DEXTERITY: 'DEXTERITY',
  CONSTITUTION: 'CONSTITUTION',
  ACCURACY: 'ACCURACY',
  LUCK: 'LUCK',
  INTELLECT: 'INTELLECT',
  MAX_HP: 'MAX_HP',
  MAX_MP: 'MAX_MP',
  MAX_STAMINA: 'MAX_STAMINA',
  SPEED: 'SPEED',
  HP_RECOVERY: 'HP_RECOVERY',
  MP_RECOVERY: 'MP_RECOVERY',
  STAMINA_RECOVERY: 'STAMINA_RECOVERY',
  RUN_STAMINA: 'RUN_STAMINA',
  DAMAGE_PHYSICAL_MIN: 'DAMAGE_PHYSICAL_MIN',
  DAMAGE_PHYSICAL_MAX: 'DAMAGE_PHYSICAL_MAX',
  HIT_MELEE: 'HIT_MELEE',
  HIT_RANGE: 'HIT_RANGE',
  CRIT: 'CRIT',
  ANTICRIT: 'ANTICRIT',
  DODGE: 'DODGE',
  AC: 'AC',
} as const;

// Item slots from client
export const ItemSlot = {
  WEAPON: 'WEAPON',
  SHIELD: 'SHIELD',
  AMMO: 'AMMO',
  EARCLIPS: 'EARCLIPS',
  HELMET: 'HELMET',
  TATOO: 'TATOO',
  AMULET: 'AMULET',
  ARMOUR: 'ARMOUR',
  GLOVES: 'GLOVES',
  RING: 'RING',
  BOOTS: 'BOOTS',
  WAIST: 'WAIST',
  JEWEL: 'JEWEL',
  SACK: 'SACK',
  RUNE: 'RUNE',
  AUTO_RUNE: 'AUTO_RUNE',
} as const;

// Element types from client
export const ElementType = {
  PHYSICAL: 'PHYSICAL',
  FIRE: 'FIRE',
  FROST: 'FROST',
  NATURE: 'NATURE',
  DARK: 'DARK',
  ARCANE: 'ARCANE',
  HOLY: 'HOLY',
} as const;
