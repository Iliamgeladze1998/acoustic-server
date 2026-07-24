package soul.model.interaction.auction
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class AuctionData implements IEventDispatcher
   {
      
      private var _3327810lots:Array;
      
      private var _110549828total:int;
      
      private var _807928932indexFrom:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function AuctionData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get lots() : Array
      {
         return this._3327810lots;
      }
      
      public function set lots(param1:Array) : void
      {
         var _loc2_:Object = this._3327810lots;
         if(_loc2_ !== param1)
         {
            this._3327810lots = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lots",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get total() : int
      {
         return this._110549828total;
      }
      
      public function set total(param1:int) : void
      {
         var _loc2_:Object = this._110549828total;
         if(_loc2_ !== param1)
         {
            this._110549828total = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"total",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get indexFrom() : int
      {
         return this._807928932indexFrom;
      }
      
      public function set indexFrom(param1:int) : void
      {
         var _loc2_:Object = this._807928932indexFrom;
         if(_loc2_ !== param1)
         {
            this._807928932indexFrom = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"indexFrom",_loc2_,param1));
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

