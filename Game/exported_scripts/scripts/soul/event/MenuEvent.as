package soul.event
{
   import flash.events.Event;
   
   public class MenuEvent extends Event
   {
      
      public static const ITEM_CLICK:String = "ITEM_CLICK";
      
      public var item:Object;
      
      public function MenuEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

