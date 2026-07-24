package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class HellhoundSmall extends UnitBitmap
   {
      
      public static const visualId:String = "hellhound_small";
      
      public function HellhoundSmall(hsl:String = "")
      {
         super();
         frameWidth = 82;
         frameHeight = 70;
         library = "hellhound_small.swf";
         linkages = ["hellhound1","hellhound2"];
         defaultFps = 12;
         spriteCenter = new Point(-40,-50);
         hitArea = new Rectangle(12,10,55,55);
         nameHeight = 85;
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[0]];
         frameList[AnimationType.DEAD] = [1,[13]];
         frameList[AnimationType.WALK] = [0,[1,2,3,4,5,6,7]];
         frameList[AnimationType.RUN] = [0,[8,9,10,11,12,13,14]];
         frameList[AnimationType.SWORD] = [0,[15,16,17,18,19,20,21]];
         frameList[AnimationType.START_CAST] = [0,[22,23,24]];
         frameList[AnimationType.CAST] = [0,[25,26]];
         frameList[AnimationType.END_CAST] = [0,[25,26,27,28]];
         frameList[AnimationType.DAMAGE] = [1,[0,1,2,3,4,5,6]];
         frameList[AnimationType.DIE] = [1,[7,8,9,10,11,12,13]];
         frameList[AnimationType.RESURREST] = [1,[13,12,11,10,9,8,7]];
      }
   }
}

