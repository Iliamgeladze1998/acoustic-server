package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Rogue extends Knight
   {
      
      public static const visualId:String = "rogue";
      
      public function Rogue(hsl:String = "")
      {
         super();
         frameWidth = 146;
         frameHeight = 182;
         spriteCenter = new Point(-73,-138);
         hitArea = new Rectangle(47,33,49,110);
         library = "rogue.swf";
      }
   }
}

