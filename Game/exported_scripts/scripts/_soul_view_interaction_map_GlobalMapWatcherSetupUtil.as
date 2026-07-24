package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.map.GlobalMap;
   
   [ExcludeClass]
   public class _soul_view_interaction_map_GlobalMapWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_map_GlobalMapWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         GlobalMap.watcherSetupUtil = new _soul_view_interaction_map_GlobalMapWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

