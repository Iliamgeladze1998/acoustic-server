package soul.view.interaction.inventory
{
   import flash.events.MouseEvent;
   import mx.core.DragSource;
   import soul.controller.mouse.DragAction;
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.DragEvent;
   import soul.event.InventoryEvent;
   import soul.model.GameModel;
   import soul.model.item.Item;
   import soul.model.item.ItemShortcut;
   import soul.model.item.ItemSlot;
   import soul.model.item.ItemType;
   import soul.view.ui.CachedImage;
   
   public class AutoRuneContainer extends RuneContainer
   {
      
      public function AutoRuneContainer()
      {
         super();
         itemSlot = ItemSlot.AUTO_RUNE;
         glowSource = null;
         menuAllowed = false;
         statsOk = true;
      }
      
      override protected function dragStart(e:MouseEvent) : void
      {
         super.mouseUp(null);
         if(locked)
         {
            return;
         }
         if(!item)
         {
            return;
         }
         var target:RuneContainer = e.target as RuneContainer;
         var ds:DragSource = new DragSource();
         ds.addData(item,"autoRuneItem");
         if(this is AutoRuneContainer)
         {
            ds.addData(slotIndex,"sourceSlot");
         }
         var dsi:CachedImage = new CachedImage();
         dsi.source = image.source;
         SimpleDragManager.doDrag(target,ds,e,dsi);
      }
      
      override protected function dragEnter(e:DragEvent) : void
      {
         if(locked)
         {
            return;
         }
         var item:Item = Item(e.dragSource.dataForFormat("item")) || Item(e.dragSource.dataForFormat("autoRuneItem"));
         if(Boolean(item) && item.type == ItemType.AUTO_RUNE)
         {
            SimpleDragManager.acceptDragDrop(this);
         }
      }
      
      override protected function dragDrop(e:DragEvent) : void
      {
         var ne:InventoryEvent = null;
         var item:Item = Item(e.dragSource.dataForFormat("item")) || Item(e.dragSource.dataForFormat("autoRuneItem"));
         var sourceSlot:int = e.dragSource.hasFormat("sourceSlot") ? int(e.dragSource.dataForFormat("sourceSlot")) : -1;
         if(sourceSlot > -1)
         {
            ne = new InventoryEvent(InventoryEvent.REMOVE_AUTO_RUNE_SHORTCUT);
            ne.slotIndex = sourceSlot;
            dispatchEvent(ne);
         }
         ne = new InventoryEvent(InventoryEvent.CREATE_AUTO_RUNE_SHORTCUT);
         ne.itemId = item.templateId;
         ne.slotIndex = slotIndex;
         dispatchEvent(ne);
      }
      
      override protected function dragComplete(e:DragEvent) : void
      {
         var ne:InventoryEvent = null;
         if(e.action == DragAction.NONE)
         {
            ne = new InventoryEvent(InventoryEvent.REMOVE_AUTO_RUNE_SHORTCUT);
            ne.slotIndex = slotIndex;
            dispatchEvent(ne);
         }
      }
      
      public function set itemShortcut(value:ItemShortcut) : void
      {
         item = Boolean(value) ? (locked ? value.toItem() : GameModel.getInstance().inventoryModel.getItemByShortcut(value)) : null;
      }
   }
}

