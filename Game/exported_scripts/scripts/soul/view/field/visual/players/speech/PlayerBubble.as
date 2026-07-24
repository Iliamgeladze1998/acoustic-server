package soul.view.field.visual.players.speech
{
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import soul.view.ui.SimpleLabel;
   
   public class PlayerBubble extends Sprite
   {
      
      private static const COLOR_MAP:Object = {};
      
      private static const MAX_TEXT:uint = 50;
      
      private static const TEXT_WIDTH:uint = 200;
      
      private static const HIDE_INT:uint = 5000;
      
      private static const PADDING:uint = 5;
      
      private static const RADIUS:uint = 3;
      
      private static const TAIL_HEIGHT:uint = 10;
      
      private static const TAIL_WIDTH:uint = 8;
      
      private static const FILTERS:Array = [new GlowFilter(0,1,1.1,1.1,20),new DropShadowFilter(3,45,0,0.5)];
      
      COLOR_MAP[SpeechType.SHOUT] = 16720418;
      COLOR_MAP[SpeechType.SPEAK] = 3285006;
      COLOR_MAP[SpeechType.WHISPER] = 7829367;
      
      private var textField:TextField = new SimpleLabel();
      
      private var hideInt:uint;
      
      public function PlayerBubble()
      {
         super();
         this.textField.autoSize = TextFieldAutoSize.NONE;
         this.textField.width = TEXT_WIDTH;
         this.textField.textColor = 16777215;
         this.textField.multiline = true;
         this.textField.wordWrap = true;
         addChild(this.textField);
         visible = false;
         mouseEnabled = false;
         this.textField.mouseEnabled = false;
         filters = FILTERS;
         alpha = 0.7;
      }
      
      public function speak(text:String, type:String) : void
      {
         if(Boolean(this.hideInt))
         {
            this.hide();
         }
         var color:uint = uint(COLOR_MAP[type]);
         if(text.length > MAX_TEXT)
         {
            text = text.substr(0,MAX_TEXT) + "...";
         }
         this.textField.text = text;
         this.textField.x = -this.textField.textWidth / 2;
         this.textField.height = this.textField.textHeight + PADDING;
         this.textField.y = -this.textField.height;
         graphics.clear();
         var x1:int = this.textField.x;
         var x2:int = this.textField.x + this.textField.textWidth + PADDING;
         var y1:int = this.textField.y;
         var y2:int = this.textField.y + this.textField.textHeight + PADDING;
         var tx1:int = x1 + this.textField.textWidth * 0.2;
         var tx2:int = tx1 + TAIL_WIDTH;
         var ty:int = y2 + TAIL_HEIGHT + RADIUS;
         graphics.lineStyle(1,8814698,1,true);
         graphics.beginFill(color,0.6);
         graphics.drawPath(Vector.<int>([1,2,3,2,3,2,2,2,2,3,2,3]),Vector.<Number>([x1,y1 - RADIUS,x2,y1 - RADIUS,x2 + RADIUS,y1 - RADIUS,x2 + RADIUS,y1,x2 + RADIUS,y2,x2 + RADIUS,y2 + RADIUS,x2,y2 + RADIUS,tx2,y2 + RADIUS,tx2,ty,tx1,y2 + RADIUS,x1,y2 + RADIUS,x1 - RADIUS,y2 + RADIUS,x1 - RADIUS,y2,x1 - RADIUS,y1,x1 - RADIUS,y1 - RADIUS,x1,y1 - RADIUS]));
         graphics.endFill();
         visible = true;
         this.hideInt = setInterval(this.hide,HIDE_INT);
      }
      
      private function hide() : void
      {
         clearInterval(this.hideInt);
         this.hideInt = 0;
         visible = false;
      }
   }
}

