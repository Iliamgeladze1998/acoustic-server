package soul.view.interaction.loot
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.event.ItemClickEvent;
   import soul.model.interaction.loot.LootItem;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.ui.Tile;
   
   [Event(name="itemClick",type="soul.event.ItemClickEvent")]
   public class LootItems extends Tile
   {
      
      public function LootItems()
      {
         super();
      }
      
      public function set dataProvider(value:Array) : void
      {
         var slot:ItemRenderer = null;
         var li:LootItem = null;
         removeAllChildren();
         for each(li in value)
         {
            slot = new ItemRenderer();
            slot.minWidth = 87;
            slot.minHeight = 104;
            slot.item = LootItem.toItem(li);
            addChild(slot);
            if(Boolean(li))
            {
               slot.addEventListener(MouseEvent.CLICK,this.click);
            }
         }
      }
      
      private function click(e:Event) : void
      {
         e.stopPropagation();
         var slot:ItemRenderer = e.currentTarget as ItemRenderer;
         var id:int = getChildIndex(slot);
         var ie:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
         ie.index = id;
         ie.item = slot.item;
         dispatchEvent(ie);
      }
   }
}

