package
{
   import mx.binding.ArrayElementWatcher;
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.social.SocialScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_social_SocialScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_social_SocialScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SocialScreen.watcherSetupUtil = new _soul_view_interaction_social_SocialScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var staticPropertyGetter:Function = param3;
         var bindings:Array = param4;
         var watchers:Array = param5;
         watchers[0] = new PropertyWatcher("characterModel",{"propertyChange":true},[bindings[0]],propertyGetter);
         watchers[1] = new PropertyWatcher("params",{"propertyChange":true},[bindings[0]],null);
         watchers[2] = new ArrayElementWatcher(target,function():*
         {
            return target.maxListEntries[target.bar.selectedIndex];
         },[bindings[0]]);
         watchers[8] = new FunctionReturnWatcher("getListByTab",target,function():Array
         {
            return [target.bar.selectedIndex];
         },{"listChanged":true},[bindings[2]],propertyGetter);
         watchers[5] = new PropertyWatcher("bar",{"propertyChange":true},[bindings[0],bindings[2]],propertyGetter);
         watchers[6] = new PropertyWatcher("selectedIndex",{"selectedIndexChanged":true},[bindings[0],bindings[2]],null);
         watchers[10] = new PropertyWatcher("renderer",{"propertyChange":true},[bindings[4],bindings[6],bindings[11]],propertyGetter);
         watchers[14] = new PropertyWatcher("selectedItem",{"propertyChange":true},[bindings[6]],null);
         watchers[11] = new PropertyWatcher("length",{"lengthChanged":true},[bindings[4],bindings[11]],null);
         watchers[12] = new PropertyWatcher("maxEntries",{"propertyChange":true},[bindings[4],bindings[11]],propertyGetter);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[1]);
         watchers[2].arrayWatcher = watchers[1];
         watchers[1].addChild(watchers[2]);
         watchers[8].updateParent(target);
         watchers[5].updateParent(target);
         watchers[5].addChild(watchers[6]);
         watchers[10].updateParent(target);
         watchers[10].addChild(watchers[14]);
         watchers[10].addChild(watchers[11]);
         watchers[12].updateParent(target);
      }
   }
}

