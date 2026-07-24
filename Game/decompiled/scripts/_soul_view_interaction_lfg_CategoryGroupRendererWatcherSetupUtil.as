package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.lfg.CategoryGroupRenderer;
   
   [ExcludeClass]
   public class _soul_view_interaction_lfg_CategoryGroupRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_lfg_CategoryGroupRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         CategoryGroupRenderer.watcherSetupUtil = new _soul_view_interaction_lfg_CategoryGroupRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

