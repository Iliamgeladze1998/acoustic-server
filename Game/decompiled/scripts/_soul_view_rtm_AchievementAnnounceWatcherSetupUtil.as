package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import soul.view.rtm.AchievementAnnounce;
   
   [ExcludeClass]
   public class _soul_view_rtm_AchievementAnnounceWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_rtm_AchievementAnnounceWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         AchievementAnnounce.watcherSetupUtil = new _soul_view_rtm_AchievementAnnounceWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

