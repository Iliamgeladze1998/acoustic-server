package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.talents.TalentScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_talents_TalentScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_talents_TalentScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         TalentScreen.watcherSetupUtil = new _soul_view_interaction_talents_TalentScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[5] = new PropertyWatcher("model",{"propertyChange":true},[param4[3],param4[7]],param2);
         param5[6] = new PropertyWatcher("pointsAvailable",{"propertyChange":true},[param4[3],param4[7]],null);
         param5[2] = new PropertyWatcher("characterModel",{"propertyChange":true},[param4[2]],param2);
         param5[3] = new PropertyWatcher("properties",{"propertyChange":true},[param4[2]],null);
         param5[4] = new PropertyWatcher("LEVEL",null,[param4[2]],null);
         param5[1] = new PropertyWatcher("abilityModel",{"propertyChange":true},[param4[1]],param2);
         param5[5].updateParent(param1);
         param5[5].addChild(param5[6]);
         param5[2].updateParent(param1);
         param5[2].addChild(param5[3]);
         param5[3].addChild(param5[4]);
         param5[1].updateParent(param1);
      }
   }
}

