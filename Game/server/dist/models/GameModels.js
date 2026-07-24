"use strict";
// Game data models matching the decompiled client structure
Object.defineProperty(exports, "__esModule", { value: true });
exports.ElementType = exports.ItemSlot = exports.ParamType = void 0;
// Param types from client
exports.ParamType = {
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
};
// Item slots from client
exports.ItemSlot = {
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
};
// Element types from client
exports.ElementType = {
    PHYSICAL: 'PHYSICAL',
    FIRE: 'FIRE',
    FROST: 'FROST',
    NATURE: 'NATURE',
    DARK: 'DARK',
    ARCANE: 'ARCANE',
    HOLY: 'HOLY',
};
//# sourceMappingURL=GameModels.js.map