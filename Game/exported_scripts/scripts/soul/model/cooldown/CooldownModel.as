package soul.model.cooldown
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import mx.events.PropertyChangeEvent;
   import mx.utils.ObjectProxy;
   
   public class CooldownModel implements IEventDispatcher
   {
      
      private static const updateFrequency:int = 40;
      
      private var _groups:Object = new ObjectProxy();
      
      private var _abilities:Object = new ObjectProxy();
      
      private var groupTimeouts:Object = {};
      
      private var abilityTimeouts:Object = {};
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function CooldownModel()
      {
         super();
      }
      
      private function set _1237460524groups(value:Object) : void
      {
         var cd:Cooldown = null;
         for each(cd in value)
         {
            this.setGroupCd(cd);
         }
      }
      
      public function get groups() : Object
      {
         return this._groups;
      }
      
      private function set _1658381128abilities(value:Object) : void
      {
         var cd:Cooldown = null;
         for each(cd in value)
         {
            this.setAbilityCd(cd);
         }
      }
      
      public function get abilities() : Object
      {
         return this._abilities;
      }
      
      public function setGroupCd(cd:Cooldown) : void
      {
         if(Boolean(this.groupTimeouts[cd.id]))
         {
            clearInterval(this.groupTimeouts[cd.id]);
         }
         this._groups[cd.id] = cd;
         cd.startTime = getTimer() - cd.progress;
         this.groupTimeouts[cd.id] = setInterval(this.updateGroup,updateFrequency,cd);
      }
      
      public function setAbilityCd(cd:Cooldown) : void
      {
         if(Boolean(this.abilityTimeouts[cd.id]))
         {
            clearInterval(this.abilityTimeouts[cd.id]);
         }
         this._abilities[cd.id] = cd;
         cd.startTime = getTimer() - cd.progress;
         this.abilityTimeouts[cd.id] = setInterval(this.updateAbility,updateFrequency,cd);
      }
      
      private function updateGroup(cd:Cooldown) : void
      {
         cd.progress = getTimer() - cd.startTime;
         if(cd.progress >= cd.total)
         {
            cd.progress = cd.total;
            clearInterval(this.groupTimeouts[cd.id]);
            delete this.groupTimeouts[cd.id];
            delete this.groups[cd.id];
         }
      }
      
      private function updateAbility(cd:Cooldown) : void
      {
         cd.progress = getTimer() - cd.startTime;
         if(cd.progress >= cd.total)
         {
            cd.progress = cd.total;
            clearInterval(this.abilityTimeouts[cd.id]);
            delete this.abilityTimeouts[cd.id];
            delete this.abilities[cd.id];
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set abilities(param1:Object) : void
      {
         var _loc2_:Object = this.abilities;
         if(_loc2_ !== param1)
         {
            this._1658381128abilities = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"abilities",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set groups(param1:Object) : void
      {
         var _loc2_:Object = this.groups;
         if(_loc2_ !== param1)
         {
            this._1237460524groups = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"groups",_loc2_,param1));
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

