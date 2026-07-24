package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Knight extends UnitBitmap
   {
      
      public function Knight(hsl:String = "")
      {
         super();
         frameWidth = 146;
         frameHeight = 182;
         spriteCenter = new Point(-72,-135);
         hitArea = new Rectangle(44,44,57,98);
         nameHeight = 130;
         defaultFps = 18;
         library = "knight.swf";
         linkages = ["1"];
         frameList = {};
         frameList[AnimationType.START_CAST] = [0,[0,1]];
         frameList[AnimationType.CAST] = [0,[2,1]];
         frameList[AnimationType.END_CAST] = [0,[1,2,3,4]];
         frameList[AnimationType.DAMAGE] = [0,[5,6,5]];
         frameList[AnimationType.DIE] = [0,[5,7,8]];
         frameList[AnimationType.DEAD] = [0,[8]];
         frameList[AnimationType.RESURREST] = [0,[8,7,5]];
         frameList[AnimationType.IDLE] = [0,[9,10,11,12,13,14,15]];
         frameList[AnimationType.SWORD] = [0,[16,17,18,19,20]];
         frameList[AnimationType.START_BOW] = [0,[9,21,22]];
         frameList[AnimationType.BOW] = [0,[22]];
         frameList[AnimationType.END_BOW] = [0,[22,22,23]];
         frameList[AnimationType.RUN] = [0,[24,25,26,27,28,29,30,31,32,33]];
         frameList[AnimationType.USE_ITEM] = [0,[34,35]];
         frameList[AnimationType.WALK] = [0,[36,37,38,39,40,41,42,43,44,45]];
         fpsList[AnimationType.IDLE] = 8;
         fpsList[AnimationType.USE_ITEM] = 6;
         fpsList[AnimationType.DAMAGE] = 6;
         fpsList[AnimationType.DIE] = 6;
         fpsList[AnimationType.END_BOW] = 6;
         fpsList[AnimationType.CAST] = 6;
         fpsList[AnimationType.END_CAST] = 12;
         fpsList[AnimationType.SWORD] = 16;
         fppList[AnimationType.WALK] = 0.09;
         fppList[AnimationType.RUN] = 0.075;
      }
   }
}

