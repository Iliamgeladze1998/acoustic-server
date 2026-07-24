package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Darkvil extends UnitBitmap
   {
      
      public function Darkvil(hsl:String = "")
      {
         super();
         frameWidth = 117;
         frameHeight = 140;
         library = "darkvil.swf";
         linkages = ["darkvil1","darkvil2","darkvil3"];
         nameHeight = 120;
         defaultFps = 12;
         frameList[AnimationType.IDLE] = [0,[0,0,0,0,0,0,0,1,2,3]];
         frameList[AnimationType.WALK] = [1,[0,1,2,3,4,5,6]];
         frameList[AnimationType.SWORD] = [1,[7,8,9,10,11,12,13]];
         frameList[AnimationType.START_BOW] = [1,[14,15,16]];
         frameList[AnimationType.BOW] = [1,[17]];
         frameList[AnimationType.END_BOW] = [1,[17,18,19,20]];
         frameList[AnimationType.START_CAST] = [2,[0,1,2]];
         frameList[AnimationType.CAST] = [2,[2,3,4,3]];
         frameList[AnimationType.END_CAST] = [2,[3,4,5,6]];
         frameList[AnimationType.DAMAGE] = [2,[7,8,9,10,11,12,13]];
         frameList[AnimationType.DIE] = [2,[14,15,16,17,18,19,20]];
         frameList[AnimationType.RESURREST] = [2,[20,19,18,17,16,15,14]];
         frameList[AnimationType.DEAD] = [2,[20]];
         spriteCenter = new Point(-56,-110);
         hitArea = new Rectangle(27,16,60,104);
      }
   }
}

