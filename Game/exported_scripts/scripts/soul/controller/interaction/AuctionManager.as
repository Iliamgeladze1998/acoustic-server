package soul.controller.interaction
{
   import flash.utils.describeType;
   import soul.controller.IManager;
   import soul.controller.Interaction;
   import soul.event.AuctionEvent;
   import soul.model.common.InteractionType;
   import soul.model.interaction.auction.AuctionConfig;
   import soul.model.interaction.auction.AuctionData;
   import soul.model.interaction.auction.AuctionModel;
   import soul.model.interaction.auction.CreateLotData;
   import soul.model.interaction.auction.Lot;
   import soul.model.interaction.auction.LotData;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   
   public class AuctionManager implements IManager
   {
      
      private var model:AuctionModel;
      
      public function AuctionManager(model:AuctionModel)
      {
         super();
         ComponentLocator.setComponent(ComponentLocator.AUCTION,this);
         this.model = model;
         model.addEventListener(AuctionEvent.FILTER_CHANGED,this.filterChanged);
         model.addEventListener(AuctionEvent.MAKE_BID,this.makeBid);
         model.addEventListener(AuctionEvent.CANCEL_BID,this.cancelBid);
         model.addEventListener(AuctionEvent.CREATE_LOT,this.createLot);
         model.addEventListener(AuctionEvent.CANCEL_LOT,this.cancelLot);
         ServerLayer.call("auctionService",ComponentLocator.READY);
      }
      
      public function reset() : void
      {
         this.model.removeEventListener(AuctionEvent.FILTER_CHANGED,this.filterChanged);
         this.model.removeEventListener(AuctionEvent.MAKE_BID,this.makeBid);
         this.model.removeEventListener(AuctionEvent.CANCEL_BID,this.cancelBid);
         this.model.removeEventListener(AuctionEvent.CREATE_LOT,this.createLot);
         this.model.removeEventListener(AuctionEvent.CANCEL_LOT,this.cancelLot);
      }
      
      public function init(lotData:LotData, bidData:AuctionData, cfg:AuctionConfig) : void
      {
         this.model.auctionItemClasses = cfg.itemClasses;
         this.model.auctionItemTypes = cfg.itemTypes;
         this.model.lotFeeCurrency = cfg.lotFeeCurrency;
         this.model.endFeePercentRubies = cfg.endFeePercentRubies;
         this.model.endFeePercentCopper = cfg.endFeePercentCopper;
         this.model.lotTimes = cfg.lotTimes;
         this.model.defaultTime = cfg.defaultTime;
         this.model.lotData = lotData;
         this.model.bidData = bidData;
         this.model.allowedCurrencies = cfg.allowedCurrencies;
      }
      
      public function close() : void
      {
         Interaction.hide(InteractionType.AUCTION);
      }
      
      public function removeLot(id:String) : void
      {
         var arr:Array = this.model.lotData.lots;
         var lot:Lot = this.getLotById(id,arr);
         if(!lot)
         {
            return;
         }
         arr.splice(arr.indexOf(lot),1);
         this.model.lotData.lots = null;
         this.model.lotData.lots = arr;
      }
      
      public function updateLot(lot:Lot) : void
      {
         var key:String = null;
         if(!lot)
         {
            return;
         }
         var oldLot:Lot = this.getLotById(lot.id,this.model.lotData.lots);
         if(!oldLot)
         {
            return;
         }
         var x:XML = describeType(lot);
         for each(key in x.accessor.@name)
         {
            oldLot[key] = lot[key];
         }
         for each(key in x.variable.@name)
         {
            oldLot[key] = lot[key];
         }
      }
      
      public function removeBid(id:String) : void
      {
         var arr:Array = this.model.bidData.lots;
         var lot:Lot = this.getLotById(id,arr);
         if(!lot)
         {
            return;
         }
         arr.splice(arr.indexOf(lot),1);
         this.model.bidData.lots = null;
         this.model.bidData.lots = arr;
      }
      
      public function updateBid(lot:Lot) : void
      {
         var key:String = null;
         if(!lot)
         {
            return;
         }
         var oldLot:Lot = this.getLotById(lot.id,this.model.bidData.lots);
         if(!oldLot)
         {
            return;
         }
         var props:XMLList = describeType(lot).accessor.@name;
         for each(key in props)
         {
            oldLot[key] = lot[key];
         }
      }
      
      public function updateInventory(value:Array) : void
      {
         this.model.lotData.inventory = value;
         this.model.dispatchEvent(new AuctionEvent(AuctionEvent.INVENTORY_CHANGED));
      }
      
      private function filterChanged(e:AuctionEvent) : void
      {
         ServerLayer.call("auctionService","getBrowseData",this.setBrowseData,null,this.model.filter);
      }
      
      private function setBrowseData(d:AuctionData) : void
      {
         this.model.browseData = d;
      }
      
      private function makeBid(e:AuctionEvent) : void
      {
         ServerLayer.call("auctionService","makeBid",this.makeBidResult,null,e.lotId,e.value);
      }
      
      private function makeBidResult(success:Boolean = false) : void
      {
         trace("bid result:" + success);
         this.filterChanged(null);
         if(!success)
         {
            return;
         }
         ServerLayer.call("auctionService","getBidData",this.setBidData);
      }
      
      private function setBidData(data:AuctionData) : void
      {
         this.model.bidData = data;
      }
      
      private function cancelBid(e:AuctionEvent) : void
      {
         ServerLayer.call("auctionService","cancelBid",this.cancelBidResult,null,e.lotId);
      }
      
      private function cancelBidResult(success:Boolean = false) : void
      {
         trace("cancelBid result:" + success);
      }
      
      private function createLot(e:AuctionEvent) : void
      {
         var cld:CreateLotData = e.createLotData;
         ServerLayer.call("auctionService","makeLot",this.createLotResult,null,cld.itemKey,cld.quantity,cld.currency,cld.startPrice,cld.buyNowPrice,cld.lotTimeId);
      }
      
      private function createLotResult(success:Boolean = false) : void
      {
         trace("createLot result:" + success);
         if(!success)
         {
            return;
         }
         ServerLayer.call("auctionService","getLotData",this.setLotData);
      }
      
      private function setLotData(data:LotData) : void
      {
         this.model.lotData = data;
      }
      
      private function cancelLot(e:AuctionEvent) : void
      {
         ServerLayer.call("auctionService","cancelLot",this.cancelLotResult,null,e.lotId);
      }
      
      private function cancelLotResult(success:Boolean = false) : void
      {
         trace("cancelLot result:" + success);
      }
      
      private function getLotById(lotId:String, data:Array) : Lot
      {
         var lot:Lot = null;
         for each(lot in data)
         {
            if(Boolean(lot) && lot.id == lotId)
            {
               return lot;
            }
         }
         return null;
      }
   }
}

