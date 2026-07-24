package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.quest.QuestDescription;
   
   [ExcludeClass]
   public class _soul_view_interaction_quest_QuestDescriptionWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_quest_QuestDescriptionWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         QuestDescription.watcherSetupUtil = new _soul_view_interaction_quest_QuestDescriptionWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[5] = new PropertyWatcher("questLog",{"propertyChange":true},[param4[6]],param2);
         param5[6] = new PropertyWatcher("avatar",{"propertyChange":true},[param4[6]],param2);
         param5[5].updateParent(param1);
         param5[6].updateParent(param1);
      }
   }
}

