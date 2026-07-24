package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BerserkFemale extends Knight
   {
      
      public static const visualId:String = "berserk_f";
      
      public function BerserkFemale(hsl:String = "")
      {
         super();
         frameWidth = 124;
         frameHeight = 161;
         spriteCenter = new Point(-62,-127);
         hitArea = new Rectangle(40,29,45,103);
         nameHeight = 130;
         library = "berserk_f.swf";
      }
   }
}

