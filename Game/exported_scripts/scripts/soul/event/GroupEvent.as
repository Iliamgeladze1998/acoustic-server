package soul.event
{
   import flash.events.Event;
   
   public class GroupEvent extends Event
   {
      
      public static const INVITE:String = "soul.event.group.GroupEvent.INVITE";
      
      public static const REMOVE:String = "soul.event.group.GroupEvent.REMOVE";
      
      public static const PROMOTE:String = "soul.event.group.GroupEvent.PROMOTE";
      
      public static const LOOT_MINING:String = "soul.event.group.GroupEvent.LOOT_MINING";
      
      public var data:*;
      
      public function GroupEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

