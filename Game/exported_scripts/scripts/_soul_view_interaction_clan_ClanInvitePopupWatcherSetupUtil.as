package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.clan.ClanInvitePopup;
   
   [ExcludeClass]
   public class _soul_view_interaction_clan_ClanInvitePopupWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_clan_ClanInvitePopupWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ClanInvitePopup.watcherSetupUtil = new _soul_view_interaction_clan_ClanInvitePopupWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[9] = new PropertyWatcher("nick",{"propertyChange":true},[param4[10]],param2);
         param5[10] = new PropertyWatcher("text",{"textChanged":true},[param4[10]],null);
         param5[11] = new PropertyWatcher("length",null,[param4[10]],null);
         param5[7] = new PropertyWatcher("enterFeeValue",{"propertyChange":true},[param4[8]],param2);
         param5[9].updateParent(param1);
         param5[9].addChild(param5[10]);
         param5[10].addChild(param5[11]);
         param5[7].updateParent(param1);
      }
   }
}

