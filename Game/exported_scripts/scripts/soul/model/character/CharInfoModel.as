package soul.model.character
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.utils.ObjectProxy;
   import soul.model.inventory.BodyModel;
   
   public class CharInfoModel implements IEventDispatcher
   {
      
      private var _3029410body:BodyModel;
      
      private var _1564195625character:CharacterPublicData;
      
      private var _1462247487inquisitor:Boolean;
      
      private var _1724546052description:String;
      
      private var _485371922homepage:String;
      
      private var _103663511mapId:String;
      
      private var _948117281sectorId:String;
      
      private var _1357943279clanId:Number;
      
      private var _686716417clanName:String;
      
      private var _1833928446effects:Array;
      
      private var _unitProperties:Object;
      
      private var _14252274achievementPoints:uint;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function CharInfoModel()
      {
         super();
      }
      
      private function set _1782108713unitProperties(o:Object) : void
      {
         this._unitProperties = new ObjectProxy(o);
      }
      
      public function get unitProperties() : Object
      {
         return this._unitProperties;
      }
      
      [Bindable(event="propertyChange")]
      public function get body() : BodyModel
      {
         return this._3029410body;
      }
      
      public function set body(param1:BodyModel) : void
      {
         var _loc2_:Object = this._3029410body;
         if(_loc2_ !== param1)
         {
            this._3029410body = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"body",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get character() : CharacterPublicData
      {
         return this._1564195625character;
      }
      
      public function set character(param1:CharacterPublicData) : void
      {
         var _loc2_:Object = this._1564195625character;
         if(_loc2_ !== param1)
         {
            this._1564195625character = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"character",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get inquisitor() : Boolean
      {
         return this._1462247487inquisitor;
      }
      
      public function set inquisitor(param1:Boolean) : void
      {
         var _loc2_:Object = this._1462247487inquisitor;
         if(_loc2_ !== param1)
         {
            this._1462247487inquisitor = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inquisitor",_loc2_,param1));
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
      
      [Bindable(event="propertyChange")]
      public function get homepage() : String
      {
         return this._485371922homepage;
      }
      
      public function set homepage(param1:String) : void
      {
         var _loc2_:Object = this._485371922homepage;
         if(_loc2_ !== param1)
         {
            this._485371922homepage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"homepage",_loc2_,param1));
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
      public function get clanId() : Number
      {
         return this._1357943279clanId;
      }
      
      public function set clanId(param1:Number) : void
      {
         var _loc2_:Object = this._1357943279clanId;
         if(_loc2_ !== param1)
         {
            this._1357943279clanId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clanId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clanName() : String
      {
         return this._686716417clanName;
      }
      
      public function set clanName(param1:String) : void
      {
         var _loc2_:Object = this._686716417clanName;
         if(_loc2_ !== param1)
         {
            this._686716417clanName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clanName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get effects() : Array
      {
         return this._1833928446effects;
      }
      
      public function set effects(param1:Array) : void
      {
         var _loc2_:Object = this._1833928446effects;
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
      public function set unitProperties(param1:Object) : void
      {
         var _loc2_:Object = this.unitProperties;
         if(_loc2_ !== param1)
         {
            this._1782108713unitProperties = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"unitProperties",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get achievementPoints() : uint
      {
         return this._14252274achievementPoints;
      }
      
      public function set achievementPoints(param1:uint) : void
      {
         var _loc2_:Object = this._14252274achievementPoints;
         if(_loc2_ !== param1)
         {
            this._14252274achievementPoints = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"achievementPoints",_loc2_,param1));
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

