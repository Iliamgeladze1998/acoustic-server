package soul.model.inventory
{
   import soul.model.item.Item;
   import soul.model.item.ItemType;
   
   public class InventoryUtils
   {
      
      private static var tabTypes:Array;
      
      public function InventoryUtils()
      {
         super();
      }
      
      public static function itemIsTab(item:Item, tab:String) : Boolean
      {
         if(!item || !tab)
         {
            return false;
         }
         if(!tabTypes)
         {
            tabTypes = [];
            tabTypes[InventoryTab.WEAPON] = [ItemType.WEAPON_AVERAGE,ItemType.WEAPON_EXOTIC,ItemType.WEAPON_HEAVY,ItemType.WEAPON_LIGHT,ItemType.WEAPON_MISSILE,ItemType.WEAPON_RIFLE_AVERAGE,ItemType.WEAPON_RIFLE_EXOTIC,ItemType.WEAPON_RIFLE_HEAVY,ItemType.WEAPON_RIFLE_LIGHT,ItemType.AMMO];
            tabTypes[InventoryTab.ARMOUR] = [ItemType.ARMOUR,ItemType.SHIELD,ItemType.BELT,ItemType.BOOTS,ItemType.GLOVES,ItemType.HELMET];
            tabTypes[InventoryTab.JEWEL] = [ItemType.AMULET,ItemType.EARCLIPS,ItemType.RING];
            tabTypes[InventoryTab.RUNE] = [ItemType.RUNE];
            tabTypes[InventoryTab.FOOD] = [ItemType.FOOD];
            tabTypes[InventoryTab.RESOURCE] = [ItemType.RESOURCE,ItemType.JEWEL];
            tabTypes[InventoryTab.QUEST] = [ItemType.QUEST];
            tabTypes[InventoryTab.OTHER] = [ItemType.TOOL,ItemType.KEY,ItemType.SMALL_THINGS,ItemType.OTHER];
         }
         var types:Array = tabTypes[tab];
         if(!types)
         {
            return false;
         }
         return types.indexOf(item.type) != -1;
      }
   }
}

