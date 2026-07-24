package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Smile extends UnitBitmap
   {
      
      public function Smile(hsl:String = "")
      {
         super();
         frameWidth = 104;
         frameHeight = 130;
         library = "smile.swf";
         linkages = ["smile"];
         defaultFps = 12;
         frameList = {};
         frameList[AnimationType.START_CAST] = [0,[0,1,2]];
         frameList[AnimationType.CAST] = [0,[2,3,4]];
         frameList[AnimationType.END_CAST] = [0,[4,5,6]];
         frameList[AnimationType.DAMAGE] = [0,[7,8,9,10,11,12,13]];
         frameList[AnimationType.DIE] = [0,[14,15,16,17,18,19,20,21,22,23]];
         frameList[AnimationType.DEAD] = [0,[23]];
         frameList[AnimationType.RESURREST] = [0,[23,22,21,20,19,18,17,16,15,14]];
         frameList[AnimationType.IDLE] = [0,[24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,26,27,27,27,27,27,27,27,27,27,27,27,28,29,30,31,31,31,31,31,31,31,31,31,31,31,32,33]];
         frameList[AnimationType.SWORD] = [0,[34,35,36,37,38,39,40,41,42,43]];
         frameList[AnimationType.START_BOW] = [0,[44,45,46,47,48]];
         frameList[AnimationType.BOW] = [0,[48]];
         frameList[AnimationType.END_BOW] = [0,[48,49,50,51,52,53]];
         frameList[AnimationType.USE_ITEM] = [0,[54,55,56,57,58,59,60,61,62,63]];
         frameList[AnimationType.WALK] = [0,[64,65,66,67,68,69,70,71,72,73]];
         frameList[AnimationType.RUN] = frameList[AnimationType.WALK];
         fpsList[AnimationType.RUN] = 24;
         nameHeight = 100;
         spriteCenter = new Point(-52,-80);
         hitArea = new Rectangle(27,31,50,54);
      }
   }
}

