package soul.model.inventory
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.describeType;
   import mx.events.PropertyChangeEvent;
   import soul.model.item.Item;
   import soul.model.item.ItemSlot;
   import soul.model.item.ItemType;
   
   public class BodyModel implements IEventDispatcher
   {
      
      private var _92936995ammo1:Item;
      
      private var _92936996ammo2:Item;
      
      private var _1413683278amulet:Item;
      
      private var _1409300624armour:Item;
      
      private var _93922241boots:Item;
      
      private var _847350419earClips:Item;
      
      private var _1243001030gloves:Item;
      
      private var _1220934547helmet:Item;
      
      private var _108518401ring1:Item;
      
      private var _108518402ring2:Item;
      
      private var _108518403ring3:Item;
      
      private var _108518404ring4:Item;
      
      private var _2061225448shield1:Item;
      
      private var _2061225449shield2:Item;
      
      private var _110133191tatoo:Item;
      
      private var _112893312waist:Item;
      
      private var _1223328149weapon1:Item;
      
      private var _1223328150weapon2:Item;
      
      private var _1405038154awards:Array = [];
      
      private var _98352451gifts:Array = [];
      
      private var _1683213006trophies:Array = [];
      
      private var map:Object = {};
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function BodyModel()
      {
         super();
         this.map[ItemSlot.AMMO] = ["ammo1","ammo2"];
         this.map[ItemSlot.RING] = ["ring1","ring2","ring3","ring4"];
         this.map[ItemSlot.SHIELD] = ["shield1","shield2"];
         this.map[ItemSlot.WEAPON] = ["weapon1","weapon2"];
      }
      
      public function load(data:Object) : void
      {
         var items:Array = null;
         for each(items in data)
         {
            this.loadItems(items);
         }
      }
      
      public function loadItems(items:Array) : void
      {
         for(var i:int = 0; i < items.length; i++)
         {
            if(Boolean(items[i]))
            {
               this.setBodyItem(items[i],i);
            }
         }
      }
      
      public function setBodyItem(item:Item, index:int) : void
      {
         var prize:Boolean = false;
         var arr:Array = null;
         item.equipped = true;
         item.bodySlot = index;
         switch(item.type)
         {
            case ItemType.AWARD:
            case ItemType.ACHIEVEMENT:
            case ItemType.NONSENSE:
               arr = this.awards;
               arr.push(item);
               this.awards = null;
               this.awards = arr;
               prize = true;
               break;
            case ItemType.TROPHY:
               arr = this.trophies;
               arr.push(item);
               this.trophies = null;
               this.trophies = arr;
               prize = true;
               break;
            case ItemType.GIFT:
               arr = this.gifts;
               arr.push(item);
               this.gifts = null;
               this.gifts = arr;
               prize = true;
         }
         if(prize)
         {
            return;
         }
         switch(item.slot)
         {
            case ItemSlot.AMMO:
               switch(index)
               {
                  case 0:
                     this.ammo1 = item;
                     break;
                  case 1:
                     this.ammo2 = item;
               }
               break;
            case ItemSlot.AMULET:
               this.amulet = item;
               break;
            case ItemSlot.ARMOUR:
               this.armour = item;
               break;
            case ItemSlot.BOOTS:
               this.boots = item;
               break;
            case ItemSlot.EARCLIPS:
               this.earClips = item;
               break;
            case ItemSlot.GLOVES:
               this.gloves = item;
               break;
            case ItemSlot.HELMET:
               this.helmet = item;
               break;
            case ItemSlot.RING:
               switch(index)
               {
                  case 0:
                     this.ring1 = item;
                     break;
                  case 1:
                     this.ring2 = item;
                     break;
                  case 2:
                     this.ring3 = item;
                     break;
                  case 3:
                     this.ring4 = item;
               }
               break;
            case ItemSlot.SHIELD:
               switch(index)
               {
                  case 0:
                     this.shield1 = item;
                     break;
                  case 1:
                     this.shield2 = item;
               }
               break;
            case ItemSlot.TATOO:
               this.tatoo = item;
               break;
            case ItemSlot.WAIST:
               this.waist = item;
               break;
            case ItemSlot.WEAPON:
               switch(index)
               {
                  case 0:
                     this.weapon1 = item;
                     break;
                  case 1:
                     this.weapon2 = item;
               }
         }
      }
      
      public function removeItem(itemId:String) : void
      {
         var oldItem:Object = null;
         var key:String = null;
         var i:String = null;
         var props:XMLList = describeType(this).accessor.@name;
         for each(key in props)
         {
            oldItem = this[key];
            if(oldItem is Item && Item(oldItem).id == itemId)
            {
               this[key] = null;
               break;
            }
            if(oldItem is Array)
            {
               for(i in oldItem)
               {
                  if(Item(oldItem[i]).id == itemId)
                  {
                     (oldItem as Array).splice(int(i),1);
                     this[key] = null;
                     this[key] = oldItem;
                     return;
                  }
               }
            }
         }
      }
      
      public function swapItem(slotType:String, src:int, dst:int) : void
      {
         var tmp:Item = null;
         var arr:Array = this.map[slotType];
         if(!arr)
         {
            return;
         }
         var srcVar:String = arr[src];
         var dstVar:String = arr[dst];
         try
         {
            tmp = this[srcVar];
            this[srcVar] = this[dstVar];
            this[dstVar] = tmp;
            tmp = this[srcVar];
            if(Boolean(tmp))
            {
               tmp.bodySlot = src;
            }
            tmp = this[dstVar];
            if(Boolean(tmp))
            {
               tmp.bodySlot = dst;
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function getItemById(id:String) : Item
      {
         var key:String = null;
         var item:Item = null;
         var props:XMLList = describeType(this).accessor.@name;
         for each(key in props)
         {
            item = this[key] as Item;
            if(Boolean(item) && item.id == id)
            {
               return item;
            }
         }
         return null;
      }
      
      public function hasBrokenItemsWorn() : Boolean
      {
         var object:Object = null;
         var item:Item = null;
         var key:String = null;
         var i:String = null;
         var has:Boolean = false;
         var props:XMLList = describeType(this).accessor.@name;
         for each(key in props)
         {
            object = this[key];
            if(object is Item)
            {
               item = object as Item;
               if(item.durabilityMaximum > 0 && item.durability <= 0)
               {
                  has = true;
                  break;
               }
            }
            else if(object is Array)
            {
               for(i in object)
               {
                  item = object[i];
                  if(item.durabilityMaximum > 0 && item.durability <= 0)
                  {
                     has = true;
                     break;
                  }
               }
            }
         }
         return has;
      }
      
      public function getWornItemBySlot(slotType:String) : Item
      {
         var object:Object = null;
         var item:Item = null;
         var key:String = null;
         var i:String = null;
         var props:XMLList = describeType(this).accessor.@name;
         for each(key in props)
         {
            object = this[key];
            if(object is Item)
            {
               item = object as Item;
               if(item.slot == slotType)
               {
                  return item;
               }
            }
            else if(object is Array)
            {
               for(i in object)
               {
                  item = object[i];
                  if(item.slot == slotType)
                  {
                     return item;
                  }
               }
            }
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get ammo1() : Item
      {
         return this._92936995ammo1;
      }
      
      public function set ammo1(param1:Item) : void
      {
         var _loc2_:Object = this._92936995ammo1;
         if(_loc2_ !== param1)
         {
            this._92936995ammo1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ammo1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ammo2() : Item
      {
         return this._92936996ammo2;
      }
      
      public function set ammo2(param1:Item) : void
      {
         var _loc2_:Object = this._92936996ammo2;
         if(_loc2_ !== param1)
         {
            this._92936996ammo2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ammo2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get amulet() : Item
      {
         return this._1413683278amulet;
      }
      
      public function set amulet(param1:Item) : void
      {
         var _loc2_:Object = this._1413683278amulet;
         if(_loc2_ !== param1)
         {
            this._1413683278amulet = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"amulet",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get armour() : Item
      {
         return this._1409300624armour;
      }
      
      public function set armour(param1:Item) : void
      {
         var _loc2_:Object = this._1409300624armour;
         if(_loc2_ !== param1)
         {
            this._1409300624armour = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"armour",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get boots() : Item
      {
         return this._93922241boots;
      }
      
      public function set boots(param1:Item) : void
      {
         var _loc2_:Object = this._93922241boots;
         if(_loc2_ !== param1)
         {
            this._93922241boots = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"boots",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get earClips() : Item
      {
         return this._847350419earClips;
      }
      
      public function set earClips(param1:Item) : void
      {
         var _loc2_:Object = this._847350419earClips;
         if(_loc2_ !== param1)
         {
            this._847350419earClips = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"earClips",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gloves() : Item
      {
         return this._1243001030gloves;
      }
      
      public function set gloves(param1:Item) : void
      {
         var _loc2_:Object = this._1243001030gloves;
         if(_loc2_ !== param1)
         {
            this._1243001030gloves = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gloves",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get helmet() : Item
      {
         return this._1220934547helmet;
      }
      
      public function set helmet(param1:Item) : void
      {
         var _loc2_:Object = this._1220934547helmet;
         if(_loc2_ !== param1)
         {
            this._1220934547helmet = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helmet",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ring1() : Item
      {
         return this._108518401ring1;
      }
      
      public function set ring1(param1:Item) : void
      {
         var _loc2_:Object = this._108518401ring1;
         if(_loc2_ !== param1)
         {
            this._108518401ring1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ring1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ring2() : Item
      {
         return this._108518402ring2;
      }
      
      public function set ring2(param1:Item) : void
      {
         var _loc2_:Object = this._108518402ring2;
         if(_loc2_ !== param1)
         {
            this._108518402ring2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ring2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ring3() : Item
      {
         return this._108518403ring3;
      }
      
      public function set ring3(param1:Item) : void
      {
         var _loc2_:Object = this._108518403ring3;
         if(_loc2_ !== param1)
         {
            this._108518403ring3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ring3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ring4() : Item
      {
         return this._108518404ring4;
      }
      
      public function set ring4(param1:Item) : void
      {
         var _loc2_:Object = this._108518404ring4;
         if(_loc2_ !== param1)
         {
            this._108518404ring4 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ring4",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get shield1() : Item
      {
         return this._2061225448shield1;
      }
      
      public function set shield1(param1:Item) : void
      {
         var _loc2_:Object = this._2061225448shield1;
         if(_loc2_ !== param1)
         {
            this._2061225448shield1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"shield1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get shield2() : Item
      {
         return this._2061225449shield2;
      }
      
      public function set shield2(param1:Item) : void
      {
         var _loc2_:Object = this._2061225449shield2;
         if(_loc2_ !== param1)
         {
            this._2061225449shield2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"shield2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tatoo() : Item
      {
         return this._110133191tatoo;
      }
      
      public function set tatoo(param1:Item) : void
      {
         var _loc2_:Object = this._110133191tatoo;
         if(_loc2_ !== param1)
         {
            this._110133191tatoo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tatoo",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get waist() : Item
      {
         return this._112893312waist;
      }
      
      public function set waist(param1:Item) : void
      {
         var _loc2_:Object = this._112893312waist;
         if(_loc2_ !== param1)
         {
            this._112893312waist = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"waist",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get weapon1() : Item
      {
         return this._1223328149weapon1;
      }
      
      public function set weapon1(param1:Item) : void
      {
         var _loc2_:Object = this._1223328149weapon1;
         if(_loc2_ !== param1)
         {
            this._1223328149weapon1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"weapon1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get weapon2() : Item
      {
         return this._1223328150weapon2;
      }
      
      public function set weapon2(param1:Item) : void
      {
         var _loc2_:Object = this._1223328150weapon2;
         if(_loc2_ !== param1)
         {
            this._1223328150weapon2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"weapon2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get awards() : Array
      {
         return this._1405038154awards;
      }
      
      public function set awards(param1:Array) : void
      {
         var _loc2_:Object = this._1405038154awards;
         if(_loc2_ !== param1)
         {
            this._1405038154awards = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"awards",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gifts() : Array
      {
         return this._98352451gifts;
      }
      
      public function set gifts(param1:Array) : void
      {
         var _loc2_:Object = this._98352451gifts;
         if(_loc2_ !== param1)
         {
            this._98352451gifts = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gifts",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get trophies() : Array
      {
         return this._1683213006trophies;
      }
      
      public function set trophies(param1:Array) : void
      {
         var _loc2_:Object = this._1683213006trophies;
         if(_loc2_ !== param1)
         {
            this._1683213006trophies = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"trophies",_loc2_,param1));
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

