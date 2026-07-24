package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.achievement.AchievementScreenExternal;
   
   [ExcludeClass]
   public class _soul_view_interaction_achievement_AchievementScreenExternalWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_achievement_AchievementScreenExternalWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         AchievementScreenExternal.watcherSetupUtil = new _soul_view_interaction_achievement_AchievementScreenExternalWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[2] = new PropertyWatcher("model",{"propertyChange":true},[param4[0],param4[1],param4[4],param4[6]],param2);
         param5[3] = new PropertyWatcher("pointsCollected",{"propertyChange":true},[param4[0]],null);
         param5[0] = new PropertyWatcher("selectedGroup",{"propertyChange":true},[param4[0],param4[1]],param2);
         param5[1] = new PropertyWatcher("pointsCollected",{"propertyChange":true},[param4[0]],null);
         param5[2].updateParent(param1);
         param5[2].addChild(param5[3]);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[1]);
      }
   }
}

