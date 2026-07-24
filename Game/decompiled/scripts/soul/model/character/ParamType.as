package soul.model.character
{
   import soul.model.ability.AbilitySchool;
   import soul.sorting.Pair;
   
   public class ParamType
   {
      
      public static const STRENGTH:String = "STRENGTH";
      
      public static const DEXTERITY:String = "DEXTERITY";
      
      public static const CONSTITUTION:String = "CONSTITUTION";
      
      public static const ACCURACY:String = "ACCURACY";
      
      public static const LUCK:String = "LUCK";
      
      public static const INTELLECT:String = "INTELLECT";
      
      public static const MAX_HP:String = "MAX_HP";
      
      public static const MAX_MP:String = "MAX_MP";
      
      public static const MAX_STAMINA:String = "MAX_STAMINA";
      
      public static const SPEED:String = "SPEED";
      
      public static const HP_RECOVERY:String = "HP_RECOVERY";
      
      public static const MP_RECOVERY:String = "MP_RECOVERY";
      
      public static const STAMINA_RECOVERY:String = "STAMINA_RECOVERY";
      
      public static const RUN_STAMINA:String = "RUN_STAMINA";
      
      public static const DAMAGE_PHYSICAL_MIN:String = "DAMAGE_PHYSICAL_MIN";
      
      public static const DAMAGE_FIRE_MIN:String = "DAMAGE_FIRE_MIN";
      
      public static const DAMAGE_FROST_MIN:String = "DAMAGE_FROST_MIN";
      
      public static const DAMAGE_NATURE_MIN:String = "DAMAGE_NATURE_MIN";
      
      public static const DAMAGE_DARK_MIN:String = "DAMAGE_DARK_MIN";
      
      public static const DAMAGE_ARCANE_MIN:String = "DAMAGE_ARCANE_MIN";
      
      public static const DAMAGE_HOLY_MIN:String = "DAMAGE_HOLY_MIN";
      
      public static const DAMAGE_PHYSICAL_MAX:String = "DAMAGE_PHYSICAL_MAX";
      
      public static const DAMAGE_FIRE_MAX:String = "DAMAGE_FIRE_MAX";
      
      public static const DAMAGE_FROST_MAX:String = "DAMAGE_FROST_MAX";
      
      public static const DAMAGE_NATURE_MAX:String = "DAMAGE_NATURE_MAX";
      
      public static const DAMAGE_DARK_MAX:String = "DAMAGE_DARK_MAX";
      
      public static const DAMAGE_ARCANE_MAX:String = "DAMAGE_ARCANE_MAX";
      
      public static const DAMAGE_HOLY_MAX:String = "DAMAGE_HOLY_MAX";
      
      public static const HIT_MELEE:String = "HIT_MELEE";
      
      public static const HIT_RANGE:String = "HIT_RANGE";
      
      public static const CRIT:String = "CRIT";
      
      public static const ANTICRIT:String = "ANTICRIT";
      
      public static const DODGE:String = "DODGE";
      
      public static const MELEE_LIGHT:String = "MELEE_LIGHT";
      
      public static const MELEE_MEDIUM:String = "MELEE_MEDIUM";
      
      public static const MELEE_HEAVY:String = "MELEE_HEAVY";
      
      public static const RANGE_LIGHT:String = "RANGE_LIGHT";
      
      public static const RANGE_HEAVY:String = "RANGE_HEAVY";
      
      public static const RANGE_THROWING:String = "RANGE_THROWING";
      
      public static const MAGIC_FIRE:String = "MAGIC_FIRE";
      
      public static const MAGIC_FROST:String = "MAGIC_FROST";
      
      public static const MAGIC_NATURE:String = "MAGIC_NATURE";
      
      public static const MAGIC_DARK:String = "MAGIC_DARK";
      
      public static const MAGIC_ARCANE:String = "MAGIC_ARCANE";
      
      public static const MAGIC_HOLY:String = "MAGIC_HOLY";
      
      public static const AC:String = "AC";
      
      public static const RESISTANCE_FIRE:String = "RESISTANCE_FIRE";
      
      public static const RESISTANCE_FROST:String = "RESISTANCE_FROST";
      
      public static const RESISTANCE_NATURE:String = "RESISTANCE_NATURE";
      
      public static const RESISTANCE_DARK:String = "RESISTANCE_DARK";
      
      public static const RESISTANCE_ARCANE:String = "RESISTANCE_ARCANE";
      
      public static const RESISTANCE_HOLY:String = "RESISTANCE_HOLY";
      
      public static const HERBALISM:String = "HERBALISM";
      
      public static const MINING:String = "MINING";
      
      public static const FISHING:String = "FISHING";
      
      public static const ALCHEMY:String = "ALCHEMY";
      
      public static const BLACKSMITHING:String = "BLACKSMITHING";
      
      public static const COOKING:String = "COOKING";
      
      public static const FIRST_AID:String = "FIRST_AID";
      
      public static const HEALING:String = "HEALING";
      
      public static const BARGAIN:String = "BARGAIN";
      
      public static const DIPLOMACY:String = "DIPLOMACY";
      
      public static const THIEVERY:String = "THIEVERY";
      
      public static const BURGLARY:String = "BURGLARY";
      
      public static const FRIEND_LIST_SIZE:String = "FRIEND_LIST_SIZE";
      
      public static const IGNORE_LIST_SIZE:String = "IGNORE_LIST_SIZE";
      
      public static const ENEMY_LIST_SIZE:String = "ENEMY_LIST_SIZE";
      
      public static const sortedParams:Array = [STRENGTH,DEXTERITY,CONSTITUTION,ACCURACY,LUCK,INTELLECT,MAX_HP,MAX_MP,MAX_STAMINA,SPEED,HP_RECOVERY,MP_RECOVERY,STAMINA_RECOVERY,RUN_STAMINA,DAMAGE_PHYSICAL_MIN,DAMAGE_FIRE_MIN,DAMAGE_FROST_MIN,DAMAGE_NATURE_MIN,DAMAGE_DARK_MIN,DAMAGE_ARCANE_MIN,DAMAGE_HOLY_MIN,DAMAGE_PHYSICAL_MAX,DAMAGE_FIRE_MAX,DAMAGE_FROST_MAX,DAMAGE_NATURE_MAX,DAMAGE_DARK_MAX,DAMAGE_ARCANE_MAX,DAMAGE_HOLY_MAX,HIT_MELEE,HIT_RANGE,CRIT,ANTICRIT,DODGE,MELEE_LIGHT,MELEE_MEDIUM,MELEE_HEAVY,RANGE_LIGHT,RANGE_HEAVY,RANGE_THROWING,MAGIC_FIRE,MAGIC_FROST,MAGIC_NATURE,MAGIC_DARK,MAGIC_ARCANE,MAGIC_HOLY,AC,RESISTANCE_FIRE,RESISTANCE_FROST,RESISTANCE_NATURE,RESISTANCE_DARK,RESISTANCE_ARCANE,RESISTANCE_HOLY,HERBALISM,MINING,FISHING,ALCHEMY,BLACKSMITHING,COOKING,FIRST_AID,HEALING,BARGAIN,DIPLOMACY,THIEVERY,BURGLARY];
      
      public static const str:Class = ParamType_str;
      
      public static const dex:Class = ParamType_dex;
      
      public static const con:Class = ParamType_con;
      
      public static const acc:Class = ParamType_acc;
      
      public static const luc:Class = ParamType_luc;
      
      public static const int:Class = ParamType_int;
      
      public static const ac:Class = ParamType_ac;
      
      public static const alchemy:Class = ParamType_alchemy;
      
      public static const blacksmithing:Class = ParamType_blacksmithing;
      
      public static const cooking:Class = ParamType_cooking;
      
      public static const fishing:Class = ParamType_fishing;
      
      public static const herbalism:Class = ParamType_herbalism;
      
      public static const mining:Class = ParamType_mining;
      
      private static const icons:Object = {};
      
      public static const acBig:Class = ParamType_acBig;
      
      public static const arcaneBig:Class = ParamType_arcaneBig;
      
      public static const darkBig:Class = ParamType_darkBig;
      
      public static const fireBig:Class = ParamType_fireBig;
      
      public static const frostBig:Class = ParamType_frostBig;
      
      public static const holyBig:Class = ParamType_holyBig;
      
      public static const natureBig:Class = ParamType_natureBig;
      
      private static const bigIcons:Object = {};
      
      icons[STRENGTH] = str;
      icons[DEXTERITY] = dex;
      icons[CONSTITUTION] = con;
      icons[ACCURACY] = acc;
      icons[LUCK] = luc;
      icons[INTELLECT] = int;
      icons[AC] = ac;
      icons[RESISTANCE_FIRE] = AbilitySchool.schoolFire;
      icons[RESISTANCE_FROST] = AbilitySchool.schoolFrost;
      icons[RESISTANCE_NATURE] = AbilitySchool.schoolNature;
      icons[RESISTANCE_DARK] = AbilitySchool.schoolDark;
      icons[RESISTANCE_ARCANE] = AbilitySchool.schoolArcane;
      icons[RESISTANCE_HOLY] = AbilitySchool.schoolHoly;
      icons[HERBALISM] = herbalism;
      icons[MINING] = mining;
      icons[FISHING] = fishing;
      icons[ALCHEMY] = alchemy;
      icons[BLACKSMITHING] = blacksmithing;
      icons[COOKING] = cooking;
      bigIcons[AC] = acBig;
      bigIcons[RESISTANCE_FIRE] = fireBig;
      bigIcons[RESISTANCE_FROST] = frostBig;
      bigIcons[RESISTANCE_NATURE] = natureBig;
      bigIcons[RESISTANCE_DARK] = darkBig;
      bigIcons[RESISTANCE_ARCANE] = arcaneBig;
      bigIcons[RESISTANCE_HOLY] = holyBig;
      
      public function ParamType()
      {
         super();
      }
      
      public static function sortParams(o:Object) : Vector.<Pair>
      {
         var key:String = null;
         var ret:Vector.<Pair> = new Vector.<Pair>();
         for(key in o)
         {
            ret.push(new Pair(key,o[key]));
         }
         ret.sort(sorter);
         return ret;
      }
      
      private static function sorter(v1:Pair, v2:Pair) : Number
      {
         if(!v1 || !v2)
         {
            return 0;
         }
         if(sortedParams.indexOf(v1.first) < sortedParams.indexOf(v2.first))
         {
            return -1;
         }
         if(sortedParams.indexOf(v1.first) > sortedParams.indexOf(v2.first))
         {
            return 1;
         }
         return 0;
      }
      
      public static function getIcon(param:String) : Class
      {
         return icons[param];
      }
      
      public static function getBigIcon(param:String) : Class
      {
         return bigIcons[param];
      }
   }
}

