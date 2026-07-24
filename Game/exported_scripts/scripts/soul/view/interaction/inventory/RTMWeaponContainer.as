package soul.view.interaction.inventory
{
   import flash.events.MouseEvent;
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.DragEvent;
   import soul.event.RTMEvent;
   import soul.model.item.Item;
   import soul.model.item.ItemSlot;
   import soul.view.assets.Assets;
   
   public class RTMWeaponContainer extends ItemContainer
   {
      
      public var selectedIndex:uint;
      
      public function RTMWeaponContainer()
      {
         super();
         itemSlot = ItemSlot.WEAPON;
         menuAllowed = false;
         glow.source = Assets.iconGlow;
      }
      
      override protected function mouseDown(e:MouseEvent) : void
      {
      }
      
      override protected function dragStart(e:MouseEvent) : void
      {
      }
      
      override protected function click(e:MouseEvent) : void
      {
      }
      
      override protected function dragEnter(e:DragEvent) : void
      {
         var item:Item = e.dragSource.hasFormat("item") ? Item(e.dragSource.dataForFormat("item")) : null;
         if(!item)
         {
            return;
         }
         if(item.slot == _itemSlot && (!this.item || item.id != this.item.id))
         {
            SimpleDragManager.acceptDragDrop(this);
         }
      }
      
      override protected function dragDrop(e:DragEvent) : void
      {
         var item:Item = Item(e.dragSource.dataForFormat("item"));
         var ne:RTMEvent = new RTMEvent(RTMEvent.APPLY_WEAPON);
         ne.item = item;
         dispatchEvent(ne);
      }
   }
}

