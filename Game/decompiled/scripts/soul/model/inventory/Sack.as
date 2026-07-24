package soul.model.inventory
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.core.IPropertyChangeNotifier;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import soul.model.item.InvKey;
   import soul.model.item.Item;
   
   [Bindable("propertyChange")]
   public class Sack extends EventDispatcher implements IPropertyChangeNotifier
   {
      
      public var item:Item;
      
      public var items:Vector.<Item>;
      
      public var index:int;
      
      public function Sack()
      {
         super();
      }
      
      public function load(index:int, sackItem:Item) : void
      {
         var item:Item = null;
         this.items = new Vector.<Item>(sackItem.items.length);
         this.index = index;
         this.item = sackItem;
         for(var i:int = 0; i < sackItem.items.length; i++)
         {
            item = sackItem.items[i];
            if(Boolean(item))
            {
               item.key = new InvKey(index,i);
               this.addItem(item);
            }
         }
         sackItem.items = null;
      }
      
      public function addItem(item:Item) : void
      {
         var e:PropertyChangeEvent = null;
         var index:int = item.key.slot;
         var oldVal:Item = this.items[index];
         this.items[index] = item;
         if(hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
         {
            e = PropertyChangeEvent.createUpdateEvent(this,index,oldVal,item);
            dispatchEvent(e);
         }
         if(hasEventListener(Event.CHANGE))
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function removeItemBySlot(slot:int) : Item
      {
         var e:PropertyChangeEvent = null;
         var item:Item = this.items[slot];
         this.items[slot] = null;
         if(Boolean(item) && hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
         {
            e = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,false,false,PropertyChangeEventKind.DELETE,slot,item,null,this);
            dispatchEvent(e);
         }
         if(hasEventListener(Event.CHANGE))
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
         return item;
      }
      
      public function getItemById(id:String) : Item
      {
         var item:Item = null;
         for each(item in this.items)
         {
            if(Boolean(item) && item.id == id)
            {
               return item;
            }
         }
         return null;
      }
      
      public function getItemBySlot(slot:int) : Item
      {
         return this.items[slot];
      }
      
      public function get uid() : String
      {
         return null;
      }
      
      public function set uid(value:String) : void
      {
      }
   }
}

