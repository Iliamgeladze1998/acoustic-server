package soul.model.interaction.clan
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import soul.model.item.Item;
   
   public class ClanSack extends EventDispatcher
   {
      
      public var role:String;
      
      public var enabled:Boolean;
      
      [Bindable("itemsChanged")]
      public var items:Array;
      
      public function ClanSack()
      {
         super();
      }
      
      public function changeItem(index:int, item:Item) : void
      {
         this.items[index] = item;
         dispatchEvent(new Event("itemsChanged"));
      }
   }
}

