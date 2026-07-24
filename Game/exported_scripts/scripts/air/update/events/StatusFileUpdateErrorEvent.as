package air.update.events
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   
   public class StatusFileUpdateErrorEvent extends ErrorEvent
   {
      
      public static const FILE_UPDATE_ERROR:String = "fileUpdateError";
      
      public function StatusFileUpdateErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = "", id:int = 0)
      {
         super(type,bubbles,cancelable,text,id);
      }
      
      override public function toString() : String
      {
         return "[StatusFileUpdateErrorEvent (type=" + type + " text=" + text + " id=" + errorID + ")]";
      }
      
      override public function clone() : Event
      {
         return new StatusFileUpdateErrorEvent(type,bubbles,cancelable,text,errorID);
      }
   }
}

