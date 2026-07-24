package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Berserk extends Knight
   {
      
      public static const visualId:String = "berserk";
      
      public function Berserk(hsl:String = "")
      {
         super();
         frameWidth = 146;
         frameHeight = 182;
         spriteCenter = new Point(-73,-138);
         hitArea = new Rectangle(42,39,59,106);
         nameHeight = 130;
         library = "berserk.swf";
         linkages = ["1"];
      }
   }
}

