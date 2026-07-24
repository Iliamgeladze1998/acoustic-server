package soul.event
{
   import flash.events.Event;
   import soul.model.interaction.auction.CreateLotData;
   
   public class AuctionEvent extends Event
   {
      
      public static const INVENTORY_CHANGED:String = "INVENTORY_CHANGED";
      
      public static const FILTER_CHANGED:String = "FILTER_CHANGED";
      
      public static const MAKE_BID:String = "MAKE_BID";
      
      public static const CANCEL_BID:String = "CANCEL_BID";
      
      public static const CREATE_LOT:String = "CREATE_LOT";
      
      public static const CANCEL_LOT:String = "CANCEL_LOT";
      
      public var lotId:String;
      
      public var value:int;
      
      public var createLotData:CreateLotData;
      
      public function AuctionEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

