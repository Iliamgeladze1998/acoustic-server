package soul.event
{
   import flash.events.Event;
   
   public class FieldEvent extends Event
   {
      
      public static const MAP_LOADING:String = "MAP_LOADING";
      
      public static const LOAD_PROGRESS:String = "LOAD_PROGRESS";
      
      public static const LOAD_COMPLETE:String = "LOAD_COMPLETE";
      
      public static const LOAD_ERROR:String = "LOAD_ERROR";
      
      public static const FIELD_READY:String = "FIELD_READY";
      
      public static const CS_MOVE_TO:String = "CS_MOVE_TO";
      
      public static const CS_RUN_TO:String = "CS_RUN_TO";
      
      public static const CS_STAND:String = "CS_STAND";
      
      public static const CS_SELECT_TARGET:String = "CS_SELECT_TARGET";
      
      public static const CS_SELECT_UNIT:String = "CS_SELECT_UNIT";
      
      public static const CS_INTERACT:String = "CS_INTERACT";
      
      public static const CS_USE_ABILITY_ON_UNIT:String = "CS_USE_ABILITY_ON_UNIT";
      
      public static const CS_USE_ABILITY_ON_FIELD:String = "CS_USE_ABILITY_ON_FIELD";
      
      public static const CS_USE_ABILITY_HERE:String = "CS_USE_ABILITY_HERE";
      
      public static const CS_USE_ITEM_HERE:String = "CS_USE_ITEM_HERE";
      
      public static const CS_USE_ITEM_ON_UNIT:String = "CS_USE_ITEM_ON_UNIT";
      
      public static const CS_USE_ITEM_ON_FIELD:String = "CS_USE_ITEM_ON_FIELD";
      
      public static const CS_USE_OBJECT:String = "CS_USE_OBJECT";
      
      public static const CREATE_SPELL_CURSOR:String = "CREATE_SPELL_CURSOR";
      
      public static const REMOVE_SPELL_CURSOR:String = "REMOVE_SPELL_CURSOR";
      
      public static const CREATE_AOE:String = "CREATE_AOE";
      
      public static const REMOVE_AOE:String = "REMOVE_AOE";
      
      public static const ACCEPT_ABILITY:String = "ACCEPT_ABILITY";
      
      public static const UNSELECT_TARGET:String = "UNSELECT_TARGET";
      
      public static const USE_POINT_ABILITY_ON_UNIT:String = "USE_POINT_ABILITY_ON_UNIT";
      
      public static const SHOW_MENU:String = "SHOW_MENU";
      
      public static const STICK_TARGET:String = "STICK_TARGET";
      
      public static const UNIT_CHANGED:String = "UNIT_CHANGED";
      
      public static const CLEAN_STICKS:String = "CLEAN_STICKS";
      
      public static const CLEAN_NPC_STICKS:String = "CLEAN_NPC_STICKS";
      
      public var data:*;
      
      public var params:*;
      
      public function FieldEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

