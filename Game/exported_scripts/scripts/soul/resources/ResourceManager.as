package soul.resources
{
   public class ResourceManager
   {
      
      private static const bundles:Object = {};
      
      public function ResourceManager()
      {
         super();
      }
      
      public static function setBundle(bundleName:String, bundle:Object) : void
      {
         bundles[bundleName] = bundle;
      }
      
      public static function getString(bundleName:String, key:String) : String
      {
         var ret:String = null;
         var bs:Object = bundles;
         var bundle:Object = bundles[bundleName];
         if(Boolean(bundle))
         {
            ret = bundle[key];
         }
         if(ret == null)
         {
            ret = String(key);
         }
         return ret;
      }
   }
}

