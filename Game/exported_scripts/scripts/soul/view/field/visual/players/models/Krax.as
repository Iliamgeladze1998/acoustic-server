package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Krax extends UnitBitmap
   {
      
      public static const visualId:String = "krax";
      
      public function Krax(hsl:String = "")
      {
         super();
         frameWidth = 125;
         frameHeight = 150;
         library = "krax.swf";
         linkages = ["krax1"];
         defaultFps = 12;
         frameList = {};
         frameList[AnimationType.START_CAST] = [0,[0,1,2]];
         frameList[AnimationType.CAST] = [0,[2,3]];
         frameList[AnimationType.END_CAST] = [0,[3,4,5,6]];
         frameList[AnimationType.DAMAGE] = [0,[7,8,9,10,11,12,13]];
         frameList[AnimationType.DIE] = [0,[14,15,16,17,18,19,20]];
         frameList[AnimationType.DEAD] = [0,[20]];
         frameList[AnimationType.RESURREST] = [0,[20,19,18,17,16,15,14]];
         frameList[AnimationType.IDLE] = [0,[21,21,21,21,21,21,21,21,21,21,21,22,22,22,22,23,23,23,23,23,23,23,23,23,24]];
         frameList[AnimationType.SWORD] = [0,[25,26,27,28,29,30,31]];
         frameList[AnimationType.START_BOW] = [0,[32,33,34]];
         frameList[AnimationType.BOW] = [0,[35]];
         frameList[AnimationType.END_BOW] = [0,[35,36,37,38]];
         frameList[AnimationType.WALK] = [0,[39,40,41,42,43,44,45]];
         nameHeight = 135;
         spriteCenter = new Point(-62,-127);
         hitArea = new Rectangle(28,24,69,112);
         hasShadow = false;
      }
   }
}

