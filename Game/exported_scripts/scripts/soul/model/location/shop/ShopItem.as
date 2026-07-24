package soul.model.location.shop
{
   import mx.events.PropertyChangeEvent;
   import soul.model.item.Item;
   
   public class ShopItem extends Item
   {
      
      private var _106934601price:Object;
      
      private var _101393fit:Boolean;
      
      public function ShopItem()
      {
         super();
      }
      
      public static function makeFromItem(item:Item, price:Object) : ShopItem
      {
         if(!item)
         {
            return null;
         }
         var si:ShopItem = new ShopItem();
         si.id = item.id;
         si.templateId = item.templateId;
         si.imagePath = item.imagePath;
         si.type = item.type;
         si.price = price;
         si.count = item.count;
         si.itemClass = item.itemClass;
         si.durabilityMaximum = item.durabilityMaximum;
         si.durability = item.durability;
         si.key = item.key;
         return si;
      }
      
      [Bindable(event="propertyChange")]
      public function get price() : Object
      {
         return this._106934601price;
      }
      
      public function set price(param1:Object) : void
      {
         var _loc2_:Object = this._106934601price;
         if(_loc2_ !== param1)
         {
            this._106934601price = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"price",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fit() : Boolean
      {
         return this._101393fit;
      }
      
      public function set fit(param1:Boolean) : void
      {
         var _loc2_:Object = this._101393fit;
         if(_loc2_ !== param1)
         {
            this._101393fit = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fit",_loc2_,param1));
            }
         }
      }
   }
}

