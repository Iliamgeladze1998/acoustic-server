package soul.view.ui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class Slider extends Component
   {
      
      private var lBtn:CachedImage = new CachedImage();
      
      private var rBtn:CachedImage = new CachedImage();
      
      private var thumb:CachedImage = new CachedImage();
      
      private var track:Sprite;
      
      private var thumbSpace:int;
      
      private var leftGap:int;
      
      private var rightGap:int;
      
      private var _value:int = 0;
      
      private var _maxValue:int = 0;
      
      private var _minValue:int = 0;
      
      public function Slider()
      {
         super();
         this.lBtn.source = UIAssets.scrollButtonDown;
         this.rBtn.source = UIAssets.scrollButtonUp;
         this.thumb.source = UIAssets.sliderThumb;
         this.track = new UIAssets.simpleBorder();
         this.track.height = 10;
         this.lBtn.rotation = 90;
         this.rBtn.rotation = 90;
         this.leftGap = this.lBtn.height;
         this.rightGap = this.rBtn.height;
         addChild(this.track);
         addChild(this.lBtn);
         addChild(this.rBtn);
         addChild(this.thumb);
         this.lBtn.addEventListener(MouseEvent.CLICK,this.onLeft);
         this.rBtn.addEventListener(MouseEvent.CLICK,this.onRight);
         this.track.addEventListener(MouseEvent.CLICK,this.onTrack);
         this.thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.onThumbDown);
         width = 100;
         height = 20;
      }
      
      private function onLeft(e:MouseEvent) : void
      {
         --this.value;
      }
      
      private function onRight(e:MouseEvent) : void
      {
         ++this.value;
      }
      
      private function onTrack(e:MouseEvent) : void
      {
         this.thumb.x = e.localX;
         this.countValueFromThumb();
      }
      
      private function onThumbDown(e:MouseEvent) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onThumbUp);
         this.thumb.startDrag(false,new Rectangle(this.leftGap,this.thumb.y,this.thumbSpace,0));
      }
      
      private function onThumbUp(e:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onThumbUp);
         this.thumb.stopDrag();
         this.countValueFromThumb();
      }
      
      private function countValueFromThumb() : void
      {
         this.value = Math.round(this._minValue + (this.thumb.x - this.leftGap) / this.thumbSpace * (this._maxValue - this._minValue));
      }
      
      [Bindable("valueChanged")]
      public function get value() : int
      {
         return this._value;
      }
      
      public function set value(v:int) : void
      {
         v = Math.max(this._minValue,v);
         v = Math.min(this._maxValue,v);
         this._value = v;
         if(this._maxValue != this._minValue)
         {
            this.thumb.x = this.leftGap + (this.value - this._minValue) / (this._maxValue - this._minValue) * this.thumbSpace;
         }
         else
         {
            this.thumb.x = this.leftGap;
         }
         dispatchEvent(new Event("valueChanged"));
      }
      
      [Bindable("maxValueChanged")]
      public function get maxValue() : int
      {
         return this._maxValue;
      }
      
      public function set maxValue(value:int) : void
      {
         if(this._maxValue == value)
         {
            return;
         }
         this._maxValue = value;
         dispatchEvent(new Event("maxValueChanged"));
         this.value = this._value;
      }
      
      [Bindable("minValueChanged")]
      public function get minValue() : int
      {
         return this._minValue;
      }
      
      public function set minValue(value:int) : void
      {
         if(this._minValue == value)
         {
            return;
         }
         this._minValue = value;
         dispatchEvent(new Event("minValueChanged"));
         this.value = this._value;
      }
      
      override protected function redraw() : void
      {
         super.redraw();
         this.lBtn.y = Math.round((_height - this.lBtn.width) / 2);
         this.lBtn.x = this.leftGap;
         this.rBtn.y = Math.round((_height - this.rBtn.width) / 2);
         this.rBtn.x = _width;
         this.thumb.y = Math.round((_height - this.thumb.height) / 2);
         var trackSize:int = _width - this.leftGap - this.rightGap;
         this.thumbSpace = trackSize - this.thumb.width;
         var percent:Number = this._maxValue == this._minValue ? 0 : (this._value - this._minValue) / (this._maxValue - this._minValue);
         this.track.y = Math.round((_height - this.track.height) / 2);
         this.track.x = this.leftGap;
         this.track.width = trackSize;
         this.thumb.x = this.leftGap + this.thumbSpace * percent;
      }
   }
}

