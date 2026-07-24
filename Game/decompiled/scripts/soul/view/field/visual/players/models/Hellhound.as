package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Hellhound extends UnitBitmap
   {
      
      public function Hellhound(hsl:String = "")
      {
         super();
         frameWidth = 124;
         frameHeight = 103;
         library = "hellhound.swf";
         linkages = ["hellhound1","hellhound2"];
         defaultFps = 12;
         spriteCenter = new Point(-58,-72);
         hitArea = new Rectangle(22,20,75,65);
         nameHeight = 85;
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[21]];
         frameList[AnimationType.DEAD] = [1,[20]];
         frameList[AnimationType.WALK] = [0,[1,2,3,4,5,6,7]];
         frameList[AnimationType.RUN] = [0,[8,9,10,11,12,13,14]];
         frameList[AnimationType.SWORD] = [0,[15,16,17,18,19,20,21]];
         frameList[AnimationType.START_CAST] = [1,[0,1,2]];
         frameList[AnimationType.CAST] = [1,[3]];
         frameList[AnimationType.END_CAST] = [1,[3,4,5,6]];
         frameList[AnimationType.DAMAGE] = [1,[7,8,9,10,11,12,13]];
         frameList[AnimationType.DIE] = [1,[14,15,16,17,18,19,20]];
         frameList[AnimationType.RESURREST] = [1,[20,19,18,17,16,15,14]];
      }
   }
}

