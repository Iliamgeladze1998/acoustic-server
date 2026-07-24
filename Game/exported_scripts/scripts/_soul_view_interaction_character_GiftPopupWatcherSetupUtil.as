package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.character.GiftPopup;
   
   [ExcludeClass]
   public class _soul_view_interaction_character_GiftPopupWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_character_GiftPopupWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         GiftPopup.watcherSetupUtil = new _soul_view_interaction_character_GiftPopupWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[3] = new PropertyWatcher("body",{"propertyChange":true},[param4[3],param4[5],param4[7]],param2);
         param5[4] = new PropertyWatcher("awards",{"propertyChange":true},[param4[3]],null);
         param5[6] = new PropertyWatcher("gifts",{"propertyChange":true},[param4[5]],null);
         param5[8] = new PropertyWatcher("trophies",{"propertyChange":true},[param4[7]],null);
         param5[3].updateParent(param1);
         param5[3].addChild(param5[4]);
         param5[3].addChild(param5[6]);
         param5[3].addChild(param5[8]);
      }
   }
}

