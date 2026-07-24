package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.auction.AuctionScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_auction_AuctionScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_auction_AuctionScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         AuctionScreen.watcherSetupUtil = new _soul_view_interaction_auction_AuctionScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[7] = new PropertyWatcher("model",{"propertyChange":true},[param4[3],param4[4],param4[5],param4[6],param4[7],param4[8],param4[9]],param2);
         param5[9] = new PropertyWatcher("bidData",{"propertyChange":true},[param4[6]],null);
         param5[8] = new PropertyWatcher("browseData",{"propertyChange":true},[param4[4]],null);
         param5[10] = new PropertyWatcher("lotData",{"propertyChange":true},[param4[8]],null);
         param5[11] = new PropertyWatcher("inventoryModel",{"propertyChange":true},[param4[10]],param2);
         param5[5] = new PropertyWatcher("bar",{"propertyChange":true},[param4[2]],param2);
         param5[6] = new PropertyWatcher("selectedIndex",{"selectedIndexChanged":true},[param4[2]],null);
         param5[7].updateParent(param1);
         param5[7].addChild(param5[9]);
         param5[7].addChild(param5[8]);
         param5[7].addChild(param5[10]);
         param5[11].updateParent(param1);
         param5[5].updateParent(param1);
         param5[5].addChild(param5[6]);
      }
   }
}

