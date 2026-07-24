package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.auction.tabs.LotTab;
   
   [ExcludeClass]
   public class _soul_view_interaction_auction_tabs_LotTabWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_auction_tabs_LotTabWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         LotTab.watcherSetupUtil = new _soul_view_interaction_auction_tabs_LotTabWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[10] = new PropertyWatcher("lotList",{"propertyChange":true},[param4[11]],param2);
         param5[11] = new PropertyWatcher("selectedLot",{"lotSelected":true},[param4[11]],null);
         param5[6] = new PropertyWatcher("lotData",{"propertyChange":true},[param4[8]],param2);
         param5[7] = new PropertyWatcher("lots",{"propertyChange":true},[param4[8]],null);
         param5[10].updateParent(param1);
         param5[10].addChild(param5[11]);
         param5[6].updateParent(param1);
         param5[6].addChild(param5[7]);
      }
   }
}

