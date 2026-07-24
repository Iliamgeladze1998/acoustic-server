package soul.view.rtm
{
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import soul.model.system.Configuration;
   import soul.view.ui.Component;
   import soul.view.ui.SimpleLabel;
   
   public class RTMClock extends Component
   {
      
      private static const FILTER:GlowFilter = new GlowFilter(0,1,3,3,3);
      
      private static const TICK:uint = 60000;
      
      private var label:SimpleLabel = new SimpleLabel();
      
      private var timeout:uint;
      
      private var timer:uint;
      
      public function RTMClock()
      {
         super();
         width = 57;
         height = 16;
         this.label.filters = [FILTER];
         this.label.align = "center";
         addChild(this.label);
         var localDate:Date = new Date();
         var remoteDate:Date = Configuration.localDateToServer(localDate);
         var firstTimerStart:uint = 60 - remoteDate.seconds;
         this.timeout = setTimeout(this.startTimer,firstTimerStart * 1000);
         this.tick();
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
      }
      
      private function removed(e:Event) : void
      {
         clearTimeout(this.timeout);
         clearInterval(this.timer);
      }
      
      private function startTimer() : void
      {
         this.timer = setInterval(this.tick,TICK);
         this.tick();
      }
      
      private function tick() : void
      {
         var remoteDate:Date = Configuration.localDateToServer(new Date());
         var h:String = (remoteDate.hours < 10 ? "0" : "") + remoteDate.hours;
         var m:String = (remoteDate.minutes < 10 ? "0" : "") + remoteDate.minutes;
         this.label.text = h + ":" + m;
      }
      
      override protected function redraw() : void
      {
         super.redraw();
         this.label.width = width;
         this.label.height = height;
      }
   }
}

