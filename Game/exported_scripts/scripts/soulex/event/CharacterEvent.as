package soulex.event
{
   import flash.events.Event;
   
   public class CharacterEvent extends Event
   {
      
      public static const CHARACTER_SELECTED:String = "CHARACTER_SELECTED";
      
      public var id:int;
      
      public function CharacterEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

