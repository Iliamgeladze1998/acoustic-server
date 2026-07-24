package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.clan.ClanStatusPopup;
   
   [ExcludeClass]
   public class _soul_view_interaction_clan_ClanStatusPopupWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_clan_ClanStatusPopupWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ClanStatusPopup.watcherSetupUtil = new _soul_view_interaction_clan_ClanStatusPopupWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[4] = new PropertyWatcher("currentRoleIndex",{"propertyChange":true},[param4[4]],param2);
         param5[1] = new PropertyWatcher("nick",{"propertyChange":true},[param4[1]],param2);
         param5[7] = new PropertyWatcher("selectedRole",{"propertyChange":true},[param4[7],param4[10]],param2);
         param5[8] = new PropertyWatcher("selectedItem",{"selectedItemChanged":true},[param4[7],param4[10]],null);
         param5[11] = new PropertyWatcher("value",null,[param4[10]],null);
         param5[12] = new PropertyWatcher("currentRole",{"propertyChange":true},[param4[10]],param2);
         param5[3] = new PropertyWatcher("sortedRoles",{"propertyChange":true},[param4[3]],param2);
         param5[4].updateParent(param1);
         param5[1].updateParent(param1);
         param5[7].updateParent(param1);
         param5[7].addChild(param5[8]);
         param5[8].addChild(param5[11]);
         param5[12].updateParent(param1);
         param5[3].updateParent(param1);
      }
   }
}

