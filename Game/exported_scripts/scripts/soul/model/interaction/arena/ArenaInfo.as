package soul.model.interaction.arena
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class ArenaInfo implements IEventDispatcher
   {
      
      private var _3355id:String;
      
      private var _1354488982fightType:String;
      
      private var _948117281sectorId:String;
      
      private var _103663511mapId:String;
      
      private var _41955764layerId:String;
      
      private var _836535815mapName:String;
      
      private var _1724546052description:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ArenaInfo()
      {
         super();
      }
      
      public function load(data:ArenaData) : void
      {
         this.id = data.id;
         this.fightType = data.fightType;
         this.sectorId = data.sectorId;
         this.mapId = data.mapId;
         this.layerId = data.layerId;
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
      public function get fightType() : String
      {
         return this._1354488982fightType;
      }
      
      public function set fightType(param1:String) : void
      {
         var _loc2_:Object = this._1354488982fightType;
         if(_loc2_ !== param1)
         {
            this._1354488982fightType = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fightType",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get sectorId() : String
      {
         return this._948117281sectorId;
      }
      
      public function set sectorId(param1:String) : void
      {
         var _loc2_:Object = this._948117281sectorId;
         if(_loc2_ !== param1)
         {
            this._948117281sectorId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sectorId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapId() : String
      {
         return this._103663511mapId;
      }
      
      public function set mapId(param1:String) : void
      {
         var _loc2_:Object = this._103663511mapId;
         if(_loc2_ !== param1)
         {
            this._103663511mapId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get layerId() : String
      {
         return this._41955764layerId;
      }
      
      public function set layerId(param1:String) : void
      {
         var _loc2_:Object = this._41955764layerId;
         if(_loc2_ !== param1)
         {
            this._41955764layerId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"layerId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapName() : String
      {
         return this._836535815mapName;
      }
      
      public function set mapName(param1:String) : void
      {
         var _loc2_:Object = this._836535815mapName;
         if(_loc2_ !== param1)
         {
            this._836535815mapName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : String
      {
         return this._1724546052description;
      }
      
      public function set description(param1:String) : void
      {
         var _loc2_:Object = this._1724546052description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
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

