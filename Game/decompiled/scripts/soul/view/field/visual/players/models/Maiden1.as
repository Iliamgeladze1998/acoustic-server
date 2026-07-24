package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.OneFaceBitmap;
   
   public class Maiden1 extends OneFaceBitmap
   {
      
      public function Maiden1(hsl:String = "")
      {
         super();
         frameWidth = 62;
         frameHeight = 105;
         library = "maiden1.swf";
         linkages = ["maiden1"];
         defaultFps = 7;
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[0,1,2,3,2,3,2,3,2,3,4,5,5,5,5,5,5,6,0,0,0,0,0,0,0,0,0,0,0,0,0,7,8,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,9,8,7,0,0,0,0,0,0,0,0,0,0,0,0,11,12,12,12,12,13,14,15,16,16,16,16,17,0,0,0,0,0,0,0,0,0,0]];
         nameHeight = 125;
         spriteCenter = new Point(-28,-100);
         hitArea = new Rectangle(0,0,frameWidth,frameHeight);
      }
   }
}

