package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.auction.tabs.BidTab;
   
   [ExcludeClass]
   public class _soul_view_interaction_auction_tabs_BidTabWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_auction_tabs_BidTabWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         BidTab.watcherSetupUtil = new _soul_view_interaction_auction_tabs_BidTabWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[6] = new PropertyWatcher("bidData",{"propertyChange":true},[param4[8]],param2);
         param5[7] = new PropertyWatcher("lots",{"propertyChange":true},[param4[8]],null);
         param5[9] = new PropertyWatcher("lotList",{"propertyChange":true},[param4[10],param4[11],param4[12],param4[15],param4[18]],param2);
         param5[10] = new PropertyWatcher("selectedLot",{"lotSelected":true},[param4[10],param4[11],param4[12],param4[15],param4[18]],null);
         param5[18] = new PropertyWatcher("myLot",{"propertyChange":true},[param4[15],param4[18]],null);
         param5[13] = new PropertyWatcher("newBid",{"propertyChange":true},[param4[11],param4[15]],null);
         param5[21] = new PropertyWatcher("buyNow",{"propertyChange":true},[param4[18]],null);
         param5[11] = new PropertyWatcher("currency",{"propertyChange":true},[param4[10]],null);
         param5[16] = new PropertyWatcher("money",{"propertyChange":true},[param4[15]],param2);
         param5[17] = new PropertyWatcher("value",{"valueChanged":true},[param4[15]],null);
         param5[6].updateParent(param1);
         param5[6].addChild(param5[7]);
         param5[9].updateParent(param1);
         param5[9].addChild(param5[10]);
         param5[10].addChild(param5[18]);
         param5[10].addChild(param5[13]);
         param5[10].addChild(param5[21]);
         param5[10].addChild(param5[11]);
         param5[16].updateParent(param1);
         param5[16].addChild(param5[17]);
      }
   }
}

