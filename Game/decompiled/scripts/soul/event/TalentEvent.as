package soul.event
{
   import flash.events.Event;
   
   public class TalentEvent extends Event
   {
      
      public static const PURCHASE:String = "PURCHASE";
      
      public var id:String;
      
      public function TalentEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

