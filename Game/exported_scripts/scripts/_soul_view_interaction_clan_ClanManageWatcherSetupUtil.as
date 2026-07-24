package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.clan.ClanManage;
   
   [ExcludeClass]
   public class _soul_view_interaction_clan_ClanManageWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_clan_ClanManageWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ClanManage.watcherSetupUtil = new _soul_view_interaction_clan_ClanManageWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[4] = new PropertyWatcher("model",{"propertyChange":true},[param4[3],param4[7],param4[13],param4[15],param4[18],param4[20],param4[23],param4[24]],param2);
         param5[5] = new PropertyWatcher("id",{"propertyChange":true},[param4[3],param4[13],param4[15],param4[18],param4[20],param4[23]],null);
         param5[17] = new PropertyWatcher("changeCost",{"propertyChange":true},[param4[18],param4[24]],null);
         param5[16] = new PropertyWatcher("creationCost",{"propertyChange":true},[param4[18]],null);
         param5[9] = new PropertyWatcher("name",{"propertyChange":true},[param4[7],param4[24]],null);
         param5[23] = new PropertyWatcher("rubies",{"propertyChange":true},[param4[24]],null);
         param5[19] = new PropertyWatcher("imageFits",{"propertyChange":true},[param4[21],param4[24]],param2);
         param5[20] = new PropertyWatcher("clanName",{"propertyChange":true},[param4[21],param4[24]],param2);
         param5[21] = new PropertyWatcher("text",{"textChanged":true},[param4[21],param4[24]],null);
         param5[22] = new PropertyWatcher("length",null,[param4[21]],null);
         param5[4].updateParent(param1);
         param5[4].addChild(param5[5]);
         param5[4].addChild(param5[17]);
         param5[4].addChild(param5[16]);
         param5[4].addChild(param5[9]);
         param5[4].addChild(param5[23]);
         param5[19].updateParent(param1);
         param5[20].updateParent(param1);
         param5[20].addChild(param5[21]);
         param5[21].addChild(param5[22]);
      }
   }
}

