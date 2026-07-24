package soul.model.character
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.utils.ObjectProxy;
   import soul.model.field.BaseUnit;
   
   public class CharacterModel extends EventDispatcher
   {
      
      private var _3355id:String;
      
      private var _3373707name:String;
      
      private var _113766sex:String;
      
      private var _currencies:Object;
      
      private var _properties:Object;
      
      private var _3530071side:String;
      
      private var _3492561race:String;
      
      private var _1395355384dispositionGroup:String;
      
      private var _583380919disposition:String;
      
      private var _264723243abilitySlots:Array;
      
      private var _2063019719avatarImagePath:String;
      
      private var _params:Object;
      
      private var _additionalPoints:Object;
      
      private var _previewParams:Object = {};
      
      private var _1223328215weapons:Array;
      
      private var _1488333531alternativeIndex:int;
      
      private var _948576578quiver:Array;
      
      private var _1273722441selectedAmmoIndex:int;
      
      private var _1649982918autoSlots:Array;
      
      private var _3020043belt:Array;
      
      private var _1549806286runMode:Boolean;
      
      private var _1961674741attackMode:Boolean;
      
      private var _1354707501fightMode:Boolean;
      
      private var _1424471270reputations:Array;
      
      private var _29097598instances:Array;
      
      private var _515734025subscriptionType:String;
      
      private var _2129512292subscriptionExpire:Date;
      
      private var _1189669744subscriptionRenew:Boolean;
      
      private var _2057840345subscriptionHidden:Boolean;
      
      private var _3079268dead:Boolean;
      
      private var _1060002480myUnit:BaseUnit;
      
      public function CharacterModel()
      {
         super();
      }
      
      private function set _1089470353currencies(o:Object) : void
      {
         this._currencies = new ObjectProxy(o);
      }
      
      public function get currencies() : Object
      {
         return this._currencies;
      }
      
      private function set _926053069properties(o:Object) : void
      {
         this._properties = new ObjectProxy(o);
      }
      
      public function get properties() : Object
      {
         return this._properties;
      }
      
      private function set _995427962params(o:Object) : void
      {
         this._params = new ObjectProxy(o);
      }
      
      public function get params() : Object
      {
         return this._params;
      }
      
      private function set _204163050additionalPoints(o:Object) : void
      {
         this._additionalPoints = new ObjectProxy(o);
      }
      
      public function get additionalPoints() : Object
      {
         return this._additionalPoints;
      }
      
      private function set _260100974previewParams(o:Object) : void
      {
         this._previewParams = new ObjectProxy(o);
      }
      
      public function get previewParams() : Object
      {
         return this._previewParams;
      }
      
      public function load(data:CharacterData) : void
      {
         this.id = data.id;
         this.name = data.name;
         this.sex = data.sex;
         this.currencies = data.currencies;
         this.side = data.side;
         this.race = data.race;
         this.dispositionGroup = data.dispositionGroup;
         this.disposition = data.disposition;
         this.abilitySlots = data.abilitySlots;
         this.avatarImagePath = data.avatarImagePath;
         this.params = data.params;
         this.properties = data.properties;
         this.additionalPoints = data.additionalPoints;
         this.previewParams = null;
         this.alternativeIndex = data.alternativeIndex;
         this.quiver = data.quiver;
         this.selectedAmmoIndex = data.selectedAmmoIndex;
         this.belt = data.belt;
         this.runMode = data.runMode;
         this.attackMode = data.attackMode;
         this.attackMode = data.attackMode;
         this.fightMode = data.fightMode;
         this.reputations = data.reputations;
         this.instances = data.instanceRecords;
         this.subscriptionType = data.subscriptionType;
         this.subscriptionExpire = data.subscriptionExpire;
         this.subscriptionRenew = data.subscriptionRenew;
         this.subscriptionHidden = data.subscriptionHidden;
         this.autoSlots = data.autoSlots;
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
      public function get sex() : String
      {
         return this._113766sex;
      }
      
      public function set sex(param1:String) : void
      {
         var _loc2_:Object = this._113766sex;
         if(_loc2_ !== param1)
         {
            this._113766sex = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sex",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set currencies(param1:Object) : void
      {
         var _loc2_:Object = this.currencies;
         if(_loc2_ !== param1)
         {
            this._1089470353currencies = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currencies",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set properties(param1:Object) : void
      {
         var _loc2_:Object = this.properties;
         if(_loc2_ !== param1)
         {
            this._926053069properties = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"properties",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get side() : String
      {
         return this._3530071side;
      }
      
      public function set side(param1:String) : void
      {
         var _loc2_:Object = this._3530071side;
         if(_loc2_ !== param1)
         {
            this._3530071side = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"side",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get race() : String
      {
         return this._3492561race;
      }
      
      public function set race(param1:String) : void
      {
         var _loc2_:Object = this._3492561race;
         if(_loc2_ !== param1)
         {
            this._3492561race = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"race",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get dispositionGroup() : String
      {
         return this._1395355384dispositionGroup;
      }
      
      public function set dispositionGroup(param1:String) : void
      {
         var _loc2_:Object = this._1395355384dispositionGroup;
         if(_loc2_ !== param1)
         {
            this._1395355384dispositionGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dispositionGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get disposition() : String
      {
         return this._583380919disposition;
      }
      
      public function set disposition(param1:String) : void
      {
         var _loc2_:Object = this._583380919disposition;
         if(_loc2_ !== param1)
         {
            this._583380919disposition = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"disposition",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get abilitySlots() : Array
      {
         return this._264723243abilitySlots;
      }
      
      public function set abilitySlots(param1:Array) : void
      {
         var _loc2_:Object = this._264723243abilitySlots;
         if(_loc2_ !== param1)
         {
            this._264723243abilitySlots = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"abilitySlots",_loc2_,param1));
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
      public function set params(param1:Object) : void
      {
         var _loc2_:Object = this.params;
         if(_loc2_ !== param1)
         {
            this._995427962params = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"params",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set additionalPoints(param1:Object) : void
      {
         var _loc2_:Object = this.additionalPoints;
         if(_loc2_ !== param1)
         {
            this._204163050additionalPoints = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"additionalPoints",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set previewParams(param1:Object) : void
      {
         var _loc2_:Object = this.previewParams;
         if(_loc2_ !== param1)
         {
            this._260100974previewParams = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"previewParams",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get weapons() : Array
      {
         return this._1223328215weapons;
      }
      
      public function set weapons(param1:Array) : void
      {
         var _loc2_:Object = this._1223328215weapons;
         if(_loc2_ !== param1)
         {
            this._1223328215weapons = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"weapons",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get alternativeIndex() : int
      {
         return this._1488333531alternativeIndex;
      }
      
      public function set alternativeIndex(param1:int) : void
      {
         var _loc2_:Object = this._1488333531alternativeIndex;
         if(_loc2_ !== param1)
         {
            this._1488333531alternativeIndex = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"alternativeIndex",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get quiver() : Array
      {
         return this._948576578quiver;
      }
      
      public function set quiver(param1:Array) : void
      {
         var _loc2_:Object = this._948576578quiver;
         if(_loc2_ !== param1)
         {
            this._948576578quiver = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"quiver",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedAmmoIndex() : int
      {
         return this._1273722441selectedAmmoIndex;
      }
      
      public function set selectedAmmoIndex(param1:int) : void
      {
         var _loc2_:Object = this._1273722441selectedAmmoIndex;
         if(_loc2_ !== param1)
         {
            this._1273722441selectedAmmoIndex = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedAmmoIndex",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get autoSlots() : Array
      {
         return this._1649982918autoSlots;
      }
      
      public function set autoSlots(param1:Array) : void
      {
         var _loc2_:Object = this._1649982918autoSlots;
         if(_loc2_ !== param1)
         {
            this._1649982918autoSlots = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"autoSlots",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get belt() : Array
      {
         return this._3020043belt;
      }
      
      public function set belt(param1:Array) : void
      {
         var _loc2_:Object = this._3020043belt;
         if(_loc2_ !== param1)
         {
            this._3020043belt = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"belt",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get runMode() : Boolean
      {
         return this._1549806286runMode;
      }
      
      public function set runMode(param1:Boolean) : void
      {
         var _loc2_:Object = this._1549806286runMode;
         if(_loc2_ !== param1)
         {
            this._1549806286runMode = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"runMode",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get attackMode() : Boolean
      {
         return this._1961674741attackMode;
      }
      
      public function set attackMode(param1:Boolean) : void
      {
         var _loc2_:Object = this._1961674741attackMode;
         if(_loc2_ !== param1)
         {
            this._1961674741attackMode = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"attackMode",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fightMode() : Boolean
      {
         return this._1354707501fightMode;
      }
      
      public function set fightMode(param1:Boolean) : void
      {
         var _loc2_:Object = this._1354707501fightMode;
         if(_loc2_ !== param1)
         {
            this._1354707501fightMode = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fightMode",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get reputations() : Array
      {
         return this._1424471270reputations;
      }
      
      public function set reputations(param1:Array) : void
      {
         var _loc2_:Object = this._1424471270reputations;
         if(_loc2_ !== param1)
         {
            this._1424471270reputations = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reputations",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get instances() : Array
      {
         return this._29097598instances;
      }
      
      public function set instances(param1:Array) : void
      {
         var _loc2_:Object = this._29097598instances;
         if(_loc2_ !== param1)
         {
            this._29097598instances = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"instances",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get subscriptionType() : String
      {
         return this._515734025subscriptionType;
      }
      
      public function set subscriptionType(param1:String) : void
      {
         var _loc2_:Object = this._515734025subscriptionType;
         if(_loc2_ !== param1)
         {
            this._515734025subscriptionType = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"subscriptionType",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get subscriptionExpire() : Date
      {
         return this._2129512292subscriptionExpire;
      }
      
      public function set subscriptionExpire(param1:Date) : void
      {
         var _loc2_:Object = this._2129512292subscriptionExpire;
         if(_loc2_ !== param1)
         {
            this._2129512292subscriptionExpire = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"subscriptionExpire",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get subscriptionRenew() : Boolean
      {
         return this._1189669744subscriptionRenew;
      }
      
      public function set subscriptionRenew(param1:Boolean) : void
      {
         var _loc2_:Object = this._1189669744subscriptionRenew;
         if(_loc2_ !== param1)
         {
            this._1189669744subscriptionRenew = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"subscriptionRenew",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get subscriptionHidden() : Boolean
      {
         return this._2057840345subscriptionHidden;
      }
      
      public function set subscriptionHidden(param1:Boolean) : void
      {
         var _loc2_:Object = this._2057840345subscriptionHidden;
         if(_loc2_ !== param1)
         {
            this._2057840345subscriptionHidden = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"subscriptionHidden",_loc2_,param1));
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
      public function get myUnit() : BaseUnit
      {
         return this._1060002480myUnit;
      }
      
      public function set myUnit(param1:BaseUnit) : void
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
   }
}

