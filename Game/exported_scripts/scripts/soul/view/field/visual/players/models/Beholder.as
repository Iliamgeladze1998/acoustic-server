package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Beholder extends UnitBitmap
   {
      
      public function Beholder(hsl:String = "")
      {
         super();
         frameWidth = 110;
         frameHeight = 110;
         library = "beholder.swf";
         linkages = ["beholder1"];
         defaultFps = 12;
         frameList = {};
         frameList[AnimationType.SWORD] = [0,[0,1,2,3,4,5,6]];
         frameList[AnimationType.DAMAGE] = [0,[7,8,9,10,11,12,13]];
         frameList[AnimationType.DIE] = [0,[14,15,16,17,18,19,20]];
         frameList[AnimationType.DEAD] = [0,[20]];
         frameList[AnimationType.RESURREST] = [0,[20,19,18,17,16,15,14]];
         frameList[AnimationType.IDLE] = [0,[21,22,23,24,25,26,27]];
         frameList[AnimationType.START_CAST] = [0,[28,29,30]];
         frameList[AnimationType.CAST] = [0,[30,31,32]];
         frameList[AnimationType.END_CAST] = [0,[32,33,34]];
         frameList[AnimationType.WALK] = [0,[35,36,37,38,39,40,41]];
         nameHeight = 130;
         spriteCenter = new Point(-55,-108);
         hitArea = new Rectangle(20,7,68,99);
      }
   }
}

