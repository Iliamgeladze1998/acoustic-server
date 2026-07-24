package soul.model.interaction.loot
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.model.item.Item;
   
   public class LootModel extends EventDispatcher
   {
      
      private var _100526016items:Array;
      
      private var _635140388totalWeight:int;
      
      private var _338414808lootAllEnabled:Boolean;
      
      private var _158074203currentTakingLoot:Item;
      
      private var _425714387currentTakingLootIndex:int;
      
      public function LootModel()
      {
         super();
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
      public function get totalWeight() : int
      {
         return this._635140388totalWeight;
      }
      
      public function set totalWeight(param1:int) : void
      {
         var _loc2_:Object = this._635140388totalWeight;
         if(_loc2_ !== param1)
         {
            this._635140388totalWeight = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalWeight",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lootAllEnabled() : Boolean
      {
         return this._338414808lootAllEnabled;
      }
      
      public function set lootAllEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._338414808lootAllEnabled;
         if(_loc2_ !== param1)
         {
            this._338414808lootAllEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lootAllEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentTakingLoot() : Item
      {
         return this._158074203currentTakingLoot;
      }
      
      public function set currentTakingLoot(param1:Item) : void
      {
         var _loc2_:Object = this._158074203currentTakingLoot;
         if(_loc2_ !== param1)
         {
            this._158074203currentTakingLoot = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentTakingLoot",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentTakingLootIndex() : int
      {
         return this._425714387currentTakingLootIndex;
      }
      
      public function set currentTakingLootIndex(param1:int) : void
      {
         var _loc2_:Object = this._425714387currentTakingLootIndex;
         if(_loc2_ !== param1)
         {
            this._425714387currentTakingLootIndex = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentTakingLootIndex",_loc2_,param1));
            }
         }
      }
   }
}

