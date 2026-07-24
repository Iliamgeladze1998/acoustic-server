package mx.containers.utilityClasses
{
   import mx.core.Container;
   import mx.core.mx_internal;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class Layout
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      protected var resourceManager:IResourceManager = ResourceManager.getInstance();
      
      private var _target:Container;
      
      public function Layout()
      {
         super();
      }
      
      public function get target() : Container
      {
         return this._target;
      }
      
      public function set target(value:Container) : void
      {
         this._target = value;
      }
      
      public function measure() : void
      {
      }
      
      public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
      }
   }
}

