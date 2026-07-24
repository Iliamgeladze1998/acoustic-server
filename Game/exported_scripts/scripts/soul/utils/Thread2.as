package soul.utils
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getTimer;
   
   public class Thread2 extends EventDispatcher
   {
      
      private static var threadStack:Vector.<ThreadStackInfo>;
      
      private static var callLaterTimeout:uint;
      
      private static var running:Boolean;
      
      private static var currentSkip:int;
      
      private static const MAX_WORK_TIME:uint = 30;
      
      private static const NEXT_CHUNK_DELAY:uint = 30;
      
      private static const FRAME_SKIP:uint = 5;
      
      private static const ticker:Sprite = new Sprite();
      
      private var chunkFunction:Function;
      
      private var _running:Boolean;
      
      public function Thread2(ownerObject:DisplayObject = null)
      {
         super();
         if(Boolean(ownerObject))
         {
            ownerObject.addEventListener(Event.REMOVED_FROM_STAGE,this.onRemovedFromStage);
         }
      }
      
      private static function init() : void
      {
         if(running)
         {
            return;
         }
         ticker.addEventListener(Event.ENTER_FRAME,callLater);
      }
      
      private static function callLater(e:Event = null) : void
      {
         var finished:Boolean = false;
         var elapsedTime:uint = 0;
         if(Boolean(e))
         {
            if(currentSkip < FRAME_SKIP)
            {
               ++currentSkip;
               return;
            }
            ticker.removeEventListener(Event.ENTER_FRAME,callLater);
         }
         running = false;
         if(threadStack.length < 1)
         {
            return;
         }
         threadStack.sort(sorter);
         var tsi:ThreadStackInfo = threadStack.shift();
         var thread:Thread2 = tsi.thread;
         var startTime:int = getTimer();
         while(!finished)
         {
            finished = thread.chunkFunction();
            elapsedTime = getTimer() - startTime;
            if(!finished && elapsedTime > MAX_WORK_TIME)
            {
               tsi.workTime += elapsedTime;
               threadStack.push(tsi);
               ticker.addEventListener(Event.ENTER_FRAME,callLater);
               running = true;
               return;
            }
         }
         thread.complete();
         if(threadStack.length > 0)
         {
            ticker.addEventListener(Event.ENTER_FRAME,callLater);
            running = true;
         }
      }
      
      private static function sorter(a:ThreadStackInfo, b:ThreadStackInfo) : int
      {
         return a.workTime < b.workTime ? -1 : (a.workTime > b.workTime ? 1 : 0);
      }
      
      private function onRemovedFromStage(e:Event) : void
      {
         this.stop();
      }
      
      public function start(chunkFunction:Function) : void
      {
         this.stop();
         this.chunkFunction = chunkFunction;
         this._running = true;
         threadStack = threadStack || new Vector.<ThreadStackInfo>();
         threadStack.push(new ThreadStackInfo(this));
         init();
      }
      
      public function stop() : void
      {
         var sid:String = null;
         var id:uint = 0;
         var tsi:ThreadStackInfo = null;
         this._running = false;
         var ids:Vector.<uint> = new Vector.<uint>();
         for(sid in threadStack)
         {
            tsi = threadStack[sid];
            if(tsi.thread == this)
            {
               ids.unshift(uint(sid));
            }
         }
         for each(id in ids)
         {
            threadStack.splice(id,1);
         }
      }
      
      private function complete() : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function get running() : Boolean
      {
         return this._running;
      }
   }
}

class ThreadStackInfo
{
   
   public var thread:Thread2;
   
   public var workTime:uint;
   
   public function ThreadStackInfo(thread:Thread2)
   {
      super();
      this.thread = thread;
   }
}
