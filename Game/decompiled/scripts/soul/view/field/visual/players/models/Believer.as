package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Believer extends Acolyte
   {
      
      public static const visualId:String = "believer";
      
      public function Believer(hsl:String = "")
      {
         super();
         frameWidth = 146;
         frameHeight = 182;
         spriteCenter = new Point(-73,-138);
         hitArea = new Rectangle(46,34,50,108);
         library = "believer.swf";
      }
   }
}

