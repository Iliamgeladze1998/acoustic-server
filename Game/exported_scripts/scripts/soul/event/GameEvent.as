package soul.event
{
   import flash.events.Event;
   
   public class GameEvent extends Event
   {
      
      public static const USER_LOGOUT:String = "USER_LOGOUT";
      
      public static const CHARACTER_LOGOUT:String = "CHARACTER_LOGOUT";
      
      public static const SWITCH_FULLSCREEN:String = "SWITCH_FULLSCREEN";
      
      public function GameEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

