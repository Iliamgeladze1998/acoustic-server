package soul.model.inventory
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.describeType;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import mx.utils.ObjectProxy;
   import soul.event.InventoryEvent;
   import soul.model.interaction.settings.SettingsModel;
   import soul.model.item.InvKey;
   import soul.model.item.Item;
   import soul.model.item.ItemShortcut;
   import soul.model.item.ItemSlot;
   
   public class InventoryModel extends EventDispatcher
   {
      
      private var _801814363hasBrokenItemsWorn:Boolean = false;
      
      private var _3029410body:BodyModel;
      
      private var _109193213sacks:Vector.<Sack>;
      
      private var _1754505103selectedSack:int;
      
      private var _725711140totalItems:ObjectProxy = new ObjectProxy();
      
      private var _1194971291totalItemCounts:ObjectProxy = new ObjectProxy();
      
      private var _1499426665encrustingItem:String;
      
      private var _1406566692currentEquippingItem:Item;
      
      private var _654074327currentEquippingIndex:int;
      
      private var settingsModel:SettingsModel;
      
      private var _virtualPanelShortcuts:Vector.<ItemShortcut>;
      
      public function InventoryModel(settingsModel:SettingsModel)
      {
         super();
         this.settingsModel = settingsModel;
      }
      
      public function get virtualPanelShortcuts() : Vector.<ItemShortcut>
      {
         return this.settingsModel.virtualPanelShortcuts;
      }
      
      private function set _982777036virtualPanelShortcuts(value:Vector.<ItemShortcut>) : void
      {
         this.settingsModel.virtualPanelShortcuts = value;
      }
      
      private function inventoryChanged(e:PropertyChangeEvent) : void
      {
         var oldTotal:Item = null;
         var newItem:Item = null;
         var newTotal:Item = null;
         var oldItem:Item = e.oldValue as Item;
         if(Boolean(oldItem))
         {
            oldTotal = this.totalItems[oldItem.templateId];
         }
         if(Boolean(oldTotal))
         {
            oldTotal.count -= oldItem.count;
            this.totalItemCounts[oldItem.templateId] -= oldItem.count;
         }
         if(e.kind == PropertyChangeEventKind.DELETE)
         {
            this.totalItems[oldItem.templateId] = oldTotal;
            oldTotal.id = null;
         }
         else if(e.kind == PropertyChangeEventKind.UPDATE)
         {
            newItem = e.newValue as Item;
            if(Boolean(newItem))
            {
               newTotal = this.totalItems[newItem.templateId];
            }
            if(Boolean(newTotal))
            {
               newTotal.count += newItem.count;
               newTotal.id = newItem.id;
               this.totalItemCounts[newItem.templateId] = this.totalItemCounts[newItem.templateId] || 0;
               this.totalItemCounts[newItem.templateId] += newItem.count;
            }
            else
            {
               this.totalItems[newItem.templateId] = newItem.clone();
               this.totalItemCounts[newItem.templateId] = newItem.count;
            }
         }
      }
      
      private function itemChanged(e:PropertyChangeEvent) : void
      {
         var changedItem:Item = Item(e.source);
         var item:Item = this.totalItems[changedItem.templateId];
         if(!item)
         {
            return;
         }
         item.count += int(e.newValue) - int(e.oldValue);
         this.totalItemCounts[item.templateId] += int(e.newValue) - int(e.oldValue);
      }
      
      public function load(data:InventoryData) : void
      {
         var sackItem:Item = null;
         this.sacks = new Vector.<Sack>(6);
         for(var i:int = 0; i < data.inventory.length; i++)
         {
            sackItem = data.inventory[i];
            this.initSack(sackItem,i);
         }
         this.body = new BodyModel();
         this.body.load(data.bodyItems);
         this.body.loadItems(data.prizes);
         this.checkBrokenItems();
      }
      
      private function initSack(sackItem:Item, index:int) : void
      {
         var item:Item = null;
         var sack:Sack = Boolean(sackItem) ? new Sack() : null;
         if(Boolean(sack))
         {
            sackItem.bodySlot = index;
            sackItem.equipped = true;
            sack.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.inventoryChanged,false,0,true);
            sack.load(index,sackItem);
            for each(item in sack.items)
            {
               this.addItemListener(item);
            }
         }
         this.sacks[index] = sack;
      }
      
      public function getItemByShortcut(shortcut:ItemShortcut) : Item
      {
         if(!shortcut)
         {
            return null;
         }
         var item:Item = this.totalItems[shortcut.templateId];
         if(!item)
         {
            item = shortcut.toItem();
            item.usable = true;
            this.totalItems[shortcut.templateId] = item;
         }
         return item;
      }
      
      public function getItemByKey(key:InvKey) : Item
      {
         var sack:Sack = this.sacks[key.sack];
         if(Boolean(sack))
         {
            return sack.getItemBySlot(key.slot);
         }
         return null;
      }
      
      public function getItemById(id:String) : Item
      {
         var sack:Sack = null;
         var item:Item = null;
         for each(sack in this.sacks)
         {
            if(sack)
            {
               item = sack.getItemById(id);
               if(Boolean(item))
               {
                  return item;
               }
            }
         }
         return null;
      }
      
      public function getWornItemBySlot(slotType:String) : Item
      {
         return this.body.getWornItemBySlot(slotType);
      }
      
      private function addItemListener(item:Item) : void
      {
         if(item is IEventDispatcher)
         {
            IEventDispatcher(item).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.itemChanged,false,0,true);
         }
      }
      
      public function addBodyItem(item:Item, index:int) : void
      {
         if(item.slot == ItemSlot.SACK)
         {
            this.initSack(item,index);
            this.sacks = this.sacks.slice();
         }
         else
         {
            this.body.setBodyItem(item,index);
            this.checkBrokenItems();
         }
      }
      
      public function removeBodyItem(itemId:String) : void
      {
         var sackItem:Item = null;
         var sack:Sack = null;
         if(this.encrustingItem == itemId)
         {
            dispatchEvent(new InventoryEvent(InventoryEvent.ENCRUST_DELETED));
         }
         for each(sack in this.sacks)
         {
            if(Boolean(sack) && Boolean(sack.item) && sack.item.id == itemId)
            {
               sackItem = sack.item;
               break;
            }
         }
         if(Boolean(sackItem))
         {
            this.sacks[sackItem.bodySlot] = null;
            this.sacks = this.sacks.slice();
         }
         else
         {
            this.body.removeItem(itemId);
            this.checkBrokenItems();
         }
      }
      
      public function swapBodyItem(slotType:String, src:int, dst:int) : void
      {
         var tmp:Sack = null;
         if(slotType == ItemSlot.SACK)
         {
            tmp = this.sacks[src];
            this.sacks[src] = this.sacks[dst];
            this.sacks[dst] = tmp;
            tmp = this.sacks[src];
            if(Boolean(tmp) && Boolean(tmp.item))
            {
               tmp.item.bodySlot = src;
            }
            tmp = this.sacks[dst];
            if(Boolean(tmp) && Boolean(tmp.item))
            {
               tmp.item.bodySlot = dst;
            }
            this.sacks = this.sacks.slice();
         }
         else
         {
            this.body.swapItem(slotType,src,dst);
         }
      }
      
      public function addInventoryItem(item:Item, key:InvKey) : void
      {
         if(!item || !key)
         {
            return;
         }
         var sack:Sack = this.sacks[key.sack];
         item.key = key;
         sack.addItem(item);
         this.addItemListener(item);
      }
      
      public function removeInventoryItem(key:InvKey) : void
      {
         if(!key)
         {
            return;
         }
         var sack:Sack = this.sacks[key.sack];
         if(!sack)
         {
            return;
         }
         var item:Item = sack.removeItemBySlot(key.slot);
         if(Boolean(item) && this.encrustingItem == item.id)
         {
            dispatchEvent(new InventoryEvent(InventoryEvent.ENCRUST_DELETED));
         }
      }
      
      public function swapInventoryItem(src:InvKey, dst:InvKey) : void
      {
         var srcSack:Sack = this.sacks[src.sack];
         if(!srcSack)
         {
            return;
         }
         var dstSack:Sack = this.sacks[dst.sack];
         if(!dstSack)
         {
            return;
         }
         var srcItem:Item = srcSack.removeItemBySlot(src.slot);
         var dstItem:Item = dstSack.removeItemBySlot(dst.slot);
         if(Boolean(srcItem))
         {
            this.addInventoryItem(srcItem,dst);
         }
         if(Boolean(dstItem))
         {
            this.addInventoryItem(dstItem,src);
         }
      }
      
      public function updateItem(item:Item) : void
      {
         var sack:Sack = null;
         var oldItem:Item = null;
         var props:XMLList = null;
         var key:String = null;
         for each(sack in this.sacks)
         {
            oldItem = sack.getItemById(item.id);
            if(Boolean(oldItem))
            {
               props = describeType(item).accessor.@name;
               for each(key in props)
               {
                  oldItem[key] = item[key];
               }
               break;
            }
         }
      }
      
      public function updateItemProperty(itemId:String, property:String, value:Object) : void
      {
         var item:Item = this.body.getItemById(itemId) || this.getItemById(itemId);
         if(Boolean(item))
         {
            item[property] = value;
         }
         this.checkBrokenItems();
      }
      
      private function checkBrokenItems() : void
      {
         this.hasBrokenItemsWorn = this.body.hasBrokenItemsWorn();
      }
      
      [Bindable(event="propertyChange")]
      public function get hasBrokenItemsWorn() : Boolean
      {
         return this._801814363hasBrokenItemsWorn;
      }
      
      public function set hasBrokenItemsWorn(param1:Boolean) : void
      {
         var _loc2_:Object = this._801814363hasBrokenItemsWorn;
         if(_loc2_ !== param1)
         {
            this._801814363hasBrokenItemsWorn = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hasBrokenItemsWorn",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get body() : BodyModel
      {
         return this._3029410body;
      }
      
      public function set body(param1:BodyModel) : void
      {
         var _loc2_:Object = this._3029410body;
         if(_loc2_ !== param1)
         {
            this._3029410body = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"body",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get sacks() : Vector.<Sack>
      {
         return this._109193213sacks;
      }
      
      public function set sacks(param1:Vector.<Sack>) : void
      {
         var _loc2_:Object = this._109193213sacks;
         if(_loc2_ !== param1)
         {
            this._109193213sacks = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sacks",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedSack() : int
      {
         return this._1754505103selectedSack;
      }
      
      public function set selectedSack(param1:int) : void
      {
         var _loc2_:Object = this._1754505103selectedSack;
         if(_loc2_ !== param1)
         {
            this._1754505103selectedSack = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedSack",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get totalItems() : ObjectProxy
      {
         return this._725711140totalItems;
      }
      
      public function set totalItems(param1:ObjectProxy) : void
      {
         var _loc2_:Object = this._725711140totalItems;
         if(_loc2_ !== param1)
         {
            this._725711140totalItems = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalItems",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get totalItemCounts() : ObjectProxy
      {
         return this._1194971291totalItemCounts;
      }
      
      public function set totalItemCounts(param1:ObjectProxy) : void
      {
         var _loc2_:Object = this._1194971291totalItemCounts;
         if(_loc2_ !== param1)
         {
            this._1194971291totalItemCounts = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalItemCounts",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get encrustingItem() : String
      {
         return this._1499426665encrustingItem;
      }
      
      public function set encrustingItem(param1:String) : void
      {
         var _loc2_:Object = this._1499426665encrustingItem;
         if(_loc2_ !== param1)
         {
            this._1499426665encrustingItem = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"encrustingItem",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentEquippingItem() : Item
      {
         return this._1406566692currentEquippingItem;
      }
      
      public function set currentEquippingItem(param1:Item) : void
      {
         var _loc2_:Object = this._1406566692currentEquippingItem;
         if(_loc2_ !== param1)
         {
            this._1406566692currentEquippingItem = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentEquippingItem",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentEquippingIndex() : int
      {
         return this._654074327currentEquippingIndex;
      }
      
      public function set currentEquippingIndex(param1:int) : void
      {
         var _loc2_:Object = this._654074327currentEquippingIndex;
         if(_loc2_ !== param1)
         {
            this._654074327currentEquippingIndex = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentEquippingIndex",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set virtualPanelShortcuts(param1:Vector.<ItemShortcut>) : void
      {
         var _loc2_:Object = this.virtualPanelShortcuts;
         if(_loc2_ !== param1)
         {
            this._982777036virtualPanelShortcuts = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"virtualPanelShortcuts",_loc2_,param1));
            }
         }
      }
   }
}

