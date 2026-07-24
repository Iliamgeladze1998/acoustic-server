package soul.model.item
{
   public class ItemClass
   {
      
      public static const CLASS1:String = "CLASS1";
      
      public static const CLASS2:String = "CLASS2";
      
      public static const CLASS3:String = "CLASS3";
      
      public static const CLASS4:String = "CLASS4";
      
      public static const CLASS5:String = "CLASS5";
      
      public static const CLASS6:String = "CLASS6";
      
      public static const CLASS7:String = "CLASS7";
      
      private static const itemClassColors:Object = {};
      
      public static const IMG_CLASS1:Class = ItemClass_IMG_CLASS1;
      
      public static const IMG_CLASS2:Class = ItemClass_IMG_CLASS2;
      
      public static const IMG_CLASS3:Class = ItemClass_IMG_CLASS3;
      
      public static const IMG_CLASS4:Class = ItemClass_IMG_CLASS4;
      
      public static const IMG_CLASS5:Class = ItemClass_IMG_CLASS5;
      
      public static const IMG_CLASS6:Class = ItemClass_IMG_CLASS6;
      
      public static const IMG_CLASS7:Class = ItemClass_IMG_CLASS7;
      
      private static const itemClassImages:Object = {};
      
      itemClassColors[CLASS1] = 16777150;
      itemClassColors[CLASS2] = 16777150;
      itemClassColors[CLASS3] = 3792166;
      itemClassColors[CLASS4] = 14040124;
      itemClassColors[CLASS5] = 2322943;
      itemClassColors[CLASS6] = 7438818;
      itemClassColors[CLASS7] = 16776960;
      itemClassImages[CLASS1] = IMG_CLASS1;
      itemClassImages[CLASS2] = IMG_CLASS2;
      itemClassImages[CLASS3] = IMG_CLASS3;
      itemClassImages[CLASS4] = IMG_CLASS4;
      itemClassImages[CLASS5] = IMG_CLASS5;
      itemClassImages[CLASS6] = IMG_CLASS6;
      itemClassImages[CLASS7] = IMG_CLASS7;
      
      public function ItemClass()
      {
         super();
      }
      
      public static function getItemColor(klass:String) : int
      {
         return itemClassColors[klass];
      }
      
      public static function getItemImage(klass:String) : Class
      {
         return itemClassImages[klass];
      }
   }
}

