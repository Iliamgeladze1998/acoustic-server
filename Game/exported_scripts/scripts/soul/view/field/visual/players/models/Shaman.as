package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Shaman extends Knight
   {
      
      public static const visualId:String = "shaman";
      
      public function Shaman(hsl:String = "")
      {
         super();
         frameWidth = 146;
         frameHeight = 182;
         spriteCenter = new Point(-73,-138);
         hitArea = new Rectangle(46,34,50,108);
         library = "shaman.swf";
      }
   }
}

