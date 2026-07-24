package soul.utils
{
   import flash.display.ShaderJob;
   import flash.events.ShaderEvent;
   
   public class ShaderJobQueue
   {
      
      private static var jobQueue:Array = [];
      
      private static var processing:Boolean = false;
      
      public function ShaderJobQueue()
      {
         super();
      }
      
      public static function addToQueue(job:ShaderJob) : void
      {
         job.addEventListener(ShaderEvent.COMPLETE,processNext,false,int.MAX_VALUE,true);
         jobQueue.push(job);
         if(!processing)
         {
            processNext(null);
         }
      }
      
      public static function processNext(e:ShaderEvent) : void
      {
         if(jobQueue.length < 1)
         {
            processing = false;
            return;
         }
         processing = true;
         var job:ShaderJob = jobQueue.shift();
         job.start();
      }
   }
}

