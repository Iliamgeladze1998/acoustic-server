package soul.event
{
   import flash.events.Event;
   import soul.model.item.Item;
   
   public class ShopEvent extends Event
   {
      
      public static const OPEN_BUY_DIALOG:String = "OPEN_BUY_DIALOG";
      
      public static const OPEN_SELL_DIALOG:String = "OPEN_SELL_DIALOG";
      
      public static const BUY_ITEM:String = "BUY_ITEM";
      
      public static const SELL_ITEM:String = "SELL_ITEM";
      
      public var item:Item;
      
      public var templateId:String;
      
      public var count:int;
      
      public function ShopEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = true)
      {
         super(type,bubbles,cancelable);
      }
   }
}

