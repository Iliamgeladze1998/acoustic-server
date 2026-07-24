package soul.view.rtm
{
   import flash.events.TimerEvent;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   import soul.utils.NumberUtils;
   import soul.view.ui.Label;
   
   public class RTMTimer extends Label
   {
      
      private static const FILTERS:Array = [new GlowFilter(0,1,1.5,1.5,10),new DropShadowFilter(4,45,0,1,4,4,0.7)];
      
      private static const MIN_TIMEOUT:uint = 2000;
      
      private static const SECOND:int = 1000;
      
      private static const MINUTE:int = SECOND * 60;
      
      private static const TIMER:Timer = new Timer(200);
      
      private var endTime:uint;
      
      public function RTMTimer()
      {
         super();
         mouseChildren = mouseEnabled = false;
         fontSize = 16;
         filters = FILTERS;
         visible = false;
         color = 16777215;
         bold = true;
         TIMER.addEventListener(TimerEvent.TIMER,this.showTime);
      }
      
      public function set timeout(value:int) : void
      {
         TIMER.stop();
         if(value < MIN_TIMEOUT)
         {
            visible = false;
            return;
         }
         visible = true;
         this.endTime = getTimer() + value;
         TIMER.start();
         this.showTime(null);
      }
      
      private function showTime(e:TimerEvent) : void
      {
         var timeLeft:int = this.endTime - getTimer();
         if(timeLeft < 1)
         {
            this.timeout = 0;
            return;
         }
         var minutes:int = int(timeLeft / MINUTE);
         timeLeft -= minutes * MINUTE;
         var seconds:int = int(uint(timeLeft / SECOND));
         text = NumberUtils.addZero(minutes) + ":" + NumberUtils.addZero(seconds);
      }
      
      override public function destroy() : void
      {
         TIMER.removeEventListener(TimerEvent.TIMER,this.showTime);
         super.destroy();
      }
   }
}

