package soul.event
{
   import flash.events.Event;
   
   public class SimpleUIEvent extends Event
   {
      
      public static const CREATION_COMPLETE:String = "creationComplete";
      
      public static const PREINITIALIZE:String = "preinitalize";
      
      public function SimpleUIEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

