package soul.model.interaction.auction
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class AuctionModel extends EventDispatcher
   {
      
      private var _525507408auctionItemClasses:Array;
      
      private var _1686143453auctionItemTypes:Array;
      
      private var _164907692browseData:AuctionData;
      
      private var _118416825bidData:AuctionData;
      
      private var _353236635lotData:LotData;
      
      private var _309825114lotFeeCurrency:String;
      
      private var _1612539314endFeePercentRubies:Number;
      
      private var _1177984723endFeePercentCopper:Number;
      
      private var _1919558027lotTimes:Array;
      
      private var _436955986defaultTime:String;
      
      private var _1274492040filter:AuctionFilter;
      
      private var _656937929allowedCurrencies:Object;
      
      public function AuctionModel()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get auctionItemClasses() : Array
      {
         return this._525507408auctionItemClasses;
      }
      
      public function set auctionItemClasses(param1:Array) : void
      {
         var _loc2_:Object = this._525507408auctionItemClasses;
         if(_loc2_ !== param1)
         {
            this._525507408auctionItemClasses = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"auctionItemClasses",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get auctionItemTypes() : Array
      {
         return this._1686143453auctionItemTypes;
      }
      
      public function set auctionItemTypes(param1:Array) : void
      {
         var _loc2_:Object = this._1686143453auctionItemTypes;
         if(_loc2_ !== param1)
         {
            this._1686143453auctionItemTypes = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"auctionItemTypes",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get browseData() : AuctionData
      {
         return this._164907692browseData;
      }
      
      public function set browseData(param1:AuctionData) : void
      {
         var _loc2_:Object = this._164907692browseData;
         if(_loc2_ !== param1)
         {
            this._164907692browseData = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"browseData",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bidData() : AuctionData
      {
         return this._118416825bidData;
      }
      
      public function set bidData(param1:AuctionData) : void
      {
         var _loc2_:Object = this._118416825bidData;
         if(_loc2_ !== param1)
         {
            this._118416825bidData = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bidData",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lotData() : LotData
      {
         return this._353236635lotData;
      }
      
      public function set lotData(param1:LotData) : void
      {
         var _loc2_:Object = this._353236635lotData;
         if(_loc2_ !== param1)
         {
            this._353236635lotData = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lotData",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lotFeeCurrency() : String
      {
         return this._309825114lotFeeCurrency;
      }
      
      public function set lotFeeCurrency(param1:String) : void
      {
         var _loc2_:Object = this._309825114lotFeeCurrency;
         if(_loc2_ !== param1)
         {
            this._309825114lotFeeCurrency = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lotFeeCurrency",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get endFeePercentRubies() : Number
      {
         return this._1612539314endFeePercentRubies;
      }
      
      public function set endFeePercentRubies(param1:Number) : void
      {
         var _loc2_:Object = this._1612539314endFeePercentRubies;
         if(_loc2_ !== param1)
         {
            this._1612539314endFeePercentRubies = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endFeePercentRubies",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get endFeePercentCopper() : Number
      {
         return this._1177984723endFeePercentCopper;
      }
      
      public function set endFeePercentCopper(param1:Number) : void
      {
         var _loc2_:Object = this._1177984723endFeePercentCopper;
         if(_loc2_ !== param1)
         {
            this._1177984723endFeePercentCopper = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endFeePercentCopper",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lotTimes() : Array
      {
         return this._1919558027lotTimes;
      }
      
      public function set lotTimes(param1:Array) : void
      {
         var _loc2_:Object = this._1919558027lotTimes;
         if(_loc2_ !== param1)
         {
            this._1919558027lotTimes = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lotTimes",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get defaultTime() : String
      {
         return this._436955986defaultTime;
      }
      
      public function set defaultTime(param1:String) : void
      {
         var _loc2_:Object = this._436955986defaultTime;
         if(_loc2_ !== param1)
         {
            this._436955986defaultTime = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"defaultTime",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get filter() : AuctionFilter
      {
         return this._1274492040filter;
      }
      
      public function set filter(param1:AuctionFilter) : void
      {
         var _loc2_:Object = this._1274492040filter;
         if(_loc2_ !== param1)
         {
            this._1274492040filter = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"filter",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get allowedCurrencies() : Object
      {
         return this._656937929allowedCurrencies;
      }
      
      public function set allowedCurrencies(param1:Object) : void
      {
         var _loc2_:Object = this._656937929allowedCurrencies;
         if(_loc2_ !== param1)
         {
            this._656937929allowedCurrencies = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allowedCurrencies",_loc2_,param1));
            }
         }
      }
   }
}

