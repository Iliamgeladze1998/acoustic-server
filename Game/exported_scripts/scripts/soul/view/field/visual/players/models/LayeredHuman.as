package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   
   public class LayeredHuman extends LayeredUnitBitmap
   {
      
      public static const visualId:String = "layered_human";
      
      public function LayeredHuman()
      {
         super();
         frameWidth = 122;
         frameHeight = 130;
         library = "layeredHuman.swf";
         spriteCenter = new Point(-59,-109);
         hitArea = new Rectangle(22,13,49,101);
         nameHeight = 125;
         frameList = {};
         frameList[AnimationType.DAMAGE] = [0,[0,1,2,3,4,5,6]];
         frameList[AnimationType.DIE] = [0,[7,8,9,10,11,12,13]];
         frameList[AnimationType.RESURREST] = [0,[13,12,11,10,9,8,7]];
         frameList[AnimationType.IDLE] = [0,[14,14,14,14,14,14,14,14,14,14,14,14,14,15,16,17,18,19,20]];
         frameList[AnimationType.USE_ITEM] = [0,[21,22,23,24,25,26,27]];
         frameList[AnimationType.START_CAST] = [0,[28,29]];
         frameList[AnimationType.CAST] = [0,[30,31,32]];
         frameList[AnimationType.END_CAST] = [0,[32,33,34]];
         frameList[AnimationType.RUN] = [0,[35,36,37,38,39,40,41]];
         frameList[AnimationType.START_BOW] = [0,[42,43,44]];
         frameList[AnimationType.BOW] = [0,[45]];
         frameList[AnimationType.END_BOW] = [0,[46,47,48]];
         frameList[AnimationType.SWORD] = [0,[49,50,51,52,53,54,55]];
         frameList[AnimationType.WALK] = [0,[56,57,58,59,60,61,62]];
         frameList[AnimationType.DEAD] = [0,[13]];
         defaultFps = 12;
      }
   }
}

