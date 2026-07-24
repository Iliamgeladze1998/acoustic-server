package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soulex.view.ServerScreen;
   
   [ExcludeClass]
   public class _soulex_view_ServerScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soulex_view_ServerScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ServerScreen.watcherSetupUtil = new _soulex_view_ServerScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[5] = new PropertyWatcher("tile",{"propertyChange":true},[param4[5]],param2);
         param5[6] = new PropertyWatcher("selectedCharacterIndex",{"propertyChange":true},[param4[5]],null);
         param5[5].updateParent(param1);
         param5[5].addChild(param5[6]);
      }
   }
}

