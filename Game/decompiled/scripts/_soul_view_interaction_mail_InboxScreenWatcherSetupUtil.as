package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.mail.InboxScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_mail_InboxScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_mail_InboxScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         InboxScreen.watcherSetupUtil = new _soul_view_interaction_mail_InboxScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[3] = new PropertyWatcher("mailList",{"propertyChange":true},[param4[3],param4[6]],param2);
         param5[4] = new PropertyWatcher("selectedMail",{"mailSelected":true},[param4[3],param4[6]],null);
         param5[5] = new PropertyWatcher("plainText",{"propertyChange":true},[param4[3]],null);
         param5[10] = new PropertyWatcher("model",{"propertyChange":true},[param4[9]],param2);
         param5[11] = new PropertyWatcher("inbox",{"propertyChange":true},[param4[9]],null);
         param5[3].updateParent(param1);
         param5[3].addChild(param5[4]);
         param5[4].addChild(param5[5]);
         param5[10].updateParent(param1);
         param5[10].addChild(param5[11]);
      }
   }
}

