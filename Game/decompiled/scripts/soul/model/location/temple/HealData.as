package soul.model.location.temple
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class HealData implements IEventDispatcher
   {
      
      private var _1094949153hpPrice:Object;
      
      private var _1237500262mpPrice:Object;
      
      private var _1647240166staminaPrice:Object;
      
      private var _1784357928allPrice:Object;
      
      private var _1266192109availEffects:Array;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function HealData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get hpPrice() : Object
      {
         return this._1094949153hpPrice;
      }
      
      public function set hpPrice(param1:Object) : void
      {
         var _loc2_:Object = this._1094949153hpPrice;
         if(_loc2_ !== param1)
         {
            this._1094949153hpPrice = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hpPrice",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mpPrice() : Object
      {
         return this._1237500262mpPrice;
      }
      
      public function set mpPrice(param1:Object) : void
      {
         var _loc2_:Object = this._1237500262mpPrice;
         if(_loc2_ !== param1)
         {
            this._1237500262mpPrice = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mpPrice",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get staminaPrice() : Object
      {
         return this._1647240166staminaPrice;
      }
      
      public function set staminaPrice(param1:Object) : void
      {
         var _loc2_:Object = this._1647240166staminaPrice;
         if(_loc2_ !== param1)
         {
            this._1647240166staminaPrice = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"staminaPrice",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get allPrice() : Object
      {
         return this._1784357928allPrice;
      }
      
      public function set allPrice(param1:Object) : void
      {
         var _loc2_:Object = this._1784357928allPrice;
         if(_loc2_ !== param1)
         {
            this._1784357928allPrice = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allPrice",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get availEffects() : Array
      {
         return this._1266192109availEffects;
      }
      
      public function set availEffects(param1:Array) : void
      {
         var _loc2_:Object = this._1266192109availEffects;
         if(_loc2_ !== param1)
         {
            this._1266192109availEffects = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"availEffects",_loc2_,param1));
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

