package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class StingFemale extends Knight
   {
      
      public static const visualId:String = "sting_f";
      
      public function StingFemale(hsl:String = "")
      {
         super();
         frameWidth = 124;
         frameHeight = 161;
         spriteCenter = new Point(-62,-127);
         hitArea = new Rectangle(41,29,45,103);
         nameHeight = 130;
         library = "sting_f.swf";
      }
   }
}

