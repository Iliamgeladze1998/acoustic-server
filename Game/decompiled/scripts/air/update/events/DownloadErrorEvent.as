package air.update.events
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   
   public class DownloadErrorEvent extends ErrorEvent
   {
      
      public static const DOWNLOAD_ERROR:String = "downloadError";
      
      public var subErrorID:int = 0;
      
      public function DownloadErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = "", id:int = 0, subErrorID:int = 0)
      {
         super(type,bubbles,cancelable,text,id);
         this.subErrorID = subErrorID;
      }
      
      override public function toString() : String
      {
         return "[DownloadErrorEvent (type=" + type + " text=" + text + " id=" + errorID + " subErrorID=" + this.subErrorID + ")]";
      }
      
      override public function clone() : Event
      {
         return new DownloadErrorEvent(type,bubbles,cancelable,text,errorID,this.subErrorID);
      }
   }
}

