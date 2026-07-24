package soul.event
{
   import flash.events.Event;
   
   public class SocialEvent extends Event
   {
      
      public static const ADD:String = "ADD";
      
      public static const REMOVE:String = "REMOVE";
      
      public static const LIST_CHANGED:String = "LIST_CHANGED";
      
      public var characterName:String;
      
      public var characterId:String;
      
      public var listType:String;
      
      public function SocialEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

