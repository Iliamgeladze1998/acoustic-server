package soul.model.field
{
   public class NpcDifficulty
   {
      
      public static const EASY:String = "EASY";
      
      public static const NORMAL:String = "NORMAL";
      
      public static const HARD:String = "HARD";
      
      public static const RARE:String = "RARE";
      
      public static const IMPOSSIBLE:String = "IMPOSSIBLE";
      
      public static const BOSS:String = "BOSS";
      
      public static const MEGABOSS:String = "MEGABOSS";
      
      private static const colorMap:Object = {};
      
      colorMap[HARD] = 5040700;
      colorMap[RARE] = 5040700;
      colorMap[IMPOSSIBLE] = 16758314;
      colorMap[BOSS] = 16758314;
      colorMap[MEGABOSS] = 8698111;
      
      public function NpcDifficulty()
      {
         super();
      }
      
      public static function getColor(diff:String) : uint
      {
         return uint(colorMap[diff]) || 16777215;
      }
   }
}

