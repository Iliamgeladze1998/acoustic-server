package soul.model.location.workshop
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.model.item.Item;
   
   public class WorkshopItem implements IEventDispatcher
   {
      
      private var _1178662002itemId:String;
      
      private var _1304010549templateId:String;
      
      private var _878289888imagePath:String;
      
      private var _2127704613itemClass:String;
      
      private var _716086281durability:int;
      
      private var _176084837durabilityMax:int;
      
      private var _575402001currency:String;
      
      private var _106934601price:int;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function WorkshopItem()
      {
         super();
      }
      
      public static function toItem(wi:WorkshopItem) : Item
      {
         if(!wi)
         {
            return null;
         }
         var i:Item = new Item();
         i.id = wi.itemId;
         i.templateId = wi.templateId;
         i.imagePath = wi.imagePath;
         i.itemClass = wi.itemClass;
         i.count = 1;
         return i;
      }
      
      [Bindable(event="propertyChange")]
      public function get itemId() : String
      {
         return this._1178662002itemId;
      }
      
      public function set itemId(param1:String) : void
      {
         var _loc2_:Object = this._1178662002itemId;
         if(_loc2_ !== param1)
         {
            this._1178662002itemId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemId",_loc2_,param1));
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
      public function get durabilityMax() : int
      {
         return this._176084837durabilityMax;
      }
      
      public function set durabilityMax(param1:int) : void
      {
         var _loc2_:Object = this._176084837durabilityMax;
         if(_loc2_ !== param1)
         {
            this._176084837durabilityMax = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"durabilityMax",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currency() : String
      {
         return this._575402001currency;
      }
      
      public function set currency(param1:String) : void
      {
         var _loc2_:Object = this._575402001currency;
         if(_loc2_ !== param1)
         {
            this._575402001currency = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currency",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get price() : int
      {
         return this._106934601price;
      }
      
      public function set price(param1:int) : void
      {
         var _loc2_:Object = this._106934601price;
         if(_loc2_ !== param1)
         {
            this._106934601price = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"price",_loc2_,param1));
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

