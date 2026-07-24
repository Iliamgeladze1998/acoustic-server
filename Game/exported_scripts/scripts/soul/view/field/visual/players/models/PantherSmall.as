package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class PantherSmall extends UnitBitmap
   {
      
      public function PantherSmall(hsl:String = "")
      {
         super();
         frameWidth = 120;
         frameHeight = 94;
         library = "panther_small.swf";
         linkages = ["panther1","panther2","panther3"];
         nameHeight = 95;
         defaultFps = 12;
         frameList[AnimationType.START_CAST] = [1,[0,1,2]];
         frameList[AnimationType.CAST] = [1,[2,3,4,3]];
         frameList[AnimationType.END_CAST] = [1,[3,4,5,6]];
         frameList[AnimationType.SPEAR] = [1,[7,8,9,10,11,12,13]];
         frameList[AnimationType.SWORD] = [1,[14,15,16,17,18,19,20]];
         frameList[AnimationType.START_BOW] = [2,[0,1,2]];
         frameList[AnimationType.BOW] = [2,[2]];
         frameList[AnimationType.END_BOW] = [2,[3,4,5,6]];
         frameList[AnimationType.DAMAGE] = [2,[7,8,9,10,11,12,13]];
         frameList[AnimationType.DIE] = [2,[14,15,16,17,18,19,20]];
         frameList[AnimationType.RESURREST] = [2,[20,19,18,17,16,15,14]];
         frameList[AnimationType.DEAD] = [2,[20]];
         spriteCenter = new Point(-59,-83);
         hitArea = new Rectangle(26,4,64,90);
      }
   }
}

