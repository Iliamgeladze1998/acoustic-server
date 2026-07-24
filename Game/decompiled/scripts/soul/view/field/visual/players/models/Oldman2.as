package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.OneFaceBitmap;
   
   public class Oldman2 extends OneFaceBitmap
   {
      
      public function Oldman2(hsl:String = "")
      {
         super();
         frameWidth = 41;
         frameHeight = 109;
         library = "oldman2.swf";
         linkages = ["oldman2"];
         defaultFps = 6;
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[0,1,2,3,4,5,6,7,0,0,0,0,0,0,0,0,0,0,0,0,8,9,10,11,12,13,12,13,12,13,14,15,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]];
         nameHeight = 125;
         spriteCenter = new Point(-23,-100);
         hitArea = new Rectangle(0,0,frameWidth,frameHeight);
      }
   }
}

