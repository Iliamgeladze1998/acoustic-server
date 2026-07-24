package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.dashboard.CombatantRenderer;
   
   [ExcludeClass]
   public class _soul_view_interaction_dashboard_CombatantRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_dashboard_CombatantRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         CombatantRenderer.watcherSetupUtil = new _soul_view_interaction_dashboard_CombatantRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

