package soul.model.common
{
   public class ElementType
   {
      
      public static const PHYSICAL:String = "PHYSICAL";
      
      public static const FIRE:String = "FIRE";
      
      public static const FROST:String = "FROST";
      
      public static const NATURE:String = "NATURE";
      
      public static const DARK:String = "DARK";
      
      public static const ARCANE:String = "ARCANE";
      
      public static const HOLY:String = "HOLY";
      
      public static const arcane:Class = ElementType_arcane;
      
      public static const dark:Class = ElementType_dark;
      
      public static const fire:Class = ElementType_fire;
      
      public static const holy:Class = ElementType_holy;
      
      public static const ice:Class = ElementType_ice;
      
      public static const nature:Class = ElementType_nature;
      
      public static const armor:Class = ElementType_armor;
      
      private static const icons:Object = {};
      
      icons[ElementType.ARCANE] = arcane;
      icons[ElementType.DARK] = dark;
      icons[ElementType.FIRE] = fire;
      icons[ElementType.FROST] = ice;
      icons[ElementType.HOLY] = holy;
      icons[ElementType.NATURE] = nature;
      
      public function ElementType()
      {
         super();
      }
      
      public static function getIcon(elementType:String) : Class
      {
         return icons[elementType];
      }
   }
}

