package soul.view.interaction.inventory
{
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.ClanEvent;
   import soul.event.DragEvent;
   import soul.model.item.InvKey;
   import soul.model.item.Item;
   import soul.model.item.ItemClass;
   
   public class BackpackItem extends ItemContainer
   {
      
      public var sackIndex:int;
      
      public function BackpackItem()
      {
         super();
         acceptsDrag = true;
      }
      
      override public function set item(value:Item) : void
      {
         super.item = value;
         if(value == null)
         {
            backgroundImage = ItemClass.getItemImage(ItemClass.CLASS2);
         }
      }
      
      override protected function dragEnter(e:DragEvent) : void
      {
         var item:Item = Item(e.dragSource.dataForFormat("storageItem"));
         if(Boolean(item))
         {
            SimpleDragManager.acceptDragDrop(this);
            return;
         }
         super.dragEnter(e);
      }
      
      override protected function dragDrop(e:DragEvent) : void
      {
         var storageSlotIndex:int = 0;
         var sack:String = null;
         var storageItem:Item = Item(e.dragSource.dataForFormat("storageItem"));
         if(Boolean(storageItem))
         {
            storageSlotIndex = e.dragSource.dataForFormat("slotIndex") as int;
            sack = e.dragSource.dataForFormat("sack") as String;
            this.takeFromStorage(sack,storageSlotIndex);
         }
         else
         {
            super.dragDrop(e);
         }
      }
      
      private function takeFromStorage(sack:String, storageSlotIndex:int) : void
      {
         var ne:ClanEvent = new ClanEvent(ClanEvent.TAKE_ITEM,true,true);
         ne.data = [sack,storageSlotIndex,new InvKey(this.sackIndex,slotIndex)];
         dispatchEvent(ne);
      }
   }
}

