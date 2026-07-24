package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Cat1 extends UnitBitmap
   {
      
      public static const visualId:String = "cat1";
      
      public function Cat1()
      {
         super();
         library = "critter.swf";
         linkages = ["cat1"];
         frameWidth = 81;
         frameHeight = 62;
         nameHeight = 60;
         defaultFps = 24;
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[0]];
         frameList[AnimationType.WALK] = [0,[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]];
         frameList[AnimationType.RUN] = [0,[1,3,5,7,9,11,13,15]];
         spriteCenter = new Point(-40,-40);
         fpsList[AnimationType.RUN] = 24;
      }
   }
}

