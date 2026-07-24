package air.update.events
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   
   public class StatusUpdateErrorEvent extends ErrorEvent
   {
      
      public static const UPDATE_ERROR:String = "updateError";
      
      public var subErrorID:int = 0;
      
      public function StatusUpdateErrorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, text:String = "", id:int = 0, subErrorID:int = 0)
      {
         super(type,bubbles,cancelable,text,id);
         this.subErrorID = subErrorID;
      }
      
      override public function toString() : String
      {
         return "[StatusUpdateErrorEvent (type=" + type + " text=" + text + " id=" + errorID + " + subErrorID=" + this.subErrorID + ")]";
      }
      
      override public function clone() : Event
      {
         return new StatusUpdateErrorEvent(type,bubbles,cancelable,text,errorID,this.subErrorID);
      }
   }
}

