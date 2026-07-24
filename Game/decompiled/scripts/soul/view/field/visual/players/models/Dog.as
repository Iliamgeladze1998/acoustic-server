package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Dog extends UnitBitmap
   {
      
      public static const visualId:String = "dog";
      
      public function Dog(hsl:String = "")
      {
         super();
         frameWidth = 118;
         frameHeight = 118;
         library = "dog.swf";
         linkages = ["dog1"];
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
         frameList[AnimationType.WALK] = frameList[AnimationType.RUN] = [0,[28,29,30,31,32,33,34]];
         frameList[AnimationType.IDLE] = [0,[7]];
         nameHeight = 80;
         spriteCenter = new Point(-59,-80);
         hitArea = new Rectangle(20,35,80,68);
      }
   }
}

