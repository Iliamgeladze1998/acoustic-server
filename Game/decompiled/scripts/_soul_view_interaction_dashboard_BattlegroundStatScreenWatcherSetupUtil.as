package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.dashboard.BattlegroundStatScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_dashboard_BattlegroundStatScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_dashboard_BattlegroundStatScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         BattlegroundStatScreen.watcherSetupUtil = new _soul_view_interaction_dashboard_BattlegroundStatScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[4] = new PropertyWatcher("stats",{"propertyChange":true},[param4[9],param4[10],param4[11],param4[12],param4[13],param4[14],param4[15],param4[16]],param2);
         param5[4].updateParent(param1);
      }
   }
}

