package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.inventory.encrust.EncrustScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_inventory_encrust_EncrustScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_inventory_encrust_EncrustScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         EncrustScreen.watcherSetupUtil = new _soul_view_interaction_inventory_encrust_EncrustScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[3] = new PropertyWatcher("jewels",{"propertyChange":true},[param4[3]],param2);
         param5[4] = new PropertyWatcher("changed",{"propertyChange":true},[param4[3]],null);
         param5[3].updateParent(param1);
         param5[3].addChild(param5[4]);
      }
   }
}

