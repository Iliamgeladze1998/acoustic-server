package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Sting extends Knight
   {
      
      public static const visualId:String = "sting";
      
      public function Sting(hsl:String = "")
      {
         super();
         frameWidth = 146;
         frameHeight = 182;
         spriteCenter = new Point(-73,-138);
         hitArea = new Rectangle(49,38,48,104);
         nameHeight = 130;
         library = "sting.swf";
      }
   }
}

