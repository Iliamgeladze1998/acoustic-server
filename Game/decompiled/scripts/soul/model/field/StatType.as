package soul.model.field
{
   import soul.view.common.Icons;
   
   public class StatType
   {
      
      public static var HP:String = "HP";
      
      public static var MP:String = "MP";
      
      public static var STAMINA:String = "STAMINA";
      
      public static var MAX_HP:String = "MAX_HP";
      
      public static var MAX_MP:String = "MAX_MP";
      
      public static var MAX_STAMINA:String = "MAX_STAMINA";
      
      public static var LEVEL:String = "LEVEL";
      
      public static var XP:String = "XP";
      
      private static const icons:Object = {};
      
      icons[HP] = Icons.hp;
      icons[MP] = Icons.mp;
      icons[STAMINA] = Icons.stamina;
      
      public function StatType()
      {
         super();
      }
      
      public static function getIcon(type:String) : Class
      {
         return icons[type];
      }
   }
}

