package soul.view.field.visual.players
{
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.RotatingBitmap;
   
   public class UnitBitmap extends RotatingBitmap
   {
      
      public function UnitBitmap()
      {
         super();
         hasShadow = true;
         frameList[AnimationType.IDLE] = [0,[14]];
         frameList[AnimationType.DEAD] = [2,[6]];
         frameList[AnimationType.WALK] = [0,[0,1,2,3,4,5,6]];
         frameList[AnimationType.RUN] = [0,[7,8,9,10,11,12,13]];
         frameList[AnimationType.USE_ITEM] = [0,[14,15,16,17,18,19,20]];
         frameList[AnimationType.START_CAST] = [0,[21,22]];
         frameList[AnimationType.CAST] = [0,[23,24,25,26]];
         frameList[AnimationType.END_CAST] = [0,[25,26,27]];
         frameList[AnimationType.SPEAR] = [1,[0,1,2,3,4,5,6]];
         frameList[AnimationType.SWORD] = [1,[7,8,9,10,11,12,13]];
         frameList[AnimationType.START_BOW] = [1,[14,15,16]];
         frameList[AnimationType.BOW] = [1,[17]];
         frameList[AnimationType.END_BOW] = [1,[18,19,20]];
         frameList[AnimationType.DAMAGE] = [1,[21,22,23,24,25,26,27]];
         frameList[AnimationType.DIE] = [2,[0,1,2,3,4,5,6]];
         frameList[AnimationType.RESURREST] = [2,[6,5,4,3,2,1,0]];
         fpsList[AnimationType.RUN] = 9;
         fpsList[AnimationType.SWORD] = 18;
      }
   }
}

