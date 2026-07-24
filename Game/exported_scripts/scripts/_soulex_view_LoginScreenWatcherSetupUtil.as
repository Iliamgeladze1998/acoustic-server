package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soulex.view.LoginScreen;
   
   [ExcludeClass]
   public class _soulex_view_LoginScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soulex_view_LoginScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         LoginScreen.watcherSetupUtil = new _soulex_view_LoginScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[2] = new PropertyWatcher("setLogin",{"propertyChange":true},[param4[2]],param2);
         param5[10] = new PropertyWatcher("passwordInput",{"propertyChange":true},[param4[8]],param2);
         param5[11] = new PropertyWatcher("text",{
            "change":false,
            "textChanged":true
         },[param4[8]],null);
         param5[12] = new PropertyWatcher("length",null,[param4[8]],null);
         param5[7] = new PropertyWatcher("userInput",{"propertyChange":true},[param4[8]],param2);
         param5[8] = new PropertyWatcher("text",{
            "change":false,
            "textChanged":true
         },[param4[8]],null);
         param5[9] = new PropertyWatcher("length",null,[param4[8]],null);
         param5[4] = new PropertyWatcher("setPassword",{"propertyChange":true},[param4[4],param4[6]],param2);
         param5[2].updateParent(param1);
         param5[10].updateParent(param1);
         param5[10].addChild(param5[11]);
         param5[11].addChild(param5[12]);
         param5[7].updateParent(param1);
         param5[7].addChild(param5[8]);
         param5[8].addChild(param5[9]);
         param5[4].updateParent(param1);
      }
   }
}

