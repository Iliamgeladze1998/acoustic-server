package soul.event
{
   import flash.events.Event;
   
   public class QuestEvent extends Event
   {
      
      public static const HINT_READ:String = "HINT_READ";
      
      public static const QUESTS_UPDATED:String = "QUESTS_UPDATED";
      
      public static const QUESTS_SELECTED:String = "QUESTS_SELECTED";
      
      public static const QUESTS_CANCEL:String = "QUESTS_CANCEL";
      
      public static const QUESTS_PIN:String = "QUESTS_PIN";
      
      public var id:String;
      
      public function QuestEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = true)
      {
         super(type,bubbles,cancelable);
      }
   }
}

