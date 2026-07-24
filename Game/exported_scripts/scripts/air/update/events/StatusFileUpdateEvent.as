package air.update.events
{
   import flash.events.Event;
   
   public class StatusFileUpdateEvent extends UpdateEvent
   {
      
      public static const FILE_UPDATE_STATUS:String = "fileUpdateStatus";
      
      public var path:String = null;
      
      public var version:String = "";
      
      public var available:Boolean = false;
      
      public var versionLabel:String = "";
      
      public function StatusFileUpdateEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, available:Boolean = false, version:String = "", path:String = "", versionLabel:String = "")
      {
         super(type,bubbles,cancelable);
         this.available = available;
         this.version = version;
         this.path = path;
         this.versionLabel = versionLabel;
      }
      
      override public function toString() : String
      {
         return "[StatusFileUpdateEvent (type=" + type + " available=" + this.available + " version=" + this.version + " path=" + this.path + " versionLabel=" + this.versionLabel + ")]";
      }
      
      override public function clone() : Event
      {
         return new StatusFileUpdateEvent(type,bubbles,cancelable,this.available,this.version,this.path,this.versionLabel);
      }
   }
}

