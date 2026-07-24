package mx.events
{
   import flash.events.Event;
   import mx.core.IWindow;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class WindowExistenceEvent extends Event
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      public static const WINDOW_CREATE:String = "globalNotifyWindowCreate";
      
      public static const WINDOW_CREATING:String = "globalNotifyWindowCreating";
      
      public static const WINDOW_CLOSE:String = "globalNotifyWindowClose";
      
      public var window:IWindow;
      
      public function WindowExistenceEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, window:IWindow = null)
      {
         super(type,bubbles,cancelable);
         this.window = window;
      }
      
      override public function clone() : Event
      {
         return new WindowExistenceEvent(type,bubbles,cancelable,this.window);
      }
   }
}

