package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.workshop.Workshop;
   
   [ExcludeClass]
   public class _soul_view_interaction_workshop_WorkshopWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_workshop_WorkshopWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         Workshop.watcherSetupUtil = new _soul_view_interaction_workshop_WorkshopWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[2] = new PropertyWatcher("items",{"propertyChange":true},[param4[2]],param2);
         param5[2].updateParent(param1);
      }
   }
}

