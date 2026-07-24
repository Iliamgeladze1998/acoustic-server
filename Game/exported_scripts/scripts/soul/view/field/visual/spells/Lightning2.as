package soul.view.field.visual.spells
{
   import flash.filters.GlowFilter;
   
   public class Lightning2 extends Lightning
   {
      
      public function Lightning2()
      {
         super();
         glowColor = 16711680;
         filters = [new GlowFilter(glowColor,1,7,7,2)];
         segmentLength = 40;
         randomSpread = 50;
         bolts = 5;
      }
   }
}

