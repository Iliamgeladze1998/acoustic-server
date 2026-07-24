package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Storm extends UnitBitmap
   {
      
      public function Storm(hsl:String = "")
      {
         super();
         frameWidth = 104;
         frameHeight = 112;
         library = "storm.swf";
         linkages = ["storm1","storm2"];
         defaultFps = 12;
         spriteCenter = new Point(-53,-98);
         hitArea = new Rectangle(23,3,57,101);
         nameHeight = 120;
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[0,1,2,3,4]];
         frameList[AnimationType.DEAD] = [1,[20]];
         frameList[AnimationType.WALK] = [0,[5,6,7,8,9,10,11]];
         frameList[AnimationType.SWORD] = [0,[12,13,14,15,16,17,18]];
         frameList[AnimationType.START_BOW] = [0,[19,20,21]];
         frameList[AnimationType.BOW] = [0,[22]];
         frameList[AnimationType.END_BOW] = [0,[22,22,22,23,24,25]];
         frameList[AnimationType.START_CAST] = [1,[0,1,2]];
         frameList[AnimationType.CAST] = [1,[2,3,4,3]];
         frameList[AnimationType.END_CAST] = [1,[4,5,6]];
         frameList[AnimationType.DAMAGE] = [1,[7,8,9,10,11,12,13]];
         frameList[AnimationType.DIE] = [1,[14,15,16,17,18,19,20]];
         frameList[AnimationType.RESURREST] = [1,[20,19,18,17,16,15,14]];
         fpsList[AnimationType.IDLE] = 6;
         fpsList[AnimationType.WALK] = 9;
         fpsList[AnimationType.DAMAGE] = 9;
      }
   }
}

