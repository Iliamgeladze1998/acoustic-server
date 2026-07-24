package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class WizardFemale extends Knight
   {
      
      public static const visualId:String = "wizard_f";
      
      public function WizardFemale(hsl:String = "")
      {
         super();
         frameWidth = 124;
         frameHeight = 161;
         spriteCenter = new Point(-62,-128);
         hitArea = new Rectangle(43,28,41,105);
         nameHeight = 130;
         library = "wizard_f.swf";
      }
   }
}

