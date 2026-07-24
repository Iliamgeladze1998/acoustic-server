package soulex
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   
   public class GameConfig
   {
      
      public static var version:String;
      
      public static var defaultLocale:String;
      
      public static var loginServer:String;
      
      public static var updateFile:String;
      
      public static var gameServer:String;
      
      public static var staticServer:String;
      
      public static var portalServer:String;
      
      private static var file:File;
      
      public static var session:String;
      
      public static var servers:Array;
      
      public static var selectedServer:ServerInfo;
      
      public static var characters:Array;
      
      public static var selectedCharacter:CharacterInfo;
      
      public static var locale:String;
      
      private static const so:SharedObject = SharedObject.getLocal("SoulDownloadable");
      
      public static var localeList:Array = [];
      
      public function GameConfig()
      {
         super();
      }
      
      public static function load(configUrl:String) : void
      {
         file = File.applicationDirectory;
         file = file.resolvePath(configUrl);
         var stream:FileStream = new FileStream();
         stream.open(file,FileMode.READ);
         parse(stream.readUTFBytes(stream.bytesAvailable));
         stream.close();
         file = null;
      }
      
      private static function parse(data:String) : void
      {
         var x:XML = null;
         var xml:XML = new XML(data);
         defaultLocale = xml[0].defaultLocale;
         loginServer = xml[0].loginServer;
         updateFile = xml[0].updateFile;
         gameServer = xml[0].gameServer;
         staticServer = xml[0].staticServer;
         portalServer = xml[0].portalServer;
         for each(x in xml[0].locales.locale)
         {
            localeList.push({
               "label":x.toString(),
               "value":x.@id
            });
         }
      }
      
      public static function goto(url:String) : void
      {
         url = portalServer + "/" + url + "?locale=" + locale;
         navigateToURL(new URLRequest(url),"blank");
      }
      
      public static function set lastWidth(value:Number) : void
      {
         so.data.width = value;
         so.flush();
      }
      
      public static function get lastWidth() : Number
      {
         return so.data.width;
      }
      
      public static function set lastHeight(value:Number) : void
      {
         so.data.height = value;
         so.flush();
      }
      
      public static function get lastHeight() : Number
      {
         return so.data.height;
      }
      
      public static function set maximized(value:Boolean) : void
      {
         so.data.maximized = value;
         so.flush();
      }
      
      public static function get maximized() : Boolean
      {
         return so.data.maximized;
      }
      
      public static function set lastLogin(value:String) : void
      {
         so.data.lastLogin = value;
         so.flush();
      }
      
      public static function get lastLogin() : String
      {
         return so.data.lastLogin;
      }
      
      public static function set lastPassword(value:String) : void
      {
         so.data.lastPassword = value;
         so.flush();
      }
      
      public static function get lastPassword() : String
      {
         return so.data.lastPassword;
      }
      
      public static function set lastServer(value:String) : void
      {
         so.data.lastServer = value;
         so.flush();
      }
      
      public static function get lastServer() : String
      {
         return so.data.lastServer;
      }
      
      public static function set lastCharacter(value:String) : void
      {
         so.data.lastCharacter = value;
         so.flush();
      }
      
      public static function get lastCharacter() : String
      {
         return so.data.lastCharacter;
      }
      
      public static function set lastLocale(value:String) : void
      {
         so.data.lastLocale = value;
         so.flush();
      }
      
      public static function get lastLocale() : String
      {
         return so.data.lastLocale;
      }
   }
}

