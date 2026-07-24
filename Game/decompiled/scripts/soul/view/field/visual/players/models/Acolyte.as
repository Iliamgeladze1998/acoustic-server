package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Acolyte extends Knight
   {
      
      public function Acolyte(hsl:String = "")
      {
         super();
         frameWidth = 146;
         frameHeight = 182;
         spriteCenter = new Point(-73,-139);
         hitArea = new Rectangle(46,34,53,109);
         library = "acolyte.swf";
      }
   }
}

