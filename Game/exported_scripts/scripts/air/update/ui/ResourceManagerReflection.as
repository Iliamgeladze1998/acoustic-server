package air.update.ui
{
   import air.update.logging.Logger;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.system.ApplicationDomain;
   
   public class ResourceManagerReflection extends EventDispatcher
   {
      
      private static var logger:Logger = Logger.getLogger("air.update.utils.ResourceManagerReflection");
      
      private static const RESOURCE_MANAGER_CLASS_NAME:String = "mx.resources.ResourceManager";
      
      private static var _instance:ResourceManagerReflection = null;
      
      private var _resourceManager:Object = null;
      
      public function ResourceManagerReflection(classLock:Class)
      {
         var ResourceManagerClass:Object = null;
         var rmGetInstance:Function = null;
         super();
         if(classLock != SingletonLock)
         {
            return;
         }
         var currentDomain:ApplicationDomain = ApplicationDomain.currentDomain;
         if(currentDomain.hasDefinition(RESOURCE_MANAGER_CLASS_NAME))
         {
            ResourceManagerClass = currentDomain.getDefinition(RESOURCE_MANAGER_CLASS_NAME);
            if(Boolean(ResourceManagerClass) && ResourceManagerClass is Class)
            {
               rmGetInstance = getFunction("getInstance",ResourceManagerClass);
               this._resourceManager = rmGetInstance();
               this.addListeners();
            }
            else
            {
               logger.warning("ResourceManager class definition is null or not a class");
            }
         }
         else
         {
            logger.warning("Could not find definition: " + RESOURCE_MANAGER_CLASS_NAME);
         }
      }
      
      private static function getProperty(propertyName:String, selfObject:Object) : *
      {
         var resultProperty:* = null;
         if(Boolean(selfObject) && selfObject.hasOwnProperty(propertyName))
         {
            resultProperty = selfObject[propertyName];
         }
         else
         {
            logger.warning("Could not find property - " + propertyName + " on object - " + selfObject);
         }
         return resultProperty;
      }
      
      public static function getInstance() : ResourceManagerReflection
      {
         if(!_instance)
         {
            _instance = new ResourceManagerReflection(SingletonLock);
         }
         return _instance;
      }
      
      private static function getFunction(functionName:String, selfObject:Object) : Function
      {
         var resultFunction:Function = function(... args):*
         {
            logger.info(functionName + " not found. Empty (stub) function called.");
         };
         if(Boolean(selfObject) && Boolean(selfObject.hasOwnProperty(functionName)) && selfObject[functionName] is Function)
         {
            resultFunction = selfObject[functionName];
         }
         else
         {
            logger.warning("Could not find member function - " + functionName + " - on object - " + selfObject);
         }
         return resultFunction;
      }
      
      private function getResourceManagerFunction(functionName:String) : Function
      {
         return getFunction(functionName,this._resourceManager);
      }
      
      public function getResourceBundleContent(locale:String, bundleName:String) : Object
      {
         var content:Object = null;
         var resourceBundle:Object = this.getResourceBundle(locale,bundleName);
         if(Boolean(resourceBundle))
         {
            content = getProperty("content",resourceBundle);
         }
         return content;
      }
      
      public function hasResourceManager() : Boolean
      {
         var result:Boolean = Boolean(this._resourceManager);
         logger.info("hasResourceManager: " + result);
         return result;
      }
      
      private function getResourceBundle(locale:String, bundleName:String) : Object
      {
         var rmGetResourceBundle:Function = this.getResourceManagerFunction("getResourceBundle");
         return rmGetResourceBundle(locale,bundleName);
      }
      
      public function getLocales() : Array
      {
         var rmGetLocales:Function = this.getResourceManagerFunction("getLocales");
         return rmGetLocales();
      }
      
      private function getResourceManagerProperty(propertyName:String) : *
      {
         return getProperty(propertyName,this._resourceManager);
      }
      
      private function addListeners() : void
      {
         var rmAddEventListener:Function = this.getResourceManagerFunction("addEventListener");
         rmAddEventListener(Event.CHANGE,dispatchEvent);
      }
      
      public function get localeChain() : Array
      {
         var localeChain:Array = this.getResourceManagerProperty("localeChain");
         if(!localeChain)
         {
            localeChain = [];
         }
         return localeChain;
      }
   }
}

class SingletonLock
{
   
   public function SingletonLock()
   {
      super();
   }
}
