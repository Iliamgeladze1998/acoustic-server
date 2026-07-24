package air.update.events
{
   import flash.events.Event;
   
   public class UpdateEvent extends Event
   {
      
      public static const INITIALIZED:String = "initialized";
      
      public static const BEFORE_INSTALL:String = "beforeInstall";
      
      public static const CHECK_FOR_UPDATE:String = "checkForUpdate";
      
      public static const DOWNLOAD_START:String = "downloadStart";
      
      public static const DOWNLOAD_COMPLETE:String = "downloadComplete";
      
      public function UpdateEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function toString() : String
      {
         return "[UpdateEvent (type=" + type + ")]";
      }
      
      override public function clone() : Event
      {
         return new UpdateEvent(type,bubbles,cancelable);
      }
   }
}

