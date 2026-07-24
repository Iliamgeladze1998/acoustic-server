package soul.view.ui
{
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import soul.event.SimpleUIEvent;
   import soul.styles.StyleManager;
   import soul.view.toolTip.ToolTipManager;
   
   use namespace soul_internal;
   
   [Event(name="creationComplete",type="soul.event.SimpleUIEvent")]
   public class Component extends Sprite
   {
      
      public var minWidth:int;
      
      public var minHeight:int;
      
      public var percentWidth:Number;
      
      public var percentHeight:Number;
      
      protected var _created:Boolean = false;
      
      private var _backgroundPadding:int;
      
      private var _backgroundColor:int = -1;
      
      private var callLaterStack:Vector.<CallLaterEntry> = new Vector.<CallLaterEntry>(0);
      
      private var hasLaterListener:Boolean;
      
      soul_internal var _visible:Boolean = true;
      
      private var _parent:DisplayObjectContainer;
      
      private var _setWidth:Number;
      
      private var _setHeight:Number;
      
      protected var _width:Number = 0;
      
      protected var _height:Number = 0;
      
      private var _maxWidth:Number;
      
      private var _maxHeight:Number;
      
      private var _left:Number;
      
      private var _right:Number;
      
      private var _top:Number;
      
      private var _bottom:Number;
      
      private var _horizontalCenter:Number;
      
      private var _verticalCenter:Number;
      
      private var _toolTip:String;
      
      protected var _enabled:Boolean = true;
      
      private var _backgroundAlpha:Number = 1;
      
      private var _styleManager:StyleManager;
      
      private var _styleName:String;
      
      public function Component()
      {
         super();
         dispatchEvent(new SimpleUIEvent(SimpleUIEvent.PREINITIALIZE));
         this.applyStyle();
         this.applyDefaultStyle();
         this.$visible = false;
         this.callLater(this.created);
      }
      
      public function get backgroundPadding() : int
      {
         return this._backgroundPadding;
      }
      
      public function set backgroundPadding(value:int) : void
      {
         if(this._backgroundPadding == value)
         {
            return;
         }
         this._backgroundPadding = value;
         this.updateLater();
      }
      
      public function get backgroundColor() : int
      {
         return this._backgroundColor;
      }
      
      public function set backgroundColor(value:int) : void
      {
         if(this._backgroundColor == value)
         {
            return;
         }
         this._backgroundColor = value;
         this.updateLater();
      }
      
      protected function created() : void
      {
         this._created = true;
         this.$visible = this._visible;
         if(hasEventListener(SimpleUIEvent.CREATION_COMPLETE))
         {
            dispatchEvent(new SimpleUIEvent(SimpleUIEvent.CREATION_COMPLETE));
         }
      }
      
      public function destroy() : void
      {
         var child:Component = null;
         for(var i:uint = 0; i < numChildren; i++)
         {
            child = getChildAt(i) as Component;
            if(Boolean(child))
            {
               child.destroy();
            }
         }
         this.toolTip = null;
      }
      
      protected function applyDefaultStyle() : void
      {
      }
      
      final private function applyStyle() : void
      {
         var sm:StyleManager = this.styleManager;
         if(!sm)
         {
            return;
         }
         sm.applyStyle(this);
      }
      
      final protected function callLater(method:Function, args:Array = null) : void
      {
         this.callLaterStack.push(new CallLaterEntry(method,args));
         if(!this.hasLaterListener)
         {
            addEventListener(Event.ENTER_FRAME,this.callLaterTrigger);
            this.hasLaterListener = true;
         }
      }
      
      final private function callLaterTrigger(e:Event) : void
      {
         var entry:CallLaterEntry = null;
         removeEventListener(Event.ENTER_FRAME,this.callLaterTrigger);
         this.hasLaterListener = false;
         for each(entry in this.callLaterStack)
         {
            entry.method.apply(null,entry.args);
         }
         this.callLaterStack.length = 0;
      }
      
      final protected function updateLater() : void
      {
         addEventListener(Event.ENTER_FRAME,this.updateNow);
      }
      
      final public function updateNow(e:Event = null) : void
      {
         removeEventListener(Event.ENTER_FRAME,this.updateNow);
         this.redraw();
      }
      
      protected function applySize() : void
      {
         this.redraw();
      }
      
      protected function redraw() : void
      {
         var p2:int = 0;
         if(this.backgroundColor > -1)
         {
            p2 = this.backgroundPadding * 2;
            graphics.clear();
            graphics.beginFill(this.backgroundColor,this.backgroundAlpha);
            graphics.drawRect(this.backgroundPadding,this.backgroundPadding,this.width - p2,this.height - p2);
            graphics.endFill();
         }
      }
      
      final public function setActualSize(w:Number, h:Number) : void
      {
         var resized:Boolean = false;
         if(this._width != w)
         {
            this._width = w;
            resized = true;
            if(hasEventListener("widthChanged"))
            {
               dispatchEvent(new Event("widthChanged"));
            }
         }
         if(this._height != h)
         {
            this._height = h;
            resized = true;
            if(hasEventListener("heightChanged"))
            {
               dispatchEvent(new Event("heightChanged"));
            }
         }
         if(resized && hasEventListener(Event.RESIZE))
         {
            dispatchEvent(new Event(Event.RESIZE));
         }
         this.applySize();
      }
      
      override public function set visible(value:Boolean) : void
      {
         this._visible = super.visible = value;
      }
      
      override public function get visible() : Boolean
      {
         return this._visible;
      }
      
      soul_internal function set $visible(value:Boolean) : void
      {
         super.visible = value;
      }
      
      public function set parent(value:DisplayObjectContainer) : void
      {
         this._parent = value;
      }
      
      override public function get parent() : DisplayObjectContainer
      {
         return Boolean(this._parent) ? this._parent : super.parent;
      }
      
      override public function set doubleClickEnabled(value:Boolean) : void
      {
         var child:InteractiveObject = null;
         super.doubleClickEnabled = value;
         for(var i:uint = 0; i < numChildren; i++)
         {
            child = getChildAt(i) as InteractiveObject;
            if(Boolean(child))
            {
               child.doubleClickEnabled = value;
            }
         }
      }
      
      public function get setWidth() : Number
      {
         return this._setWidth;
      }
      
      public function get setHeight() : Number
      {
         return this._setHeight;
      }
      
      public function set actualWidth(value:Number) : void
      {
         if(this._width == value)
         {
            return;
         }
         this._width = value;
         if(hasEventListener("widthChanged"))
         {
            dispatchEvent(new Event("widthChanged"));
         }
         if(hasEventListener(Event.RESIZE))
         {
            dispatchEvent(new Event(Event.RESIZE));
         }
         this.applySize();
      }
      
      public function set actualHeight(value:Number) : void
      {
         if(this._height == value)
         {
            return;
         }
         this._height = value;
         if(hasEventListener("heightChanged"))
         {
            dispatchEvent(new Event("heightChanged"));
         }
         if(hasEventListener(Event.RESIZE))
         {
            dispatchEvent(new Event(Event.RESIZE));
         }
         this.applySize();
      }
      
      [PercentProxy("percentWidth")]
      override public function set width(value:Number) : void
      {
         if(!isNaN(value))
         {
            this.percentWidth = NaN;
         }
         this._setWidth = value;
         this.actualWidth = value;
      }
      
      [Bindable("widthChanged")]
      override public function get width() : Number
      {
         return this._width * scaleX;
      }
      
      [PercentProxy("percentHeight")]
      override public function set height(value:Number) : void
      {
         if(!isNaN(value))
         {
            this.percentHeight = NaN;
         }
         this._setHeight = value;
         this.actualHeight = value;
      }
      
      [Bindable("heightChanged")]
      override public function get height() : Number
      {
         return this._height * scaleY;
      }
      
      public function set maxWidth(value:Number) : void
      {
         if(this._maxWidth == value)
         {
            return;
         }
         this._maxWidth = value;
         this.makeLayout();
      }
      
      public function get maxWidth() : Number
      {
         return this._maxWidth;
      }
      
      public function set maxHeight(value:Number) : void
      {
         if(this._maxHeight == value)
         {
            return;
         }
         this._maxHeight = value;
         this.makeLayout();
      }
      
      public function get maxHeight() : Number
      {
         return this._maxHeight;
      }
      
      override public function set scaleX(value:Number) : void
      {
         if(super.scaleX == value)
         {
            return;
         }
         super.scaleX = value;
         if(hasEventListener("widthChanged"))
         {
            dispatchEvent(new Event("widthChanged"));
         }
         if(hasEventListener(Event.RESIZE))
         {
            dispatchEvent(new Event(Event.RESIZE));
         }
         this.applySize();
      }
      
      override public function set scaleY(value:Number) : void
      {
         if(super.scaleY == value)
         {
            return;
         }
         super.scaleY = value;
         if(hasEventListener("heightChanged"))
         {
            dispatchEvent(new Event("heightChanged"));
         }
         if(hasEventListener(Event.RESIZE))
         {
            dispatchEvent(new Event(Event.RESIZE));
         }
         this.applySize();
      }
      
      public function set left(value:Number) : void
      {
         if(this._left == value)
         {
            return;
         }
         this._left = value;
         this.makeLayout();
      }
      
      public function get left() : Number
      {
         return this._left;
      }
      
      public function set right(value:Number) : void
      {
         if(this._right == value)
         {
            return;
         }
         this._right = value;
         this.makeLayout();
      }
      
      public function get right() : Number
      {
         return this._right;
      }
      
      public function set top(value:Number) : void
      {
         if(this._top == value)
         {
            return;
         }
         this._top = value;
         this.makeLayout();
      }
      
      public function get top() : Number
      {
         return this._top;
      }
      
      public function set bottom(value:Number) : void
      {
         if(this._bottom == value)
         {
            return;
         }
         this._bottom = value;
         this.makeLayout();
      }
      
      public function get bottom() : Number
      {
         return this._bottom;
      }
      
      public function set horizontalCenter(value:Number) : void
      {
         if(this._horizontalCenter == value)
         {
            return;
         }
         this._horizontalCenter = value;
         this.makeLayout();
      }
      
      public function get horizontalCenter() : Number
      {
         return this._horizontalCenter;
      }
      
      public function set verticalCenter(value:Number) : void
      {
         if(this._verticalCenter == value)
         {
            return;
         }
         this._verticalCenter = value;
         this.makeLayout();
      }
      
      public function get verticalCenter() : Number
      {
         return this._verticalCenter;
      }
      
      public function set toolTip(value:String) : void
      {
         if(this._toolTip == value)
         {
            return;
         }
         this._toolTip = value;
         if(!value || value.length < 1)
         {
            ToolTipManager.unregister(this);
         }
         else
         {
            ToolTipManager.register(this,value);
         }
      }
      
      public function get toolTip() : String
      {
         return this._toolTip;
      }
      
      [Bindable("enabledChanged")]
      public function set enabled(value:Boolean) : void
      {
         if(this._enabled == value)
         {
            this._enabled = value;
         }
         this._enabled = value;
         mouseEnabled = value;
         alpha = value ? 1 : 0.4;
         if(hasEventListener("enabledChanged"))
         {
            dispatchEvent(new Event("enabledChanged"));
         }
      }
      
      public function get enabled() : Boolean
      {
         return this._enabled;
      }
      
      public function set backgroundAlpha(value:Number) : void
      {
         if(this._backgroundAlpha == value)
         {
            return;
         }
         this._backgroundAlpha = value;
         this.updateLater();
      }
      
      public function get backgroundAlpha() : Number
      {
         return this._backgroundAlpha;
      }
      
      protected function set styleManager(value:StyleManager) : void
      {
         this._styleManager = value;
      }
      
      protected function get styleManager() : StyleManager
      {
         if(Boolean(this._styleManager))
         {
            return this._styleManager;
         }
         if(this.parent is Component)
         {
            return Component(this.parent).styleManager;
         }
         return StyleManager.defaultManager;
      }
      
      public function getStyle(prop:String) : *
      {
         return this.styleManager.getStyle(this,prop);
      }
      
      public function setStyle(prop:String, value:*) : void
      {
         this.styleManager.setStyle(this,prop,value);
      }
      
      public function set styleName(value:String) : void
      {
         if(this._styleName == value)
         {
            return;
         }
         this._styleName = value;
         this.applyStyle();
      }
      
      public function get styleName() : String
      {
         return this._styleName;
      }
      
      final private function makeLayout() : void
      {
         if(Boolean(this.parent) && Boolean(this.parent is Container) && Boolean(Container(this.parent).layout))
         {
            Container(this.parent).layout.layoutOne(this);
         }
      }
   }
}

final class CallLaterEntry
{
   
   public var method:Function;
   
   public var args:Array;
   
   public function CallLaterEntry(method:Function, args:Array = null)
   {
      super();
      this.method = method;
      this.args = args;
   }
}
