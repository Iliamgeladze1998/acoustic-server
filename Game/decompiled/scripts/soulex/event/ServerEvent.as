package soulex.event
{
   import flash.events.Event;
   
   public class ServerEvent extends Event
   {
      
      public static const SERVER_SELECTED:String = "SERVER_SELECTED";
      
      public var index:int;
      
      public function ServerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

