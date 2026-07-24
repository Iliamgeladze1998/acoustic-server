package soul.model.rtm
{
   import flash.display.Bitmap;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   
   public class MiniMapModel extends EventDispatcher
   {
      
      public static const SCALE:Number = 0.05;
      
      public var miniMapSnapshot:Bitmap;
      
      public var pov:Point;
      
      public var questDetails:Array;
      
      public function MiniMapModel()
      {
         super();
      }
   }
}

