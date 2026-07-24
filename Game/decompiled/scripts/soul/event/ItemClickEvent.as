package soul.event
{
   import flash.events.Event;
   
   public class ItemClickEvent extends Event
   {
      
      public static const ITEM_CLICK:String = "itemClick";
      
      public var item:Object;
      
      public var index:int = -1;
      
      public function ItemClickEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var ne:ItemClickEvent = new ItemClickEvent(type,bubbles,cancelable);
         ne.item = this.item;
         ne.index = this.index;
         return ne;
      }
   }
}

