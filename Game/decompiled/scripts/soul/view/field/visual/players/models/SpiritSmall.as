package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class SpiritSmall extends UnitBitmap
   {
      
      public function SpiritSmall(hsl:String = "")
      {
         super();
         frameWidth = 95;
         frameHeight = 99;
         library = "spirit_small.swf";
         linkages = ["spirit1","spirit2","spirit3"];
         spriteCenter = new Point(-46,-85);
         hitArea = new Rectangle(27,12,40,80);
         defaultFps = 12;
      }
   }
}

