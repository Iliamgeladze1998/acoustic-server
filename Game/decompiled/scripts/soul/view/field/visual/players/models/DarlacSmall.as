package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class DarlacSmall extends UnitBitmap
   {
      
      public static const visualId:String = "darlac_small";
      
      public function DarlacSmall()
      {
         super();
         frameWidth = 48;
         frameHeight = 70;
         library = "darlac_small.swf";
         linkages = ["darlac1","darlac2"];
         nameHeight = 80;
         defaultFps = 12;
         frameList[AnimationType.IDLE] = [0,[0]];
         frameList[AnimationType.DEAD] = [1,[18]];
         frameList[AnimationType.WALK] = [0,[1,2,3,4,5,6,7]];
         frameList[AnimationType.RUN] = [0,[8,9,10,11,12,13,14]];
         frameList[AnimationType.START_CAST] = [0,[32,33,34]];
         frameList[AnimationType.CAST] = [0,[35,36,37,34]];
         frameList[AnimationType.END_CAST] = [0,[36,37,38]];
         frameList[AnimationType.SWORD] = [0,[39,40,41,42]];
         frameList[AnimationType.SPEAR] = [0,[43,44,45,46,47,48,49]];
         frameList[AnimationType.START_BOW] = [0,[50,51,52]];
         frameList[AnimationType.BOW] = [0,[53]];
         frameList[AnimationType.END_BOW] = [0,[53,54,55]];
         frameList[AnimationType.USE_ITEM] = [1,[0,1,2,3,4,5,6]];
         frameList[AnimationType.DAMAGE] = [1,[7,8,9,10,11]];
         frameList[AnimationType.DIE] = [1,[12,13,14,15,16,17,18]];
         frameList[AnimationType.RESURREST] = [1,[18,17,16,15,14,13,12]];
         spriteCenter = new Point(-23,-56);
         hitArea = new Rectangle(6,0,32,61);
      }
   }
}

