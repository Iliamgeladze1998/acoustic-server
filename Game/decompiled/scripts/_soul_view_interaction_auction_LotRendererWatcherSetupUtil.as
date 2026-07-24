package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.auction.LotRenderer;
   
   [ExcludeClass]
   public class _soul_view_interaction_auction_LotRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_auction_LotRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         LotRenderer.watcherSetupUtil = new _soul_view_interaction_auction_LotRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("lot",{"propertyChange":true},[param4[0],param4[1],param4[3],param4[4],param4[5],param4[6],param4[7],param4[8],param4[9],param4[10],param4[12],param4[13]],param2);
         param5[4] = new PropertyWatcher("myLot",{"propertyChange":true},[param4[3]],null);
         param5[7] = new PropertyWatcher("lotTime",{"propertyChange":true},[param4[5]],null);
         param5[5] = new PropertyWatcher("level",{"propertyChange":true},[param4[4]],null);
         param5[12] = new PropertyWatcher("currentBid",{"propertyChange":true},[param4[9]],null);
         param5[1] = new PropertyWatcher("item",{"propertyChange":true},[param4[0],param4[1]],null);
         param5[13] = new PropertyWatcher("buyNow",{"propertyChange":true},[param4[10],param4[13]],null);
         param5[11] = new PropertyWatcher("currency",{"propertyChange":true},[param4[8],param4[12]],null);
         param5[9] = new PropertyWatcher("myBid",{"propertyChange":true},[param4[6],param4[7],param4[9]],null);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[4]);
         param5[0].addChild(param5[7]);
         param5[0].addChild(param5[5]);
         param5[0].addChild(param5[12]);
         param5[0].addChild(param5[1]);
         param5[0].addChild(param5[13]);
         param5[0].addChild(param5[11]);
         param5[0].addChild(param5[9]);
      }
   }
}

