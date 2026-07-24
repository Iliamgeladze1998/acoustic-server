package soul.event
{
   import flash.events.Event;
   
   public class MiniMapEvent extends Event
   {
      
      public static const MAP_CHANGED:String = "MAP_CHANGED";
      
      public static const POV_CHANGED:String = "POV_CHANGED";
      
      public static const UNITS_CHANGED:String = "UNITS_CHANGED";
      
      public static const UNITS_MOVED:String = "UNITS_MOVED";
      
      public static const POI_CHANGED:String = "POI_CHANGED";
      
      public function MiniMapEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

