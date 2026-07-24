package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.chat.ChatTabs;
   
   [ExcludeClass]
   public class _soul_view_chat_ChatTabsWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_chat_ChatTabsWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChatTabs.watcherSetupUtil = new _soul_view_chat_ChatTabsWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("model",{"propertyChange":true},[param4[0],param4[1]],param2);
         param5[2] = new PropertyWatcher("currentTab",{"propertyChange":true},[param4[1]],null);
         param5[1] = new PropertyWatcher("tabs",{"propertyChange":true},[param4[0]],null);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[2]);
         param5[0].addChild(param5[1]);
      }
   }
}

