package soul.model.rtm
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.model.ability.Ability;
   import soul.model.field.FieldUnit;
   import soul.model.item.ItemShortcut;
   import soul.view.field.visual.FieldObject;
   import soul.view.field.visual.players.Player;
   
   public class RTMModel extends EventDispatcher
   {
      
      private static var proximityMap:Vector.<ProximityObject>;
      
      private static const MAX_INTERACTIVE_OBJECTS:uint = 4;
      
      private static const INTERACTIVE_RADIUS_SQ:uint = 310 * 310;
      
      public var sectorCache:Object = {};
      
      public var sectorId:String;
      
      public var mapId:String;
      
      private var _836535815mapName:String;
      
      private var _1735816313pvpState:String;
      
      private var _836270393mapEdge:int;
      
      private var _1313911455timeout:int;
      
      public var mapWidth:uint;
      
      public var mapHeight:uint;
      
      public var miniMapModel:MiniMapModel = new MiniMapModel();
      
      private var _111433583units:Object = {};
      
      private var _1060002480myUnit:FieldUnit;
      
      private var _486641333targetUnit:FieldUnit;
      
      public var commonObjectLayouts:Object;
      
      public var activeAbility:Ability;
      
      public var activeItem:ItemShortcut;
      
      public var activeUnit:FieldUnit;
      
      private var _1831970518nearestObjects:Array = [];
      
      private var interactiveObjects:Vector.<ProximityObject> = new Vector.<ProximityObject>();
      
      public function RTMModel()
      {
         super();
      }
      
      private static function proximitySorter(a:ProximityObject, b:ProximityObject) : int
      {
         return a.distance < b.distance ? -1 : (a.distance > b.distance ? 1 : 0);
      }
      
      public function canBeTraded(characterId:String) : Boolean
      {
         var fu:FieldUnit = null;
         for each(fu in this.units)
         {
            if(fu.tradable && fu.id == characterId)
            {
               return true;
            }
         }
         return false;
      }
      
      public function clearToProximityMap() : void
      {
         this.interactiveObjects.length = 0;
      }
      
      public function addToProximityMap(fo:FieldObject) : void
      {
         if(this.interactiveObjects.indexOf(fo) == -1)
         {
            this.interactiveObjects.push(new ProximityObject(fo));
         }
      }
      
      public function removeFromProximityMap(fo:FieldObject) : void
      {
         for(var i:uint = 0; i < this.interactiveObjects.length; i++)
         {
            if(this.interactiveObjects[i].object == fo)
            {
               this.interactiveObjects.splice(i,1);
               break;
            }
         }
      }
      
      public function countNearestInteractive(myPlayer:Player) : void
      {
         var dx:int = 0;
         var dy:int = 0;
         var distance:uint = 0;
         var po:ProximityObject = null;
         var changed:Boolean = false;
         var i:uint = 0;
         proximityMap = proximityMap || new Vector.<ProximityObject>();
         if(!myPlayer)
         {
            proximityMap.length = 0;
            return;
         }
         var x:uint = myPlayer.x;
         var y:uint = myPlayer.y;
         proximityMap.length = 0;
         for each(po in this.interactiveObjects)
         {
            dx = po.object.x - x;
            dy = po.object.y - y << 1;
            distance = dx * dx + dy * dy;
            if(distance < INTERACTIVE_RADIUS_SQ)
            {
               po.distance = distance;
               proximityMap.push(po);
            }
         }
         proximityMap.sort(proximitySorter);
         if(proximityMap.length != this.nearestObjects.length)
         {
            this.upadateNearest();
         }
         else
         {
            i = 0;
            while(i < MAX_INTERACTIVE_OBJECTS && i < proximityMap.length)
            {
               if(this.nearestObjects[i] != proximityMap[i].object)
               {
                  changed = true;
                  break;
               }
               i++;
            }
            if(changed)
            {
               this.upadateNearest();
            }
         }
      }
      
      private function upadateNearest() : void
      {
         this.nearestObjects.length = 0;
         var i:uint = 0;
         while(i < MAX_INTERACTIVE_OBJECTS && i < proximityMap.length)
         {
            this.nearestObjects.push(proximityMap[i].object);
            i++;
         }
         this.nearestObjects = this.nearestObjects.slice();
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
      public function get pvpState() : String
      {
         return this._1735816313pvpState;
      }
      
      public function set pvpState(param1:String) : void
      {
         var _loc2_:Object = this._1735816313pvpState;
         if(_loc2_ !== param1)
         {
            this._1735816313pvpState = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pvpState",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapEdge() : int
      {
         return this._836270393mapEdge;
      }
      
      public function set mapEdge(param1:int) : void
      {
         var _loc2_:Object = this._836270393mapEdge;
         if(_loc2_ !== param1)
         {
            this._836270393mapEdge = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapEdge",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get timeout() : int
      {
         return this._1313911455timeout;
      }
      
      public function set timeout(param1:int) : void
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
      public function get units() : Object
      {
         return this._111433583units;
      }
      
      public function set units(param1:Object) : void
      {
         var _loc2_:Object = this._111433583units;
         if(_loc2_ !== param1)
         {
            this._111433583units = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"units",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myUnit() : FieldUnit
      {
         return this._1060002480myUnit;
      }
      
      public function set myUnit(param1:FieldUnit) : void
      {
         var _loc2_:Object = this._1060002480myUnit;
         if(_loc2_ !== param1)
         {
            this._1060002480myUnit = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myUnit",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get targetUnit() : FieldUnit
      {
         return this._486641333targetUnit;
      }
      
      public function set targetUnit(param1:FieldUnit) : void
      {
         var _loc2_:Object = this._486641333targetUnit;
         if(_loc2_ !== param1)
         {
            this._486641333targetUnit = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"targetUnit",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get nearestObjects() : Array
      {
         return this._1831970518nearestObjects;
      }
      
      public function set nearestObjects(param1:Array) : void
      {
         var _loc2_:Object = this._1831970518nearestObjects;
         if(_loc2_ !== param1)
         {
            this._1831970518nearestObjects = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nearestObjects",_loc2_,param1));
            }
         }
      }
   }
}

import soul.view.field.visual.FieldObject;

class ProximityObject
{
   
   public var distance:uint;
   
   public var object:FieldObject;
   
   public function ProximityObject(object:FieldObject)
   {
      super();
      this.object = object;
   }
}
