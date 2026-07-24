package soul.view.interaction.inventory.encrust
{
   import flash.events.Event;
   import mx.events.PropertyChangeEvent;
   import soul.model.item.Item;
   import soul.model.item.ItemShortcut;
   import soul.view.ui.HBox;
   
   public class Jewels extends HBox
   {
      
      private var _738943668changed:Boolean;
      
      public function Jewels()
      {
         super();
      }
      
      public function init(container:Item, sockets:Array) : void
      {
         var shortcut:ItemShortcut = null;
         var jewel:Item = null;
         var child:JewelContainer = null;
         removeAllChildren();
         for each(shortcut in sockets)
         {
            jewel = this.getItemFromShortcut(shortcut);
            child = new JewelContainer();
            child.allowedSockets = container.socketTypes;
            child.item = jewel;
            child.addEventListener(Event.CHANGE,this.childChanged);
            addChild(child);
         }
      }
      
      public function getAllJewels() : Array
      {
         var child:JewelContainer = null;
         var arr:Array = [];
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i) as JewelContainer;
            arr[i] = Boolean(child.item) ? child.item.key : null;
         }
         return arr;
      }
      
      private function getItemFromShortcut(value:ItemShortcut) : Item
      {
         if(!value)
         {
            return null;
         }
         var i:Item = new Item();
         i.templateId = value.templateId;
         i.abilityId = value.abilityId;
         i.itemClass = value.itemClass;
         i.imagePath = value.imagePath;
         return i;
      }
      
      private function childChanged(e:Event) : void
      {
         this.changed = true;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      [Bindable(event="propertyChange")]
      public function get changed() : Boolean
      {
         return this._738943668changed;
      }
      
      public function set changed(param1:Boolean) : void
      {
         var _loc2_:Object = this._738943668changed;
         if(_loc2_ !== param1)
         {
            this._738943668changed = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"changed",_loc2_,param1));
            }
         }
      }
   }
}

