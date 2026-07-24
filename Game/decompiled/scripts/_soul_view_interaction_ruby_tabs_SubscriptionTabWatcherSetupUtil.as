package
{
   import mx.binding.ArrayElementWatcher;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.model.character.CharPropertyType;
   import soul.view.interaction.ruby.tabs.SubscriptionTab;
   
   [ExcludeClass]
   public class _soul_view_interaction_ruby_tabs_SubscriptionTabWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_ruby_tabs_SubscriptionTabWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SubscriptionTab.watcherSetupUtil = new _soul_view_interaction_ruby_tabs_SubscriptionTabWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var staticPropertyGetter:Function = param3;
         var bindings:Array = param4;
         var watchers:Array = param5;
         watchers[2] = new PropertyWatcher("model",{"propertyChange":true},[bindings[0],bindings[3],bindings[16],bindings[18]],propertyGetter);
         watchers[3] = new PropertyWatcher("currencies",{"propertyChange":true},[bindings[0]],null);
         watchers[4] = new PropertyWatcher("RUBIES",null,[bindings[0]],null);
         watchers[23] = new PropertyWatcher("subscriptionHidden",{"propertyChange":true},[bindings[16]],null);
         watchers[9] = new PropertyWatcher("properties",{"propertyChange":true},[bindings[3]],null);
         watchers[10] = new ArrayElementWatcher(target,function():*
         {
            return CharPropertyType.LEVEL;
         },[bindings[3]]);
         watchers[0] = new PropertyWatcher("terms",{"propertyChange":true},[bindings[0],bindings[4],bindings[10]],propertyGetter);
         watchers[1] = new PropertyWatcher("selectedIndex",{"propertyChange":true},[bindings[0],bindings[4]],null);
         watchers[5] = new PropertyWatcher("selectedValue",{"propertyChange":true},[bindings[0],bindings[10]],null);
         watchers[18] = new PropertyWatcher("enoughRubies",{"propertyChange":true},[bindings[8],bindings[11],bindings[13]],propertyGetter);
         watchers[15] = new PropertyWatcher("group",{"propertyChange":true},[bindings[6],bindings[19]],propertyGetter);
         watchers[16] = new PropertyWatcher("selectedIndex",{"propertyChange":true},[bindings[6],bindings[19]],null);
         watchers[2].updateParent(target);
         watchers[2].addChild(watchers[3]);
         watchers[3].addChild(watchers[4]);
         watchers[2].addChild(watchers[23]);
         watchers[2].addChild(watchers[9]);
         watchers[10].arrayWatcher = watchers[9];
         watchers[9].addChild(watchers[10]);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[1]);
         watchers[0].addChild(watchers[5]);
         watchers[18].updateParent(target);
         watchers[15].updateParent(target);
         watchers[15].addChild(watchers[16]);
      }
   }
}

