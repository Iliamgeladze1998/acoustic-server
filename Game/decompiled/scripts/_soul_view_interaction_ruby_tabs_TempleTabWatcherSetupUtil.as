package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.ruby.tabs.TempleTab;
   
   [ExcludeClass]
   public class _soul_view_interaction_ruby_tabs_TempleTabWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_ruby_tabs_TempleTabWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         TempleTab.watcherSetupUtil = new _soul_view_interaction_ruby_tabs_TempleTabWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[3] = new PropertyWatcher("availBlessings",{"propertyChange":true},[param4[3]],param2);
         param5[11] = new PropertyWatcher("model",{"propertyChange":true},[param4[10]],param2);
         param5[12] = new PropertyWatcher("currencies",{"propertyChange":true},[param4[10]],null);
         param5[13] = new PropertyWatcher("RUBIES",null,[param4[10]],null);
         param5[2] = new PropertyWatcher("abilityModel",{"propertyChange":true},[param4[2],param4[12]],param2);
         param5[6] = new PropertyWatcher("blessings",{"propertyChange":true},[param4[7],param4[10],param4[13],param4[14],param4[16]],param2);
         param5[7] = new PropertyWatcher("selectedBlessing",{"propertyChange":true},[param4[7],param4[10],param4[13],param4[14],param4[16]],null);
         param5[3].updateParent(param1);
         param5[11].updateParent(param1);
         param5[11].addChild(param5[12]);
         param5[12].addChild(param5[13]);
         param5[2].updateParent(param1);
         param5[6].updateParent(param1);
         param5[6].addChild(param5[7]);
      }
   }
}

