package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Panther extends UnitBitmap
   {
      
      public static const visualId:String = "panther";
      
      public function Panther(hsl:String = "")
      {
         super();
         frameWidth = 100;
         frameHeight = 145;
         library = "panther.swf";
         linkages = ["panther1","panther2"];
         nameHeight = 115;
         defaultFps = 12;
         frameList[AnimationType.WALK] = [0,[0,1,2,3,4,5,6]];
         frameList[AnimationType.RUN] = [0,[7,8,9,10,11,12,13]];
         frameList[AnimationType.USE_ITEM] = [0,[14,15,16,17,18,19,20]];
         frameList[AnimationType.SWORD] = [0,[21,22,23,24,25,26,27]];
         frameList[AnimationType.START_BOW] = [1,[0,1,2]];
         frameList[AnimationType.BOW] = [1,[2]];
         frameList[AnimationType.END_BOW] = [1,[3,4,5,6]];
         frameList[AnimationType.START_CAST] = [1,[7,8,9]];
         frameList[AnimationType.CAST] = [1,[9,10,11,10]];
         frameList[AnimationType.END_CAST] = [1,[10,11,12,13]];
         frameList[AnimationType.DAMAGE] = [1,[14,15,16,17,18,19,20]];
         frameList[AnimationType.DIE] = [1,[21,22,23,24,25,26,27]];
         frameList[AnimationType.RESURREST] = [1,[27,26,25,24,23,22,21]];
         frameList[AnimationType.DEAD] = [1,[27]];
         spriteCenter = new Point(-50,-117);
         hitArea = new Rectangle(25,18,52,103);
      }
   }
}

