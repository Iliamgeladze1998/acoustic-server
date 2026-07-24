package
{
   import mx.binding.ArrayElementWatcher;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.inventory.InventoryScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_inventory_InventoryScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_inventory_InventoryScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         InventoryScreen.watcherSetupUtil = new _soul_view_interaction_inventory_InventoryScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var staticPropertyGetter:Function = param3;
         var bindings:Array = param4;
         var watchers:Array = param5;
         watchers[3] = new PropertyWatcher("model",{"propertyChange":true},[bindings[2],bindings[3]],propertyGetter);
         watchers[4] = new PropertyWatcher("sacks",{"propertyChange":true},[bindings[2],bindings[3]],null);
         watchers[5] = new ArrayElementWatcher(target,function():*
         {
            return target.bar.selectedIndex;
         },[bindings[3]]);
         watchers[6] = new PropertyWatcher("characterModel",{"propertyChange":true},[bindings[4],bindings[7],bindings[11]],propertyGetter);
         watchers[7] = new PropertyWatcher("currencies",{"propertyChange":true},[bindings[4],bindings[7],bindings[11]],null);
         watchers[11] = new PropertyWatcher("RUBIES",null,[bindings[7]],null);
         watchers[14] = new PropertyWatcher("PVP",null,[bindings[11]],null);
         watchers[8] = new PropertyWatcher("COPPER",null,[bindings[4]],null);
         watchers[0] = new PropertyWatcher("bar",{"propertyChange":true},[bindings[0],bindings[3]],propertyGetter);
         watchers[1] = new PropertyWatcher("selectedIndex",{"propertyChange":true},[bindings[0],bindings[3]],null);
         watchers[3].updateParent(target);
         watchers[3].addChild(watchers[4]);
         watchers[5].arrayWatcher = watchers[4];
         watchers[4].addChild(watchers[5]);
         watchers[6].updateParent(target);
         watchers[6].addChild(watchers[7]);
         watchers[7].addChild(watchers[11]);
         watchers[7].addChild(watchers[14]);
         watchers[7].addChild(watchers[8]);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[1]);
      }
   }
}

