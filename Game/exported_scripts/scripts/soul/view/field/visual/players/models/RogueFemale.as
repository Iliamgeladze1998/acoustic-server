package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class RogueFemale extends Knight
   {
      
      public static const visualId:String = "rogue_f";
      
      public function RogueFemale(hsl:String = "")
      {
         super();
         frameWidth = 124;
         frameHeight = 161;
         spriteCenter = new Point(-63,-127);
         hitArea = new Rectangle(43,28,40,105);
         library = "rogue_f.swf";
      }
   }
}

