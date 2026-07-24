package
{
   import mx.binding.ArrayElementWatcher;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.academy.StatResetScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_academy_StatResetScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_academy_StatResetScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         StatResetScreen.watcherSetupUtil = new _soul_view_interaction_academy_StatResetScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var staticPropertyGetter:Function = param3;
         var bindings:Array = param4;
         var watchers:Array = param5;
         watchers[2] = new PropertyWatcher("selector",{"propertyChange":true},[bindings[2],bindings[6],bindings[7],bindings[9]],propertyGetter);
         watchers[3] = new PropertyWatcher("selectedType",{"selectedTypeChanged":true},[bindings[2],bindings[6],bindings[7],bindings[9]],null);
         watchers[6] = new PropertyWatcher("model",{"propertyChange":true},[bindings[6],bindings[7],bindings[9]],propertyGetter);
         watchers[7] = new PropertyWatcher("resets",{"propertyChange":true},[bindings[6],bindings[7],bindings[9]],null);
         watchers[8] = new ArrayElementWatcher(target,function():*
         {
            return target.selector.selectedType;
         },[bindings[6]]);
         watchers[9] = new PropertyWatcher("changeCurrency",null,[bindings[6]],null);
         watchers[10] = new ArrayElementWatcher(target,function():*
         {
            return target.selector.selectedType;
         },[bindings[7]]);
         watchers[11] = new PropertyWatcher("changePrice",null,[bindings[7]],null);
         watchers[13] = new ArrayElementWatcher(target,function():*
         {
            return target.selector.selectedType;
         },[bindings[9]]);
         watchers[14] = new PropertyWatcher("buttonEnabled",{"propertyChange":true},[bindings[9]],null);
         watchers[2].updateParent(target);
         watchers[2].addChild(watchers[3]);
         watchers[6].updateParent(target);
         watchers[6].addChild(watchers[7]);
         watchers[8].arrayWatcher = watchers[7];
         watchers[7].addChild(watchers[8]);
         watchers[8].addChild(watchers[9]);
         watchers[10].arrayWatcher = watchers[7];
         watchers[7].addChild(watchers[10]);
         watchers[10].addChild(watchers[11]);
         watchers[13].arrayWatcher = watchers[7];
         watchers[7].addChild(watchers[13]);
         watchers[13].addChild(watchers[14]);
      }
   }
}

