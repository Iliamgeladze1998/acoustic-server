package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Shady extends UnitBitmap
   {
      
      public static const visualId:String = "shady";
      
      public function Shady(hsl:String = "")
      {
         super();
         frameWidth = 105;
         frameHeight = 112;
         library = "shady.swf";
         linkages = ["shady1"];
         spriteCenter = new Point(-53,-100);
         hitArea = new Rectangle(27,7,59,98);
         nameHeight = 120;
         defaultFps = 12;
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,6,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,10,11,12,13,14,15,16,17,18]];
         frameList[AnimationType.WALK] = [0,[19,20,21,22,23,24,25]];
         fpsList[AnimationType.WALK] = 9;
         fpsList[AnimationType.IDLE] = 9;
      }
   }
}

