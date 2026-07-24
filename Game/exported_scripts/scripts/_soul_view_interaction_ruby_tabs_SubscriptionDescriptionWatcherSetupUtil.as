package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.ruby.tabs.SubscriptionDescription;
   
   [ExcludeClass]
   public class _soul_view_interaction_ruby_tabs_SubscriptionDescriptionWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_ruby_tabs_SubscriptionDescriptionWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SubscriptionDescription.watcherSetupUtil = new _soul_view_interaction_ruby_tabs_SubscriptionDescriptionWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[2] = new PropertyWatcher("model",{"propertyChange":true},[param4[1],param4[3]],param2);
         param5[6] = new PropertyWatcher("subscriptionExpire",{"propertyChange":true},[param4[3]],null);
         param5[3] = new PropertyWatcher("subscriptionType",{"propertyChange":true},[param4[1],param4[3]],null);
         param5[7] = new PropertyWatcher("subscriptionRenew",{"propertyChange":true},[param4[3]],null);
         param5[2].updateParent(param1);
         param5[2].addChild(param5[6]);
         param5[2].addChild(param5[3]);
         param5[2].addChild(param5[7]);
      }
   }
}

