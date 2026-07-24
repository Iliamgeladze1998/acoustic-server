package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class KnightFemale extends Knight
   {
      
      public function KnightFemale(hsl:String = "")
      {
         super();
         frameWidth = 124;
         frameHeight = 161;
         spriteCenter = new Point(-62,-128);
         hitArea = new Rectangle(41,28,45,106);
         nameHeight = 130;
         library = "knight_f.swf";
      }
   }
}

