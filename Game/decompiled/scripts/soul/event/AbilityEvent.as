package soul.event
{
   import flash.events.Event;
   
   public class AbilityEvent extends Event
   {
      
      public static const CREATE_ABILITY_SHORTCUT:String = "CREATE_ABILITY_SHORTCUT";
      
      public static const REMOVE_ABILITY_SHORTCUT:String = "REMOVE_ABILITY_SHORTCUT";
      
      public static const ABILITY_CLICK:String = "ABILITY_CLICK";
      
      public var abilityId:String;
      
      public var slotIndex:int;
      
      public var self:Boolean;
      
      public function AbilityEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var ne:AbilityEvent = new AbilityEvent(type,bubbles,cancelable);
         ne.abilityId = this.abilityId;
         ne.slotIndex = this.slotIndex;
         return ne;
      }
   }
}

