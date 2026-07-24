package
{
   import mx.binding.ArrayElementWatcher;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.clan.ClanStorage;
   
   [ExcludeClass]
   public class _soul_view_interaction_clan_ClanStorageWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_clan_ClanStorageWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ClanStorage.watcherSetupUtil = new _soul_view_interaction_clan_ClanStorageWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var staticPropertyGetter:Function = param3;
         var bindings:Array = param4;
         var watchers:Array = param5;
         watchers[0] = new PropertyWatcher("model",{"propertyChange":true},[bindings[0],bindings[1]],propertyGetter);
         watchers[1] = new PropertyWatcher("storage",{"propertyChange":true},[bindings[0],bindings[1]],null);
         watchers[2] = new ArrayElementWatcher(target,function():*
         {
            return target.bar.selectedIndex;
         },[bindings[1]]);
         watchers[3] = new PropertyWatcher("bar",{"propertyChange":true},[bindings[1]],propertyGetter);
         watchers[4] = new PropertyWatcher("selectedIndex",{"selectedIndexChanged":true},[bindings[1]],null);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[1]);
         watchers[2].arrayWatcher = watchers[1];
         watchers[1].addChild(watchers[2]);
         watchers[3].updateParent(target);
         watchers[3].addChild(watchers[4]);
      }
   }
}

