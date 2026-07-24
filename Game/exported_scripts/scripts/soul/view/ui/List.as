package soul.view.ui
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Event(name="childDoubleClick",type="flash.events.Event")]
   [Event(name="selectedItemChanged",type="flash.events.Event")]
   public class List extends ScrollBase
   {
      
      protected var vbox:VBox = new VBox();
      
      private var _itemRenderer:Class = Label;
      
      private var _dataProvider:Object;
      
      private var _selectedItem:Object;
      
      protected var _selectedChild:IDataRenderer;
      
      public function List()
      {
         super();
         this.vbox.percentWidth = 100;
         addChild(this.vbox);
         verticalScrollPolicy = ScrollPolicy.AUTO;
      }
      
      public function set itemRenderer(value:Class) : void
      {
         var instance:Object = null;
         var isData:Boolean = false;
         if(this._itemRenderer == value)
         {
            return;
         }
         if(Boolean(value))
         {
            instance = new value();
            isData = instance is IDataRenderer;
            if(instance is Component)
            {
               Component(instance).destroy();
            }
            if(!isData)
            {
               return;
            }
         }
         this._itemRenderer = value;
         this.redrawChildren();
      }
      
      public function set dataProvider(value:Object) : void
      {
         if(this._dataProvider == value)
         {
            return;
         }
         this._dataProvider = value;
         this.redrawChildren();
      }
      
      [Bindable("selectedItemChanged")]
      public function get selectedItem() : Object
      {
         return this._selectedItem;
      }
      
      private function setSelectedItem(value:Object) : void
      {
         if(this._selectedItem == value)
         {
            return;
         }
         this._selectedItem = value;
         if(hasEventListener("selectedItemChanged"))
         {
            dispatchEvent(new Event("selectedItemChanged"));
         }
      }
      
      private function set selectedChild(child:IDataRenderer) : void
      {
         if(child == this._selectedChild)
         {
            return;
         }
         if(Boolean(this._selectedChild) && this._selectedChild is IListItemRenderer)
         {
            IListItemRenderer(this._selectedChild).selected = false;
         }
         this._selectedChild = child;
         if(child is IListItemRenderer)
         {
            IListItemRenderer(child).selected = true;
         }
         this.setSelectedItem(child.data);
      }
      
      public function set gap(value:int) : void
      {
         this.vbox.gap = value;
      }
      
      private function redrawChildren() : void
      {
         var data:Object = null;
         var renderer:IDataRenderer = null;
         var child:DisplayObject = null;
         this.vbox.removeAllChildren();
         for each(data in this._dataProvider)
         {
            renderer = new this._itemRenderer();
            renderer.data = data;
            child = renderer as DisplayObject;
            if(child)
            {
               child.addEventListener(MouseEvent.CLICK,this.childClick);
               child.addEventListener(MouseEvent.DOUBLE_CLICK,this.childDoubleClick);
               this.vbox.addChild(child as DisplayObject);
            }
         }
      }
      
      private function childClick(e:MouseEvent) : void
      {
         this.selectedChild = e.currentTarget as IDataRenderer;
      }
      
      private function childDoubleClick(e:MouseEvent) : void
      {
         if(hasEventListener("childDoubleClick"))
         {
            dispatchEvent(new Event("childDoubleClick"));
         }
      }
   }
}

