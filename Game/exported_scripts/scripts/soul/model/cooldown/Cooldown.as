package soul.model.cooldown
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class Cooldown extends EventDispatcher
   {
      
      public static const PROGRESS_CHANGED:String = "PROGRESS_CHANGED";
      
      public var id:String;
      
      public var total:int;
      
      private var _progress:int;
      
      public var startTime:int;
      
      public function Cooldown(id:String = null, total:int = 0, progress:int = 0)
      {
         super();
         this.id = id;
         this.total = total;
         this.progress = progress;
      }
      
      public function set progress(value:int) : void
      {
         if(value == this._progress)
         {
            return;
         }
         this._progress = value;
         if(hasEventListener(PROGRESS_CHANGED))
         {
            dispatchEvent(new Event(PROGRESS_CHANGED));
         }
      }
      
      public function get progress() : int
      {
         return this._progress;
      }
      
      override public function toString() : String
      {
         return "Cooldown: " + this.id + " " + this.startTime + " " + this.progress + "/" + this.total;
      }
   }
}

