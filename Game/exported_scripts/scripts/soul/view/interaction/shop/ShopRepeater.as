package soul.view.interaction.shop
{
   import soul.model.location.shop.ShopItem;
   import soul.utils.Thread;
   import soul.view.common.CurrencyType;
   import soul.view.ui.Tile;
   
   public class ShopRepeater extends Tile
   {
      
      private var thread:Thread = new Thread(this);
      
      private var _dataProvider:Array;
      
      private var position:uint;
      
      public function ShopRepeater()
      {
         super();
      }
      
      private static function sortFunction(a:ShopItem, b:ShopItem) : int
      {
         var price1:int = 0;
         var price2:int = 0;
         if(a.fit && !b.fit)
         {
            return -1;
         }
         if(!a.fit && b.fit)
         {
            return 1;
         }
         if(a.type < b.type)
         {
            return -1;
         }
         if(a.type > b.type)
         {
            return 1;
         }
         if(Boolean(a.price[CurrencyType.COPPER]) && Boolean(b.price[CurrencyType.COPPER]))
         {
            price1 = int(a.price[CurrencyType.COPPER]);
            price2 = int(b.price[CurrencyType.COPPER]);
            return price1 < price2 ? -1 : (price1 > price2 ? 1 : 0);
         }
         if(Boolean(a.price[CurrencyType.RUBIES]) && Boolean(b.price[CurrencyType.RUBIES]))
         {
            price1 = int(a.price[CurrencyType.RUBIES]);
            price2 = int(b.price[CurrencyType.RUBIES]);
            return price1 < price2 ? -1 : (price1 > price2 ? 1 : 0);
         }
         if(Boolean(a.price[CurrencyType.PVP]) && Boolean(b.price[CurrencyType.PVP]))
         {
            price1 = int(a.price[CurrencyType.PVP]);
            price2 = int(b.price[CurrencyType.PVP]);
            return price1 < price2 ? -1 : (price1 > price2 ? 1 : 0);
         }
         return 0;
      }
      
      public function set dataProvider(value:Array) : void
      {
         if(value == this._dataProvider)
         {
            return;
         }
         removeAllChildren();
         if(!value)
         {
            return;
         }
         this._dataProvider = value.sort(sortFunction);
         if(value.length > 0)
         {
            this.position = 0;
            this.thread.start(this.proceedChunk);
         }
      }
      
      private function proceedChunk() : void
      {
         var item:ShopItem = null;
         var child:ShopItemContainer = null;
         while(this.position < this._dataProvider.length)
         {
            if(!this.thread.check())
            {
               return;
            }
            item = this._dataProvider[this.position];
            child = new ShopItemContainer();
            child.item = item;
            addChild(child);
            ++this.position;
         }
      }
   }
}

