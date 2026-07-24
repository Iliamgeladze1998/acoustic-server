package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.shop.ShopDialog;
   
   [ExcludeClass]
   public class _soul_view_interaction_shop_ShopDialogWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_shop_ShopDialogWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ShopDialog.watcherSetupUtil = new _soul_view_interaction_shop_ShopDialogWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[6] = new PropertyWatcher("slider",{"propertyChange":true},[param4[4],param4[12]],param2);
         param5[7] = new PropertyWatcher("value",{"valueChanged":true},[param4[4],param4[12]],null);
         param5[4] = new PropertyWatcher("count",{"propertyChange":true},[param4[3]],param2);
         param5[5] = new PropertyWatcher("text",{"textChanged":true},[param4[3]],null);
         param5[1] = new PropertyWatcher("item",{"propertyChange":true},[param4[0],param4[1],param4[13]],param2);
         param5[2] = new PropertyWatcher("id",{"propertyChange":true},[param4[0]],null);
         param5[15] = new PropertyWatcher("price",{"propertyChange":true},[param4[13]],null);
         param5[3] = new PropertyWatcher("maxCount",{"propertyChange":true},[param4[2]],param2);
         param5[6].updateParent(param1);
         param5[6].addChild(param5[7]);
         param5[4].updateParent(param1);
         param5[4].addChild(param5[5]);
         param5[1].updateParent(param1);
         param5[1].addChild(param5[2]);
         param5[1].addChild(param5[15]);
         param5[3].updateParent(param1);
      }
   }
}

