package soul.model.ability
{
   public class AbilitySchool
   {
      
      public static const MAGIC_WARRIOR_01:String = "MAGIC_WARRIOR_01";
      
      public static const MAGIC_WARRIOR_02:String = "MAGIC_WARRIOR_02";
      
      public static const MAGIC_WARRIOR_03:String = "MAGIC_WARRIOR_03";
      
      public static const MAGIC_THIEF_01:String = "MAGIC_THIEF_01";
      
      public static const MAGIC_THIEF_02:String = "MAGIC_THIEF_02";
      
      public static const MAGIC_THIEF_03:String = "MAGIC_THIEF_03";
      
      public static const MAGIC_NATURE:String = "MAGIC_NATURE";
      
      public static const MAGIC_HOLY:String = "MAGIC_HOLY";
      
      public static const MAGIC_DARK:String = "MAGIC_DARK";
      
      public static const MAGIC_FIRE:String = "MAGIC_FIRE";
      
      public static const MAGIC_FROST:String = "MAGIC_FROST";
      
      public static const MAGIC_ARCANE:String = "MAGIC_ARCANE";
      
      public static const OTHER:String = "OTHER";
      
      public static const schoolArcane:Class = AbilitySchool_schoolArcane;
      
      public static const schoolBear:Class = AbilitySchool_schoolBear;
      
      public static const schoolChameleon:Class = AbilitySchool_schoolChameleon;
      
      public static const schoolDark:Class = AbilitySchool_schoolDark;
      
      public static const schoolFire:Class = AbilitySchool_schoolFire;
      
      public static const schoolFrost:Class = AbilitySchool_schoolFrost;
      
      public static const schoolHawk:Class = AbilitySchool_schoolHawk;
      
      public static const schoolHoly:Class = AbilitySchool_schoolHoly;
      
      public static const schoolNature:Class = AbilitySchool_schoolNature;
      
      public static const schoolSnake:Class = AbilitySchool_schoolSnake;
      
      public static const schoolTiger:Class = AbilitySchool_schoolTiger;
      
      public static const schoolWolf:Class = AbilitySchool_schoolWolf;
      
      public static const schoolOther:Class = AbilitySchool_schoolOther;
      
      private static const icons:Object = {};
      
      icons[MAGIC_WARRIOR_01] = schoolTiger;
      icons[MAGIC_WARRIOR_02] = schoolHawk;
      icons[MAGIC_WARRIOR_03] = schoolBear;
      icons[MAGIC_THIEF_01] = schoolWolf;
      icons[MAGIC_THIEF_01] = schoolSnake;
      icons[MAGIC_THIEF_01] = schoolChameleon;
      icons[MAGIC_NATURE] = schoolNature;
      icons[MAGIC_HOLY] = schoolHoly;
      icons[MAGIC_DARK] = schoolDark;
      icons[MAGIC_FIRE] = schoolFire;
      icons[MAGIC_FROST] = schoolFrost;
      icons[MAGIC_ARCANE] = schoolArcane;
      icons[OTHER] = schoolOther;
      
      public function AbilitySchool()
      {
         super();
      }
      
      public static function getSchoolIcon(school:String) : Class
      {
         return icons[school];
      }
   }
}

