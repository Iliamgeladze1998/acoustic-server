package soul.event
{
   import flash.events.Event;
   
   public class ArenaEvent extends Event
   {
      
      public static const STATE_CHANGED:String = "STATE_CHANGED";
      
      public static const TICK:String = "TICK";
      
      public static const CREATE_FIGHT_TYPE_CLAIM:String = "CREATE_FIGHT_TYPE_CLAIM";
      
      public static const CREATE_ARENA_CLAIM:String = "CREATE_ARENA_CLAIM";
      
      public static const CANCEL:String = "CANCEL";
      
      public var data:*;
      
      public function ArenaEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

