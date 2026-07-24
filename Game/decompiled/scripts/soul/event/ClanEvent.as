package soul.event
{
   import flash.events.Event;
   
   public class ClanEvent extends Event
   {
      
      public static const CREATE_CLAN:String = "CREATE_CLAN";
      
      public static const CHANGE_CLAN:String = "CHANGE_CLAN";
      
      public static const INVITE_CONFIRM:String = "INVITE_CONFIRM";
      
      public static const KICK_CONFIRM:String = "KICK_CONFIRM";
      
      public static const STATUS_CONFIRM:String = "STATUS_CONFIRM";
      
      public static const DEPOSIT_CONFIRM:String = "DEPOSIT_CONFIRM";
      
      public static const BUY_BONUS:String = "BUY_BONUS";
      
      public static const STORE_ITEM:String = "STORE_ITEM";
      
      public static const TAKE_ITEM:String = "TAKE_ITEM";
      
      public var data:*;
      
      public function ClanEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var ne:ClanEvent = new ClanEvent(type,bubbles,cancelable);
         ne.data = this.data;
         return ne;
      }
   }
}

