package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.GameScreen;
   
   [ExcludeClass]
   public class _soul_view_GameScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_GameScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         GameScreen.watcherSetupUtil = new _soul_view_GameScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("model",{"propertyChange":true},[param4[0],param4[1],param4[2],param4[3],param4[4],param4[5],param4[6],param4[7],param4[8],param4[9],param4[10],param4[11],param4[12],param4[13],param4[14],param4[15],param4[16]],param2);
         param5[5] = new PropertyWatcher("rtmModel",{"propertyChange":true},[param4[4],param4[15]],null);
         param5[10] = new PropertyWatcher("chatModel",{"propertyChange":true},[param4[11]],null);
         param5[2] = new PropertyWatcher("characterModel",{"propertyChange":true},[param4[2],param4[10],param4[14]],null);
         param5[3] = new PropertyWatcher("id",{"propertyChange":true},[param4[2]],null);
         param5[9] = new PropertyWatcher("myUnit",{"propertyChange":true},[param4[10]],null);
         param5[11] = new PropertyWatcher("socialModel",{"propertyChange":true},[param4[13]],null);
         param5[12] = new PropertyWatcher("settingsModel",{"propertyChange":true},[param4[16]],null);
         param5[8] = new PropertyWatcher("inventoryModel",{"propertyChange":true},[param4[9]],null);
         param5[4] = new PropertyWatcher("groupModel",{"propertyChange":true},[param4[3],param4[12]],null);
         param5[1] = new PropertyWatcher("astralModel",{"propertyChange":true},[param4[1]],null);
         param5[6] = new PropertyWatcher("mode",{"propertyChange":true},[param4[6],param4[8]],null);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[5]);
         param5[0].addChild(param5[10]);
         param5[0].addChild(param5[2]);
         param5[2].addChild(param5[3]);
         param5[2].addChild(param5[9]);
         param5[0].addChild(param5[11]);
         param5[0].addChild(param5[12]);
         param5[0].addChild(param5[8]);
         param5[0].addChild(param5[4]);
         param5[0].addChild(param5[1]);
         param5[0].addChild(param5[6]);
      }
   }
}

