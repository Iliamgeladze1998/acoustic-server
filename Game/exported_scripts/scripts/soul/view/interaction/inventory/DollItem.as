package soul.view.interaction.inventory
{
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.DragEvent;
   import soul.model.item.Item;
   
   public class DollItem extends ItemContainer
   {
      
      public function DollItem()
      {
         super();
         backgroundTransparent = true;
      }
      
      override protected function dragEnter(e:DragEvent) : void
      {
         var item:Item = e.dragSource.hasFormat("item") ? Item(e.dragSource.dataForFormat("item")) : null;
         if(locked || !item || item.slot != _itemSlot)
         {
            return;
         }
         if(!this.item || this.item.id != item.id)
         {
            SimpleDragManager.acceptDragDrop(this);
         }
      }
   }
}

