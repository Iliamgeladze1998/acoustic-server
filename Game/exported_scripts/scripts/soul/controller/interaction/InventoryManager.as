package soul.controller.interaction
{
   import flash.events.Event;
   import soul.controller.IManager;
   import soul.controller.Interaction;
   import soul.event.InventoryEvent;
   import soul.event.LootEvent;
   import soul.model.common.InteractionType;
   import soul.model.inventory.InventoryData;
   import soul.model.inventory.InventoryModel;
   import soul.model.item.InvKey;
   import soul.model.item.Item;
   import soul.model.item.ItemBindingType;
   import soul.model.item.ItemInfoManager;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   import soul.view.console.Console;
   import soul.view.interaction.loot.BindingDialog;
   import soul.view.ui.controls.PopupManager;
   import soul.view.ui.controls.Window;
   
   public class InventoryManager implements IManager
   {
      
      private static const SERVICE:String = "inventoryService";
      
      private var model:InventoryModel;
      
      private var popup:BindingDialog;
      
      public function InventoryManager(model:InventoryModel)
      {
         super();
         ComponentLocator.setComponent(ComponentLocator.INVENTORY,this);
         this.model = model;
         model.addEventListener(InventoryEvent.TAKEOFF,this.takeOff);
         model.addEventListener(InventoryEvent.TAKEOFF_TO_SACK,this.takeOffToSack);
         model.addEventListener(InventoryEvent.TAKEOFF_TO_SLOT,this.takeOffToSlot);
         model.addEventListener(InventoryEvent.EQUIP,this.equip);
         model.addEventListener(InventoryEvent.EQUIP_TO_SLOT,this.equipToSlot);
         model.addEventListener(InventoryEvent.CHANGE_SLOT,this.changeSlot);
         model.addEventListener(InventoryEvent.CHANGE_SACK,this.changeSack);
         model.addEventListener(InventoryEvent.CHANGE_BODY_SLOT,this.changeBodySlot);
         model.addEventListener(InventoryEvent.SPLIT,this.split);
         model.addEventListener(InventoryEvent.SPLIT_TO_SACK,this.splitToSack);
         model.addEventListener(InventoryEvent.DROP,this.dropItem);
         model.addEventListener(InventoryEvent.GET_SOCKETS,this.getSockets);
         model.addEventListener(InventoryEvent.ENCRUST_DELETED,this.encrustDeleted);
         ServerLayer.call(SERVICE,ComponentLocator.READY);
      }
      
      public function reset() : void
      {
         this.model.removeEventListener(InventoryEvent.TAKEOFF,this.takeOff);
         this.model.removeEventListener(InventoryEvent.TAKEOFF_TO_SACK,this.takeOffToSack);
         this.model.removeEventListener(InventoryEvent.TAKEOFF_TO_SLOT,this.takeOffToSlot);
         this.model.removeEventListener(InventoryEvent.EQUIP,this.equip);
         this.model.removeEventListener(InventoryEvent.EQUIP_TO_SLOT,this.equipToSlot);
         this.model.removeEventListener(InventoryEvent.CHANGE_SLOT,this.changeSlot);
         this.model.removeEventListener(InventoryEvent.CHANGE_SACK,this.changeSack);
         this.model.removeEventListener(InventoryEvent.CHANGE_BODY_SLOT,this.changeBodySlot);
         this.model.removeEventListener(InventoryEvent.SPLIT,this.split);
         this.model.removeEventListener(InventoryEvent.SPLIT_TO_SACK,this.splitToSack);
         this.model.removeEventListener(InventoryEvent.DROP,this.dropItem);
         this.model.removeEventListener(InventoryEvent.GET_SOCKETS,this.getSockets);
         this.model.removeEventListener(InventoryEvent.ENCRUST_DELETED,this.encrustDeleted);
      }
      
      private function equip(e:InventoryEvent) : void
      {
         var item:Item = e.item;
         this.model.currentEquippingItem = item;
         this.model.currentEquippingIndex = -1;
         if(item.binding == ItemBindingType.ON_EQUIP && !item.bound && item.confirmBinding)
         {
            this.createItemBindingScreen();
         }
         else
         {
            this.equipRequest();
         }
      }
      
      private function equipToSlot(e:InventoryEvent) : void
      {
         var item:Item = e.item;
         this.model.currentEquippingItem = item;
         this.model.currentEquippingIndex = e.slotIndex;
         if(item.binding == ItemBindingType.ON_EQUIP && !item.bound && item.confirmBinding)
         {
            this.createItemBindingScreen();
         }
         else
         {
            this.equipRequest();
         }
      }
      
      private function createItemBindingScreen() : void
      {
         this.closePopup();
         this.popup = new BindingDialog();
         this.popup.item = this.model.currentEquippingItem;
         this.popup.action = ItemBindingType.ON_EQUIP;
         this.popup.addEventListener(Window.DIALOG_CLOSE,this.closePopup);
         this.popup.addEventListener(LootEvent.CONFIRM,this.popupConfirm);
         PopupManager.addPopup(this.popup,null,true);
         PopupManager.centerPopup(this.popup);
      }
      
      private function popupConfirm(e:LootEvent) : void
      {
         this.closePopup();
         this.equipRequest();
      }
      
      private function closePopup(e:Event = null) : void
      {
         if(!this.popup)
         {
            return;
         }
         PopupManager.removePopup(this.popup);
         this.popup = null;
      }
      
      private function equipRequest() : void
      {
         if(this.model.currentEquippingIndex != -1)
         {
            ServerLayer.call(SERVICE,"equip",null,this.methodFailed,this.model.currentEquippingItem.key,this.model.currentEquippingIndex);
         }
         else
         {
            ServerLayer.call(SERVICE,"equip",null,this.methodFailed,this.model.currentEquippingItem.key);
         }
      }
      
      private function takeOff(e:InventoryEvent) : void
      {
         ServerLayer.call(SERVICE,"takeoff",null,this.methodFailed,e.item.slot,e.item.bodySlot);
      }
      
      private function takeOffToSack(e:InventoryEvent) : void
      {
         ServerLayer.call(SERVICE,"takeoff",null,this.methodFailed,e.item.slot,e.item.bodySlot,e.slotIndex);
      }
      
      private function takeOffToSlot(e:InventoryEvent) : void
      {
         ServerLayer.call(SERVICE,"takeoff",null,this.methodFailed,e.item.slot,e.item.bodySlot,new InvKey(this.model.selectedSack,e.slotIndex));
      }
      
      private function changeSlot(e:InventoryEvent) : void
      {
         ServerLayer.call(SERVICE,"changeSlot",null,this.methodFailed,e.item.key,e.slotIndex);
      }
      
      private function changeSack(e:InventoryEvent) : void
      {
         ServerLayer.call(SERVICE,"changeSack",null,this.methodFailed,e.item.key,e.slotIndex);
      }
      
      private function changeBodySlot(e:InventoryEvent) : void
      {
         ServerLayer.call(SERVICE,"changeBodySlot",null,this.methodFailed,e.item.slot,e.item.bodySlot,e.slotIndex);
      }
      
      private function split(e:InventoryEvent) : void
      {
         ServerLayer.call(SERVICE,"split",null,this.methodFailed,e.item.key,e.item.count,e.slotIndex);
      }
      
      private function splitToSack(e:InventoryEvent) : void
      {
         ServerLayer.call(SERVICE,"splitToSack",null,this.methodFailed,e.item.key,e.item.count,e.slotIndex);
      }
      
      private function dropItem(e:InventoryEvent) : void
      {
         if(!e.item)
         {
            return;
         }
         ServerLayer.call(SERVICE,"drop",null,this.methodFailed,e.item.key,e.item.count);
      }
      
      private function getSockets(e:InventoryEvent) : void
      {
         var item:Item = e.item;
         if(!item)
         {
            return;
         }
         Interaction.toggle(InteractionType.ENCRUST,false,item);
      }
      
      private function encrustDeleted(e:InventoryEvent) : void
      {
         Interaction.hide(InteractionType.ENCRUST);
      }
      
      private function methodFailed(r:* = null) : void
      {
         Console.trace("InventoryManager.methodFailed()",r);
      }
      
      public function init(data:InventoryData) : void
      {
         this.model.load(data);
      }
      
      public function addBodyItem(item:Item, index:int) : void
      {
         trace("InventoryManager.addBodyItem()",item,index);
         this.model.addBodyItem(item,index);
      }
      
      public function removeBodyItem(itemId:String) : void
      {
         trace("InventoryManager.addBodyItem()",itemId);
         this.model.removeBodyItem(itemId);
      }
      
      public function swapBodyItem(slotType:String, src:int, dst:int) : void
      {
         trace("InventoryManager.swapBodyItem()",slotType,src,dst);
         this.model.swapBodyItem(slotType,src,dst);
      }
      
      public function addInventoryItem(item:Item, key:InvKey) : void
      {
         trace("InventoryManager.addInventoryItems()",item);
         this.model.addInventoryItem(item,key);
      }
      
      public function removeInventoryItem(key:InvKey) : void
      {
         trace("InventoryManager.removeInventoryItems()",key);
         this.model.removeInventoryItem(key);
      }
      
      public function swapInventoryItem(src:InvKey, dst:InvKey) : void
      {
         trace("InventoryManager.swapInventoryItem()",src,dst);
         this.model.swapInventoryItem(src,dst);
      }
      
      public function updateItem(item:Item) : void
      {
         if(!item)
         {
            return;
         }
         trace("InventoryManager.updateItem()",item);
         this.model.updateItem(item);
         ItemInfoManager.removeCacheEntry(item.id);
      }
      
      public function updateItemProperty(itemId:String, property:String, value:Object) : void
      {
         this.model.updateItemProperty(itemId,property,value);
         ItemInfoManager.removeCacheEntry(itemId);
      }
      
      public function invalidateItemCache(itemId:String) : void
      {
         ItemInfoManager.removeCacheEntry(itemId);
      }
   }
}

