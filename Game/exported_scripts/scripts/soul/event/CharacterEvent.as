package soul.event
{
   import flash.events.Event;
   
   public class CharacterEvent extends Event
   {
      
      public static const PREVIEW:String = "PREVIEW";
      
      public static const ACCEPT:String = "ACCEPT";
      
      public var tab:String;
      
      public var characterId:String;
      
      public var previewObject:Object;
      
      public function CharacterEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

