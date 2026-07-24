package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class DarlacFemale extends UnitBitmap
   {
      
      public function DarlacFemale()
      {
         super();
         frameWidth = 119;
         frameHeight = 134;
         library = "darlac_f.swf";
         linkages = ["darlac1"];
         defaultFps = 12;
         frameList = {};
         frameList[AnimationType.START_CAST] = [0,[0,1,2]];
         frameList[AnimationType.CAST] = [0,[2,3,4]];
         frameList[AnimationType.END_CAST] = [0,[4,5,6]];
         frameList[AnimationType.DAMAGE] = [0,[7,8,9,10,11,12,13]];
         frameList[AnimationType.DIE] = [0,[14,15,16,17,18,19,20]];
         frameList[AnimationType.DEAD] = [0,[20]];
         frameList[AnimationType.RESURREST] = [0,[20,19,18,17,16,15,14]];
         frameList[AnimationType.SWORD] = [0,[21,22,23,24,25,26,27]];
         frameList[AnimationType.START_BOW] = [0,[28,29,30]];
         frameList[AnimationType.BOW] = [0,[31]];
         frameList[AnimationType.END_BOW] = [0,[31,32,33,34]];
         frameList[AnimationType.RUN] = [0,[35,36,37,38,39,40,41]];
         frameList[AnimationType.USE_ITEM] = [0,[42,43,44,45,46,47,48]];
         frameList[AnimationType.WALK] = [0,[49,50,51,52,53,54,55]];
         frameList[AnimationType.IDLE] = [0,[7]];
         nameHeight = 115;
         spriteCenter = new Point(-59,-102);
         hitArea = new Rectangle(28,8,62,106);
         hasShadow = false;
      }
   }
}

