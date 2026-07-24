package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.auction.tabs.BrowseTab;
   
   [ExcludeClass]
   public class _soul_view_interaction_auction_tabs_BrowseTabWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_auction_tabs_BrowseTabWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         BrowseTab.watcherSetupUtil = new _soul_view_interaction_auction_tabs_BrowseTabWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[12] = new PropertyWatcher("browseData",{"propertyChange":true},[param4[15],param4[16],param4[17]],param2);
         param5[15] = new PropertyWatcher("total",{"propertyChange":true},[param4[16]],null);
         param5[13] = new PropertyWatcher("lots",{"propertyChange":true},[param4[15]],null);
         param5[17] = new PropertyWatcher("indexFrom",{"propertyChange":true},[param4[17]],null);
         param5[19] = new PropertyWatcher("lotList",{"propertyChange":true},[param4[19],param4[20],param4[21],param4[24],param4[27]],param2);
         param5[20] = new PropertyWatcher("selectedLot",{"lotSelected":true},[param4[19],param4[20],param4[21],param4[24],param4[27]],null);
         param5[28] = new PropertyWatcher("myLot",{"propertyChange":true},[param4[24],param4[27]],null);
         param5[23] = new PropertyWatcher("newBid",{"propertyChange":true},[param4[20],param4[24]],null);
         param5[30] = new PropertyWatcher("buyNow",{"propertyChange":true},[param4[27]],null);
         param5[21] = new PropertyWatcher("currency",{"propertyChange":true},[param4[19]],null);
         param5[26] = new PropertyWatcher("money",{"propertyChange":true},[param4[24]],param2);
         param5[27] = new PropertyWatcher("value",{"valueChanged":true},[param4[24]],null);
         param5[12].updateParent(param1);
         param5[12].addChild(param5[15]);
         param5[12].addChild(param5[13]);
         param5[12].addChild(param5[17]);
         param5[19].updateParent(param1);
         param5[19].addChild(param5[20]);
         param5[20].addChild(param5[28]);
         param5[20].addChild(param5[23]);
         param5[20].addChild(param5[30]);
         param5[20].addChild(param5[21]);
         param5[26].updateParent(param1);
         param5[26].addChild(param5[27]);
      }
   }
}

