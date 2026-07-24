package soul.event
{
   import flash.events.Event;
   
   public class CraftEvent extends Event
   {
      
      public static const CRAFT:String = "CRAFT";
      
      public static const CANCEL:String = "CANCEL";
      
      public static const CRAFT_STARTED:String = "CRAFT_STARTED";
      
      public static const CRAFT_COMPLETE:String = "CRAFT_COMPLETE";
      
      public static const CRAFT_FINISHED:String = "CRAFT_FINISHED";
      
      public static const CRAFT_CANCELED:String = "CRAFT_CANCELED";
      
      public var time:uint;
      
      public function CraftEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

