package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.ability.AbilityScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_ability_AbilityScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_ability_AbilityScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         AbilityScreen.watcherSetupUtil = new _soul_view_interaction_ability_AbilityScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[1] = new PropertyWatcher("characterModel",{"propertyChange":true},[param4[1],param4[3],param4[5],param4[7]],param2);
         param5[0] = new PropertyWatcher("abilityModel",{"propertyChange":true},[param4[0],param4[2],param4[4],param4[6]],param2);
         param5[1].updateParent(param1);
         param5[0].updateParent(param1);
      }
   }
}

