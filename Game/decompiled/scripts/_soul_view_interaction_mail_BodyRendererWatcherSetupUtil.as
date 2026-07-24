package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.mail.BodyRenderer;
   
   [ExcludeClass]
   public class _soul_view_interaction_mail_BodyRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_mail_BodyRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         BodyRenderer.watcherSetupUtil = new _soul_view_interaction_mail_BodyRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("mail",{"propertyChange":true},[param4[0],param4[2],param4[4],param4[5]],param2);
         param5[6] = new PropertyWatcher("localizedBody",null,[param4[5]],null);
         param5[1] = new PropertyWatcher("attachments",{"propertyChange":true},[param4[0]],null);
         param5[5] = new PropertyWatcher("localizedSubject",null,[param4[4]],null);
         param5[3] = new PropertyWatcher("localizedFrom",null,[param4[2]],null);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[6]);
         param5[0].addChild(param5[1]);
         param5[0].addChild(param5[5]);
         param5[0].addChild(param5[3]);
      }
   }
}

