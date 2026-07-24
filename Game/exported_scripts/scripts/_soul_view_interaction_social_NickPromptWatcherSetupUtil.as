package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.social.NickPrompt;
   
   [ExcludeClass]
   public class _soul_view_interaction_social_NickPromptWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_social_NickPromptWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         NickPrompt.watcherSetupUtil = new _soul_view_interaction_social_NickPromptWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[3] = new PropertyWatcher("nick",{"propertyChange":true},[param4[3]],param2);
         param5[4] = new PropertyWatcher("text",{"textChanged":true},[param4[3]],null);
         param5[5] = new PropertyWatcher("length",null,[param4[3]],null);
         param5[3].updateParent(param1);
         param5[3].addChild(param5[4]);
         param5[4].addChild(param5[5]);
      }
   }
}

