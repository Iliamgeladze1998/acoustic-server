package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BelieverFemale extends Acolyte
   {
      
      public static const visualId:String = "believer_f";
      
      public function BelieverFemale(hsl:String = "")
      {
         super();
         frameWidth = 124;
         frameHeight = 161;
         spriteCenter = new Point(-62,-127);
         hitArea = new Rectangle(40,26,43,106);
         library = "believer_f.swf";
      }
   }
}

