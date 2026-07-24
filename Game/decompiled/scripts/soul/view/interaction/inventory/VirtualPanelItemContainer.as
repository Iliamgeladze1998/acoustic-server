package soul.view.interaction.inventory
{
   import soul.event.DragEvent;
   import soul.event.InventoryEvent;
   import soul.model.item.Item;
   
   public class VirtualPanelItemContainer extends RuneContainer
   {
      
      public function VirtualPanelItemContainer()
      {
         super();
         menuAllowed = false;
         locked = true;
      }
      
      override protected function dragDrop(e:DragEvent) : void
      {
         var ne:InventoryEvent = null;
         var item:Item = Item(e.dragSource.dataForFormat("item")) || Item(e.dragSource.dataForFormat("runeItem"));
         var sourceSlot:int = e.dragSource.hasFormat("sourceSlot") ? int(e.dragSource.dataForFormat("sourceSlot")) : -1;
         if(sourceSlot > -1)
         {
            ne = new InventoryEvent(InventoryEvent.REMOVE_RUNE_SHORTCUT);
            ne.slotIndex = sourceSlot;
            dispatchEvent(ne);
         }
         ne = new InventoryEvent(InventoryEvent.CREATE_RUNE_SHORTCUT);
         ne.item = item;
         ne.slotIndex = slotIndex;
         dispatchEvent(ne);
      }
   }
}

