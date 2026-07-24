package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class GorraFemale extends UnitBitmap
   {
      
      public function GorraFemale(hsl:String = "")
      {
         super();
         frameWidth = 118;
         frameHeight = 127;
         library = "gorra_f.swf";
         linkages = ["gorra1","gorra2","gorra3"];
         spriteCenter = new Point(-59,-106);
         hitArea = new Rectangle(34,15,51,103);
         nameHeight = 115;
         frameList[AnimationType.IDLE] = [0,[14]];
         frameList[AnimationType.WALK] = [0,[0,1,2,3,4,5,6]];
         frameList[AnimationType.RUN] = [0,[7,8,9,10,11,12,13]];
         frameList[AnimationType.USE_ITEM] = [0,[14,15,16,17,18,19,20]];
         frameList[AnimationType.SWORD] = [1,[0,1,2,3,4,5,6]];
         frameList[AnimationType.START_BOW] = [1,[7,8,9]];
         frameList[AnimationType.BOW] = [1,[10]];
         frameList[AnimationType.END_BOW] = [1,[10,11,12,13]];
         frameList[AnimationType.START_CAST] = [1,[14,15,16]];
         frameList[AnimationType.CAST] = [1,[16,17,18,17]];
         frameList[AnimationType.END_CAST] = [1,[17,18,19,20]];
         frameList[AnimationType.DAMAGE] = [2,[0,1,2,3,4,5,6]];
         frameList[AnimationType.DIE] = [2,[7,8,9,10,11,12,13]];
         frameList[AnimationType.RESURREST] = [2,[13,12,11,10,9,8,7]];
         frameList[AnimationType.DEAD] = [2,[13]];
         defaultFps = 12;
         fpsList[AnimationType.USE_ITEM] = 6;
      }
   }
}

