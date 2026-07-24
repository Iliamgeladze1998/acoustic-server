package soulex.event
{
   import flash.events.Event;
   
   public class LoginEvent extends Event
   {
      
      public static const CONFIRM:String = "CONFIRM";
      
      public static const LOCALE_CHANGED:String = "LOCALE_CHANGED";
      
      public static const COMPLETE:String = "COMPLETE";
      
      public static const EXIT:String = "EXIT";
      
      public var locale:String;
      
      public var user:String;
      
      public var password:String;
      
      public function LoginEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

