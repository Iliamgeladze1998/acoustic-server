package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.bank.BankScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_bank_BankScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_bank_BankScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         BankScreen.watcherSetupUtil = new _soul_view_interaction_bank_BankScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[12] = new PropertyWatcher("slider",{"propertyChange":true},[param4[17]],param2);
         param5[13] = new PropertyWatcher("value",{"valueChanged":true},[param4[17]],null);
         param5[17] = new PropertyWatcher("count",{"propertyChange":true},[param4[21]],param2);
         param5[18] = new PropertyWatcher("text",{"textChanged":true},[param4[21]],null);
         param5[1] = new PropertyWatcher("toBank",{"propertyChange":true},[param4[1],param4[4],param4[6],param4[8],param4[22]],param2);
         param5[8] = new PropertyWatcher("characterCoppers",{"propertyChange":true},[param4[11],param4[22]],param2);
         param5[10] = new PropertyWatcher("bankCoppers",{"propertyChange":true},[param4[14],param4[22]],param2);
         param5[12].updateParent(param1);
         param5[12].addChild(param5[13]);
         param5[17].updateParent(param1);
         param5[17].addChild(param5[18]);
         param5[1].updateParent(param1);
         param5[8].updateParent(param1);
         param5[10].updateParent(param1);
      }
   }
}

