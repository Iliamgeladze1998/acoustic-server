package soul.utils
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class StackLoader extends URLLoader
   {
      
      private static const NEXT_CAN_START:String = "NEXT_CAN_START";
      
      private static const stack:Vector.<StackLoader> = new Vector.<StackLoader>();
      
      private var request:URLRequest;
      
      public function StackLoader(request:URLRequest = null)
      {
         super(request);
      }
      
      override public function load(request:URLRequest) : void
      {
         var lastLoader:StackLoader = null;
         this.request = request;
         if(stack.length > 0)
         {
            lastLoader = stack[stack.length - 1];
            lastLoader.addEventListener(NEXT_CAN_START,this.nextCanStart);
            stack.push(this);
         }
         else
         {
            stack.push(this);
            this.delayedLoad();
         }
      }
      
      private function nextCanStart(e:Event) : void
      {
         if(stack.length < 1)
         {
            return;
         }
         var firstLoader:StackLoader = stack[0];
         firstLoader.delayedLoad();
      }
      
      private function currentFinished(e:Event) : void
      {
         removeEventListener(Event.COMPLETE,this.currentFinished);
         removeEventListener(IOErrorEvent.IO_ERROR,this.currentFinished);
         removeEventListener(IOErrorEvent.DISK_ERROR,this.currentFinished);
         removeEventListener(IOErrorEvent.NETWORK_ERROR,this.currentFinished);
         var currentIndex:int = stack.indexOf(this);
         if(currentIndex > -1)
         {
            stack.splice(currentIndex,1);
         }
         dispatchEvent(new Event(NEXT_CAN_START));
      }
      
      private function delayedLoad() : void
      {
         addEventListener(Event.COMPLETE,this.currentFinished,false,100);
         addEventListener(IOErrorEvent.IO_ERROR,this.currentFinished,false,100);
         addEventListener(IOErrorEvent.DISK_ERROR,this.currentFinished,false,100);
         addEventListener(IOErrorEvent.NETWORK_ERROR,this.currentFinished,false,100);
         super.load(this.request);
      }
   }
}

