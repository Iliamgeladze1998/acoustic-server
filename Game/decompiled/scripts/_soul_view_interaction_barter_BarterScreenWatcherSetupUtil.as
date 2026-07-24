package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.barter.BarterScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_barter_BarterScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_barter_BarterScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         BarterScreen.watcherSetupUtil = new _soul_view_interaction_barter_BarterScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[44] = new PropertyWatcher("readyButton",{"propertyChange":true},[param4[38]],param2);
         param5[5] = new PropertyWatcher("model",{"propertyChange":true},[param4[4],param4[5],param4[6],param4[7],param4[8],param4[10],param4[12],param4[14],param4[17],param4[18],param4[19],param4[20],param4[21],param4[23],param4[26],param4[31],param4[35]],param2);
         param5[24] = new PropertyWatcher("opponentRubies",{"propertyChange":true},[param4[26]],null);
         param5[22] = new PropertyWatcher("opponentCopper",{"propertyChange":true},[param4[23]],null);
         param5[14] = new PropertyWatcher("myRubies",{"propertyChange":true},[param4[12]],null);
         param5[28] = new PropertyWatcher("waiting",{"propertyChange":true},[param4[31]],null);
         param5[17] = new PropertyWatcher("opponentReady",{"propertyChange":true},[param4[17]],null);
         param5[12] = new PropertyWatcher("myCopper",{"propertyChange":true},[param4[10]],null);
         param5[34] = new PropertyWatcher("opponentImage",{"propertyChange":true},[param4[35]],null);
         param5[6] = new PropertyWatcher("iAmReady",{"propertyChange":true},[param4[4]],null);
         param5[9] = new PropertyWatcher("myItem2",{"propertyChange":true},[param4[7]],null);
         param5[8] = new PropertyWatcher("myItem1",{"propertyChange":true},[param4[6]],null);
         param5[7] = new PropertyWatcher("myItem0",{"propertyChange":true},[param4[5]],null);
         param5[10] = new PropertyWatcher("myItem3",{"propertyChange":true},[param4[8]],null);
         param5[18] = new PropertyWatcher("opponentItem0",{"propertyChange":true},[param4[18]],null);
         param5[19] = new PropertyWatcher("opponentItem1",{"propertyChange":true},[param4[19]],null);
         param5[20] = new PropertyWatcher("opponentItem2",{"propertyChange":true},[param4[20]],null);
         param5[21] = new PropertyWatcher("opponentItem3",{"propertyChange":true},[param4[21]],null);
         param5[15] = new PropertyWatcher("opponentName",{"propertyChange":true},[param4[14]],null);
         param5[1] = new PropertyWatcher("characterModel",{"propertyChange":true},[param4[1],param4[33]],param2);
         param5[31] = new PropertyWatcher("avatarImagePath",{"propertyChange":true},[param4[33]],null);
         param5[2] = new PropertyWatcher("name",{"propertyChange":true},[param4[1]],null);
         param5[40] = new PropertyWatcher("myItem2",{"propertyChange":true},[param4[38]],param2);
         param5[41] = new PropertyWatcher("item",{"itemChanged":true},[param4[38]],null);
         param5[38] = new PropertyWatcher("myItem1",{"propertyChange":true},[param4[38]],param2);
         param5[39] = new PropertyWatcher("item",{"itemChanged":true},[param4[38]],null);
         param5[36] = new PropertyWatcher("myItem0",{"propertyChange":true},[param4[38]],param2);
         param5[37] = new PropertyWatcher("item",{"itemChanged":true},[param4[38]],null);
         param5[42] = new PropertyWatcher("myItem3",{"propertyChange":true},[param4[38]],param2);
         param5[43] = new PropertyWatcher("item",{"itemChanged":true},[param4[38]],null);
         param5[44].updateParent(param1);
         param5[5].updateParent(param1);
         param5[5].addChild(param5[24]);
         param5[5].addChild(param5[22]);
         param5[5].addChild(param5[14]);
         param5[5].addChild(param5[28]);
         param5[5].addChild(param5[17]);
         param5[5].addChild(param5[12]);
         param5[5].addChild(param5[34]);
         param5[5].addChild(param5[6]);
         param5[5].addChild(param5[9]);
         param5[5].addChild(param5[8]);
         param5[5].addChild(param5[7]);
         param5[5].addChild(param5[10]);
         param5[5].addChild(param5[18]);
         param5[5].addChild(param5[19]);
         param5[5].addChild(param5[20]);
         param5[5].addChild(param5[21]);
         param5[5].addChild(param5[15]);
         param5[1].updateParent(param1);
         param5[1].addChild(param5[31]);
         param5[1].addChild(param5[2]);
         param5[40].updateParent(param1);
         param5[40].addChild(param5[41]);
         param5[38].updateParent(param1);
         param5[38].addChild(param5[39]);
         param5[36].updateParent(param1);
         param5[36].addChild(param5[37]);
         param5[42].updateParent(param1);
         param5[42].addChild(param5[43]);
      }
   }
}

