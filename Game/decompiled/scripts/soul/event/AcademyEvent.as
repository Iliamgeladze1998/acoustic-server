package soul.event
{
   import flash.events.Event;
   
   public class AcademyEvent extends Event
   {
      
      public static const CHANGE_DISPOSITION:String = "CHANGE_DISPOSITION";
      
      public static const RESET_STATS:String = "RESET_STATS";
      
      public var data:String;
      
      public function AcademyEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

