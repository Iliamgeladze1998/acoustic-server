package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Skeletor extends UnitBitmap
   {
      
      public function Skeletor(hsl:String = "")
      {
         super();
         frameWidth = 97;
         frameHeight = 140;
         library = "skeletor.swf";
         linkages = ["skeletor1"];
         defaultFps = 12;
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[6]];
         frameList[AnimationType.DEAD] = [0,[27]];
         frameList[AnimationType.WALK] = [0,[0,1,2,3,4,5,6]];
         frameList[AnimationType.SWORD] = [0,[7,8,9,10,11,12,13]];
         frameList[AnimationType.DAMAGE] = [0,[14,15,16,17,18,19,20]];
         frameList[AnimationType.DIE] = [0,[21,22,23,24,25,26,27]];
         frameList[AnimationType.RESURREST] = [0,[27,26,25,24,23,22,21]];
         spriteCenter = new Point(-49,-115);
         hitArea = new Rectangle(20,11,58,113);
      }
   }
}

