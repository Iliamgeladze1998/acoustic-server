package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.inventory.RTMWeapon;
   
   [ExcludeClass]
   public class _soul_view_interaction_inventory_RTMWeaponWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_inventory_RTMWeaponWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         RTMWeapon.watcherSetupUtil = new _soul_view_interaction_inventory_RTMWeaponWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[6] = new PropertyWatcher("cooldownModel",{"propertyChange":true},[param4[1]],param2);
         param5[7] = new PropertyWatcher("groups",{"propertyChange":true},[param4[1]],null);
         param5[8] = new PropertyWatcher("weapon",null,[param4[1]],null);
         param5[0] = new PropertyWatcher("characterModel",{"propertyChange":true},[param4[0],param4[3]],param2);
         param5[1] = new PropertyWatcher("alternativeIndex",{"propertyChange":true},[param4[0],param4[3]],null);
         param5[2] = new PropertyWatcher("inventoryModel",{"propertyChange":true},[param4[0]],param2);
         param5[3] = new PropertyWatcher("body",{"propertyChange":true},[param4[0]],null);
         param5[4] = new PropertyWatcher("weapon2",{"propertyChange":true},[param4[0]],null);
         param5[5] = new PropertyWatcher("weapon1",{"propertyChange":true},[param4[0]],null);
         param5[6].updateParent(param1);
         param5[6].addChild(param5[7]);
         param5[7].addChild(param5[8]);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[1]);
         param5[2].updateParent(param1);
         param5[2].addChild(param5[3]);
         param5[3].addChild(param5[4]);
         param5[3].addChild(param5[5]);
      }
   }
}

