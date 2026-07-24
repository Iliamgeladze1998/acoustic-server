package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.ruby.tabs.RubyTab;
   
   [ExcludeClass]
   public class _soul_view_interaction_ruby_tabs_RubyTabWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_ruby_tabs_RubyTabWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         RubyTab.watcherSetupUtil = new _soul_view_interaction_ruby_tabs_RubyTabWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[10] = new PropertyWatcher("slider",{"propertyChange":true},[param4[14],param4[20],param4[23],param4[30]],param2);
         param5[11] = new PropertyWatcher("value",{"valueChanged":true},[param4[14],param4[20],param4[23],param4[30]],null);
         param5[12] = new PropertyWatcher("model",{"propertyChange":true},[param4[15],param4[27]],param2);
         param5[13] = new PropertyWatcher("currencies",{"propertyChange":true},[param4[15],param4[27]],null);
         param5[14] = new PropertyWatcher("RUBIES",null,[param4[15],param4[27]],null);
         param5[8] = new PropertyWatcher("rubyItem",null,[param4[12]],param2);
         param5[23] = new PropertyWatcher("moneyItem",null,[param4[25]],param2);
         param5[15] = new PropertyWatcher("input",{"propertyChange":true},[param4[16]],param2);
         param5[16] = new PropertyWatcher("text",{"textChanged":true},[param4[16]],null);
         param5[10].updateParent(param1);
         param5[10].addChild(param5[11]);
         param5[12].updateParent(param1);
         param5[12].addChild(param5[13]);
         param5[13].addChild(param5[14]);
         param5[8].updateParent(param1);
         param5[23].updateParent(param1);
         param5[15].updateParent(param1);
         param5[15].addChild(param5[16]);
      }
   }
}

