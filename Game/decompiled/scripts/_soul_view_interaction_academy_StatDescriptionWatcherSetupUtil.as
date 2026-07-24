package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.academy.StatDescription;
   
   [ExcludeClass]
   public class _soul_view_interaction_academy_StatDescriptionWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_academy_StatDescriptionWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         StatDescription.watcherSetupUtil = new _soul_view_interaction_academy_StatDescriptionWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

