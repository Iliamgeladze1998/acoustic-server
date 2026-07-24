package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Knight1 extends UnitBitmap
   {
      
      public function Knight1(hsl:String = "")
      {
         super();
         frameWidth = 146;
         frameHeight = 177;
         spriteCenter = new Point(-72,-135);
         hitArea = new Rectangle(44,44,57,98);
         nameHeight = 130;
         defaultFps = 11;
         library = "knight1.swf";
         linkages = ["1"];
         frameList = {};
         frameList[AnimationType.SWORD] = [0,[0,1,2,3,4,5,6,7,8,9]];
         frameList[AnimationType.DIE] = [0,[10,11,12,13,14,15,16]];
         frameList[AnimationType.DEAD] = [0,[16]];
         frameList[AnimationType.RESURREST] = [0,[16,15,14,13,12,11,10]];
         frameList[AnimationType.IDLE] = [0,[17,18,19,20,21,22,23]];
         frameList[AnimationType.START_CAST] = [0,[24,25,26]];
         frameList[AnimationType.CAST] = [0,[27,28]];
         frameList[AnimationType.END_CAST] = [0,[29,30,31,32,33]];
         frameList[AnimationType.RUN] = [0,[34,35,36,37,38,39,40,41,42,43]];
         fppList[AnimationType.RUN] = 0.075;
      }
   }
}

