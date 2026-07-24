package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.chat.ChatTab;
   
   [ExcludeClass]
   public class _soul_view_chat_ChatTabWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_chat_ChatTabWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChatTab.watcherSetupUtil = new _soul_view_chat_ChatTabWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[2] = new PropertyWatcher("selected",{"propertyChange":true},[param4[1],param4[4]],param2);
         param5[0] = new PropertyWatcher("model",{"propertyChange":true},[param4[0],param4[2],param4[3],param4[4]],param2);
         param5[6] = new PropertyWatcher("newMessages",{"propertyChange":true},[param4[3],param4[4]],null);
         param5[8] = new PropertyWatcher("transparent",{"propertyChange":true},[param4[4]],param2);
         param5[2].updateParent(param1);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[6]);
         param5[8].updateParent(param1);
      }
   }
}

