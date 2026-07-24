package soul.controller.interaction
{
   import flash.events.Event;
   import soul.controller.IManager;
   import soul.event.BarterEvent;
   import soul.model.interaction.barter.BarterData;
   import soul.model.interaction.barter.BarterModel;
   import soul.model.inventory.InventoryModel;
   import soul.model.item.InvKey;
   import soul.model.item.Item;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   import soul.view.common.CurrencyType;
   
   public class BarterManager implements IManager
   {
      
      private static const barterService:String = "barterService";
      
      private var model:BarterModel;
      
      private var inventoryModel:InventoryModel;
      
      public function BarterManager(model:BarterModel, inventoryModel:InventoryModel)
      {
         super();
         ComponentLocator.setComponent(ComponentLocator.BARTER,this);
         this.model = model;
         this.inventoryModel = inventoryModel;
         model.addEventListener(Event.CANCEL,this.onClose,false,0,true);
         model.addEventListener(BarterEvent.INVITE,this.onInvite,false,0,true);
         model.addEventListener(BarterEvent.INIT,this.onInit,false,0,true);
         model.addEventListener(BarterEvent.OFFER_ITEM,this.offerItem,false,0,true);
         model.addEventListener(BarterEvent.OFFER_MONEY,this.offerMoney,false,0,true);
         model.addEventListener(BarterEvent.READY,this.ready,false,0,true);
      }
      
      public function reset() : void
      {
         ComponentLocator.setComponent(ComponentLocator.BARTER,null);
      }
      
      private function onClose(e:Event) : void
      {
         ServerLayer.call(barterService,"cancel");
      }
      
      private function onInvite(e:BarterEvent) : void
      {
         ServerLayer.call(barterService,"barter",null,null,e.characterId);
      }
      
      private function onInit(e:BarterEvent) : void
      {
         ServerLayer.call(barterService,ComponentLocator.READY);
      }
      
      private function offerItem(e:BarterEvent) : void
      {
         var item:Item = e.item;
         if(Boolean(item))
         {
            ServerLayer.call(barterService,"offerItem",null,null,e.item.key,e.index);
         }
         else
         {
            ServerLayer.call(barterService,"removeItem",null,null,e.index);
         }
      }
      
      private function offerMoney(e:BarterEvent) : void
      {
         ServerLayer.call(barterService,"offerMoney",null,null,e.currency,e.amount);
      }
      
      private function ready(e:BarterEvent) : void
      {
         ServerLayer.call(barterService,"setReady",null,null,e.ready);
      }
      
      public function init(data:BarterData) : void
      {
         var i:int = 0;
         trace("BarterManager.init()",arguments);
         this.model.opponentId = data.charId;
         this.model.opponentName = data.charName;
         this.model.opponentImage = data.imagePath;
         this.model.opponentCopper = data.copper;
         this.model.opponentRubies = data.rubies;
         this.model.waiting = data.waiting;
         if(Boolean(data.items))
         {
            for(i = 0; i < data.items.length; i++)
            {
               this.model["opponentItem" + i] = data.items[i];
            }
         }
      }
      
      public function setSelfItem(key:InvKey, position:int) : void
      {
         trace("BarterManager.setSelfItem()",arguments);
         var item:Item = this.model["myItem" + position];
         if(Boolean(item))
         {
            item.locked = false;
         }
         item = this.inventoryModel.getItemByKey(key);
         if(Boolean(item))
         {
            item.locked = true;
         }
         this.model["myItem" + position] = item;
      }
      
      public function removeSelfItem(position:int) : void
      {
         trace("BarterManager.removeSelfItem()",arguments);
         var item:Item = this.model["myItem" + position];
         if(Boolean(item))
         {
            item.locked = false;
         }
         this.model["myItem" + position] = null;
      }
      
      public function setPartnerItem(item:Item, position:int) : void
      {
         trace("BarterManager.setPartnerItem()",arguments);
         this.model["opponentItem" + position] = item;
      }
      
      public function removePartnerItem(position:int) : void
      {
         trace("BarterManager.removePartnerItem()",arguments);
         this.model["opponentItem" + position] = null;
      }
      
      public function setSelfMoney(type:String, amount:int) : void
      {
         trace("BarterManager.setSelfMoney()",arguments);
         if(type == CurrencyType.RUBIES)
         {
            this.model.myRubies = amount;
         }
         else
         {
            this.model.myCopper = amount;
         }
      }
      
      public function setPartnerMoney(type:String, amount:int) : void
      {
         trace("BarterManager.setPartnerMoney()",arguments);
         if(type == CurrencyType.RUBIES)
         {
            this.model.opponentRubies = amount;
         }
         else
         {
            this.model.opponentCopper = amount;
         }
      }
      
      public function setPartnerReady(flag:Boolean) : void
      {
         trace("BarterManager.setPartnerReady()",flag);
         this.model.opponentReady = flag;
      }
      
      public function setMyReady(flag:Boolean) : void
      {
         trace("BarterManager.setMyReady()",flag);
         this.model.iAmReady = flag;
      }
   }
}

