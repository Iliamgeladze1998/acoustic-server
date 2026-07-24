package soul.view.loading
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import soul.view.ui.SimpleLabel;
   
   public class LoadingScreen extends Sprite
   {
      
      private static const imageClass:Class = LoadingScreen_imageClass;
      
      private static const progressBarClass:Class = LoadingScreen_progressBarClass;
      
      private static const LABEL_BOTTOM:uint = 150;
      
      private static const LABEL_FILTERS:Array = [new DropShadowFilter(2,45,0,1,2,2,5)];
      
      private static const FORMAT:TextFormat = new TextFormat("Tahoma, Vedana",15,15772262);
      
      FORMAT.align = TextFormatAlign.CENTER;
      
      private var progressBar:Sprite = new progressBarClass();
      
      private var bar:Sprite = this.progressBar.getChildByName("bar") as Sprite;
      
      private var image:Bitmap = new imageClass();
      
      private var percents:SimpleLabel = new SimpleLabel();
      
      private var label:SimpleLabel = new SimpleLabel();
      
      private var tipLabel:TextField = new TextField();
      
      public function LoadingScreen()
      {
         super();
         this.percents.autoSize = TextFieldAutoSize.NONE;
         this.percents.defaultTextFormat = FORMAT;
         this.percents.width = 268;
         this.percents.x = -this.percents.width >> 1;
         this.percents.y = -12;
         this.percents.filters = LABEL_FILTERS;
         this.label.autoSize = TextFieldAutoSize.NONE;
         this.label.defaultTextFormat = FORMAT;
         this.label.width = 268;
         this.label.x = -this.label.width >> 1;
         this.label.y = 30;
         this.label.filters = LABEL_FILTERS;
         this.tipLabel.defaultTextFormat = new TextFormat("Tahoma, Vedana",20,15772262);
         this.tipLabel.filters = LABEL_FILTERS;
         this.tipLabel.autoSize = TextFieldAutoSize.LEFT;
         this.tipLabel.selectable = false;
         this.progressBar.x = -this.progressBar.width >> 1;
         this.progressBar.y = -this.progressBar.height >> 1;
         this.image.x = -this.image.width >> 1;
         this.image.y = -this.image.height;
         addChild(this.image);
         addChild(this.progressBar);
         addChild(this.percents);
         addChild(this.label);
         addChild(this.tipLabel);
         addEventListener(Event.ADDED_TO_STAGE,this.added);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
      }
      
      private function added(e:Event) : void
      {
         stage.addEventListener(Event.RESIZE,this.resized);
         this.center();
      }
      
      private function removed(e:Event) : void
      {
         stage.removeEventListener(Event.RESIZE,this.resized);
      }
      
      private function resized(e:Event) : void
      {
         this.center();
      }
      
      private function center() : void
      {
         if(!stage)
         {
            return;
         }
         var w:uint = uint(stage.stageWidth);
         var h:uint = uint(stage.stageHeight);
         x = w >> 1;
         y = h >> 1;
         this.tipLabel.y = y - LABEL_BOTTOM;
         this.tipLabel.x = -(this.tipLabel.width >> 1);
      }
      
      public function set progress(value:Number) : void
      {
         value = Math.max(0,value);
         value = Math.min(1,value);
         this.bar.scaleX = value;
         this.percents.text = Math.round(value * 100) + "%";
      }
      
      public function set action(value:String) : void
      {
         this.label.text = value;
      }
      
      public function set tip(value:String) : void
      {
         this.tipLabel.text = value;
         this.center();
      }
   }
}

