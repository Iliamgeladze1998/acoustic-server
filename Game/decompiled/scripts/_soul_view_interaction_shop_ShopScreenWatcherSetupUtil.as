package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.shop.ShopScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_shop_ShopScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_shop_ShopScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ShopScreen.watcherSetupUtil = new _soul_view_interaction_shop_ShopScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

