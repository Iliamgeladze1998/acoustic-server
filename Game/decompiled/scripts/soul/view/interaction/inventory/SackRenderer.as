package soul.view.interaction.inventory
{
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import mx.core.DragSource;
   import soul.controller.mouse.DragProxy;
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.DragEvent;
   import soul.event.InventoryEvent;
   import soul.model.inventory.Sack;
   import soul.model.item.Item;
   import soul.model.item.ItemType;
   import soul.view.assets.Assets;
   import soul.view.assets.Colors;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Label;
   
   public class SackRenderer extends ItemRenderer
   {
      
      public var slotIndex:int = -1;
      
      private var space:Label = new Label();
      
      private var dragProxy:DragProxy;
      
      private var _sack:Sack;
      
      public function SackRenderer()
      {
         super();
         width = 66;
         height = 66;
         this.space.color = Colors.GOLD_LIGHT;
         this.space.left = 5;
         this.space.top = 0;
         addChild(this.space);
         dropsShadow = false;
         borderSkin = null;
         background.visible = false;
         this.sack = null;
         this.dragProxy = new DragProxy(this,this.dragStart,this.dragEnter,this.dragDrop,null,this.dragExit);
      }
      
      private function dragStart(e:MouseEvent) : void
      {
         if(item == null || _enabled)
         {
            return;
         }
         var ds:DragSource = new DragSource();
         ds.addData(item,"item");
         var dsi:CachedImage = new CachedImage();
         dsi.source = source;
         SimpleDragManager.doDrag(this,ds,e,dsi);
      }
      
      private function dragEnter(e:DragEvent) : void
      {
         var item:Item = Item(e.dragSource.dataForFormat("item")) || Item(e.dragSource.dataForFormat("splitItem"));
         if(!item || item == this.item)
         {
            return;
         }
         if(item.type != ItemType.CONTAINER && !this.item)
         {
            return;
         }
         if(item.type == ItemType.CONTAINER && !item.isEmpty())
         {
            return;
         }
         if(Boolean(item.key) && item.key.sack == this.slotIndex)
         {
            return;
         }
         SimpleDragManager.acceptDragDrop(this);
         image.filters = [new GlowFilter(16777215)];
      }
      
      private function dragExit(e:DragEvent) : void
      {
         image.filters = [];
      }
      
      private function dragDrop(e:DragEvent) : void
      {
         var type:String = null;
         var item:Item = e.dragSource.dataForFormat("item") as Item;
         var split:Boolean = false;
         if(!item)
         {
            item = e.dragSource.dataForFormat("splitItem") as Item;
            split = true;
         }
         if(!item)
         {
            return;
         }
         if(item.equipped)
         {
            if(item.type == ItemType.CONTAINER)
            {
               if(this.slotIndex == 0 || item.bodySlot == 0)
               {
                  return;
               }
               type = InventoryEvent.CHANGE_BODY_SLOT;
            }
            else
            {
               type = InventoryEvent.TAKEOFF_TO_SACK;
            }
         }
         else if(item.type == ItemType.CONTAINER)
         {
            type = InventoryEvent.EQUIP_TO_SLOT;
         }
         else if(split)
         {
            type = InventoryEvent.SPLIT_TO_SACK;
         }
         else
         {
            type = InventoryEvent.CHANGE_SACK;
         }
         var ne:InventoryEvent = new InventoryEvent(type);
         ne.item = item;
         ne.slotIndex = this.slotIndex;
         dispatchEvent(ne);
      }
      
      public function set sack(value:Sack) : void
      {
         this._sack = value;
         item = Boolean(value) ? value.item : null;
         this.space.text = Boolean(value) ? String(Boolean(value.items) ? value.items.length : 0) : "";
         if(!value)
         {
            source = Assets.sackEmpty;
         }
      }
      
      public function get sack() : Sack
      {
         return this._sack;
      }
      
      override public function set enabled(value:Boolean) : void
      {
         if(_enabled == value)
         {
            return;
         }
         _enabled = value;
         alpha = value ? 1 : 0.5;
      }
   }
}

