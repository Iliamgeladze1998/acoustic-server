package soul.event
{
   import flash.events.Event;
   import soul.model.item.Item;
   
   public class RTMEvent extends Event
   {
      
      public static const APPLY_WEAPON:String = "APPLY_WEAPON";
      
      public static const CALL_DUEL:String = "CALL_DUEL";
      
      public static const SELECT_WEAPON:String = "SELECT_WEAPON";
      
      public static const SELECT_AMMO:String = "SELECT_AMMO";
      
      public static const SWITCH_RUN:String = "SWITCH_RUN";
      
      public var id:String;
      
      public var index:int;
      
      public var item:Item;
      
      public function RTMEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var ne:RTMEvent = new RTMEvent(type,bubbles,cancelable);
         ne.id = this.id;
         ne.index = this.index;
         ne.item = this.item;
         return ne;
      }
   }
}

