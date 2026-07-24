package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import soul.view.login.LogoutScreen;
   
   [ExcludeClass]
   public class _soul_view_login_LogoutScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_login_LogoutScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         LogoutScreen.watcherSetupUtil = new _soul_view_login_LogoutScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

