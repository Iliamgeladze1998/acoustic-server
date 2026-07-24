package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Settler1 extends UnitBitmap
   {
      
      public function Settler1(hsl:String = "")
      {
         super();
         frameWidth = 64;
         frameHeight = 124;
         spriteCenter = new Point(-32,-110);
         hitArea = new Rectangle(0,0,frameWidth,frameHeight);
         nameHeight = 130;
         defaultFps = 8;
         library = "settler1.swf";
         linkages = ["settler1"];
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,11,11,11,11,12,13,14,15,15,15,15,16,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,17,18,19,20,19,20,19,20,19,20,21,22]];
         frameList[AnimationType.WALK] = [0,[23,24,25,26,27,28,29,30,31,32]];
      }
   }
}

