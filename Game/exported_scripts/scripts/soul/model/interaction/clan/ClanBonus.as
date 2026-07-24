package soul.model.interaction.clan
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class ClanBonus implements IEventDispatcher
   {
      
      private var _3355id:String;
      
      private var _878289888imagePath:String;
      
      private var _3242771item:Boolean;
      
      private var _3492908rank:uint;
      
      private var _107876max:uint;
      
      private var _3059661cost:uint;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ClanBonus()
      {
         super();
      }
      
      public function get localeId() : String
      {
         return this.id;
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
      public function get imagePath() : String
      {
         return this._878289888imagePath;
      }
      
      public function set imagePath(param1:String) : void
      {
         var _loc2_:Object = this._878289888imagePath;
         if(_loc2_ !== param1)
         {
            this._878289888imagePath = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"imagePath",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get item() : Boolean
      {
         return this._3242771item;
      }
      
      public function set item(param1:Boolean) : void
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
      public function get rank() : uint
      {
         return this._3492908rank;
      }
      
      public function set rank(param1:uint) : void
      {
         var _loc2_:Object = this._3492908rank;
         if(_loc2_ !== param1)
         {
            this._3492908rank = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rank",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get max() : uint
      {
         return this._107876max;
      }
      
      public function set max(param1:uint) : void
      {
         var _loc2_:Object = this._107876max;
         if(_loc2_ !== param1)
         {
            this._107876max = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"max",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cost() : uint
      {
         return this._3059661cost;
      }
      
      public function set cost(param1:uint) : void
      {
         var _loc2_:Object = this._3059661cost;
         if(_loc2_ !== param1)
         {
            this._3059661cost = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cost",_loc2_,param1));
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

