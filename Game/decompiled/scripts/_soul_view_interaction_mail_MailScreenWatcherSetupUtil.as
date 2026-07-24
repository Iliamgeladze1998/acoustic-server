package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.mail.MailScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_mail_MailScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_mail_MailScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         MailScreen.watcherSetupUtil = new _soul_view_interaction_mail_MailScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[3] = new PropertyWatcher("model",{"propertyChange":true},[param4[2],param4[3]],param2);
         param5[4] = new PropertyWatcher("characterModel",{"propertyChange":true},[param4[4]],param2);
         param5[5] = new PropertyWatcher("name",{"propertyChange":true},[param4[4]],null);
         param5[1] = new PropertyWatcher("bar",{"propertyChange":true},[param4[1]],param2);
         param5[2] = new PropertyWatcher("selectedIndex",{"selectedIndexChanged":true},[param4[1]],null);
         param5[3].updateParent(param1);
         param5[4].updateParent(param1);
         param5[4].addChild(param5[5]);
         param5[1].updateParent(param1);
         param5[1].addChild(param5[2]);
      }
   }
}

