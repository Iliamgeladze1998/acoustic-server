package soul.controller.interaction
{
   import flash.events.Event;
   import soul.controller.IManager;
   import soul.event.ShopEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.character.CharacterModel;
   import soul.model.inventory.InventoryModel;
   import soul.model.location.shop.SellData;
   import soul.model.location.shop.ShopData;
   import soul.model.location.shop.ShopItem;
   import soul.model.location.shop.ShopModel;
   import soul.net.ServerLayer;
   import soul.view.interaction.shop.ShopDialog;
   import soul.view.interaction.shop.ShopScreen;
   import soul.view.ui.controls.PopupManager;
   import soul.view.ui.controls.Window;
   
   public class ShopManager implements IManager
   {
      
      private var inventoryModel:InventoryModel;
      
      private var model:ShopModel;
      
      private var characterModel:CharacterModel;
      
      private var view:ShopScreen;
      
      private var popup:ShopDialog;
      
      public function ShopManager(view:ShopScreen, model:ShopModel, characterModel:CharacterModel, inventoryModel:InventoryModel)
      {
         super();
         this.view = view;
         this.model = model;
         this.inventoryModel = inventoryModel;
         this.characterModel = characterModel;
         view.model = model;
         view.addEventListener(SimpleUIEvent.CREATION_COMPLETE,this.creationComplete);
         view.addEventListener(ShopEvent.BUY_ITEM,this.buyItem);
         view.addEventListener(ShopEvent.SELL_ITEM,this.sellItem);
         view.addEventListener(ShopEvent.OPEN_BUY_DIALOG,this.openBuyDialog);
         view.addEventListener(ShopEvent.OPEN_SELL_DIALOG,this.openSellDialog);
         model.addEventListener(ShopEvent.OPEN_SELL_DIALOG,this.openSellDialog);
      }
      
      private function creationComplete(e:Event) : void
      {
         this.view.removeEventListener(SimpleUIEvent.CREATION_COMPLETE,this.creationComplete);
         this.refresh(null);
      }
      
      public function reset() : void
      {
         this.view.removeEventListener(SimpleUIEvent.CREATION_COMPLETE,this.creationComplete);
         this.view.removeEventListener(ShopEvent.BUY_ITEM,this.buyItem);
         this.view.removeEventListener(ShopEvent.SELL_ITEM,this.sellItem);
         this.view.removeEventListener(ShopEvent.OPEN_BUY_DIALOG,this.openBuyDialog);
         this.view.removeEventListener(ShopEvent.OPEN_SELL_DIALOG,this.openSellDialog);
         this.model.removeEventListener(ShopEvent.OPEN_SELL_DIALOG,this.openSellDialog);
         ShopModel.sellDatas = null;
         if(Boolean(this.popup))
         {
            this.closeDialog(null);
         }
      }
      
      private function openBuyDialog(e:ShopEvent) : void
      {
         var item:ShopItem = null;
         var si:ShopItem = null;
         for each(si in this.view.buyItemProvider)
         {
            if(si.templateId == e.templateId)
            {
               item = si;
               break;
            }
         }
         if(!item)
         {
            return;
         }
         this.closeDialog(null);
         this.popup = new ShopDialog();
         this.popup.addEventListener(Window.DIALOG_CLOSE,this.closeDialog);
         this.popup.addEventListener(ShopEvent.BUY_ITEM,this.buyItem);
         this.popup.item = item;
         this.popup.characterModel = this.characterModel;
         PopupManager.addPopup(this.popup,null,true);
         PopupManager.centerPopup(this.popup);
      }
      
      private function openSellDialog(e:ShopEvent) : void
      {
         var item:ShopItem = ShopItem.makeFromItem(this.inventoryModel.getItemByKey(e.item.key),ShopModel.sellDatas[e.item.id]);
         if(!item)
         {
            return;
         }
         if(Boolean(this.popup))
         {
            this.closeDialog(null);
         }
         this.popup = new ShopDialog();
         this.popup.addEventListener(Window.DIALOG_CLOSE,this.closeDialog);
         this.popup.addEventListener(ShopEvent.SELL_ITEM,this.sellItem);
         this.popup.item = item;
         PopupManager.addPopup(this.popup,null,true);
         PopupManager.centerPopup(this.popup);
      }
      
      private function closeDialog(e:Event) : void
      {
         if(!this.popup)
         {
            return;
         }
         this.view.mouseEnabled = true;
         PopupManager.removePopup(this.popup);
         this.popup = null;
      }
      
      private function refresh(e:Event) : void
      {
         ServerLayer.call("shopService","getShopData",this.setShopData);
      }
      
      private function setShopData(d:ShopData) : void
      {
         var data:SellData = null;
         trace("ShopManager.setShopData()");
         this.view.buyItemProvider = d.buyItems;
         var map:Object = {};
         for each(data in d.sellItems)
         {
            map[data.id] = data.price;
         }
         ShopModel.sellDatas = map;
         this.view.filterChange();
      }
      
      private function buyItem(e:ShopEvent) : void
      {
         trace("ShopManager.buyItem",e.templateId);
         this.closeDialog(null);
         ServerLayer.call("shopService","buyItem",this.buyOk,null,e.templateId,e.count);
      }
      
      private function sellItem(e:ShopEvent) : void
      {
         trace("ShopManager.sellItem",e.item.id);
         this.closeDialog(null);
         ServerLayer.call("shopService","sellItem",this.sellOk,null,e.item.key,e.count);
      }
      
      private function buyOk(sellDatas:Array = null) : void
      {
         var sellData:SellData = null;
         trace("ShopScreen.buyOk()",sellDatas);
         if(!sellDatas)
         {
            return;
         }
         for each(sellData in sellDatas)
         {
            if(Boolean(sellData))
            {
               ShopModel.sellDatas[sellData.id] = sellData.price;
            }
         }
      }
      
      private function sellOk(o:* = null) : void
      {
      }
   }
}

