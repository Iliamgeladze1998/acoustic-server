package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.lfg.LFGScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_lfg_LFGScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_lfg_LFGScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         LFGScreen.watcherSetupUtil = new _soul_view_interaction_lfg_LFGScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[11] = new PropertyWatcher("model",{"propertyChange":true},[param4[9],param4[10],param4[13],param4[14],param4[17],param4[18],param4[27],param4[29],param4[31],param4[32],param4[33],param4[37],param4[40]],param2);
         param5[19] = new PropertyWatcher("locations",{"propertyChange":true},[param4[17]],null);
         param5[13] = new PropertyWatcher("currentApplication",{"propertyChange":true},[param4[10],param4[14],param4[18],param4[32],param4[33],param4[37],param4[40]],null);
         param5[12] = new PropertyWatcher("quests",{"propertyChange":true},[param4[9]],null);
         param5[26] = new PropertyWatcher("applications",{"propertyChange":true},[param4[27],param4[29],param4[31]],null);
         param5[16] = new PropertyWatcher("instances",{"propertyChange":true},[param4[13]],null);
         param5[21] = new PropertyWatcher("categorySelector",{"propertyChange":true},[param4[23]],param2);
         param5[22] = new PropertyWatcher("selectedType",{"selectedTypeChanged":true},[param4[23]],null);
         param5[35] = new PropertyWatcher("instances",{"propertyChange":true},[param4[37]],param2);
         param5[36] = new PropertyWatcher("total",{"totalChanged":true},[param4[37]],null);
         param5[37] = new PropertyWatcher("locations",{"propertyChange":true},[param4[37]],param2);
         param5[38] = new PropertyWatcher("total",{"totalChanged":true},[param4[37]],null);
         param5[33] = new PropertyWatcher("quests",{"propertyChange":true},[param4[37]],param2);
         param5[34] = new PropertyWatcher("total",{"totalChanged":true},[param4[37]],null);
         param5[39] = new PropertyWatcher("applications",{"propertyChange":true},[param4[37]],param2);
         param5[40] = new PropertyWatcher("selectedItem",{"selectedItemChanged":true},[param4[37]],null);
         param5[24] = new PropertyWatcher("subcategory",{"propertyChange":true},[param4[25]],param2);
         param5[25] = new PropertyWatcher("selectedIndex",{"selectedIndexChanged":true},[param4[25]],null);
         param5[3] = new PropertyWatcher("bar",{"propertyChange":true},[param4[2],param4[36],param4[37]],param2);
         param5[4] = new PropertyWatcher("selectedIndex",{"selectedIndexChanged":true},[param4[2],param4[36],param4[37]],null);
         param5[11].updateParent(param1);
         param5[11].addChild(param5[19]);
         param5[11].addChild(param5[13]);
         param5[11].addChild(param5[12]);
         param5[11].addChild(param5[26]);
         param5[11].addChild(param5[16]);
         param5[21].updateParent(param1);
         param5[21].addChild(param5[22]);
         param5[35].updateParent(param1);
         param5[35].addChild(param5[36]);
         param5[37].updateParent(param1);
         param5[37].addChild(param5[38]);
         param5[33].updateParent(param1);
         param5[33].addChild(param5[34]);
         param5[39].updateParent(param1);
         param5[39].addChild(param5[40]);
         param5[24].updateParent(param1);
         param5[24].addChild(param5[25]);
         param5[3].updateParent(param1);
         param5[3].addChild(param5[4]);
      }
   }
}

