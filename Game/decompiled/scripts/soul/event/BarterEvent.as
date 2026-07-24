package soul.event
{
   import flash.events.Event;
   import soul.model.item.Item;
   
   public class BarterEvent extends Event
   {
      
      public static const INVITE:String = "INVITE";
      
      public static const INIT:String = "INIT";
      
      public static const OFFER_ITEM:String = "OFFER_ITEM";
      
      public static const OFFER_MONEY:String = "OFFER_MONEY";
      
      public static const READY:String = "READY";
      
      public var characterId:String;
      
      public var index:int;
      
      public var item:Item;
      
      public var currency:String;
      
      public var amount:uint;
      
      public var ready:Boolean;
      
      public function BarterEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var ne:BarterEvent = new BarterEvent(type,bubbles,cancelable);
         ne.characterId = this.characterId;
         ne.index = this.index;
         ne.item = this.item;
         ne.currency = this.currency;
         ne.amount = this.amount;
         ne.ready = this.ready;
         return ne;
      }
   }
}

