package air.update.logging
{
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.utils.Dictionary;
   
   [ExcludeClass]
   public class Logger
   {
      
      private static var loggers:Dictionary = new Dictionary();
      
      private static var _level:int = Level.OFF;
      
      private var name:String = "";
      
      public function Logger(name:String)
      {
         super();
         this.name = name;
      }
      
      public static function get level() : int
      {
         return _level;
      }
      
      public static function getLogger(name:String) : Logger
      {
         if(!loggers[name])
         {
            return new Logger(name);
         }
         return loggers[name];
      }
      
      public static function set level(value:int) : void
      {
         _level = value;
      }
      
      public function config(... arguments) : void
      {
         this.log(Level.CONFIG,arguments);
      }
      
      public function log(logLevel:int, ... arguments) : void
      {
         var s:String;
         var file:File = null;
         var fs:FileStream = null;
         if(!this.isLoggable(logLevel))
         {
            return;
         }
         s = this.format(logLevel,arguments);
         trace(s);
         try
         {
            file = new File(File.documentsDirectory.nativePath + "/../.airappupdater.log");
            if(file.exists)
            {
               fs = new FileStream();
               fs.open(file,FileMode.APPEND);
               fs.writeUTFBytes(s + "\n");
               fs.close();
            }
         }
         catch(e:Error)
         {
         }
      }
      
      public function isLoggable(logLevel:int) : Boolean
      {
         return logLevel >= level;
      }
      
      public function info(... arguments) : void
      {
         this.log(Level.INFO,arguments);
      }
      
      public function severe(... arguments) : void
      {
         this.log(Level.SEVERE,arguments);
      }
      
      private function format(logLevel:int, ... arguments) : String
      {
         var date:Date = new Date();
         var dateString:String = date.fullYear + "/" + date.month + "/" + date.day + " " + date.hours + ":" + date.minutes + ":" + date.seconds + "." + date.milliseconds;
         var output:String = date + " | " + this.name + " | [" + Level.getName(logLevel) + "] ";
         if(arguments == null)
         {
            return output;
         }
         for(var i:int = 0; i < arguments.length; i++)
         {
            output += (i > 0 ? "," : "") + (arguments[i] != null ? arguments[i].toString() : "null");
         }
         return output;
      }
      
      public function finer(... arguments) : void
      {
         this.log(Level.FINER,arguments);
      }
      
      public function fine(... arguments) : void
      {
         this.log(Level.FINE,arguments);
      }
      
      public function finest(... arguments) : void
      {
         this.log(Level.FINEST,arguments);
      }
      
      public function warning(... arguments) : void
      {
         this.log(Level.WARNING,arguments);
      }
   }
}

