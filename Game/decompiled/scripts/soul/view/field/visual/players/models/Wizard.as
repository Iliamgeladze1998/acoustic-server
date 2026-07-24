package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Wizard extends Knight
   {
      
      public static const visualId:String = "wizard";
      
      public function Wizard(hsl:String = "")
      {
         super();
         frameWidth = 146;
         frameHeight = 182;
         spriteCenter = new Point(-73,-137);
         hitArea = new Rectangle(45,33,53,109);
         nameHeight = 130;
         library = "wizard.swf";
      }
   }
}

