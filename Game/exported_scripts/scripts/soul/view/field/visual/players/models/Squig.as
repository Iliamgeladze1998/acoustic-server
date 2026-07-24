package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Squig extends UnitBitmap
   {
      
      public static const visualId:String = "squig";
      
      public function Squig(hsl:String = "")
      {
         super();
         frameWidth = 130;
         frameHeight = 100;
         library = "squig.swf";
         linkages = ["squig1"];
         defaultFps = 12;
         frameList = {};
         frameList[AnimationType.START_CAST] = [0,[0,1,2]];
         frameList[AnimationType.CAST] = [0,[2,3,4]];
         frameList[AnimationType.END_CAST] = [0,[4,5,6]];
         frameList[AnimationType.DAMAGE] = [0,[7,8,9,10,11,12,13]];
         frameList[AnimationType.DIE] = [0,[14,15,16,17,18,19,20]];
         frameList[AnimationType.DEAD] = [0,[20]];
         frameList[AnimationType.RESURREST] = [0,[20,19,18,17,16,15,14]];
         frameList[AnimationType.IDLE] = [0,[21,22,23,24,25,26,27]];
         frameList[AnimationType.SWORD] = [0,[28,29,30,31,32,33,34]];
         frameList[AnimationType.START_BOW] = [0,[35,36,37]];
         frameList[AnimationType.BOW] = [0,[38]];
         frameList[AnimationType.END_BOW] = [0,[39,40,41]];
         frameList[AnimationType.WALK] = [0,[42,43,44,45,46,47,48]];
         nameHeight = 90;
         spriteCenter = new Point(-67,-60);
         hitArea = new Rectangle(29,20,77,62);
      }
   }
}

