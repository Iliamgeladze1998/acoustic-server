package soul.utils
{
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedSuperclassName;
   
   public class ClassUtils
   {
      
      public function ClassUtils()
      {
         super();
      }
      
      public static function getSuperclass(object:Object) : Class
      {
         var superclassName:String = null;
         while(true)
         {
            superclassName = getQualifiedSuperclassName(object);
            if(superclassName == null)
            {
               return null;
            }
            object = getDefinitionByName(superclassName);
            if(object == MovieClip || object == BitmapData || object == Sprite)
            {
               return object as Class;
            }
         }
         return null;
      }
   }
}

