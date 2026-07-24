package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.quest.QuestDialog;
   
   [ExcludeClass]
   public class _soul_view_interaction_quest_QuestDialogWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_quest_QuestDialogWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         QuestDialog.watcherSetupUtil = new _soul_view_interaction_quest_QuestDialogWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[3] = new PropertyWatcher("answers",{"propertyChange":true},[param4[2]],param2);
         param5[4] = new PropertyWatcher("height",{"heightChanged":true},[param4[2]],null);
         param5[3].updateParent(param1);
         param5[3].addChild(param5[4]);
      }
   }
}

