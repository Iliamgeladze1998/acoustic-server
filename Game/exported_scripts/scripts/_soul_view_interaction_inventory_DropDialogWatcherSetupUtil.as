package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.inventory.DropDialog;
   
   [ExcludeClass]
   public class _soul_view_interaction_inventory_DropDialogWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_inventory_DropDialogWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         DropDialog.watcherSetupUtil = new _soul_view_interaction_inventory_DropDialogWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[6] = new PropertyWatcher("slider",{"propertyChange":true},[param4[4]],param2);
         param5[7] = new PropertyWatcher("value",{"valueChanged":true},[param4[4]],null);
         param5[4] = new PropertyWatcher("count",{"propertyChange":true},[param4[3]],param2);
         param5[5] = new PropertyWatcher("text",{"textChanged":true},[param4[3]],null);
         param5[2] = new PropertyWatcher("item",{"propertyChange":true},[param4[1]],param2);
         param5[3] = new PropertyWatcher("maxCount",{"propertyChange":true},[param4[2]],param2);
         param5[6].updateParent(param1);
         param5[6].addChild(param5[7]);
         param5[4].updateParent(param1);
         param5[4].addChild(param5[5]);
         param5[2].updateParent(param1);
         param5[3].updateParent(param1);
      }
   }
}

