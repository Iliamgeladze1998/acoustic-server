package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class RatmanSmall extends UnitBitmap
   {
      
      public static const visualId:String = "ratman_small";
      
      public function RatmanSmall(hsl:String = "")
      {
         super();
         frameWidth = 57;
         frameHeight = 82;
         library = "ratman_small.swf";
         linkages = ["ratman1","ratman2"];
         defaultFps = 12;
         frameList[AnimationType.IDLE] = [0,[0]];
         frameList[AnimationType.DEAD] = [1,[24]];
         frameList[AnimationType.WALK] = [0,[1,2,3,4,5,6,7]];
         frameList[AnimationType.RUN] = [0,[8,9,10,11,12,13,14]];
         frameList[AnimationType.START_CAST] = [0,[32,33,34]];
         frameList[AnimationType.CAST] = [0,[35,36,37,34]];
         frameList[AnimationType.END_CAST] = [0,[36,37,38]];
         frameList[AnimationType.SWORD] = [0,[39,40,41,42]];
         frameList[AnimationType.SPEAR] = [0,[43,44,45,46,47,48]];
         frameList[AnimationType.START_BOW] = [1,[0,1,2]];
         frameList[AnimationType.BOW] = [1,[3]];
         frameList[AnimationType.END_BOW] = [1,[3,4,5]];
         frameList[AnimationType.USE_ITEM] = [1,[6,7,8,9,10,11,12]];
         frameList[AnimationType.DAMAGE] = [1,[12,14,15,16,17]];
         frameList[AnimationType.DIE] = [1,[18,19,20,21,22,23,24]];
         frameList[AnimationType.RESURREST] = [1,[24,23,22,21,20,19,18]];
         spriteCenter = new Point(-29,-67);
         hitArea = new Rectangle(12,10,32,65);
      }
   }
}

