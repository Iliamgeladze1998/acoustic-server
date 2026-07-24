package
{
   import mx.binding.ArrayElementWatcher;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.arena.Arena;
   
   [ExcludeClass]
   public class _soul_view_interaction_arena_ArenaWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_arena_ArenaWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         Arena.watcherSetupUtil = new _soul_view_interaction_arena_ArenaWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var staticPropertyGetter:Function = param3;
         var bindings:Array = param4;
         var watchers:Array = param5;
         watchers[10] = new PropertyWatcher("aTypes",{"propertyChange":true},[bindings[7]],propertyGetter);
         watchers[11] = new PropertyWatcher("selectedItem",{"selectedItemChanged":true},[bindings[7]],null);
         watchers[12] = new PropertyWatcher("fightType",null,[bindings[7]],null);
         watchers[15] = new PropertyWatcher("aArenas",{"propertyChange":true},[bindings[11],bindings[13]],propertyGetter);
         watchers[16] = new PropertyWatcher("selectedIndex",{"selectedIndexChanged":true},[bindings[11]],null);
         watchers[19] = new PropertyWatcher("selectedItem",{"selectedItemChanged":true},[bindings[13]],null);
         watchers[5] = new PropertyWatcher("model",{"propertyChange":true},[bindings[5],bindings[7]],propertyGetter);
         watchers[8] = new PropertyWatcher("arenas",{"propertyChange":true},[bindings[7]],null);
         watchers[9] = new ArrayElementWatcher(target,function():*
         {
            return target.aTypes.selectedItem.fightType;
         },[bindings[7]]);
         watchers[6] = new PropertyWatcher("fightTypes",{"propertyChange":true},[bindings[5]],null);
         watchers[13] = new PropertyWatcher("scrollBase",{"propertyChange":true},[bindings[10]],propertyGetter);
         watchers[14] = new PropertyWatcher("width",{"widthChanged":true},[bindings[10]],null);
         watchers[10].updateParent(target);
         watchers[10].addChild(watchers[11]);
         watchers[11].addChild(watchers[12]);
         watchers[15].updateParent(target);
         watchers[15].addChild(watchers[16]);
         watchers[15].addChild(watchers[19]);
         watchers[5].updateParent(target);
         watchers[5].addChild(watchers[8]);
         watchers[9].arrayWatcher = watchers[8];
         watchers[8].addChild(watchers[9]);
         watchers[5].addChild(watchers[6]);
         watchers[13].updateParent(target);
         watchers[13].addChild(watchers[14]);
      }
   }
}

