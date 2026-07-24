package soulex.controller
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import soul.controller.locale.LocaleManager;
   import soul.view.console.Console;
   import soulex.GameConfig;
   
   public class AirLocale
   {
      
      private static const localePath:String = "i18n/";
      
      private static const BUNDLE:String = "client";
      
      private static const BUNDLE_FILE:String = BUNDLE + ".xml";
      
      public function AirLocale()
      {
         super();
      }
      
      public static function loadLocale() : void
      {
         Console.trace("loading air locale");
         var file:File = File.applicationDirectory.resolvePath(localePath + GameConfig.locale + File.separator + BUNDLE_FILE);
         if(!file.exists)
         {
            Console.trace("error loading locale: " + file.url);
            return;
         }
         var stream:FileStream = new FileStream();
         stream.open(file,FileMode.READ);
         var xml:XML = new XML(stream.readUTFBytes(stream.bytesAvailable));
         LocaleManager.setBundle(BUNDLE_FILE,xml);
         stream.close();
         Console.trace("loaded air locale");
      }
      
      public static function getString(key:String) : String
      {
         return LocaleManager.getString(BUNDLE,key);
      }
   }
}

