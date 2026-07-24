package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.clan.CreateClanScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_clan_CreateClanScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_clan_CreateClanScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         CreateClanScreen.watcherSetupUtil = new _soul_view_interaction_clan_CreateClanScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[1] = new PropertyWatcher("model",{"propertyChange":true},[param4[1]],param2);
         param5[2] = new PropertyWatcher("characterModel",{"propertyChange":true},[param4[2]],param2);
         param5[1].updateParent(param1);
         param5[2].updateParent(param1);
      }
   }
}

