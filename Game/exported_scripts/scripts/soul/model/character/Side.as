package soul.model.character
{
   public class Side
   {
      
      public static const GREAT_EMPIRE:String = "GREAT_EMPIRE";
      
      public static const WASTELAND:String = "WASTELAND";
      
      public static const NEUTRAL:String = "NEUTRAL";
      
      public static const GOOD:String = "GOOD";
      
      public static const EVIL:String = "EVIL";
      
      private static const colorMap:Object = {};
      
      public static const empire:Class = Side_empire;
      
      public static const wasteland:Class = Side_wasteland;
      
      private static const icons:Object = {};
      
      public static const roundEmpire:Class = Side_roundEmpire;
      
      public static const roundWasteland:Class = Side_roundWasteland;
      
      private static const roundIcons:Object = {};
      
      colorMap[GREAT_EMPIRE] = 255;
      colorMap[WASTELAND] = 15649996;
      colorMap[GOOD] = 65280;
      colorMap[EVIL] = 15606476;
      colorMap[NEUTRAL] = 16776960;
      icons[GREAT_EMPIRE] = empire;
      icons[WASTELAND] = wasteland;
      roundIcons[GREAT_EMPIRE] = roundEmpire;
      roundIcons[WASTELAND] = roundWasteland;
      
      public function Side()
      {
         super();
      }
      
      public static function getColor(side:String) : uint
      {
         return uint(colorMap[side]) || 13421772;
      }
      
      public static function getIcon(side:String) : Class
      {
         return icons[side];
      }
      
      public static function getRoundIcon(side:String) : Class
      {
         return roundIcons[side];
      }
   }
}

