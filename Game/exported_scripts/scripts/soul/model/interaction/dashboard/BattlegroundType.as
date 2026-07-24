package soul.model.interaction.dashboard
{
   public class BattlegroundType
   {
      
      public static const STRONG_SIDE:String = "STRONG_SIDE";
      
      public static const CHAOTIC:String = "CHAOTIC";
      
      public static const CARAVAN:String = "CARAVAN";
      
      public static const DUEL:String = "DUEL";
      
      public static const BASE_ATTACK:String = "BASE_ATTACK";
      
      public static const caravan:Class = BattlegroundType_caravan;
      
      public static const slauther:Class = BattlegroundType_slauther;
      
      public static const strongSide:Class = BattlegroundType_strongSide;
      
      public static const baseAttack:Class = BattlegroundType_baseAttack;
      
      private static const icons:Object = {};
      
      icons[STRONG_SIDE] = strongSide;
      icons[CHAOTIC] = slauther;
      icons[CARAVAN] = caravan;
      icons[BASE_ATTACK] = baseAttack;
      
      public function BattlegroundType()
      {
         super();
      }
      
      public static function getIcon(type:String) : Class
      {
         return icons[type];
      }
   }
}

