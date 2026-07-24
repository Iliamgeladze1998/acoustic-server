package soul.view.field.visual.players.models
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import soul.model.field.LibraryManager;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.players.UnitBitmap;
   
   public class Contour extends UnitBitmap
   {
      
      public function Contour()
      {
         super();
         library = LibraryManager.mainLibrary;
         linkages = ["contour"];
         frameWidth = 45;
         frameHeight = 65;
         spriteCenter = new Point(-22,-58);
         defaultFps = 12;
         hitArea = new Rectangle(8,0,30,65);
         nameHeight = 95;
         frameList = {};
         frameList[AnimationType.IDLE] = [0,[2]];
         frameList[AnimationType.DEAD] = [0,[2]];
         frameList[AnimationType.WALK] = [0,[0,1,2,3,4,5,6]];
         frameList[AnimationType.RUN] = [0,[0,1,2,3,4,5,6]];
      }
   }
}

