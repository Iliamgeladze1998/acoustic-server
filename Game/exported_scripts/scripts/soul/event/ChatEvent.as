package soul.event
{
   import flash.events.Event;
   
   public class ChatEvent extends Event
   {
      
      public static const TABS_CHANGED:String = "TABS_CHANGED";
      
      public static const TAB_CHANGED:String = "TAB_CHANGED";
      
      public static const LOCALE_CHANGED:String = "LOCALE_CHANGED";
      
      public static const TIMESTAMP_CHANGED:String = "TIMESTAMP_CHANGED";
      
      public static const CHAR_CLICKED:String = "CHAR_CLICKED";
      
      public static const MESSAGE_SEND:String = "messageSend";
      
      public static const ADD_CHAT_RECIPIENT:String = "ADD_CHAT_RECIPIENT";
      
      public static const OPEN_CHAR_MENU:String = "OPEN_CHAR_MENU";
      
      public static const OPEN_CHAR_CLAN:String = "OPEN_CHAR_CLAN";
      
      public static const ADD_COMBAT_MESSAGE:String = "ADD_COMBAT_MESSAGE";
      
      public static const TOGGLE_COMBAT_LOG:String = "TOGGLE_COMBAT_LOG";
      
      public var data:*;
      
      public function ChatEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

