package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.dashboard.DashboardScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_dashboard_DashboardScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_dashboard_DashboardScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         DashboardScreen.watcherSetupUtil = new _soul_view_interaction_dashboard_DashboardScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[8] = new PropertyWatcher("model",{"propertyChange":true},[param4[5]],param2);
         param5[9] = new PropertyWatcher("citadelEntries",{"propertyChange":true},[param4[5]],null);
         param5[10] = new PropertyWatcher("bgEntries",{"propertyChange":true},[param4[5]],null);
         param5[14] = new PropertyWatcher("settingsModel",{"propertyChange":true},[param4[8]],param2);
         param5[15] = new PropertyWatcher("pvpEventsHidden",{"pvpEventsHiddenChanged":true},[param4[8]],null);
         param5[6] = new PropertyWatcher("bar",{"propertyChange":true},[param4[5],param4[12],param4[16]],param2);
         param5[7] = new PropertyWatcher("selectedIndex",{"selectedIndexChanged":true},[param4[5],param4[12],param4[16]],null);
         param5[11] = new PropertyWatcher("calendar",{"propertyChange":true},[param4[6],param4[11],param4[15]],param2);
         param5[12] = new PropertyWatcher("selectedEntry",{"selectedEntryChanged":true},[param4[6],param4[11],param4[15]],null);
         param5[21] = new PropertyWatcher("canBeDenied",{"canBeDeniedChanged":true},[param4[15]],null);
         param5[18] = new PropertyWatcher("canBeAccepted",{"canBeAcceptedChanged":true},[param4[11]],null);
         param5[8].updateParent(param1);
         param5[8].addChild(param5[9]);
         param5[8].addChild(param5[10]);
         param5[14].updateParent(param1);
         param5[14].addChild(param5[15]);
         param5[6].updateParent(param1);
         param5[6].addChild(param5[7]);
         param5[11].updateParent(param1);
         param5[11].addChild(param5[12]);
         param5[12].addChild(param5[21]);
         param5[12].addChild(param5[18]);
      }
   }
}

