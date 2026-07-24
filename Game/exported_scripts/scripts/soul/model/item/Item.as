package soul.model.item
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.describeType;
   import mx.events.PropertyChangeEvent;
   
   public class Item implements IEventDispatcher
   {
      
      private var _3355id:String;
      
      private var _3533310slot:String;
      
      private var _3575610type:String;
      
      private var _93927806bound:Boolean;
      
      private var _893863845confirmBinding:Boolean;
      
      private var _108220795binding:String;
      
      private var _429917758undroppable:Boolean;
      
      private var _103144571locId:String;
      
      private var _1958907828suffixId:String;
      
      private var _1304010549templateId:String;
      
      private var _1335253108descId:String;
      
      private var _1658395621abilityId:String;
      
      private var _878289888imagePath:String;
      
      private var _2127704613itemClass:String;
      
      private var _94851343count:int;
      
      private var _716086281durability:int;
      
      private var _1989753385durabilityMaximum:int;
      
      private var _836164360usable:Boolean;
      
      private var _2038706336sockets:uint;
      
      private var _969472198socketTypes:Array;
      
      private var _1868521062subType:String;
      
      private var _102865796level:int;
      
      private var _100526016items:Array;
      
      private var _563747417autoAbilities:Array;
      
      private var _588913375equipped:Boolean;
      
      private var _1702622912bodySlot:int;
      
      private var _106079key:InvKey;
      
      private var _1097452790locked:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function Item()
      {
         super();
      }
      
      public function canBeEquipped() : Boolean
      {
         return ItemSlot.EQUIPABLE.indexOf(this.slot) > -1;
      }
      
      public function isEmpty() : Boolean
      {
         var item:Item = null;
         for each(item in this.items)
         {
            if(Boolean(item))
            {
               return false;
            }
         }
         return true;
      }
      
      public function clone() : Item
      {
         var key:String = null;
         var i:Item = new Item();
         var props:XMLList = describeType(this).accessor.@name;
         for each(key in props)
         {
            if(key != "items" && key != "key")
            {
               i[key] = this[key];
            }
         }
         return i;
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
      public function get slot() : String
      {
         return this._3533310slot;
      }
      
      public function set slot(param1:String) : void
      {
         var _loc2_:Object = this._3533310slot;
         if(_loc2_ !== param1)
         {
            this._3533310slot = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"slot",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get type() : String
      {
         return this._3575610type;
      }
      
      public function set type(param1:String) : void
      {
         var _loc2_:Object = this._3575610type;
         if(_loc2_ !== param1)
         {
            this._3575610type = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"type",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bound() : Boolean
      {
         return this._93927806bound;
      }
      
      public function set bound(param1:Boolean) : void
      {
         var _loc2_:Object = this._93927806bound;
         if(_loc2_ !== param1)
         {
            this._93927806bound = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bound",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get confirmBinding() : Boolean
      {
         return this._893863845confirmBinding;
      }
      
      public function set confirmBinding(param1:Boolean) : void
      {
         var _loc2_:Object = this._893863845confirmBinding;
         if(_loc2_ !== param1)
         {
            this._893863845confirmBinding = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"confirmBinding",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get binding() : String
      {
         return this._108220795binding;
      }
      
      public function set binding(param1:String) : void
      {
         var _loc2_:Object = this._108220795binding;
         if(_loc2_ !== param1)
         {
            this._108220795binding = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"binding",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get undroppable() : Boolean
      {
         return this._429917758undroppable;
      }
      
      public function set undroppable(param1:Boolean) : void
      {
         var _loc2_:Object = this._429917758undroppable;
         if(_loc2_ !== param1)
         {
            this._429917758undroppable = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"undroppable",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get locId() : String
      {
         return this._103144571locId;
      }
      
      public function set locId(param1:String) : void
      {
         var _loc2_:Object = this._103144571locId;
         if(_loc2_ !== param1)
         {
            this._103144571locId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"locId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get suffixId() : String
      {
         return this._1958907828suffixId;
      }
      
      public function set suffixId(param1:String) : void
      {
         var _loc2_:Object = this._1958907828suffixId;
         if(_loc2_ !== param1)
         {
            this._1958907828suffixId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"suffixId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get templateId() : String
      {
         return this._1304010549templateId;
      }
      
      public function set templateId(param1:String) : void
      {
         var _loc2_:Object = this._1304010549templateId;
         if(_loc2_ !== param1)
         {
            this._1304010549templateId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"templateId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get descId() : String
      {
         return this._1335253108descId;
      }
      
      public function set descId(param1:String) : void
      {
         var _loc2_:Object = this._1335253108descId;
         if(_loc2_ !== param1)
         {
            this._1335253108descId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"descId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get abilityId() : String
      {
         return this._1658395621abilityId;
      }
      
      public function set abilityId(param1:String) : void
      {
         var _loc2_:Object = this._1658395621abilityId;
         if(_loc2_ !== param1)
         {
            this._1658395621abilityId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"abilityId",_loc2_,param1));
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
      public function get itemClass() : String
      {
         return this._2127704613itemClass;
      }
      
      public function set itemClass(param1:String) : void
      {
         var _loc2_:Object = this._2127704613itemClass;
         if(_loc2_ !== param1)
         {
            this._2127704613itemClass = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemClass",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get count() : int
      {
         return this._94851343count;
      }
      
      public function set count(param1:int) : void
      {
         var _loc2_:Object = this._94851343count;
         if(_loc2_ !== param1)
         {
            this._94851343count = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"count",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get durability() : int
      {
         return this._716086281durability;
      }
      
      public function set durability(param1:int) : void
      {
         var _loc2_:Object = this._716086281durability;
         if(_loc2_ !== param1)
         {
            this._716086281durability = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"durability",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get durabilityMaximum() : int
      {
         return this._1989753385durabilityMaximum;
      }
      
      public function set durabilityMaximum(param1:int) : void
      {
         var _loc2_:Object = this._1989753385durabilityMaximum;
         if(_loc2_ !== param1)
         {
            this._1989753385durabilityMaximum = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"durabilityMaximum",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get usable() : Boolean
      {
         return this._836164360usable;
      }
      
      public function set usable(param1:Boolean) : void
      {
         var _loc2_:Object = this._836164360usable;
         if(_loc2_ !== param1)
         {
            this._836164360usable = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"usable",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get sockets() : uint
      {
         return this._2038706336sockets;
      }
      
      public function set sockets(param1:uint) : void
      {
         var _loc2_:Object = this._2038706336sockets;
         if(_loc2_ !== param1)
         {
            this._2038706336sockets = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sockets",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get socketTypes() : Array
      {
         return this._969472198socketTypes;
      }
      
      public function set socketTypes(param1:Array) : void
      {
         var _loc2_:Object = this._969472198socketTypes;
         if(_loc2_ !== param1)
         {
            this._969472198socketTypes = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"socketTypes",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get subType() : String
      {
         return this._1868521062subType;
      }
      
      public function set subType(param1:String) : void
      {
         var _loc2_:Object = this._1868521062subType;
         if(_loc2_ !== param1)
         {
            this._1868521062subType = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"subType",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get level() : int
      {
         return this._102865796level;
      }
      
      public function set level(param1:int) : void
      {
         var _loc2_:Object = this._102865796level;
         if(_loc2_ !== param1)
         {
            this._102865796level = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"level",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get items() : Array
      {
         return this._100526016items;
      }
      
      public function set items(param1:Array) : void
      {
         var _loc2_:Object = this._100526016items;
         if(_loc2_ !== param1)
         {
            this._100526016items = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"items",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get autoAbilities() : Array
      {
         return this._563747417autoAbilities;
      }
      
      public function set autoAbilities(param1:Array) : void
      {
         var _loc2_:Object = this._563747417autoAbilities;
         if(_loc2_ !== param1)
         {
            this._563747417autoAbilities = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"autoAbilities",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get equipped() : Boolean
      {
         return this._588913375equipped;
      }
      
      public function set equipped(param1:Boolean) : void
      {
         var _loc2_:Object = this._588913375equipped;
         if(_loc2_ !== param1)
         {
            this._588913375equipped = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"equipped",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bodySlot() : int
      {
         return this._1702622912bodySlot;
      }
      
      public function set bodySlot(param1:int) : void
      {
         var _loc2_:Object = this._1702622912bodySlot;
         if(_loc2_ !== param1)
         {
            this._1702622912bodySlot = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bodySlot",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get key() : InvKey
      {
         return this._106079key;
      }
      
      public function set key(param1:InvKey) : void
      {
         var _loc2_:Object = this._106079key;
         if(_loc2_ !== param1)
         {
            this._106079key = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"key",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get locked() : Boolean
      {
         return this._1097452790locked;
      }
      
      public function set locked(param1:Boolean) : void
      {
         var _loc2_:Object = this._1097452790locked;
         if(_loc2_ !== param1)
         {
            this._1097452790locked = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"locked",_loc2_,param1));
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

