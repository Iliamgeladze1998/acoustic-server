package soul.view.interaction.workshop
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.events.ItemClickEvent;
   import soul.model.location.workshop.WorkshopItem;
   import soul.view.ui.Tile;
   
   public class WorkshopItems extends Tile
   {
      
      [Event(name="itemClick",type="mx.events.ItemClickEvent")]
      private static const MIN_ITEMS_TO_RENDER:int = 12;
      
      public function WorkshopItems()
      {
         super();
      }
      
      public function set dataProvider(value:Array) : void
      {
         var slot:WorkshopItemRenderer = null;
         var wi:WorkshopItem = null;
         removeAllChildren();
         var rendered:int = 0;
         for each(wi in value)
         {
            rendered++;
            slot = new WorkshopItemRenderer();
            slot.workshopItem = wi;
            slot.addEventListener(MouseEvent.DOUBLE_CLICK,this.click,true);
            addChild(slot);
         }
         while(rendered < MIN_ITEMS_TO_RENDER)
         {
            rendered++;
            slot = new WorkshopItemRenderer();
            slot.workshopItem = null;
            addChild(slot);
         }
      }
      
      private function click(e:Event) : void
      {
         e.stopPropagation();
         var slot:WorkshopItemRenderer = e.currentTarget as WorkshopItemRenderer;
         var id:int = getChildIndex(slot);
         var ie:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
         ie.index = id;
         dispatchEvent(ie);
      }
   }
}

