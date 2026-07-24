package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.toolbar.ToolBar;
   
   [ExcludeClass]
   public class _soul_view_toolbar_ToolBarWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_toolbar_ToolBarWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ToolBar.watcherSetupUtil = new _soul_view_toolbar_ToolBarWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("model",{"propertyChange":true},[param4[0],param4[15]],param2);
         param5[17] = new PropertyWatcher("questModel",{"propertyChange":true},[param4[15]],null);
         param5[18] = new PropertyWatcher("hasNewHints",{"propertyChange":true},[param4[15]],null);
         param5[1] = new PropertyWatcher("mode",{"propertyChange":true},[param4[0]],null);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[17]);
         param5[17].addChild(param5[18]);
         param5[0].addChild(param5[1]);
      }
   }
}

