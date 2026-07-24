package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ShamanFemale extends Knight
   {
      
      public static const visualId:String = "shaman_f";
      
      public function ShamanFemale(hsl:String = "")
      {
         super();
         frameWidth = 124;
         frameHeight = 161;
         spriteCenter = new Point(-63,-127);
         hitArea = new Rectangle(41,28,42,106);
         library = "shaman_f.swf";
      }
   }
}

