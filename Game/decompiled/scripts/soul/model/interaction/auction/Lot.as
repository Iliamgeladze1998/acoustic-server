package soul.model.interaction.auction
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.model.item.Item;
   
   public class Lot implements IEventDispatcher
   {
      
      private var _3355id:String;
      
      private var _104345093myLot:Boolean;
      
      private var _3242771item:Item;
      
      private var _102865796level:int;
      
      private var _575402001currency:String;
      
      private var _1089001276currentBid:int;
      
      private var _1377575312buyNow:int;
      
      private var _104335281myBid:int;
      
      private var _1048873155newBid:int;
      
      private var _640500911cancelPenalty:int;
      
      private var _353720766lotTime:Number;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function Lot()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : String
      {
         return this._3355id;
      }
      
      public function set id(param1:String) : void
      {
         var _loc2_:Object = this._3355id;
         if(_loc2_ !== param1)
         {
            this._3355id = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"id",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myLot() : Boolean
      {
         return this._104345093myLot;
      }
      
      public function set myLot(param1:Boolean) : void
      {
         var _loc2_:Object = this._104345093myLot;
         if(_loc2_ !== param1)
         {
            this._104345093myLot = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myLot",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get item() : Item
      {
         return this._3242771item;
      }
      
      public function set item(param1:Item) : void
      {
         var _loc2_:Object = this._3242771item;
         if(_loc2_ !== param1)
         {
            this._3242771item = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"item",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get level() : int
      {
         return this._102865796level;
      }
      
      public function set level(param1:int) : void
      {
         var _loc2_:Object = this._102865796level;
         if(_loc2_ !== param1)
         {
            this._102865796level = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"level",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currency() : String
      {
         return this._575402001currency;
      }
      
      public function set currency(param1:String) : void
      {
         var _loc2_:Object = this._575402001currency;
         if(_loc2_ !== param1)
         {
            this._575402001currency = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currency",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentBid() : int
      {
         return this._1089001276currentBid;
      }
      
      public function set currentBid(param1:int) : void
      {
         var _loc2_:Object = this._1089001276currentBid;
         if(_loc2_ !== param1)
         {
            this._1089001276currentBid = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentBid",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get buyNow() : int
      {
         return this._1377575312buyNow;
      }
      
      public function set buyNow(param1:int) : void
      {
         var _loc2_:Object = this._1377575312buyNow;
         if(_loc2_ !== param1)
         {
            this._1377575312buyNow = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buyNow",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myBid() : int
      {
         return this._104335281myBid;
      }
      
      public function set myBid(param1:int) : void
      {
         var _loc2_:Object = this._104335281myBid;
         if(_loc2_ !== param1)
         {
            this._104335281myBid = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myBid",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get newBid() : int
      {
         return this._1048873155newBid;
      }
      
      public function set newBid(param1:int) : void
      {
         var _loc2_:Object = this._1048873155newBid;
         if(_loc2_ !== param1)
         {
            this._1048873155newBid = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"newBid",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cancelPenalty() : int
      {
         return this._640500911cancelPenalty;
      }
      
      public function set cancelPenalty(param1:int) : void
      {
         var _loc2_:Object = this._640500911cancelPenalty;
         if(_loc2_ !== param1)
         {
            this._640500911cancelPenalty = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cancelPenalty",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lotTime() : Number
      {
         return this._353720766lotTime;
      }
      
      public function set lotTime(param1:Number) : void
      {
         var _loc2_:Object = this._353720766lotTime;
         if(_loc2_ !== param1)
         {
            this._353720766lotTime = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lotTime",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

