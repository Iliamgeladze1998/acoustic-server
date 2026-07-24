package soul.view.rtm
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.utils.getTimer;
   import soul.view.ui.Component;
   
   public class CastBar extends Component
   {
      
      private var total:int;
      
      private var startTime:int;
      
      private var bar:Sprite = new Sprite();
      
      private var glow:Sprite = new Sprite();
      
      public function CastBar()
      {
         super();
         width = 100;
         height = 10;
         graphics.lineStyle(2,0,1);
         graphics.beginFill(5583650,0.3);
         graphics.drawRect(0,0,width,height);
         filters = [new DropShadowFilter(2,45,0,1,3,3),new DropShadowFilter(2,45,0,1,3,3,1,1,true)];
         this.bar.graphics.beginFill(65280);
         this.bar.graphics.drawRect(0,0,width,height);
         this.bar.graphics.endFill();
         this.glow.graphics.beginFill(16777215,0.5);
         this.glow.graphics.drawRect(0,0,3,10);
         this.glow.graphics.endFill();
         this.glow.filters = [new DropShadowFilter(1,175,16777215,1,13,17,10,2)];
         addChild(this.bar);
         addChild(this.glow);
         visible = false;
      }
      
      public function set time(value:int) : void
      {
         if(value < 500)
         {
            this.stopCast();
            return;
         }
         visible = true;
         this.total = value;
         this.startTime = getTimer();
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      private function onEnterFrame(e:Event) : void
      {
         var progress:Number = (getTimer() - this.startTime) / this.total;
         if(progress > 1)
         {
            this.stopCast();
            return;
         }
         this.bar.scaleX = progress;
         this.glow.x = this.bar.width;
      }
      
      private function stopCast() : void
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnterFrame);
         visible = false;
      }
   }
}

