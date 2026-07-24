package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.OneFaceBitmap;
   
   public class Oldman1 extends OneFaceBitmap
   {
      
      public function Oldman1(hsl:String = "")
      {
         super();
         frameWidth = 46;
         frameHeight = 111;
         library = "oldman1.swf";
         linkages = ["oldman1"];
         defaultFps = 7;
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[0,1,2,3,4,5,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,9,10,11,12,13,14,15,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]];
         nameHeight = 125;
         spriteCenter = new Point(-28,-100);
         hitArea = new Rectangle(0,0,frameWidth,frameHeight);
      }
   }
}

