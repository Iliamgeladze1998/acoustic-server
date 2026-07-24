package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.OneFaceBitmap;
   
   public class Maiden2 extends OneFaceBitmap
   {
      
      public function Maiden2(hsl:String = "")
      {
         super();
         frameWidth = 50;
         frameHeight = 105;
         library = "maiden2.swf";
         linkages = ["maiden2"];
         defaultFps = 7;
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,4,5,6,7,0,0,0,0,0,0,0,0,0,0,0,0,8,9,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,10,9,8,0,0,0,0,0,0,0,0,0,0,0,12,13,14,15,16]];
         nameHeight = 125;
         spriteCenter = new Point(-28,-100);
         hitArea = new Rectangle(0,0,frameWidth,frameHeight);
      }
   }
}

