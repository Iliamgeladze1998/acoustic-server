package soul.utils
{
   public class ColorUtils
   {
      
      public function ColorUtils()
      {
         super();
      }
      
      public static function getHueMatrix(hue:int, lightness:int = 0) : Array
      {
         var getR:Function = function(hue:int):Number
         {
            hue = (hue % 360 + 360) % 360;
            var r:Number = Math.abs((180 - hue) / 60) - 1;
            r = Math.min(1,r);
            return Math.max(0,r);
         };
         var getG:Function = function(hue:int):Number
         {
            return getR(hue + 120);
         };
         var getB:Function = function(hue:int):Number
         {
            return getR(hue - 120);
         };
         var m:Array = [getR(hue),getG(hue),getB(hue),0,lightness,getR(hue - 120),getG(hue - 120),getB(hue - 120),0,lightness,getR(hue + 120),getG(hue + 120),getB(hue + 120),0,lightness,0,0,0,1,0];
         return m;
      }
      
      public static function hslToString(h:int = 0, s:int = 0, l:int = 0) : String
      {
         h = (h % 360 + 360) % 360;
         s = Math.max(0,Math.min(200,s));
         l = Math.max(0,Math.min(200,l));
         if(h == 0 && s == 0 && l == 0)
         {
            return "";
         }
         return "" + h + "_" + s + "_" + l;
      }
      
      public static function colorFromString(value:String) : uint
      {
         if(!value)
         {
            return 0;
         }
         if(value.charAt(0) == "#")
         {
            value = value.substring(1,value.length);
         }
         return Number("0x" + value);
      }
   }
}

