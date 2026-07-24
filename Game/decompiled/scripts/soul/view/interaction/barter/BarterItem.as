package soul.view.interaction.barter
{
   import flash.display.Sprite;
   import flash.events.Event;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.BarterEvent;
   import soul.event.DragEvent;
   import soul.model.item.Item;
   import soul.view.assets.Assets;
   import soul.view.interaction.inventory.ItemContainer;
   import soul.view.ui.soul_internal;
   
   use namespace soul_internal;
   
   public class BarterItem extends ItemContainer
   {
      
      private var glowBorder:Sprite = new Assets.barterItemGlow();
      
      public function BarterItem()
      {
         super();
         menuAllowed = false;
         soul_internal::$addChild(this.glowBorder);
         this.glowBorder.mouseEnabled = false;
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
         var item:Item = e.dragSource.dataForFormat("item") as Item;
         this.dragComplete(null);
         var ne:BarterEvent = new BarterEvent(BarterEvent.OFFER_ITEM,true,true);
         ne.item = item;
         ne.index = slotIndex;
         dispatchEvent(ne);
      }
      
      override protected function dragComplete(e:DragEvent) : void
      {
         var ne:BarterEvent = new BarterEvent(BarterEvent.OFFER_ITEM,true,true);
         ne.item = null;
         ne.index = slotIndex;
         dispatchEvent(ne);
      }
      
      override protected function applySize() : void
      {
         super.applySize();
         this.glowBorder.width = width;
         this.glowBorder.height = height;
      }
      
      override public function set enabled(value:Boolean) : void
      {
      }
      
      [Bindable("itemChanged")]
      override public function get item() : Item
      {
         return super.item;
      }
      
      override public function set item(value:Item) : void
      {
         if(Boolean(this.item))
         {
            this.item.locked = false;
         }
         super.item = value;
         this.glowBorder.visible = !value;
         if(!value)
         {
            toolTip = null;
            toolTip = LocaleManager.getString(BundleName.INTERFACE,"placeItemToBarted");
         }
         dispatchEvent(new Event("itemChanged"));
      }
   }
}

