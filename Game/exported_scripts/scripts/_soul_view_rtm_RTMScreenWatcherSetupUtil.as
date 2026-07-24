package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.rtm.RTMScreen;
   
   [ExcludeClass]
   public class _soul_view_rtm_RTMScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_rtm_RTMScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         RTMScreen.watcherSetupUtil = new _soul_view_rtm_RTMScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("model",{"propertyChange":true},[param4[0],param4[1],param4[2],param4[3],param4[4],param4[6],param4[10],param4[11],param4[16],param4[20],param4[22],param4[23],param4[24],param4[25],param4[26],param4[27],param4[28],param4[29],param4[30],param4[31]],param2);
         param5[24] = new PropertyWatcher("achievementModel",{"propertyChange":true},[param4[27]],null);
         param5[23] = new PropertyWatcher("cooldownModel",{"propertyChange":true},[param4[25]],null);
         param5[1] = new PropertyWatcher("rtmModel",{"propertyChange":true},[param4[0],param4[1],param4[2],param4[4],param4[6],param4[10],param4[11],param4[16],param4[23],param4[28],param4[29],param4[30],param4[31]],null);
         param5[2] = new PropertyWatcher("targetUnit",{"propertyChange":true},[param4[0]],null);
         param5[9] = new PropertyWatcher("mapEdge",{"propertyChange":true},[param4[10],param4[11]],null);
         param5[25] = new PropertyWatcher("nearestObjects",{"propertyChange":true},[param4[28]],null);
         param5[26] = new PropertyWatcher("myUnit",{"propertyChange":true},[param4[30]],null);
         param5[27] = new PropertyWatcher("castingTime",{"propertyChange":true},[param4[30]],null);
         param5[3] = new PropertyWatcher("pvpState",{"propertyChange":true},[param4[2]],null);
         param5[28] = new PropertyWatcher("timeout",{"propertyChange":true},[param4[31]],null);
         param5[6] = new PropertyWatcher("mapName",{"propertyChange":true},[param4[6]],null);
         param5[20] = new PropertyWatcher("lfgModel",{"propertyChange":true},[param4[22]],null);
         param5[21] = new PropertyWatcher("currentApplication",{"propertyChange":true},[param4[22]],null);
         param5[4] = new PropertyWatcher("characterModel",{"propertyChange":true},[param4[3],param4[20],param4[26]],null);
         param5[18] = new PropertyWatcher("runMode",{"propertyChange":true},[param4[20]],null);
         param5[22] = new PropertyWatcher("inventoryModel",{"propertyChange":true},[param4[24]],null);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[24]);
         param5[0].addChild(param5[23]);
         param5[0].addChild(param5[1]);
         param5[1].addChild(param5[2]);
         param5[1].addChild(param5[9]);
         param5[1].addChild(param5[25]);
         param5[1].addChild(param5[26]);
         param5[26].addChild(param5[27]);
         param5[1].addChild(param5[3]);
         param5[1].addChild(param5[28]);
         param5[1].addChild(param5[6]);
         param5[0].addChild(param5[20]);
         param5[20].addChild(param5[21]);
         param5[0].addChild(param5[4]);
         param5[4].addChild(param5[18]);
         param5[0].addChild(param5[22]);
      }
   }
}

