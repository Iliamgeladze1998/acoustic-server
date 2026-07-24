package soul.view.ui
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import soul.event.SimpleUIEvent;
   import soul.view.ui.layout.ILayout;
   
   use namespace soul_internal;
   
   [DefaultProperty("children")]
   public class Container extends Component
   {
      
      soul_internal var content:Sprite = new Sprite();
      
      protected var background:Sprite = new Sprite();
      
      private var _initialized:Boolean = false;
      
      public var padding:int = 0;
      
      public var layout:ILayout;
      
      public var layoutInProgress:Boolean;
      
      [ArrayElementType("flash.display.DisplayObject")]
      private var _children:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      public function Container()
      {
         super();
         this.content.mouseEnabled = false;
         this.background.mouseEnabled = false;
         this.$addChild(this.background);
         this.$addChild(this.content);
      }
      
      final override protected function created() : void
      {
         _created = true;
         $visible = _visible;
         this.makeLayout();
         updateNow();
      }
      
      protected function makeLayout() : void
      {
         if(Boolean(this.layout) && !this.layoutInProgress)
         {
            this.layoutInProgress = true;
            this.layout.layout();
            this.layoutInProgress = false;
         }
         if(_created && !this._initialized)
         {
            this._initialized = true;
            if(hasEventListener(SimpleUIEvent.CREATION_COMPLETE))
            {
               dispatchEvent(new SimpleUIEvent(SimpleUIEvent.CREATION_COMPLETE));
            }
         }
      }
      
      override protected function applySize() : void
      {
         if(!this._initialized)
         {
            return;
         }
         super.applySize();
      }
      
      override protected function redraw() : void
      {
         this.makeLayout();
         super.redraw();
      }
      
      final soul_internal function $getContent() : Sprite
      {
         return this.content;
      }
      
      final soul_internal function get $numChildren() : int
      {
         return super.numChildren;
      }
      
      final soul_internal function $getChildAt(index:int) : DisplayObject
      {
         return super.getChildAt(index);
      }
      
      final soul_internal function $getChildIndex(child:DisplayObject) : int
      {
         return super.getChildIndex(child);
      }
      
      final soul_internal function $addChild(child:DisplayObject) : DisplayObject
      {
         return super.addChild(child);
      }
      
      final soul_internal function $addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         return super.addChildAt(child,index);
      }
      
      final soul_internal function $removeChildAt(index:int) : DisplayObject
      {
         return super.removeChildAt(index);
      }
      
      final soul_internal function $removeChild(child:DisplayObject) : DisplayObject
      {
         return super.removeChild(child);
      }
      
      final override public function get numChildren() : int
      {
         return this.content.numChildren;
      }
      
      final override public function contains(child:DisplayObject) : Boolean
      {
         return this.content.contains(child);
      }
      
      final override public function getChildAt(index:int) : DisplayObject
      {
         return this.content.getChildAt(index);
      }
      
      final override public function getChildIndex(child:DisplayObject) : int
      {
         return this.content.getChildIndex(child);
      }
      
      final override public function setChildIndex(child:DisplayObject, index:int) : void
      {
         this.content.setChildIndex(child,index);
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         if(child.parent == this)
         {
            return child;
         }
         return this.addChildAt(child,this.numChildren);
      }
      
      final override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
      {
         if(!(child is Component))
         {
            throw new Error("Child should be inherited of SimpleComponent");
         }
         if(Boolean(child.parent) && child.parent is Container)
         {
            child.parent.removeChild(child);
         }
         if(child is Component)
         {
            Component(child).parent = this;
         }
         this.childAdding(child);
         this.content.addChildAt(child,index);
         this.childAdded(child);
         return child;
      }
      
      final override public function removeChildAt(index:int) : DisplayObject
      {
         var child:DisplayObject = this.content.getChildAt(index);
         this.removeChild(child);
         this.childRemoved(child);
         return child;
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         this.childRemoving(child);
         updateLater();
         if(child is Component)
         {
            Component(child).parent = null;
         }
         return this.content.removeChild(child);
      }
      
      final public function removeAllChildren(destroyChildren:Boolean = true) : void
      {
         var child:Component = null;
         while(this.numChildren > 0)
         {
            child = this.getChildAt(0) as Component;
            if(destroyChildren && Boolean(child))
            {
               child.destroy();
            }
            this.removeChildAt(0);
         }
      }
      
      protected function childAdded(child:DisplayObject) : void
      {
      }
      
      protected function childRemoved(child:DisplayObject) : void
      {
      }
      
      protected function childAdding(child:DisplayObject) : void
      {
         if(child is Component)
         {
            child.addEventListener(Event.RESIZE,this.childResized);
         }
      }
      
      protected function childRemoving(child:DisplayObject) : void
      {
         if(child is Component)
         {
            if(!child.hasEventListener(Event.RESIZE))
            {
               return;
            }
            child.removeEventListener(Event.RESIZE,this.childResized);
         }
      }
      
      protected function childResized(e:Event) : void
      {
      }
      
      public function get initialized() : Boolean
      {
         return this._initialized;
      }
      
      public function set children(value:Array) : void
      {
         var child:DisplayObject = null;
         for each(child in this._children)
         {
            this.removeChild(child);
         }
         this._children.length = 0;
         for each(child in value)
         {
            this.addChild(child);
            this._children.push(child);
         }
      }
   }
}

