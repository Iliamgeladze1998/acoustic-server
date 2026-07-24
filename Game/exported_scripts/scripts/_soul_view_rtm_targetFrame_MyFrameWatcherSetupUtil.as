package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.rtm.targetFrame.MyFrame;
   
   [ExcludeClass]
   public class _soul_view_rtm_targetFrame_MyFrameWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_rtm_targetFrame_MyFrameWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         MyFrame.watcherSetupUtil = new _soul_view_rtm_targetFrame_MyFrameWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("model",{"propertyChange":true},[param4[0],param4[1],param4[4],param4[5],param4[8],param4[9],param4[11],param4[12],param4[13],param4[14],param4[16],param4[17],param4[19],param4[20],param4[25],param4[26],param4[29],param4[31],param4[34],param4[36],param4[37],param4[40],param4[41],param4[42],param4[45],param4[46],param4[47]],param2);
         param5[1] = new PropertyWatcher("characterModel",{"propertyChange":true},[param4[0],param4[1],param4[4],param4[5],param4[8],param4[9],param4[11],param4[12],param4[13],param4[14],param4[16],param4[17],param4[19],param4[25],param4[26],param4[31],param4[40],param4[42],param4[45],param4[47]],null);
         param5[53] = new PropertyWatcher("abilitySlots",{"propertyChange":true},[param4[42]],null);
         param5[55] = new PropertyWatcher("belt",{"propertyChange":true},[param4[47]],null);
         param5[15] = new PropertyWatcher("properties",{"propertyChange":true},[param4[11],param4[12]],null);
         param5[16] = new PropertyWatcher("XP",null,[param4[11],param4[12]],null);
         param5[2] = new PropertyWatcher("myUnit",{"propertyChange":true},[param4[0],param4[1],param4[4],param4[5],param4[8],param4[9],param4[14],param4[16],param4[26],param4[40],param4[45]],null);
         param5[3] = new PropertyWatcher("stats",{"propertyChange":true},[param4[0],param4[1],param4[4],param4[5],param4[8],param4[9],param4[16]],null);
         param5[4] = new PropertyWatcher("STAMINA",null,[param4[0]],null);
         param5[24] = new PropertyWatcher("LEVEL",null,[param4[16]],null);
         param5[12] = new PropertyWatcher("MP",null,[param4[8]],null);
         param5[8] = new PropertyWatcher("HP",null,[param4[4]],null);
         param5[9] = new PropertyWatcher("MAX_HP",null,[param4[5]],null);
         param5[13] = new PropertyWatcher("MAX_MP",null,[param4[9]],null);
         param5[5] = new PropertyWatcher("MAX_STAMINA",null,[param4[1]],null);
         param5[22] = new PropertyWatcher("avatarImagePath",{"propertyChange":true},[param4[14]],null);
         param5[37] = new PropertyWatcher("effects",{"propertyChange":true},[param4[26]],null);
         param5[36] = new PropertyWatcher("dead",{"propertyChange":true},[param4[25]],null);
         param5[43] = new PropertyWatcher("additionalPoints",{"propertyChange":true},[param4[31]],null);
         param5[44] = new PropertyWatcher("STATS",null,[param4[31]],null);
         param5[19] = new PropertyWatcher("fightMode",{"propertyChange":true},[param4[13],param4[17],param4[19]],null);
         param5[50] = new PropertyWatcher("settingsModel",{"propertyChange":true},[param4[36]],null);
         param5[47] = new PropertyWatcher("inventoryModel",{"propertyChange":true},[param4[34]],null);
         param5[48] = new PropertyWatcher("hasBrokenItemsWorn",{"propertyChange":true},[param4[34]],null);
         param5[40] = new PropertyWatcher("mailModel",{"propertyChange":true},[param4[29]],null);
         param5[41] = new PropertyWatcher("hasNewMail",{"propertyChange":true},[param4[29]],null);
         param5[26] = new PropertyWatcher("groupModel",{"propertyChange":true},[param4[20]],null);
         param5[27] = new PropertyWatcher("leader",{"propertyChange":true},[param4[20]],null);
         param5[28] = new PropertyWatcher("members",{"propertyChange":true},[param4[20]],null);
         param5[51] = new PropertyWatcher("dashboardModel",{"propertyChange":true},[param4[37]],null);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[1]);
         param5[1].addChild(param5[53]);
         param5[1].addChild(param5[55]);
         param5[1].addChild(param5[15]);
         param5[15].addChild(param5[16]);
         param5[1].addChild(param5[2]);
         param5[2].addChild(param5[3]);
         param5[3].addChild(param5[4]);
         param5[3].addChild(param5[24]);
         param5[3].addChild(param5[12]);
         param5[3].addChild(param5[8]);
         param5[3].addChild(param5[9]);
         param5[3].addChild(param5[13]);
         param5[3].addChild(param5[5]);
         param5[2].addChild(param5[22]);
         param5[2].addChild(param5[37]);
         param5[1].addChild(param5[36]);
         param5[1].addChild(param5[43]);
         param5[43].addChild(param5[44]);
         param5[1].addChild(param5[19]);
         param5[0].addChild(param5[50]);
         param5[0].addChild(param5[47]);
         param5[47].addChild(param5[48]);
         param5[0].addChild(param5[40]);
         param5[40].addChild(param5[41]);
         param5[0].addChild(param5[26]);
         param5[26].addChild(param5[27]);
         param5[26].addChild(param5[28]);
         param5[0].addChild(param5[51]);
      }
   }
}

