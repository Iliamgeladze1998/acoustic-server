package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.character.InternalInfo;
   
   [ExcludeClass]
   public class _soul_view_interaction_character_InternalInfoWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_character_InternalInfoWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         InternalInfo.watcherSetupUtil = new _soul_view_interaction_character_InternalInfoWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[4] = new PropertyWatcher("model",{"propertyChange":true},[param4[1],param4[11]],param2);
         param5[5] = new PropertyWatcher("body",{"propertyChange":true},[param4[1],param4[11]],null);
         param5[6] = new PropertyWatcher("awards",{"propertyChange":true},[param4[1]],null);
         param5[7] = new PropertyWatcher("gifts",{"propertyChange":true},[param4[1]],null);
         param5[8] = new PropertyWatcher("trophies",{"propertyChange":true},[param4[1]],null);
         param5[17] = new PropertyWatcher("rtmModel",{"propertyChange":true},[param4[8]],param2);
         param5[18] = new PropertyWatcher("mapName",{"propertyChange":true},[param4[8]],null);
         param5[0] = new PropertyWatcher("characterModel",{"propertyChange":true},[param4[0],param4[3],param4[4],param4[9],param4[12],param4[14],param4[15],param4[16],param4[26],param4[31],param4[34],param4[37],param4[40],param4[43],param4[46],param4[49],param4[51],param4[52]],param2);
         param5[22] = new PropertyWatcher("autoSlots",{"propertyChange":true},[param4[12]],null);
         param5[13] = new PropertyWatcher("side",{"propertyChange":true},[param4[4]],null);
         param5[24] = new PropertyWatcher("alternativeIndex",{"propertyChange":true},[param4[14]],null);
         param5[20] = new PropertyWatcher("avatarImagePath",{"propertyChange":true},[param4[9]],null);
         param5[26] = new PropertyWatcher("subscriptionType",{"propertyChange":true},[param4[15],param4[16]],null);
         param5[43] = new PropertyWatcher("params",{"propertyChange":true},[param4[31],param4[34],param4[37],param4[40],param4[43],param4[46],param4[49]],null);
         param5[44] = new PropertyWatcher("AC",null,[param4[31]],null);
         param5[60] = new PropertyWatcher("RESISTANCE_FIRE",null,[param4[43]],null);
         param5[48] = new PropertyWatcher("RESISTANCE_NATURE",null,[param4[34]],null);
         param5[52] = new PropertyWatcher("RESISTANCE_HOLY",null,[param4[37]],null);
         param5[68] = new PropertyWatcher("RESISTANCE_ARCANE",null,[param4[49]],null);
         param5[64] = new PropertyWatcher("RESISTANCE_FROST",null,[param4[46]],null);
         param5[56] = new PropertyWatcher("RESISTANCE_DARK",null,[param4[40]],null);
         param5[1] = new PropertyWatcher("properties",{"propertyChange":true},[param4[0]],null);
         param5[2] = new PropertyWatcher("LEVEL",null,[param4[0]],null);
         param5[38] = new PropertyWatcher("reputations",{"propertyChange":true},[param4[26]],null);
         param5[70] = new PropertyWatcher("additionalPoints",{"propertyChange":true},[param4[52]],null);
         param5[71] = new PropertyWatcher("STATS",null,[param4[52]],null);
         param5[11] = new PropertyWatcher("disposition",{"propertyChange":true},[param4[3]],null);
         param5[28] = new PropertyWatcher("achievementModel",{"propertyChange":true},[param4[17]],param2);
         param5[29] = new PropertyWatcher("pointsCollected",{"propertyChange":true},[param4[17]],null);
         param5[23] = new PropertyWatcher("showGifts",{"propertyChange":true},[param4[13]],param2);
         param5[14] = new PropertyWatcher("clanModel",{"propertyChange":true},[param4[5],param4[6],param4[7]],param2);
         param5[15] = new PropertyWatcher("id",{"propertyChange":true},[param4[5],param4[6]],null);
         param5[16] = new PropertyWatcher("name",{"propertyChange":true},[param4[7]],null);
         param5[4].updateParent(param1);
         param5[4].addChild(param5[5]);
         param5[5].addChild(param5[6]);
         param5[5].addChild(param5[7]);
         param5[5].addChild(param5[8]);
         param5[17].updateParent(param1);
         param5[17].addChild(param5[18]);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[22]);
         param5[0].addChild(param5[13]);
         param5[0].addChild(param5[24]);
         param5[0].addChild(param5[20]);
         param5[0].addChild(param5[26]);
         param5[0].addChild(param5[43]);
         param5[43].addChild(param5[44]);
         param5[43].addChild(param5[60]);
         param5[43].addChild(param5[48]);
         param5[43].addChild(param5[52]);
         param5[43].addChild(param5[68]);
         param5[43].addChild(param5[64]);
         param5[43].addChild(param5[56]);
         param5[0].addChild(param5[1]);
         param5[1].addChild(param5[2]);
         param5[0].addChild(param5[38]);
         param5[0].addChild(param5[70]);
         param5[70].addChild(param5[71]);
         param5[0].addChild(param5[11]);
         param5[28].updateParent(param1);
         param5[28].addChild(param5[29]);
         param5[23].updateParent(param1);
         param5[14].updateParent(param1);
         param5[14].addChild(param5[15]);
         param5[14].addChild(param5[16]);
      }
   }
}

