package soul.view.interaction.auction
{
   import soul.model.item.Item;
   import soul.view.interaction.inventory.ItemContainer;
   import soul.view.ui.Tile;
   
   public class AuctionBackpack extends Tile
   {
      
      private var _dataProvider:Array;
      
      public function AuctionBackpack()
      {
         super();
      }
      
      public function set dataProvider(value:Array) : void
      {
         var item:Item = null;
         var child:ItemContainer = null;
         if(value == this._dataProvider)
         {
            return;
         }
         this._dataProvider = value;
         removeAllChildren();
         for each(item in value)
         {
            child = new ItemContainer();
            child.item = item;
            child.acceptsDrag = false;
            child.menuAllowed = false;
            addChild(child);
         }
      }
   }
}

