package soul.model.interaction.craft
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.model.item.Item;
   import soul.model.item.ItemShortcut;
   
   public class Recipe implements IEventDispatcher
   {
      
      public var id:String;
      
      public var locale:String;
      
      public var level:int;
      
      public var itemType:String;
      
      public var components:Array;
      
      public var creationTime:int;
      
      public var item:ItemShortcut;
      
      public var count:int;
      
      private var _2079904826availableCount:uint;
      
      private var _realItem:Item;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function Recipe()
      {
         super();
      }
      
      public function get realItem() : Item
      {
         if(!this._realItem)
         {
            this._realItem = this.item.toItem();
         }
         return this._realItem;
      }
      
      [Bindable(event="propertyChange")]
      public function get availableCount() : uint
      {
         return this._2079904826availableCount;
      }
      
      public function set availableCount(param1:uint) : void
      {
         var _loc2_:Object = this._2079904826availableCount;
         if(_loc2_ !== param1)
         {
            this._2079904826availableCount = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"availableCount",_loc2_,param1));
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

