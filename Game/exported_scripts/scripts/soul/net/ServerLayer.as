package soul.net
{
   public class ServerLayer
   {
      
      private static var instance:ServerLayerInstance;
      
      private static var readyCallback:Function;
      
      private static var disconnectHandler:Function;
      
      public static var host:String;
      
      public function ServerLayer()
      {
         super();
      }
      
      public static function init(host:String, readyCallback:Function, disconnectHandler:Function) : void
      {
         ServerLayer.host = host;
         if(Boolean(instance))
         {
            throw new Error("ServerLayer already initialized");
         }
         ServerLayer.readyCallback = readyCallback;
         ServerLayer.disconnectHandler = disconnectHandler;
         instance = new ServerLayerInstance(initSucceeded,initFailed,disconnectHandler);
      }
      
      public static function reset() : void
      {
         instance = null;
         readyCallback = null;
         disconnectHandler = null;
      }
      
      private static function initSucceeded() : void
      {
         trace("server init succeeded");
         readyCallback();
         readyCallback = null;
      }
      
      private static function initFailed() : void
      {
         trace("server init failed");
         disconnectHandler();
      }
      
      public static function call(service:String, method:String, result:Function = null, fault:Function = null, ... args) : void
      {
         trace("ServerLayer.call()",service,method,args);
         instance.call(service,method,result,fault,args);
      }
      
      public static function registerCharacter(id:String, result:Function = null, fault:Function = null) : void
      {
         instance.registerCharacter(id,result,fault);
      }
      
      public static function unregisterCharacter(result:Function = null, fault:Function = null) : void
      {
         instance.unregisterCharacter(result,fault);
      }
      
      public static function ping(result:Function = null) : void
      {
         if(!instance)
         {
            return;
         }
         instance.ping(result);
      }
      
      public static function get latency() : uint
      {
         return Boolean(instance) ? instance.latency : 0;
      }
   }
}

