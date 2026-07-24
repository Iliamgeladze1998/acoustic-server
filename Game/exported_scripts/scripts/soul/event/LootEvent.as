package soul.event
{
   import flash.events.Event;
   
   public class LootEvent extends Event
   {
      
      public static const TAKE_ALL:String = "TAKE_ALL";
      
      public static const CONFIRM:String = "CONFIRM";
      
      public function LootEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

