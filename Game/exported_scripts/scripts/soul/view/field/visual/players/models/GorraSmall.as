package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class GorraSmall extends UnitBitmap
   {
      
      public static const visualId:String = "gorra_small";
      
      public function GorraSmall(hsl:String = "")
      {
         super();
         frameWidth = 95;
         frameHeight = 105;
         library = "gorra_small.swf";
         linkages = ["gorra1","gorra2","gorra3"];
         spriteCenter = new Point(-45,-85);
         hitArea = new Rectangle(25,9,40,80);
         defaultFps = 12;
      }
   }
}

