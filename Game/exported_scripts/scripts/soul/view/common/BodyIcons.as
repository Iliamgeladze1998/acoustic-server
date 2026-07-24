package soul.view.common
{
   import soul.model.item.ItemSlot;
   
   public class BodyIcons
   {
      
      public static const amulet:Class = BodyIcons_amulet;
      
      public static const ammo:Class = BodyIcons_ammo;
      
      public static const armour:Class = BodyIcons_armour;
      
      public static const boots:Class = BodyIcons_boots;
      
      public static const bottle:Class = BodyIcons_bottle;
      
      public static const earclips:Class = BodyIcons_earclips;
      
      public static const gloves:Class = BodyIcons_gloves;
      
      public static const helmet:Class = BodyIcons_helmet;
      
      public static const ring:Class = BodyIcons_ring;
      
      public static const shield:Class = BodyIcons_shield;
      
      public static const tatoo:Class = BodyIcons_tatoo;
      
      public static const waist:Class = BodyIcons_waist;
      
      public static const weapon:Class = BodyIcons_weapon;
      
      public static const rune:Class = BodyIcons_rune;
      
      private static const icons:Object = {};
      
      icons[ItemSlot.AMMO] = ammo;
      icons[ItemSlot.AMULET] = amulet;
      icons[ItemSlot.ARMOUR] = armour;
      icons[ItemSlot.AUTO_RUNE] = rune;
      icons[ItemSlot.BOOTS] = boots;
      icons[ItemSlot.EARCLIPS] = earclips;
      icons[ItemSlot.GLOVES] = gloves;
      icons[ItemSlot.HELMET] = helmet;
      icons[ItemSlot.RING] = ring;
      icons[ItemSlot.RUNE] = bottle;
      icons[ItemSlot.SHIELD] = shield;
      icons[ItemSlot.TATOO] = tatoo;
      icons[ItemSlot.WAIST] = waist;
      icons[ItemSlot.WEAPON] = weapon;
      
      public function BodyIcons()
      {
         super();
      }
      
      public static function getIcon(slot:String) : Class
      {
         return icons[slot];
      }
   }
}

