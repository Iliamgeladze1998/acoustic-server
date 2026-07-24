package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.astral.AstralScreen;
   
   [ExcludeClass]
   public class _soul_view_astral_AstralScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_astral_AstralScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         AstralScreen.watcherSetupUtil = new _soul_view_astral_AstralScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("model",{"propertyChange":true},[param4[0],param4[1],param4[2],param4[3]],param2);
         param5[1] = new PropertyWatcher("destinaton",{"propertyChange":true},[param4[1]],null);
         param5[2] = new PropertyWatcher("enabled",{"propertyChange":true},[param4[2]],null);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[1]);
         param5[0].addChild(param5[2]);
      }
   }
}

