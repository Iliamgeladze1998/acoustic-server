package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.mail.ComposeScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_mail_ComposeScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_mail_ComposeScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ComposeScreen.watcherSetupUtil = new _soul_view_interaction_mail_ComposeScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[11] = new PropertyWatcher("model",{"propertyChange":true},[param4[13]],param2);
         param5[12] = new PropertyWatcher("mailCost",{"propertyChange":true},[param4[13]],null);
         param5[21] = new PropertyWatcher("characterName",{"propertyChange":true},[param4[16]],param2);
         param5[18] = new PropertyWatcher("subject",{"propertyChange":true},[param4[16]],param2);
         param5[19] = new PropertyWatcher("text",{"textChanged":true},[param4[16]],null);
         param5[20] = new PropertyWatcher("length",null,[param4[16]],null);
         param5[15] = new PropertyWatcher("recipient",{"propertyChange":true},[param4[16]],param2);
         param5[16] = new PropertyWatcher("text",{"textChanged":true},[param4[16]],null);
         param5[17] = new PropertyWatcher("length",null,[param4[16]],null);
         param5[11].updateParent(param1);
         param5[11].addChild(param5[12]);
         param5[21].updateParent(param1);
         param5[18].updateParent(param1);
         param5[18].addChild(param5[19]);
         param5[19].addChild(param5[20]);
         param5[15].updateParent(param1);
         param5[15].addChild(param5[16]);
         param5[16].addChild(param5[17]);
      }
   }
}

