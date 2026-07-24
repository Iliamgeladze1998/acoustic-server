package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.dashboard.TeamRenderer;
   
   [ExcludeClass]
   public class _soul_view_interaction_dashboard_TeamRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_dashboard_TeamRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         TeamRenderer.watcherSetupUtil = new _soul_view_interaction_dashboard_TeamRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[3] = new PropertyWatcher("win",{"propertyChange":true},[param4[3]],param2);
         param5[6] = new PropertyWatcher("myTeam",{"propertyChange":true},[param4[6],param4[7]],param2);
         param5[3].updateParent(param1);
         param5[6].updateParent(param1);
      }
   }
}

