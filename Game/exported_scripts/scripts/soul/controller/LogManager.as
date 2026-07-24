package soul.controller
{
   import flash.display.DisplayObjectContainer;
   import flash.system.Capabilities;
   import soul.net.ServerLayer;
   import soul.view.rtm.errorFrame.ErrorMessages;
   
   public class LogManager
   {
      
      private static var container:ErrorMessages;
      
      private static const SERVICE:String = "loggerService";
      
      private static const reportParams:Vector.<String> = Vector.<String>(["language","manufacturer","cpuArchitecture","playerType","version"]);
      
      public function LogManager()
      {
         super();
      }
      
      public static function init(container:DisplayObjectContainer) : void
      {
         LogManager.container = container as ErrorMessages;
      }
      
      public static function reset() : void
      {
         container = null;
      }
      
      public static function addMessage(key:String, params:Array = null) : void
      {
         container.addMessage(key);
      }
      
      public static function report(message:String, submitSystemInfo:Boolean = false) : void
      {
         var key:String = null;
         var systemInfo:String = "";
         if(submitSystemInfo)
         {
            systemInfo = " ";
            for each(key in reportParams)
            {
               systemInfo += key + "=" + Capabilities[key] + ", ";
            }
         }
         ServerLayer.call(SERVICE,"report",null,null,message,systemInfo);
      }
      
      public static function log(component:String, message:String) : void
      {
         ServerLayer.call(SERVICE,"log",null,null,component,message);
      }
   }
}

