package soul.view.assets
{
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   
   public class Colors
   {
      
      public static const LABEL:uint = 12618080;
      
      public static const BUTTON_LABEL:uint = 16769704;
      
      public static const GOLD_LIGHT:uint = 16233043;
      
      public static const GOLD_DARK:uint = 16096059;
      
      public static const PLUSES:uint = 2073890;
      
      public static const MINUSES:uint = 11804189;
      
      public static const QUEST_SPLITTER:uint = 8283201;
      
      public static const DISABLED_ALPHA_FILTER:Array = [new ColorMatrixFilter([0.333,0.333,0.333,0,0,0.333,0.333,0.333,0,0,0.333,0.333,0.333,0,0,0,0,0,0.5,0])];
      
      public static const DISABLED_FILTER:Array = [new ColorMatrixFilter([0.333,0.333,0.333,0,0,0.333,0.333,0.333,0,0,0.333,0.333,0.333,0,0,0,0,0,1,0])];
      
      public static const PLAYER_HOVER_FILTER:GlowFilter = new GlowFilter(65535,1,3,3,2);
      
      public static const OBJECT_HOVER_FILTER:GlowFilter = new GlowFilter(16777079,1,15,15,1,1);
      
      public static const QUEST_OBJECTIVE_FILTER:GlowFilter = new GlowFilter(65280,1,8,8,1.5);
      
      public function Colors()
      {
         super();
      }
   }
}

