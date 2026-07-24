package soulex.event
{
   import flash.events.Event;
   
   public class ContentEvent extends Event
   {
      
      public static const DATA_OK:String = "DATA_OK";
      
      public static const UPDATE_CANCELED:String = "UPDATE_CANCELED";
      
      public static const UPDATE_ERROR:String = "UPDATE_ERROR";
      
      public var details:String;
      
      public function ContentEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

