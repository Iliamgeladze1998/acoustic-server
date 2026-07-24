package soul.model.character
{
   import soul.model.ability.AbilitySchool;
   
   public class DispositionGroup
   {
      
      public static const WARRIOR:String = "WARRIOR";
      
      public static const THIEF:String = "THIEF";
      
      public static const PRIEST:String = "PRIEST";
      
      public static const MAGICIAN:String = "MAGICIAN";
      
      public static const SORTED_LIST:Array = [WARRIOR,THIEF,PRIEST,MAGICIAN];
      
      private static const tabImages:Object = {};
      
      private static const schoolIcons:Object = {};
      
      private static const axe:Class = DispositionGroup_axe;
      
      private static const bow:Class = DispositionGroup_bow;
      
      private static const claw:Class = DispositionGroup_claw;
      
      private static const club:Class = DispositionGroup_club;
      
      private static const dagger:Class = DispositionGroup_dagger;
      
      private static const hammer:Class = DispositionGroup_hammer;
      
      private static const staff:Class = DispositionGroup_staff;
      
      private static const sword:Class = DispositionGroup_sword;
      
      private static const wand:Class = DispositionGroup_wand;
      
      private static const weaponIcons:Object = {};
      
      private static const mage:Class = DispositionGroup_mage;
      
      private static const priest:Class = DispositionGroup_priest;
      
      private static const thief:Class = DispositionGroup_thief;
      
      private static const warrior:Class = DispositionGroup_warrior;
      
      private static const icons:Object = {};
      
      private static const partyMage:Class = DispositionGroup_partyMage;
      
      private static const partyPriest:Class = DispositionGroup_partyPriest;
      
      private static const partyThief:Class = DispositionGroup_partyThief;
      
      private static const partyWarrior:Class = DispositionGroup_partyWarrior;
      
      private static const partyIcons:Object = {};
      
      private static const schools:Object = {};
      
      schoolIcons[WARRIOR] = [AbilitySchool.schoolTiger,AbilitySchool.schoolHawk,AbilitySchool.schoolBear,AbilitySchool.schoolOther];
      schoolIcons[THIEF] = [AbilitySchool.schoolWolf,AbilitySchool.schoolSnake,AbilitySchool.schoolChameleon,AbilitySchool.schoolOther];
      schoolIcons[PRIEST] = [AbilitySchool.schoolNature,AbilitySchool.schoolHoly,AbilitySchool.schoolDark,AbilitySchool.schoolOther];
      schoolIcons[MAGICIAN] = [AbilitySchool.schoolFire,AbilitySchool.schoolFrost,AbilitySchool.schoolArcane,AbilitySchool.schoolOther];
      weaponIcons[WARRIOR] = [sword,axe,bow];
      weaponIcons[THIEF] = [claw,dagger,bow];
      weaponIcons[PRIEST] = [club,hammer,bow];
      weaponIcons[MAGICIAN] = [staff,wand,bow];
      icons[WARRIOR] = warrior;
      icons[THIEF] = thief;
      icons[PRIEST] = priest;
      icons[MAGICIAN] = mage;
      partyIcons[WARRIOR] = partyWarrior;
      partyIcons[THIEF] = partyThief;
      partyIcons[PRIEST] = partyPriest;
      partyIcons[MAGICIAN] = partyMage;
      schools[WARRIOR] = [AbilitySchool.MAGIC_WARRIOR_01,AbilitySchool.MAGIC_WARRIOR_02,AbilitySchool.MAGIC_WARRIOR_03];
      schools[THIEF] = [AbilitySchool.MAGIC_THIEF_01,AbilitySchool.MAGIC_THIEF_02,AbilitySchool.MAGIC_THIEF_03];
      schools[PRIEST] = [AbilitySchool.MAGIC_NATURE,AbilitySchool.MAGIC_HOLY,AbilitySchool.MAGIC_DARK];
      schools[MAGICIAN] = [AbilitySchool.MAGIC_FIRE,AbilitySchool.MAGIC_FROST,AbilitySchool.MAGIC_ARCANE];
      
      public function DispositionGroup()
      {
         super();
      }
      
      public static function getTabImages(group:String) : Array
      {
         return tabImages[group];
      }
      
      public static function getSchoolIcons(group:String) : Array
      {
         return schoolIcons[group];
      }
      
      public static function getWeaponIcons(group:String) : Array
      {
         return weaponIcons[group];
      }
      
      public static function getIcon(group:String) : Class
      {
         return icons[group];
      }
      
      public static function getPartyIcon(group:String) : Class
      {
         return partyIcons[group];
      }
      
      public static function getSchools(group:String) : Array
      {
         return schools[group];
      }
   }
}

