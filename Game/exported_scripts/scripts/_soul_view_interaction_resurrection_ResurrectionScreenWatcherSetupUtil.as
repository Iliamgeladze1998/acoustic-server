package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.resurrection.ResurrectionScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_resurrection_ResurrectionScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_resurrection_ResurrectionScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ResurrectionScreen.watcherSetupUtil = new _soul_view_interaction_resurrection_ResurrectionScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

