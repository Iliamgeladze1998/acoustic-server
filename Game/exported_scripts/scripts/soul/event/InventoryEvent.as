package soul.event
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.model.item.Item;
   
   public class InventoryEvent extends Event
   {
      
      public static const TAKEOFF:String = "TAKEOFF";
      
      public static const TAKEOFF_TO_SACK:String = "TAKEOFF_TO_SACK";
      
      public static const TAKEOFF_TO_SLOT:String = "TAKEOFF_TO_SLOT";
      
      public static const EQUIP:String = "EQUIP";
      
      public static const EQUIP_TO_SLOT:String = "EQUIP_TO_SLOT";
      
      public static const CHANGE_SLOT:String = "CHANGE_SLOT";
      
      public static const CHANGE_BODY_SLOT:String = "CHANGE_BODY_SLOT";
      
      public static const CHANGE_SACK:String = "CHANGE_SACK";
      
      public static const DROP:String = "DROP";
      
      public static const USE:String = "USE";
      
      public static const SPLIT_START:String = "SPLIT_START";
      
      public static const SPLIT:String = "SPLIT";
      
      public static const SPLIT_TO_SACK:String = "SPLIT_TO_SACK";
      
      public static const GET_SOCKETS:String = "GET_SOCKETS";
      
      public static const ENCRUST_DELETED:String = "ENCRUST_DELETED";
      
      public static const CREATE_RUNE_SHORTCUT:String = "CREATE_RUNE_SHORTCUT";
      
      public static const REMOVE_RUNE_SHORTCUT:String = "REMOVE_RUNE_SHORTCUT";
      
      public static const CREATE_AUTO_RUNE_SHORTCUT:String = "CREATE_AUTO_RUNE_SHORTCUT";
      
      public static const REMOVE_AUTO_RUNE_SHORTCUT:String = "REMOVE_AUTO_RUNE_SHORTCUT";
      
      public static const CREATE_AMMO_SHORTCUT:String = "CREATE_AMMO_SHORTCUT";
      
      public static const REMOVE_AMMO_SHORTCUT:String = "REMOVE_AMMO_SHORTCUT";
      
      public static const INVENTORY_VISIBLE:String = "INVENTORY_VISIBLE";
      
      public static const INVENTORY_HIDDEN:String = "INVENTORY_HIDDEN";
      
      public var itemId:String;
      
      public var slotIndex:int;
      
      public var item:Item;
      
      public var encrusts:Array;
      
      public var mouseEvent:MouseEvent;
      
      public function InventoryEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = true)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var ne:InventoryEvent = new InventoryEvent(type,bubbles,cancelable);
         ne.itemId = this.itemId;
         ne.slotIndex = this.slotIndex;
         ne.item = this.item;
         ne.encrusts = this.encrusts;
         ne.mouseEvent = this.mouseEvent;
         return ne;
      }
   }
}

