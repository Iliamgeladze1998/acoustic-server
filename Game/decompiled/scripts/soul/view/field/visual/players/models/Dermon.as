package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Dermon extends UnitBitmap
   {
      
      public static const visualId:String = "dermon";
      
      public function Dermon(hsl:String = "")
      {
         super();
         frameWidth = 121;
         frameHeight = 154;
         library = "dermon.swf";
         linkages = ["1","2"];
         defaultFps = 12;
         frameList = {};
         frameList[AnimationType.START_CAST] = [0,[0,1,2]];
         frameList[AnimationType.CAST] = [0,[3,4,5]];
         frameList[AnimationType.END_CAST] = [0,[6,7,8,9]];
         frameList[AnimationType.DAMAGE] = [0,[10,11,12,13,14,15,16]];
         frameList[AnimationType.DIE] = [0,[17,18,19,20,21,22,23,24,25,26]];
         frameList[AnimationType.DEAD] = [0,[26]];
         frameList[AnimationType.RESURREST] = [0,[26,25,24,23,22,21,20,19,18,17]];
         frameList[AnimationType.IDLE] = [0,[27,27,27,27,27,27,27,27,27,27,27,27,28,29,30,31,32,33]];
         frameList[AnimationType.SWORD] = [1,[0,1,2,3,4,5,6,7,8,9]];
         frameList[AnimationType.START_BOW] = [1,[10,11,12]];
         frameList[AnimationType.BOW] = [1,[13]];
         frameList[AnimationType.END_BOW] = [1,[14,15,16,17,18,19]];
         frameList[AnimationType.WALK] = frameList[AnimationType.RUN] = [1,[20,21,22,23,24,25,26,27,28,29]];
         nameHeight = 120;
         spriteCenter = new Point(-60,-126);
         hitArea = new Rectangle(20,25,79,105);
      }
   }
}

