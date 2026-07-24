package soul.model.interaction.arena
{
   import flash.events.EventDispatcher;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import mx.events.PropertyChangeEvent;
   import soul.event.ArenaEvent;
   
   public class ArenaModel extends EventDispatcher
   {
      
      private var _960514633fightTypes:Array;
      
      private var _1409540532arenas:Object;
      
      private var _109757585state:ArenaStateData;
      
      private var _1117770723losingCooldown:uint;
      
      private var _cooldown:uint;
      
      private var tickInt:int;
      
      private var tickEnds:uint;
      
      public function ArenaModel()
      {
         super();
      }
      
      private function set _546109589cooldown(value:uint) : void
      {
         if(Boolean(this.tickInt))
         {
            clearInterval(this.tickInt);
         }
         this.tickEnds = getTimer() + value;
         this.tickInt = setInterval(this.tick,3000);
         this.tick();
      }
      
      public function get cooldown() : uint
      {
         return this._cooldown;
      }
      
      private function tick() : void
      {
         this._cooldown = Math.max(0,this.tickEnds - getTimer());
         if(this._cooldown == 0)
         {
            clearInterval(this.tickInt);
         }
         dispatchEvent(new ArenaEvent(ArenaEvent.TICK));
      }
      
      [Bindable(event="propertyChange")]
      public function get fightTypes() : Array
      {
         return this._960514633fightTypes;
      }
      
      public function set fightTypes(param1:Array) : void
      {
         var _loc2_:Object = this._960514633fightTypes;
         if(_loc2_ !== param1)
         {
            this._960514633fightTypes = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fightTypes",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get arenas() : Object
      {
         return this._1409540532arenas;
      }
      
      public function set arenas(param1:Object) : void
      {
         var _loc2_:Object = this._1409540532arenas;
         if(_loc2_ !== param1)
         {
            this._1409540532arenas = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"arenas",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get state() : ArenaStateData
      {
         return this._109757585state;
      }
      
      public function set state(param1:ArenaStateData) : void
      {
         var _loc2_:Object = this._109757585state;
         if(_loc2_ !== param1)
         {
            this._109757585state = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"state",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get losingCooldown() : uint
      {
         return this._1117770723losingCooldown;
      }
      
      public function set losingCooldown(param1:uint) : void
      {
         var _loc2_:Object = this._1117770723losingCooldown;
         if(_loc2_ !== param1)
         {
            this._1117770723losingCooldown = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"losingCooldown",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set cooldown(param1:uint) : void
      {
         var _loc2_:Object = this.cooldown;
         if(_loc2_ !== param1)
         {
            this._546109589cooldown = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cooldown",_loc2_,param1));
            }
         }
      }
   }
}

