package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class AIREvent extends Event
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      public static const APPLICATION_ACTIVATE:String = "applicationActivate";
      
      public static const APPLICATION_DEACTIVATE:String = "applicationDeactivate";
      
      public static const WINDOW_ACTIVATE:String = "windowActivate";
      
      public static const WINDOW_DEACTIVATE:String = "windowDeactivate";
      
      public static const WINDOW_COMPLETE:String = "windowComplete";
      
      public function AIREvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         return new AIREvent(type,bubbles,cancelable);
      }
   }
}

