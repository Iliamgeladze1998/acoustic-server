package soul.view.fps
{
   import flash.display.Shape;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.filters.DropShadowFilter;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import soul.controller.shortcut.Shortcut;
   import soul.controller.shortcut.ShortcutManager;
   import soul.net.ServerLayer;
   import soul.view.ui.Component;
   
   public class Fps extends Component
   {
      
      public static var fps:uint;
      
      private static var frames:uint;
      
      private static var totalFrames:uint;
      
      private static var averageFpsCount:uint;
      
      private static const PING_FREQ:uint = 2000;
      
      private static const AVERAGE_FRAME_COUNT:uint = 60;
      
      private static const FRAME_SHAPE:Shape = new Shape();
      
      private static var fpsInt:uint = setInterval(staticCountFps,1000);
      
      public static var averageFps:uint = uint.MAX_VALUE;
      
      FRAME_SHAPE.addEventListener(Event.ENTER_FRAME,onStaticFrame);
      
      private var updateInterval:uint;
      
      private var tLabel:TextField = new TextField();
      
      public function Fps()
      {
         super();
         this.visible = false;
         ShortcutManager.addShortcutListener(Shortcut.CTRL_ALT_F,this.showHide);
         this.tLabel.mouseEnabled = false;
         this.tLabel.defaultTextFormat = new TextFormat("Verdana",10,16777215);
         this.tLabel.width = 230;
         this.tLabel.height = 20;
         this.tLabel.multiline = this.tLabel.wordWrap = true;
         this.tLabel.text = "";
         this.tLabel.background = false;
         this.tLabel.selectable = false;
         this.tLabel.filters = [new DropShadowFilter(1,45,0,1,1,1,2)];
         this.tLabel.autoSize = TextFieldAutoSize.LEFT;
         addChild(this.tLabel);
      }
      
      private static function onStaticFrame(event:Event) : void
      {
         ++frames;
      }
      
      private static function staticCountFps() : void
      {
         fps = frames;
         frames = 0;
         totalFrames += fps;
         if(averageFpsCount < AVERAGE_FRAME_COUNT)
         {
            ++averageFpsCount;
            averageFps = uint.MAX_VALUE;
         }
         else
         {
            averageFps = totalFrames / averageFpsCount;
            totalFrames -= averageFps;
         }
      }
      
      public static function resetAverage() : void
      {
         averageFpsCount = 0;
      }
      
      private function showFps() : void
      {
         var s:Object = System;
         var latency:uint = ServerLayer.latency;
         var pingColor:String = latency <= 150 ? "#44FF44" : (latency <= 250 ? "#FFFF44" : "#FF4444");
         var mem:uint = System.privateMemory / 1048576;
         this.tLabel.htmlText = "<font color=\'#00FF00\'>fps:   </font>" + fps + "<br>ping: <font color=\'" + pingColor + "\'>" + latency + "</font><br><font color=\'#FF4444\'>mem:</font>" + mem + "Mb";
         setActualSize(this.tLabel.textWidth,this.tLabel.textHeight);
      }
      
      private function showHide(e:KeyboardEvent) : void
      {
         this.visible = !visible;
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = value;
         if(value)
         {
            frames = 0;
            this.updateInterval = setInterval(this.update,PING_FREQ);
         }
         else
         {
            clearInterval(this.updateInterval);
         }
      }
      
      private function update() : void
      {
         this.showFps();
         ServerLayer.ping(this.pong);
      }
      
      private function pong() : void
      {
      }
   }
}

