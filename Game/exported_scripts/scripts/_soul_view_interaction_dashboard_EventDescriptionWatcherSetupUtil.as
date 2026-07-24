package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.dashboard.EventDescription;
   
   [ExcludeClass]
   public class _soul_view_interaction_dashboard_EventDescriptionWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_dashboard_EventDescriptionWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         EventDescription.watcherSetupUtil = new _soul_view_interaction_dashboard_EventDescriptionWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

