package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import soulex.view.LoginBackground;
   
   [ExcludeClass]
   public class _soulex_view_LoginBackgroundWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soulex_view_LoginBackgroundWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         LoginBackground.watcherSetupUtil = new _soulex_view_LoginBackgroundWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

