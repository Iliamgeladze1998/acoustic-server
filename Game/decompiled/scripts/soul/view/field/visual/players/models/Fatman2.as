package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.OneFaceBitmap;
   
   public class Fatman2 extends OneFaceBitmap
   {
      
      public function Fatman2(hsl:String = "")
      {
         super();
         frameWidth = 66;
         frameHeight = 122;
         library = "fatman2.swf";
         linkages = ["fatman2"];
         defaultFps = 12;
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[0,0,0,0,0,0,0,0,0,0,1,1,2,2,3,3,2,1,1,0,0,1,1,2,2,3,3,2,2,1,1,0,0,1,1,2,2,3,3,2,1,1,0,0,1,1,2,2,3,3,2,2,1,1,4,5,6,7,7,8,8,7,7,8,8,6,5,4,0,0,1,1,2,2,3,3,2,1,1,0,0,1,1,2,2,3,3,2,2,1,1,13,14,15,15,15,15,15,15,15,15,15,15,15,16,17,19,18,18,18,18,18,18,18,18,18,18,18,19,0,0,1,1,2,2,3,3,2,1,1,0,0,1,1,2,2,3,3,2,2,1,1,0,0,1,1,2,2,3,3,2,1,1,0,0,1,1,2,2,3,3,2,2,1,1,9,10,11,11,12,12,11,11,12,12,11,11,12,12,10,9,0,0,1,1,2,2,3,3,2,1,1,0,0,1,1,2,2,3,3,2,2,1,1,0,0,1,1,2,2,3,3,2,1,1,0,0,1,1,2,2,3,3,2,2,1,1,13,14,15,15,15,15,15,15,15,15,15,15,15,16,19,17,18,18,18,18,18,18,18,18,18,18,18,19]];
         nameHeight = 125;
         spriteCenter = new Point(-31,-111);
         hitArea = new Rectangle(0,0,66,122);
      }
   }
}

