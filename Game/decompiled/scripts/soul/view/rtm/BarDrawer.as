package soul.view.rtm
{
   import flash.display.Shape;
   import flash.events.Event;
   import flash.filters.DropShadowFilter;
   import soul.view.ui.Canvas;
   import soul.view.ui.Label;
   import soul.view.ui.soul_internal;
   
   use namespace soul_internal;
   
   public class BarDrawer extends Canvas
   {
      
      public static const RIGHT:String = "RIGHT";
      
      public static const LEFT:String = "LEFT";
      
      public static const UP:String = "UP";
      
      public static const DOWN:String = "DOWN";
      
      public static const HP_COLORS:Array = [16711680,16711680,13421056,30464];
      
      private static const ALERT_PERCENT:int = 35;
      
      private static const blinkSpeed:int = 10;
      
      public var colors:Array;
      
      public var alertsActive:Boolean;
      
      private var shape:Shape = new Shape();
      
      private var label:Label = new Label();
      
      private var _direction:String = "RIGHT";
      
      private var _value:int;
      
      private var _maxValue:int = 1;
      
      private var _barColor:int = 16777215;
      
      private var blinkDirection:int = 10;
      
      public function BarDrawer()
      {
         super();
         this.label.horizontalCenter = 0;
         this.label.verticalCenter = 0;
         this.label.color = 16303533;
         this.label.filters = [new DropShadowFilter(1,60,0,1,0.85,0.85,1)];
         soul_internal::$addChildAt(this.shape,1);
         addChild(this.label);
      }
      
      public function set direction(value:String) : void
      {
         if(this._direction == value)
         {
            return;
         }
         this._direction = value;
         this.redraw();
      }
      
      public function set value(val:int) : void
      {
         this._value = val;
         this.label.text = this._value + "/" + this._maxValue;
         this.redraw();
      }
      
      public function set maxValue(val:int) : void
      {
         this._maxValue = val;
         this.label.text = this._value + "/" + this._maxValue;
         this.redraw();
      }
      
      public function set labelVisible(value:Boolean) : void
      {
         this.label.visible = value;
      }
      
      public function set labelSize(value:Number) : void
      {
         this.label.fontSize = value;
      }
      
      public function set barColor(value:int) : void
      {
         this._barColor = value;
         this.redraw();
      }
      
      override protected function redraw() : void
      {
         var shift:int = 0;
         var colorNum:int = 0;
         var index:int = 0;
         var c1:int = 0;
         var c2:int = 0;
         var b1:int = 0;
         var g1:int = 0;
         var r1:int = 0;
         var b2:int = 0;
         var g2:int = 0;
         var r2:int = 0;
         var portion:int = 0;
         var lshift:int = 0;
         var rshift:int = 0;
         var r:int = 0;
         var g:int = 0;
         var b:int = 0;
         var h:Number = NaN;
         var w:Number = NaN;
         super.redraw();
         this.shape.graphics.clear();
         if(width < 1 || this._maxValue <= 0)
         {
            return;
         }
         if(Boolean(this.colors))
         {
            shift = this._value / this._maxValue * 100;
            colorNum = this.colors.length - 1;
            index = shift / 100 * colorNum;
            if(this._value == this._maxValue)
            {
               this._barColor = this.colors[index];
            }
            else
            {
               c1 = int(this.colors[index]);
               c2 = int(this.colors[index + 1]);
               b1 = c1 & 0xFF;
               g1 = c1 >> 8 & 0xFF;
               r1 = c1 >> 16 & 0xFF;
               b2 = c2 & 0xFF;
               g2 = c2 >> 8 & 0xFF;
               r2 = c2 >> 16 & 0xFF;
               portion = 100 / colorNum;
               lshift = (shift - 1) % portion;
               rshift = portion - lshift;
               r = r2 * lshift / portion + r1 * rshift / portion;
               g = g2 * lshift / portion + g1 * rshift / portion;
               b = b2 * lshift / portion + b1 * rshift / portion;
               this._barColor = r << 16 | g << 8 | b;
            }
         }
         if(this.alertsActive)
         {
            if(shift <= ALERT_PERCENT && !hasEventListener(Event.ENTER_FRAME))
            {
               addEventListener(Event.ENTER_FRAME,this.blink);
            }
            if(shift > ALERT_PERCENT && hasEventListener(Event.ENTER_FRAME))
            {
               removeEventListener(Event.ENTER_FRAME,this.blink);
               this.shape.alpha = 1;
            }
         }
         this.shape.graphics.beginFill(this._barColor,1);
         switch(this._direction)
         {
            case UP:
               h = Math.round(height / this._maxValue * this._value);
               this.shape.graphics.drawRect(0,height - h,width,h);
               break;
            case DOWN:
               this.shape.graphics.drawRect(0,0,width,Math.round(height / this._maxValue * this._value));
               break;
            case LEFT:
               w = Math.round(width / this._maxValue * this._value);
               this.shape.graphics.drawRect(width - w,0,w,height);
               break;
            case RIGHT:
            default:
               this.shape.graphics.drawRect(0,0,Math.round(width / this._maxValue * this._value),height);
         }
         this.shape.graphics.endFill();
      }
      
      private function blink(e:Event) : void
      {
         this.shape.alpha += this.blinkDirection / 100;
         if(this.shape.alpha <= 0 || this.shape.alpha >= 1)
         {
            this.blinkDirection = -this.blinkDirection;
         }
      }
   }
}

