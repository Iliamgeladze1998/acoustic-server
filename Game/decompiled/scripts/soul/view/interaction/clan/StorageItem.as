package soul.view.interaction.clan
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.core.DragSource;
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.ClanEvent;
   import soul.event.DragEvent;
   import soul.model.item.Item;
   import soul.view.interaction.inventory.ItemContainer;
   import soul.view.ui.CachedImage;
   
   public class StorageItem extends ItemContainer
   {
      
      public var sack:String;
      
      public function StorageItem()
      {
         super();
         menuAllowed = false;
      }
      
      override protected function dragStart(e:MouseEvent) : void
      {
         var ds:DragSource = null;
         var dsi:CachedImage = null;
         mouseUp(null);
         var target:ItemContainer = e.target as ItemContainer;
         if(item != null)
         {
            ds = new DragSource();
            ds.addData(item,"storageItem");
            ds.addData(slotIndex,"slotIndex");
            ds.addData(this.sack,"sack");
            dsi = new CachedImage();
            dsi.source = image.source;
            SimpleDragManager.doDrag(target,ds,e,dsi);
         }
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
         var ne:ClanEvent = new ClanEvent(ClanEvent.STORE_ITEM,true,true);
         ne.data = [this.sack,slotIndex,item.key];
         dispatchEvent(ne);
      }
      
      override protected function dblClick(e:Event) : void
      {
         if(Boolean(item))
         {
            this.take();
         }
      }
      
      private function take() : void
      {
         var ne:ClanEvent = new ClanEvent(ClanEvent.TAKE_ITEM,true,true);
         ne.data = [this.sack,slotIndex];
         dispatchEvent(ne);
      }
   }
}

