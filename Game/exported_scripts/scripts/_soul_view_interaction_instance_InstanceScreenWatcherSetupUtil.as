package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.instance.InstanceScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_instance_InstanceScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_instance_InstanceScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         InstanceScreen.watcherSetupUtil = new _soul_view_interaction_instance_InstanceScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[3] = new PropertyWatcher("model",{"propertyChange":true},[param4[3]],param2);
         param5[4] = new PropertyWatcher("instances",{"propertyChange":true},[param4[3]],null);
         param5[3].updateParent(param1);
         param5[3].addChild(param5[4]);
      }
   }
}

