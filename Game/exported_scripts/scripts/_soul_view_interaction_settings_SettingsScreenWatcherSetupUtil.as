package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.settings.SettingsScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_settings_SettingsScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_settings_SettingsScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SettingsScreen.watcherSetupUtil = new _soul_view_interaction_settings_SettingsScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("model",{"propertyChange":true},[param4[0],param4[1],param4[2],param4[23],param4[26],param4[27]],param2);
         param5[24] = new PropertyWatcher("fullScreen",{"propertyChange":true},[param4[26]],null);
         param5[10] = new PropertyWatcher("damageGroup",{"propertyChange":true},[param4[9],param4[13],param4[17]],param2);
         param5[29] = new PropertyWatcher("fowGroup",{"propertyChange":true},[param4[32],param4[36],param4[40]],param2);
         param5[40] = new PropertyWatcher("cameraGroup",{"propertyChange":true},[param4[46],param4[50],param4[54]],param2);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[24]);
         param5[10].updateParent(param1);
         param5[29].updateParent(param1);
         param5[40].updateParent(param1);
      }
   }
}

