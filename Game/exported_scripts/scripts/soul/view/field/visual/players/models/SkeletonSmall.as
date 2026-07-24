package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class SkeletonSmall extends UnitBitmap
   {
      
      public function SkeletonSmall(hsl:String = "")
      {
         super();
         frameWidth = 57;
         frameHeight = 95;
         library = "skeleton_small.swf";
         linkages = ["skeleton1","skeleton2"];
         defaultFps = 12;
         spriteCenter = new Point(-26,-84);
         hitArea = new Rectangle(6,20,40,70);
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[0]];
         frameList[AnimationType.DEAD] = [1,[6]];
         frameList[AnimationType.WALK] = [0,[1,2,3,4,5,6,7]];
         frameList[AnimationType.USE_ITEM] = [0,[8,9,10,11,12,13,14]];
         frameList[AnimationType.SWORD] = [0,[15,16,17,18,19,20,21]];
         frameList[AnimationType.START_BOW] = [0,[22,23,24]];
         frameList[AnimationType.BOW] = [0,[25]];
         frameList[AnimationType.END_BOW] = [0,[25,26,27,28]];
         frameList[AnimationType.START_CAST] = [0,[29,30]];
         frameList[AnimationType.CAST] = [0,[31,31,32,32]];
         frameList[AnimationType.END_CAST] = [0,[32,33,34,35]];
         frameList[AnimationType.DAMAGE] = [0,[36,37,38,39,40,41,42]];
         frameList[AnimationType.DIE] = [1,[0,1,2,3,4,5,6]];
         frameList[AnimationType.RESURREST] = [1,[6,5,4,3,2,1,0]];
      }
   }
}

