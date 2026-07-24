package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.ruby.RubyScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_ruby_RubyScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_ruby_RubyScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         RubyScreen.watcherSetupUtil = new _soul_view_interaction_ruby_RubyScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[10] = new PropertyWatcher("model",{"propertyChange":true},[param4[7],param4[8],param4[10]],param2);
         param5[0] = new PropertyWatcher("selectedTab",{"propertyChange":true},[param4[0]],param2);
         param5[8] = new PropertyWatcher("bar",{"propertyChange":true},[param4[6]],param2);
         param5[9] = new PropertyWatcher("selectedIndex",{"selectedIndexChanged":true},[param4[6]],null);
         param5[11] = new PropertyWatcher("abilityModel",{"propertyChange":true},[param4[9]],param2);
         param5[10].updateParent(param1);
         param5[0].updateParent(param1);
         param5[8].updateParent(param1);
         param5[8].addChild(param5[9]);
         param5[11].updateParent(param1);
      }
   }
}

