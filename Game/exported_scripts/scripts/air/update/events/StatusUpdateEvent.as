package air.update.events
{
   import flash.events.Event;
   
   public class StatusUpdateEvent extends UpdateEvent
   {
      
      public static const UPDATE_STATUS:String = "updateStatus";
      
      public var details:Array = [];
      
      public var version:String = "";
      
      public var available:Boolean = false;
      
      public var versionLabel:String = "";
      
      public function StatusUpdateEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, available:Boolean = false, version:String = "", details:Array = null, versionLabel:String = "")
      {
         super(type,bubbles,cancelable);
         this.available = available;
         this.version = version;
         this.details = details == null ? [] : details;
         this.versionLabel = versionLabel;
      }
      
      override public function toString() : String
      {
         return "[StatusUpdateEvent (type=" + type + " available=" + this.available + " version=" + this.version + " details=" + this.details + " versionLabel=" + this.versionLabel + " )]";
      }
      
      override public function clone() : Event
      {
         return new StatusUpdateEvent(type,bubbles,cancelable,this.available,this.version,this.details,this.versionLabel);
      }
   }
}

