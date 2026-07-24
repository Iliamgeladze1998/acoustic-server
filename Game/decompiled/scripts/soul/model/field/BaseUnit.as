package soul.model.field
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.utils.ObjectProxy;
   import soul.model.buff.Effect;
   
   public class BaseUnit implements IEventDispatcher
   {
      
      private var _3355id:String;
      
      private var _3373707name:String;
      
      private var _3079268dead:Boolean;
      
      private var _2063019719avatarImagePath:String;
      
      private var _effects:Array;
      
      private var _stats:Object;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function BaseUnit()
      {
         super();
      }
      
      private function set _1833928446effects(value:Array) : void
      {
         var effect:Effect = null;
         for each(effect in this._effects)
         {
            effect.reset();
         }
         this._effects = value;
      }
      
      public function get effects() : Array
      {
         return this._effects;
      }
      
      private function set _109757599stats(o:Object) : void
      {
         this._stats = new ObjectProxy(o);
      }
      
      public function get stats() : Object
      {
         return this._stats;
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
      public function get name() : String
      {
         return this._3373707name;
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get dead() : Boolean
      {
         return this._3079268dead;
      }
      
      public function set dead(param1:Boolean) : void
      {
         var _loc2_:Object = this._3079268dead;
         if(_loc2_ !== param1)
         {
            this._3079268dead = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dead",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get avatarImagePath() : String
      {
         return this._2063019719avatarImagePath;
      }
      
      public function set avatarImagePath(param1:String) : void
      {
         var _loc2_:Object = this._2063019719avatarImagePath;
         if(_loc2_ !== param1)
         {
            this._2063019719avatarImagePath = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"avatarImagePath",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set effects(param1:Array) : void
      {
         var _loc2_:Object = this.effects;
         if(_loc2_ !== param1)
         {
            this._1833928446effects = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"effects",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set stats(param1:Object) : void
      {
         var _loc2_:Object = this.stats;
         if(_loc2_ !== param1)
         {
            this._109757599stats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stats",_loc2_,param1));
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

