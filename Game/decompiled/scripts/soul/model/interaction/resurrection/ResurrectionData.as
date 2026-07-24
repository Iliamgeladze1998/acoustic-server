package soul.model.interaction.resurrection
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class ResurrectionData implements IEventDispatcher
   {
      
      private var _104079552money:ResurrectionMoneyOption;
      
      private var _3242771item:ResurrectionItemOption;
      
      private var _1313911455timeout:uint;
      
      private var _825443083potionLocations:Array;
      
      private var _2067271152showLFG:Boolean;
      
      private var _176260247resurrectAtInstance:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ResurrectionData()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get money() : ResurrectionMoneyOption
      {
         return this._104079552money;
      }
      
      public function set money(param1:ResurrectionMoneyOption) : void
      {
         var _loc2_:Object = this._104079552money;
         if(_loc2_ !== param1)
         {
            this._104079552money = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"money",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get item() : ResurrectionItemOption
      {
         return this._3242771item;
      }
      
      public function set item(param1:ResurrectionItemOption) : void
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
      public function get timeout() : uint
      {
         return this._1313911455timeout;
      }
      
      public function set timeout(param1:uint) : void
      {
         var _loc2_:Object = this._1313911455timeout;
         if(_loc2_ !== param1)
         {
            this._1313911455timeout = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"timeout",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get potionLocations() : Array
      {
         return this._825443083potionLocations;
      }
      
      public function set potionLocations(param1:Array) : void
      {
         var _loc2_:Object = this._825443083potionLocations;
         if(_loc2_ !== param1)
         {
            this._825443083potionLocations = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"potionLocations",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get showLFG() : Boolean
      {
         return this._2067271152showLFG;
      }
      
      public function set showLFG(param1:Boolean) : void
      {
         var _loc2_:Object = this._2067271152showLFG;
         if(_loc2_ !== param1)
         {
            this._2067271152showLFG = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showLFG",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get resurrectAtInstance() : Boolean
      {
         return this._176260247resurrectAtInstance;
      }
      
      public function set resurrectAtInstance(param1:Boolean) : void
      {
         var _loc2_:Object = this._176260247resurrectAtInstance;
         if(_loc2_ !== param1)
         {
            this._176260247resurrectAtInstance = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"resurrectAtInstance",_loc2_,param1));
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

