package soul.view.ui
{
   import flash.events.Event;
   
   public class ScrollBar extends Component
   {
      
      public static var THICKNESS:uint = 16;
      
      private var _bar:ScrollBarBase = new ScrollBarBase();
      
      private var _direction:String;
      
      public function ScrollBar()
      {
         super();
         addChild(this._bar);
         this._bar.addEventListener("scrollPositionChanged",this.scrollPositionChanged);
         this.direction = BoxDirection.VERTICAL;
      }
      
      private function scrollPositionChanged(e:Event) : void
      {
         dispatchEvent(new Event("scrollPositionChanged"));
         updateNow();
      }
      
      [Inspectable(category="General",enumeration="vertical,horizontal",defaultValue="vertical")]
      public function set direction(value:String) : void
      {
         if(this._direction == value)
         {
            return;
         }
         this._direction = value;
         if(value == BoxDirection.HORIZONTAL)
         {
            this._bar.rotation = -90;
            this._bar.y = this._bar.height;
            this.height = THICKNESS;
         }
         else
         {
            this._bar.rotation = 0;
            this.width = THICKNESS;
         }
      }
      
      [Bindable("scrollPositionChanged")]
      public function set scrollPosition(value:Number) : void
      {
         this._bar.scrollPosition = value;
         this._bar.updateNow();
      }
      
      public function get scrollPosition() : Number
      {
         return this._bar.scrollPosition;
      }
      
      public function set minScrollPosition(value:Number) : void
      {
         this._bar.minScrollPosition = value;
      }
      
      public function get minScrollPosition() : Number
      {
         return this._bar.minScrollPosition;
      }
      
      public function set maxScrollPosition(value:Number) : void
      {
         this._bar.maxScrollPosition = value;
      }
      
      public function get maxScrollPosition() : Number
      {
         return this._bar.maxScrollPosition;
      }
      
      public function set pageSize(value:uint) : void
      {
         this._bar.pageSize = value;
      }
      
      override public function set width(value:Number) : void
      {
         if(this._direction == BoxDirection.HORIZONTAL)
         {
            this._bar.height = value;
         }
         else
         {
            this._bar.width = value;
         }
      }
      
      override public function get width() : Number
      {
         return this._direction == BoxDirection.HORIZONTAL ? Number(this._bar.height) : Number(this._bar.width);
      }
      
      override public function set height(value:Number) : void
      {
         if(this._direction == BoxDirection.HORIZONTAL)
         {
            this._bar.width = value;
            this._bar.y = value;
         }
         else
         {
            this._bar.height = value;
         }
      }
      
      override public function get height() : Number
      {
         return this._direction == BoxDirection.HORIZONTAL ? Number(this._bar.width) : Number(this._bar.height);
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import flash.geom.Rectangle;

class ScrollBarBase extends Component
{
   
   private var up:CachedImage;
   
   private var down:CachedImage;
   
   private var thumb:Sprite;
   
   private var track:Sprite;
   
   private var isDragging:Boolean = false;
   
   private var minThumbSize:uint;
   
   private var _pageSize:uint = 0;
   
   private var _scrollPosition:Number = 0;
   
   private var _minScrollPosition:Number = 0;
   
   private var _maxScrollPosition:Number = 0;
   
   public function ScrollBarBase()
   {
      super();
      this.up = new CachedImage();
      this.up.source = UIAssets.scrollButtonUp;
      this.down = new CachedImage();
      this.down.source = UIAssets.scrollButtonDown;
      this.thumb = new UIAssets.scrollSlider();
      this.minThumbSize = this.thumb.height;
      this.track = new UIAssets.scrollTrack();
      addChild(this.track);
      addChild(this.up);
      addChild(this.down);
      addChild(this.thumb);
      this.up.addEventListener(MouseEvent.CLICK,this.onButton);
      this.down.addEventListener(MouseEvent.CLICK,this.onButton);
      this.thumb.addEventListener(MouseEvent.MOUSE_DOWN,this.onThumbDown);
   }
   
   override protected function redraw() : void
   {
      var trackSize:int = 0;
      var thumbSpace:int = 0;
      if(this.isDragging)
      {
         return;
      }
      super.redraw();
      var scrollSize:int = this._maxScrollPosition - this._minScrollPosition;
      var pageSize:int = this._pageSize > 0 ? int(this._pageSize) : int(height);
      trackSize = height - this.up.height - this.down.height;
      this.thumb.height = Math.max(this.minThumbSize,trackSize * pageSize / (scrollSize + pageSize));
      thumbSpace = trackSize - this.thumb.height;
      this.track.x = Math.round((width - this.track.width) / 2);
      this.track.y = this.up.height;
      this.track.height = trackSize;
      this.down.y = height - this.down.height;
      this.thumb.y = this.up.height + Math.round(thumbSpace * (this._scrollPosition - this._minScrollPosition) / (this._maxScrollPosition - this._minScrollPosition));
      this.thumb.x = Math.round((width - this.thumb.width) / 2);
      this.thumb.visible = this._maxScrollPosition > this._minScrollPosition;
   }
   
   private function onButton(e:MouseEvent) : void
   {
      if(e.currentTarget == this.up)
      {
         --this.scrollPosition;
      }
      else
      {
         ++this.scrollPosition;
      }
   }
   
   private function onThumbDown(e:MouseEvent) : void
   {
      var thumbSpace:int = Math.max(0,height - this.up.height - this.down.height - this.thumb.height);
      var rect:Rectangle = new Rectangle(this.thumb.x,this.up.height,0,thumbSpace);
      this.isDragging = true;
      stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMove);
      stage.addEventListener(MouseEvent.MOUSE_UP,this.onThumbUp);
      this.thumb.startDrag(false,rect);
   }
   
   private function onThumbMove(e:MouseEvent) : void
   {
      var thumbSpace:int = Math.max(0,height - this.up.height - this.down.height - this.thumb.height);
      var newPosition:Number = Math.round((this.maxScrollPosition - this.minScrollPosition) * (this.thumb.y - this.up.height) / thumbSpace) + this.minScrollPosition;
      this.scrollPosition = newPosition;
   }
   
   private function onThumbUp(e:MouseEvent) : void
   {
      this.onThumbMove(null);
      this.thumb.stopDrag();
      this.isDragging = false;
      stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onThumbMove);
      stage.removeEventListener(MouseEvent.MOUSE_UP,this.onThumbUp);
   }
   
   public function set pageSize(value:uint) : void
   {
      if(this._pageSize == value)
      {
         return;
      }
      this._pageSize = value;
      updateLater();
   }
   
   [Bindable("scrollPositionChanged")]
   public function set scrollPosition(value:Number) : void
   {
      value = Math.max(this._minScrollPosition,value);
      value = Math.min(this._maxScrollPosition,value);
      if(this._scrollPosition == value)
      {
         return;
      }
      this._scrollPosition = value;
      dispatchEvent(new Event("scrollPositionChanged"));
      updateLater();
   }
   
   public function get scrollPosition() : Number
   {
      return this._scrollPosition;
   }
   
   public function set minScrollPosition(value:Number) : void
   {
      if(this._minScrollPosition == value)
      {
         return;
      }
      this._minScrollPosition = value;
      this.scrollPosition = this.scrollPosition;
      updateLater();
   }
   
   public function get minScrollPosition() : Number
   {
      return this._minScrollPosition;
   }
   
   public function set maxScrollPosition(value:Number) : void
   {
      if(this._maxScrollPosition == value)
      {
         return;
      }
      this._maxScrollPosition = value;
      this.scrollPosition = this.scrollPosition;
      this.redraw();
   }
   
   public function get maxScrollPosition() : Number
   {
      return this._maxScrollPosition;
   }
}
