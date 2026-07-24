package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class AcolyteFemale extends Acolyte
   {
      
      public static const visualId:String = "acolyte_f";
      
      public function AcolyteFemale(hsl:String = "")
      {
         super();
         frameWidth = 124;
         frameHeight = 161;
         spriteCenter = new Point(-62,-128);
         hitArea = new Rectangle(42,28,42,104);
         nameHeight = 130;
         library = "acolyte_f.swf";
      }
   }
}

