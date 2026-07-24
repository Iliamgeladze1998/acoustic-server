package soul.view.ui
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   import soul.view.ui.layout.Layout;
   
   use namespace soul_internal;
   
   public class ScrollBase extends Container
   {
      
      public var wheelMultiplier:Number = 7;
      
      private var _hScrollBar:ScrollBar;
      
      private var _vScrollBar:ScrollBar;
      
      private var box:Sprite;
      
      private var availWidth:uint;
      
      private var availHeight:uint;
      
      private var _verticalScrollPolicy:String = "off";
      
      private var _horizontalScrollPolicy:String = "off";
      
      private var _vScrollPosition:Number = 0;
      
      private var _hScrollPosition:Number = 0;
      
      public function ScrollBase()
      {
         super();
         layout = new Layout(this);
         backgroundColor = 0;
         backgroundAlpha = 0;
         width = 100;
         height = 100;
         addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
      }
      
      override protected function redraw() : void
      {
         var maxChildWidth:int = 0;
         var maxChildHeight:int = 0;
         var child:DisplayObject = null;
         super.redraw();
         for(var i:uint = 0; i < numChildren; i++)
         {
            child = getChildAt(i);
            maxChildWidth = Math.max(maxChildWidth,child.width);
            maxChildHeight = Math.max(maxChildHeight,child.height);
         }
         var vBarVisible:Boolean = this._verticalScrollPolicy == ScrollPolicy.ON || this._verticalScrollPolicy == ScrollPolicy.AUTO && maxChildHeight > height;
         var hBarVisible:Boolean = this._horizontalScrollPolicy == ScrollPolicy.ON || this._horizontalScrollPolicy == ScrollPolicy.AUTO && maxChildWidth > width;
         if(!vBarVisible && Boolean(this._vScrollBar))
         {
            $removeChild(this._vScrollBar);
            this._vScrollBar = null;
         }
         if(!hBarVisible && Boolean(this._hScrollBar))
         {
            $removeChild(this._hScrollBar);
            this._hScrollBar = null;
         }
         this.availWidth = width - (vBarVisible ? ScrollBar.THICKNESS : 0);
         this.availHeight = height - (hBarVisible ? ScrollBar.THICKNESS : 0);
         if(vBarVisible)
         {
            if(!this._vScrollBar)
            {
               this._vScrollBar = new ScrollBar();
               this._vScrollBar.addEventListener("scrollPositionChanged",this.positionChanged);
               this._vScrollBar.direction = BoxDirection.VERTICAL;
               $addChild(this._vScrollBar);
            }
            this._vScrollBar.height = this.availHeight;
            this._vScrollBar.x = this.availWidth;
            this._vScrollBar.maxScrollPosition = Math.max(0,maxChildHeight - this.availHeight);
            this._vScrollBar.scrollPosition = this._vScrollPosition;
         }
         if(hBarVisible)
         {
            if(!this._hScrollBar)
            {
               this._hScrollBar = new ScrollBar();
               this._hScrollBar.direction = BoxDirection.HORIZONTAL;
               this._hScrollBar.addEventListener("scrollPositionChanged",this.positionChanged);
               $addChild(this._hScrollBar);
            }
            this._hScrollBar.width = this.availWidth;
            this._hScrollBar.y = this.availHeight;
            this._hScrollBar.maxScrollPosition = Math.max(0,maxChildWidth - this.availWidth);
            this._hScrollBar.scrollPosition = this._hScrollPosition;
         }
         this.positionChanged(null);
      }
      
      override protected function childAdded(child:DisplayObject) : void
      {
         super.childAdded(child);
         updateLater();
      }
      
      override protected function childRemoved(child:DisplayObject) : void
      {
         super.childRemoved(child);
         updateLater();
      }
      
      override protected function childResized(e:Event) : void
      {
         this.redraw();
      }
      
      private function positionChanged(e:Event) : void
      {
         var xPos:uint = 0;
         var yPos:uint = 0;
         if(Boolean(this._hScrollBar))
         {
            xPos = Math.max(this._hScrollBar.scrollPosition,0);
            xPos = Math.min(this._hScrollBar.maxScrollPosition,xPos);
            this._hScrollPosition = xPos;
         }
         if(Boolean(this._vScrollBar))
         {
            yPos = Math.max(this._vScrollBar.scrollPosition,0);
            yPos = Math.min(this._vScrollBar.maxScrollPosition,yPos);
            this._vScrollPosition = yPos;
         }
         content.scrollRect = new Rectangle(xPos,yPos,this.availWidth,this.availHeight);
      }
      
      private function onMouseWheel(e:MouseEvent) : void
      {
         if(Boolean(this._vScrollBar))
         {
            this._vScrollBar.scrollPosition -= e.delta * this.wheelMultiplier;
         }
         else if(Boolean(this._hScrollBar))
         {
            this._hScrollBar.scrollPosition -= e.delta * this.wheelMultiplier;
         }
      }
      
      [Inspectable(category="General",enumeration="off,on,auto",defaultValue="off")]
      public function set verticalScrollPolicy(value:String) : void
      {
         if(this._verticalScrollPolicy == value)
         {
            return;
         }
         this._verticalScrollPolicy = value;
         updateLater();
      }
      
      [Inspectable(category="General",enumeration="off,on,auto",defaultValue="off")]
      public function set horizontalScrollPolicy(value:String) : void
      {
         if(this._horizontalScrollPolicy == value)
         {
            return;
         }
         this._horizontalScrollPolicy = value;
         updateLater();
      }
      
      public function get vScrollPosition() : Number
      {
         return this._vScrollPosition;
      }
      
      public function set vScrollPosition(value:Number) : void
      {
         if(this._vScrollPosition == value)
         {
            return;
         }
         this._vScrollPosition = value;
         if(Boolean(this._vScrollBar))
         {
            this._vScrollBar.scrollPosition = this._vScrollPosition;
         }
         updateLater();
      }
      
      public function get hScrollPosition() : Number
      {
         return this._hScrollPosition;
      }
      
      public function set hScrollPosition(value:Number) : void
      {
         if(this._hScrollPosition == value)
         {
            return;
         }
         this._hScrollPosition = value;
         if(Boolean(this._hScrollBar))
         {
            this._hScrollBar.scrollPosition = this._hScrollPosition;
         }
         updateLater();
      }
   }
}

