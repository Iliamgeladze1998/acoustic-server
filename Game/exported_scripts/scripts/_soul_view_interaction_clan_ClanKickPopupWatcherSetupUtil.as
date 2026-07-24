package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.clan.ClanKickPopup;
   
   [ExcludeClass]
   public class _soul_view_interaction_clan_ClanKickPopupWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_clan_ClanKickPopupWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ClanKickPopup.watcherSetupUtil = new _soul_view_interaction_clan_ClanKickPopupWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[4] = new PropertyWatcher("nick",{"propertyChange":true},[param4[4]],param2);
         param5[2] = new PropertyWatcher("self",{"propertyChange":true},[param4[1],param4[3],param4[5]],param2);
         param5[4].updateParent(param1);
         param5[2].updateParent(param1);
      }
   }
}

