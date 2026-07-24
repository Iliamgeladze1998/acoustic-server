package soul.view.interaction.mail
{
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.DragEvent;
   import soul.model.item.Item;
   import soul.view.interaction.inventory.ItemContainer;
   
   public class MailItemContainer extends ItemContainer
   {
      
      public function MailItemContainer()
      {
         super();
         width = height = 51;
         menuAllowed = false;
      }
      
      override protected function dragEnter(e:DragEvent) : void
      {
         var item:Item = e.dragSource.hasFormat("item") ? Item(e.dragSource.dataForFormat("item")) : null;
         if(!item || item.locked || item.bound || item.equipped)
         {
            return;
         }
         if(!this.item || this.item.id != item.id)
         {
            SimpleDragManager.acceptDragDrop(this);
         }
      }
      
      override protected function dragDrop(e:DragEvent) : void
      {
         this.item = e.dragSource.dataForFormat("item") as Item;
      }
      
      override protected function dragComplete(e:DragEvent) : void
      {
         this.item = null;
      }
      
      override public function set enabled(value:Boolean) : void
      {
      }
      
      override public function set item(value:Item) : void
      {
         if(Boolean(super.item))
         {
            super.item.locked = false;
         }
         if(Boolean(value))
         {
            value.locked = true;
         }
         super.item = value;
      }
   }
}

