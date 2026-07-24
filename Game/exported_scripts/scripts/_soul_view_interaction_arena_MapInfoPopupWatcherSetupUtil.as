package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.arena.MapInfoPopup;
   
   [ExcludeClass]
   public class _soul_view_interaction_arena_MapInfoPopupWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_arena_MapInfoPopupWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         MapInfoPopup.watcherSetupUtil = new _soul_view_interaction_arena_MapInfoPopupWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[2] = new PropertyWatcher("arenaInfo",{"propertyChange":true},[param4[1]],param2);
         param5[2].updateParent(param1);
      }
   }
}

