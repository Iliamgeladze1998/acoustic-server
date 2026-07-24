package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.character.ExternalInfo;
   
   [ExcludeClass]
   public class _soul_view_interaction_character_ExternalInfoWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_character_ExternalInfoWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ExternalInfo.watcherSetupUtil = new _soul_view_interaction_character_ExternalInfoWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[1] = new PropertyWatcher("charInfo",{"propertyChange":true},[param4[0],param4[2],param4[3],param4[4],param4[5],param4[6],param4[7],param4[8],param4[10],param4[11],param4[13],param4[14],param4[15],param4[16],param4[25],param4[30],param4[33],param4[36],param4[39],param4[42],param4[45],param4[48],param4[50]],param2);
         param5[16] = new PropertyWatcher("mapId",{"propertyChange":true},[param4[7]],null);
         param5[2] = new PropertyWatcher("body",{"propertyChange":true},[param4[0],param4[10]],null);
         param5[3] = new PropertyWatcher("awards",{"propertyChange":true},[param4[0]],null);
         param5[4] = new PropertyWatcher("gifts",{"propertyChange":true},[param4[0]],null);
         param5[5] = new PropertyWatcher("trophies",{"propertyChange":true},[param4[0]],null);
         param5[25] = new PropertyWatcher("achievementPoints",{"propertyChange":true},[param4[15]],null);
         param5[15] = new PropertyWatcher("sectorId",{"propertyChange":true},[param4[7]],null);
         param5[13] = new PropertyWatcher("clanName",{"propertyChange":true},[param4[6]],null);
         param5[12] = new PropertyWatcher("clanId",{"propertyChange":true},[param4[4],param4[5]],null);
         param5[8] = new PropertyWatcher("character",{"propertyChange":true},[param4[2],param4[3],param4[8],param4[11],param4[13],param4[14],param4[25],param4[30],param4[33],param4[36],param4[39],param4[42],param4[45],param4[48],param4[50]],null);
         param5[39] = new PropertyWatcher("params",null,[param4[30],param4[33],param4[36],param4[39],param4[42],param4[45],param4[48]],null);
         param5[40] = new PropertyWatcher("AC",null,[param4[30]],null);
         param5[56] = new PropertyWatcher("RESISTANCE_FIRE",null,[param4[42]],null);
         param5[44] = new PropertyWatcher("RESISTANCE_NATURE",null,[param4[33]],null);
         param5[48] = new PropertyWatcher("RESISTANCE_HOLY",null,[param4[36]],null);
         param5[64] = new PropertyWatcher("RESISTANCE_ARCANE",null,[param4[48]],null);
         param5[60] = new PropertyWatcher("RESISTANCE_FROST",null,[param4[45]],null);
         param5[52] = new PropertyWatcher("RESISTANCE_DARK",null,[param4[39]],null);
         param5[21] = new PropertyWatcher("showGifts",{"propertyChange":true},[param4[12]],param2);
         param5[1].updateParent(param1);
         param5[1].addChild(param5[16]);
         param5[1].addChild(param5[2]);
         param5[2].addChild(param5[3]);
         param5[2].addChild(param5[4]);
         param5[2].addChild(param5[5]);
         param5[1].addChild(param5[25]);
         param5[1].addChild(param5[15]);
         param5[1].addChild(param5[13]);
         param5[1].addChild(param5[12]);
         param5[1].addChild(param5[8]);
         param5[8].addChild(param5[39]);
         param5[39].addChild(param5[40]);
         param5[39].addChild(param5[56]);
         param5[39].addChild(param5[44]);
         param5[39].addChild(param5[48]);
         param5[39].addChild(param5[64]);
         param5[39].addChild(param5[60]);
         param5[39].addChild(param5[52]);
         param5[21].updateParent(param1);
      }
   }
}

