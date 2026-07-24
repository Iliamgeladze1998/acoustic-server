package soul.utils
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setTimeout;
   
   public class Thread
   {
      
      private static const MAX_TIME:uint = 50;
      
      private static const CHUNK_INTERVAL:uint = 100;
      
      public var maxChunkTime:uint;
      
      public var chunkInterval:uint;
      
      private var object:Object;
      
      private var removed:Boolean;
      
      private var chunk:Function;
      
      private var chunkStartTime:uint;
      
      private var nextChunkTimer:uint;
      
      public function Thread(o:Object = null)
      {
         super();
         this.maxChunkTime = MAX_TIME;
         this.chunkInterval = CHUNK_INTERVAL;
         if(!o)
         {
            return;
         }
         this.object = o;
         if(o is DisplayObject)
         {
            DisplayObject(o).addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStage);
         }
      }
      
      private function removedFromStage(e:Event) : void
      {
         if(e.target != this.object)
         {
            return;
         }
         this.removed = true;
         this.stop();
      }
      
      public function start(chunk:Function) : void
      {
         this.chunk = chunk;
         clearTimeout(this.nextChunkTimer);
         this.callLater();
      }
      
      public function check() : Boolean
      {
         if(this.removed)
         {
            return false;
         }
         if(getTimer() - this.chunkStartTime > this.maxChunkTime)
         {
            this.nextChunkTimer = setTimeout(this.callLater,this.chunkInterval);
            return false;
         }
         return true;
      }
      
      private function callLater(e:Event = null) : void
      {
         this.chunkStartTime = getTimer();
         this.chunk();
      }
      
      public function stop() : void
      {
         this.removed = true;
         clearTimeout(this.nextChunkTimer);
      }
   }
}

