package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.quest.QuestLog;
   
   [ExcludeClass]
   public class _soul_view_interaction_quest_QuestLogWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_quest_QuestLogWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         QuestLog.watcherSetupUtil = new _soul_view_interaction_quest_QuestLogWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("model",{"propertyChange":true},[param4[0],param4[1],param4[2],param4[3],param4[4],param4[6],param4[11],param4[14]],param2);
         param5[1] = new PropertyWatcher("selectedQuest",{"propertyChange":true},[param4[0],param4[2],param4[11],param4[14]],null);
         param5[16] = new PropertyWatcher("tracked",{"propertyChange":true},[param4[11]],null);
         param5[7] = new PropertyWatcher("selectedTab",{"propertyChange":true},[param4[4]],null);
         param5[2] = new PropertyWatcher("hints",{"propertyChange":true},[param4[1]],null);
         param5[5] = new PropertyWatcher("selectedHint",{"propertyChange":true},[param4[3]],null);
         param5[6] = new PropertyWatcher("id",{"propertyChange":true},[param4[3]],null);
         param5[9] = new PropertyWatcher("tabs",{"propertyChange":true},[param4[6]],null);
         param5[14] = new PropertyWatcher("tabs",{"propertyChange":true},[param4[11],param4[14]],param2);
         param5[15] = new PropertyWatcher("selectedIndex",{"selectedIndexChanged":true},[param4[11],param4[14]],null);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[1]);
         param5[1].addChild(param5[16]);
         param5[0].addChild(param5[7]);
         param5[0].addChild(param5[2]);
         param5[0].addChild(param5[5]);
         param5[5].addChild(param5[6]);
         param5[0].addChild(param5[9]);
         param5[14].updateParent(param1);
         param5[14].addChild(param5[15]);
      }
   }
}

