package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.loot.LootScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_loot_LootScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_loot_LootScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         LootScreen.watcherSetupUtil = new _soul_view_interaction_loot_LootScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[1] = new PropertyWatcher("model",{"propertyChange":true},[param4[1],param4[3],param4[7]],param2);
         param5[2] = new PropertyWatcher("items",{"propertyChange":true},[param4[1]],null);
         param5[4] = new PropertyWatcher("totalWeight",{"propertyChange":true},[param4[3]],null);
         param5[8] = new PropertyWatcher("lootAllEnabled",{"propertyChange":true},[param4[7]],null);
         param5[1].updateParent(param1);
         param5[1].addChild(param5[2]);
         param5[1].addChild(param5[4]);
         param5[1].addChild(param5[8]);
      }
   }
}

