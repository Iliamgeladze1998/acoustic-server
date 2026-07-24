package
{
   import mx.binding.ArrayElementWatcher;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.auction.tabs.CreateLotTab;
   
   [ExcludeClass]
   public class _soul_view_interaction_auction_tabs_CreateLotTabWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_auction_tabs_CreateLotTabWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         CreateLotTab.watcherSetupUtil = new _soul_view_interaction_auction_tabs_CreateLotTabWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var staticPropertyGetter:Function = param3;
         var bindings:Array = param4;
         var watchers:Array = param5;
         watchers[0] = new PropertyWatcher("model",{"propertyChange":true},[bindings[0],bindings[1],bindings[5],bindings[33]],propertyGetter);
         watchers[2] = new PropertyWatcher("lotTimes",{"propertyChange":true},[bindings[1],bindings[5]],null);
         watchers[3] = new ArrayElementWatcher(target,function():*
         {
            return target.lotTimes.selectedIndex;
         },[bindings[1]]);
         watchers[34] = new PropertyWatcher("lotFeeCurrency",{"propertyChange":true},[bindings[33]],null);
         watchers[1] = new PropertyWatcher("lotData",{"propertyChange":true},[bindings[0]],null);
         watchers[22] = new PropertyWatcher("count",{"propertyChange":true},[bindings[16],bindings[35]],propertyGetter);
         watchers[23] = new PropertyWatcher("text",{"textChanged":true},[bindings[16],bindings[35]],null);
         watchers[4] = new PropertyWatcher("lotTimes",{"propertyChange":true},[bindings[1]],propertyGetter);
         watchers[5] = new PropertyWatcher("selectedIndex",{"selectedIndexChanged":true},[bindings[1]],null);
         watchers[18] = new PropertyWatcher("currencyType",{"propertyChange":true},[bindings[14],bindings[19],bindings[24],bindings[25],bindings[29],bindings[30]],propertyGetter);
         watchers[19] = new PropertyWatcher("selectedItem",{"selectedItemChanged":true},[bindings[14],bindings[19],bindings[24],bindings[25],bindings[29],bindings[30]],null);
         watchers[20] = new PropertyWatcher("value",null,[bindings[14],bindings[19],bindings[24],bindings[25],bindings[29],bindings[30]],null);
         watchers[26] = new PropertyWatcher("lotPrice",{"propertyChange":true},[bindings[24]],propertyGetter);
         watchers[27] = new PropertyWatcher("value",{"valueChanged":true},[bindings[24]],null);
         watchers[36] = new PropertyWatcher("lotTime",{"propertyChange":true},[bindings[35]],propertyGetter);
         watchers[11] = new PropertyWatcher("item",{"propertyChange":true},[bindings[8],bindings[10],bindings[11],bindings[15],bindings[16],bindings[20],bindings[35],bindings[38],bindings[41]],propertyGetter);
         watchers[12] = new PropertyWatcher("item",{"itemChanged":true},[bindings[8],bindings[10],bindings[11],bindings[15],bindings[16],bindings[20],bindings[35],bindings[38],bindings[41]],null);
         watchers[13] = new PropertyWatcher("count",{"propertyChange":true},[bindings[8]],null);
         watchers[30] = new PropertyWatcher("buyPrice",{"propertyChange":true},[bindings[29]],propertyGetter);
         watchers[31] = new PropertyWatcher("value",{"valueChanged":true},[bindings[29]],null);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[2]);
         watchers[3].arrayWatcher = watchers[2];
         watchers[2].addChild(watchers[3]);
         watchers[0].addChild(watchers[34]);
         watchers[0].addChild(watchers[1]);
         watchers[22].updateParent(target);
         watchers[22].addChild(watchers[23]);
         watchers[4].updateParent(target);
         watchers[4].addChild(watchers[5]);
         watchers[18].updateParent(target);
         watchers[18].addChild(watchers[19]);
         watchers[19].addChild(watchers[20]);
         watchers[26].updateParent(target);
         watchers[26].addChild(watchers[27]);
         watchers[36].updateParent(target);
         watchers[11].updateParent(target);
         watchers[11].addChild(watchers[12]);
         watchers[12].addChild(watchers[13]);
         watchers[30].updateParent(target);
         watchers[30].addChild(watchers[31]);
      }
   }
}

