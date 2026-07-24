package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.loot.BindingDialog;
   
   [ExcludeClass]
   public class _soul_view_interaction_loot_BindingDialogWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_loot_BindingDialogWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         BindingDialog.watcherSetupUtil = new _soul_view_interaction_loot_BindingDialogWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("item",{"propertyChange":true},[param4[0]],param2);
         param5[2] = new PropertyWatcher("action",{"propertyChange":true},[param4[1]],param2);
         param5[0].updateParent(param1);
         param5[2].updateParent(param1);
      }
   }
}

