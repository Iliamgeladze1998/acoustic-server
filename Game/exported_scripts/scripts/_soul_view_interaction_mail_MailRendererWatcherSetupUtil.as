package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.mail.MailRenderer;
   
   [ExcludeClass]
   public class _soul_view_interaction_mail_MailRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_mail_MailRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         MailRenderer.watcherSetupUtil = new _soul_view_interaction_mail_MailRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("mail",{"propertyChange":true},[param4[0],param4[2],param4[4],param4[6]],param2);
         param5[8] = new PropertyWatcher("expires",{"propertyChange":true},[param4[4]],null);
         param5[1] = new PropertyWatcher("read",{"propertyChange":true},[param4[0]],null);
         param5[10] = new PropertyWatcher("localizedSubject",null,[param4[6]],null);
         param5[5] = new PropertyWatcher("localizedFrom",null,[param4[2]],null);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[8]);
         param5[0].addChild(param5[1]);
         param5[0].addChild(param5[10]);
         param5[0].addChild(param5[5]);
      }
   }
}

