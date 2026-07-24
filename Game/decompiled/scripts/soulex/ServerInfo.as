package soulex
{
   public class ServerInfo
   {
      
      private static const TAG:String = "ServerInfo";
      
      public var id:String;
      
      public var name:String;
      
      public var host:String;
      
      public var online:Boolean;
      
      public var characters:uint;
      
      public var version:String;
      
      public function ServerInfo()
      {
         super();
      }
      
      public static function load(data:String) : Array
      {
         var x:XML = null;
         var si:ServerInfo = null;
         var arr:Array = [];
         var xml:XML = new XML(data);
         for each(x in xml[TAG])
         {
            si = new ServerInfo();
            si.id = x.@id;
            si.name = x.@name;
            si.host = x.@host;
            si.online = x.@online == "true";
            si.characters = uint(x.@characters);
            si.version = x.@version;
            arr.push(si);
         }
         return arr;
      }
      
      public function get label() : String
      {
         return "[" + this.characters + "] " + this.name + " (" + this.version + ") " + (this.online ? "online" : "offline");
      }
   }
}

