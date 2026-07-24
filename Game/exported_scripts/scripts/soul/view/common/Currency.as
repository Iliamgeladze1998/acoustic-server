package soul.view.common
{
   public class Currency
   {
      
      public static const copperImg:Class = Currency_copperImg;
      
      public static const silverImg:Class = Currency_silverImg;
      
      public static const goldImg:Class = Currency_goldImg;
      
      public static const rubiesImg:Class = Currency_rubiesImg;
      
      public static const repImg:Class = Currency_repImg;
      
      public static const pvpImg:Class = Currency_pvpImg;
      
      public static const COPPER:String = "COPPER";
      
      public static const RUBIES:String = "RUBIES";
      
      public static const ARENA:String = "ARENA";
      
      public static const PVP:String = "PVP";
      
      private static const icons:Object = {};
      
      icons[COPPER] = copperImg;
      icons[RUBIES] = rubiesImg;
      icons[ARENA] = repImg;
      icons[PVP] = pvpImg;
      
      public function Currency()
      {
         super();
      }
      
      public static function getCurrencyIcon(type:String) : Class
      {
         return icons[type];
      }
   }
}

