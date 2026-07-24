package soul.view.interaction.inventory
{
   import flash.events.Event;
   import soul.model.inventory.Sack;
   import soul.model.item.Item;
   import soul.view.ui.Tile;
   
   public class Backpack extends Tile
   {
      
      private static const SLOT_NUMBER:int = 24;
      
      private var _dataProvider:Sack;
      
      public function Backpack()
      {
         super();
      }
      
      public function set dataProvider(value:Sack) : void
      {
         if(value == this._dataProvider)
         {
            return;
         }
         if(Boolean(this._dataProvider))
         {
            this._dataProvider.removeEventListener(Event.CHANGE,this.itemsChanges);
         }
         this._dataProvider = value;
         this._dataProvider.addEventListener(Event.CHANGE,this.itemsChanges);
         this.itemsChanges(null);
      }
      
      private function itemsChanges(e:Event) : void
      {
         var item:Item = null;
         var child:BackpackItem = null;
         removeAllChildren();
         var items:Vector.<Item> = Boolean(this._dataProvider) ? this._dataProvider.items : new Vector.<Item>();
         var len:int = int(items.length);
         for(var i:int = 0; i < SLOT_NUMBER; i++)
         {
            item = i < len ? items[i] : null;
            child = new BackpackItem();
            child.sackIndex = this._dataProvider.index;
            child.slotIndex = i;
            child.enabled = i < len;
            child.item = item;
            addChild(child);
         }
      }
   }
}

