package soul.model.location.academy
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class AcademyOptionData implements IEventDispatcher
   {
      
      private var _1680467137changeCount:int;
      
      private var _1668383879changePrice:int;
      
      private var _289847265changeCurrency:String;
      
      private var _352919633buttonEnabled:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function AcademyOptionData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get changeCount() : int
      {
         return this._1680467137changeCount;
      }
      
      public function set changeCount(param1:int) : void
      {
         var _loc2_:Object = this._1680467137changeCount;
         if(_loc2_ !== param1)
         {
            this._1680467137changeCount = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"changeCount",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get changePrice() : int
      {
         return this._1668383879changePrice;
      }
      
      public function set changePrice(param1:int) : void
      {
         var _loc2_:Object = this._1668383879changePrice;
         if(_loc2_ !== param1)
         {
            this._1668383879changePrice = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"changePrice",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get changeCurrency() : String
      {
         return this._289847265changeCurrency;
      }
      
      public function set changeCurrency(param1:String) : void
      {
         var _loc2_:Object = this._289847265changeCurrency;
         if(_loc2_ !== param1)
         {
            this._289847265changeCurrency = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"changeCurrency",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get buttonEnabled() : Boolean
      {
         return this._352919633buttonEnabled;
      }
      
      public function set buttonEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._352919633buttonEnabled;
         if(_loc2_ !== param1)
         {
            this._352919633buttonEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buttonEnabled",_loc2_,param1));
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

