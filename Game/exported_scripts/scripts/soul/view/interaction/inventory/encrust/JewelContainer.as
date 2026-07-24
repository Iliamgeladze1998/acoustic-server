package soul.view.interaction.inventory.encrust
{
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import soul.controller.mouse.DragProxy;
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.DragEvent;
   import soul.model.item.Item;
   import soul.model.item.ItemType;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.ui.Component;
   
   public class JewelContainer extends Component
   {
      
      private static const selecterFilters:Array = [new GlowFilter(16777011)];
      
      public var allowedSockets:Array;
      
      private var itemRenderer:ItemRenderer = new ItemRenderer();
      
      private var dragProxy:DragProxy;
      
      private var _changed:Boolean;
      
      public function JewelContainer()
      {
         super();
         this.width = this.height = 55;
         addChild(this.itemRenderer);
         this.dragProxy = new DragProxy(this,null,this.dragEnter,this.dragDrop);
      }
      
      public function set item(value:Item) : void
      {
         this.itemRenderer.item = value;
      }
      
      public function get item() : Item
      {
         return this.itemRenderer.item;
      }
      
      public function set changed(value:Boolean) : void
      {
         this._changed = value;
         filters = value ? selecterFilters : [];
      }
      
      public function get changed() : Boolean
      {
         return this._changed;
      }
      
      override public function set width(value:Number) : void
      {
         this.itemRenderer.width = value;
      }
      
      override public function get width() : Number
      {
         return this.itemRenderer.width;
      }
      
      override public function set height(value:Number) : void
      {
         this.itemRenderer.height = value;
      }
      
      override public function get height() : Number
      {
         return this.itemRenderer.height;
      }
      
      protected function dragEnter(e:DragEvent) : void
      {
         var item:Item = e.dragSource.hasFormat("item") ? Item(e.dragSource.dataForFormat("item")) : null;
         if(Boolean(item && item.type == ItemType.JEWEL) && Boolean(this.allowedSockets) && this.allowedSockets.indexOf(item.subType) > -1)
         {
            SimpleDragManager.acceptDragDrop(this);
         }
      }
      
      protected function dragDrop(e:DragEvent) : void
      {
         var src:Item = Item(e.dragSource.dataForFormat("item"));
         var item:Item = src.clone();
         item.count = 1;
         item.key = src.key;
         this.item = item;
         this.changed = true;
         dispatchEvent(new Event(Event.CHANGE));
      }
   }
}

