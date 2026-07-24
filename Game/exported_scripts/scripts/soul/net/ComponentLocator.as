package soul.net
{
   import soul.controller.LogManager;
   
   public class ComponentLocator
   {
      
      public static const READY:String = "componentReady";
      
      public static const NOT_READY:String = "componentNotReady";
      
      public static const ACHIEVEMENT:String = "achievement";
      
      public static const ARENA:String = "arena";
      
      public static const ASTRAL:String = "astral";
      
      public static const AUCTION:String = "auction";
      
      public static const BANK:String = "bank";
      
      public static const BARTER:String = "barter";
      
      public static const CHARACTER:String = "character";
      
      public static const CHAT:String = "chat";
      
      public static const CLAN:String = "clan";
      
      public static const COMBAT:String = "combat";
      
      public static const COOLDOWN:String = "cooldown";
      
      public static const CRAFT:String = "craft";
      
      public static const DASHBOARD:String = "dashboard";
      
      public static const FIELD:String = "field";
      
      public static const GAME:String = "game";
      
      public static const GROUP:String = "group";
      
      public static const INVENTORY:String = "inventory";
      
      public static const LFG:String = "lfg";
      
      public static const LOOT:String = "loot";
      
      public static const MAIL:String = "mail";
      
      public static const QUEST:String = "quest";
      
      public static const RTM:String = "rtm";
      
      public static const SOCIAL:String = "social";
      
      public static const TALENT:String = "talent";
      
      private static var componentList:Object = {};
      
      public function ComponentLocator()
      {
         super();
      }
      
      public static function reset() : void
      {
         componentList = {};
      }
      
      public static function setComponent(key:String, component:*) : void
      {
         componentList[key] = component;
      }
      
      public static function getComponent(key:String) : *
      {
         return componentList[key];
      }
      
      public static function call(service:String, method:String, args:Array) : void
      {
         var func:Function = null;
         var module:* = getComponent(service);
         if(Boolean(module))
         {
            try
            {
               func = module[method];
            }
            catch(e:TypeError)
            {
               trace("ComponentLocator::" + e,service + "." + method,"is not function");
               return;
            }
            catch(e:ReferenceError)
            {
               trace("ComponentLocator::" + e,service + "." + method,"is not defined");
               return;
            }
            if(func == null)
            {
               trace("ComponentLocator::",service + "." + method,"is not defined");
               return;
            }
            try
            {
               func.apply(module,args);
            }
            catch(e:ArgumentError)
            {
               trace("ComponentLocator::" + service + "." + method + "()",args,": Wrong parameters");
               LogManager.report("ComponentLocator::" + service + "." + method + "()" + args + " : Wrong arguments");
               return;
            }
         }
         else
         {
            trace("[Not registered] " + service + "." + method + "()",args);
         }
      }
   }
}

