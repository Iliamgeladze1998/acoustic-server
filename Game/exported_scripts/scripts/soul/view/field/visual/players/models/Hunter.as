package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Hunter extends UnitBitmap
   {
      
      public static const visualId:String = "hunter";
      
      public function Hunter(hsl:String = "")
      {
         super();
         frameWidth = 95;
         frameHeight = 120;
         library = "hunter.swf";
         linkages = ["hunter1"];
         spriteCenter = new Point(-48,-104);
         hitArea = new Rectangle(19,6,57,101);
         nameHeight = 125;
         defaultFps = 12;
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,2,3,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,7,8,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10]];
         frameList[AnimationType.WALK] = [0,[11,12,13,14,15,16]];
         fpsList[AnimationType.WALK] = 9;
         fpsList[AnimationType.IDLE] = 9;
      }
   }
}

