package soul.view.interaction.auction
{
   import flash.events.Event;
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.DragEvent;
   import soul.model.item.Item;
   import soul.model.item.ItemClass;
   import soul.model.location.shop.SellData;
   import soul.view.interaction.inventory.ItemContainer;
   
   public class AuctionItemContainer extends ItemContainer
   {
      
      public var allowedItems:Array;
      
      public function AuctionItemContainer()
      {
         super();
         menuAllowed = false;
         locked = true;
         this.item = null;
      }
      
      override protected function dragEnter(e:DragEvent) : void
      {
         var sd:SellData = null;
         var item:Item = e.dragSource.hasFormat("item") ? Item(e.dragSource.dataForFormat("item")) : null;
         if(Boolean(item) && item != this.item)
         {
            for each(sd in this.allowedItems)
            {
               if(Boolean(sd) && sd.id == item.id)
               {
                  SimpleDragManager.acceptDragDrop(this);
                  break;
               }
            }
         }
      }
      
      override protected function dragDrop(e:DragEvent) : void
      {
         var item:Item = Item(e.dragSource.dataForFormat("item"));
         this.item = item;
      }
      
      [Bindable("itemChanged")]
      override public function get item() : Item
      {
         return super.item;
      }
      
      override public function set item(value:Item) : void
      {
         super.item = value;
         if(!value)
         {
            backgroundImage = ItemClass.getItemImage(ItemClass.CLASS2);
            redraw();
         }
         dispatchEvent(new Event("itemChanged"));
      }
   }
}

