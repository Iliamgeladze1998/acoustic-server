package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Dragonfly extends UnitBitmap
   {
      
      public function Dragonfly()
      {
         super();
         frameWidth = 68;
         frameHeight = 81;
         library = "dragonfly.swf";
         linkages = ["dragonfly1"];
         spriteCenter = new Point(-35,-75);
         hitArea = new Rectangle(15,15,42,70);
         defaultFps = 12;
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[1,2,3,4,5,6,7]];
         frameList[AnimationType.DEAD] = [0,[28]];
         frameList[AnimationType.WALK] = [0,[1,2,3,4,5,6,7]];
         frameList[AnimationType.END_CAST] = [0,[8,9,10,11,12,13,14]];
         frameList[AnimationType.SWORD] = [0,[8,9,10,11,12,13,14]];
         frameList[AnimationType.DAMAGE] = [0,[15,16,17,18,19,20,21]];
         frameList[AnimationType.DIE] = [0,[22,23,24,25,25,27,28]];
         frameList[AnimationType.RESURREST] = [0,[28,27,26,25,24,23,22]];
         fpsList[AnimationType.RUN] = 9;
         fpsList[AnimationType.SWORD] = 18;
      }
   }
}

