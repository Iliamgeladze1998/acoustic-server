package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Spiker extends UnitBitmap
   {
      
      public static const visualId:String = "spiker";
      
      public function Spiker(hsl:String = "")
      {
         super();
         frameWidth = 100;
         frameHeight = 95;
         library = "spiker.swf";
         linkages = ["spiker1"];
         spriteCenter = new Point(-50,-60);
         hitArea = new Rectangle(10,10,81,78);
         nameHeight = 80;
         frameList = {};
         frameList[AnimationType.START_CAST] = [0,[0,1,2]];
         frameList[AnimationType.CAST] = [0,[2,3]];
         frameList[AnimationType.END_CAST] = [0,[3,4,5,6]];
         frameList[AnimationType.DAMAGE] = [0,[7,8,9,10,11,12,13]];
         frameList[AnimationType.DIE] = [0,[14,15,16,17,18,19,20]];
         frameList[AnimationType.DEAD] = [0,[20]];
         frameList[AnimationType.RESURREST] = [0,[20,19,18,17,16,15,14]];
         frameList[AnimationType.SWORD] = [0,[21,22,23,24,25,26,27]];
         frameList[AnimationType.START_BOW] = [0,[28,29,30]];
         frameList[AnimationType.BOW] = [0,[31]];
         frameList[AnimationType.END_BOW] = [0,[31,32,33,34]];
         frameList[AnimationType.WALK] = [0,[35,36,37,38,39,40,41]];
         frameList[AnimationType.IDLE] = [0,[7]];
         defaultFps = 12;
      }
   }
}

