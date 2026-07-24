package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class HumanSmall extends UnitBitmap
   {
      
      public static const visualId:String = "human_small";
      
      public function HumanSmall(hsl:String = "")
      {
         super();
         frameWidth = 103;
         frameHeight = 100;
         library = "human_small.swf";
         linkages = ["human1","human2","human3"];
         spriteCenter = new Point(-51,-79);
         hitArea = new Rectangle(21,15,45,70);
         nameHeight = 105;
         frameList[AnimationType.USE_ITEM] = [0,[14,15,16,17,18,17,18,17,18,17,18,19,20]];
         frameList[AnimationType.START_CAST] = [1,[0,1,2]];
         frameList[AnimationType.CAST] = [1,[2,3,4,3]];
         frameList[AnimationType.END_CAST] = [1,[3,4,5,6]];
         frameList[AnimationType.SPEAR] = [1,[7,8,9,10,11,12,13]];
         frameList[AnimationType.SWORD] = [1,[14,15,16,17,18,19,20]];
         frameList[AnimationType.START_BOW] = [2,[0,1,2]];
         frameList[AnimationType.BOW] = [2,[3]];
         frameList[AnimationType.END_BOW] = [2,[3,4,5,6]];
         frameList[AnimationType.DAMAGE] = [2,[7,8,9,10,11,12,13]];
         frameList[AnimationType.DIE] = [2,[14,15,16,17,18,19,20]];
         frameList[AnimationType.RESURREST] = [2,[20,19,18,17,16,15,14]];
         frameList[AnimationType.DEAD] = [2,[20]];
         defaultFps = 12;
         fpsList[AnimationType.USE_ITEM] = 6;
      }
   }
}

