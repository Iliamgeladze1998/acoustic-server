package
{
   import mx.binding.ArrayElementWatcher;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.academy.ClassChangeScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_academy_ClassChangeScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_academy_ClassChangeScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ClassChangeScreen.watcherSetupUtil = new _soul_view_interaction_academy_ClassChangeScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var staticPropertyGetter:Function = param3;
         var bindings:Array = param4;
         var watchers:Array = param5;
         watchers[5] = new PropertyWatcher("model",{"propertyChange":true},[bindings[5],bindings[6],bindings[14],bindings[15],bindings[17]],propertyGetter);
         watchers[16] = new PropertyWatcher("presets",{"propertyChange":true},[bindings[14],bindings[15],bindings[17]],null);
         watchers[17] = new PropertyWatcher("changeCurrency",{"propertyChange":true},[bindings[14],bindings[17]],null);
         watchers[18] = new PropertyWatcher("changePrice",{"propertyChange":true},[bindings[15],bindings[17]],null);
         watchers[7] = new PropertyWatcher("wastelandAllowed",{"propertyChange":true},[bindings[6]],null);
         watchers[6] = new PropertyWatcher("empireAllowed",{"propertyChange":true},[bindings[5]],null);
         watchers[10] = new PropertyWatcher("sideSelector",{"propertyChange":true},[bindings[9]],propertyGetter);
         watchers[11] = new PropertyWatcher("selectedSide",{"selectedSideChanged":true},[bindings[9]],null);
         watchers[12] = new PropertyWatcher("classSelector",{"propertyChange":true},[bindings[10]],propertyGetter);
         watchers[13] = new PropertyWatcher("selectedClass",{"selectedClassChanged":true},[bindings[10]],null);
         watchers[3] = new PropertyWatcher("character",{"propertyChange":true},[bindings[4],bindings[7],bindings[8],bindings[17]],propertyGetter);
         watchers[20] = new PropertyWatcher("currencies",{"propertyChange":true},[bindings[17]],null);
         watchers[21] = new ArrayElementWatcher(target,function():*
         {
            return target.model.presets.changeCurrency;
         },[bindings[17]]);
         watchers[9] = new PropertyWatcher("sex",{"propertyChange":true},[bindings[8]],null);
         watchers[4] = new PropertyWatcher("side",{"propertyChange":true},[bindings[4]],null);
         watchers[8] = new PropertyWatcher("dispositionGroup",{"propertyChange":true},[bindings[7]],null);
         watchers[5].updateParent(target);
         watchers[5].addChild(watchers[16]);
         watchers[16].addChild(watchers[17]);
         watchers[16].addChild(watchers[18]);
         watchers[5].addChild(watchers[7]);
         watchers[5].addChild(watchers[6]);
         watchers[10].updateParent(target);
         watchers[10].addChild(watchers[11]);
         watchers[12].updateParent(target);
         watchers[12].addChild(watchers[13]);
         watchers[3].updateParent(target);
         watchers[3].addChild(watchers[20]);
         watchers[21].arrayWatcher = watchers[20];
         watchers[20].addChild(watchers[21]);
         watchers[3].addChild(watchers[9]);
         watchers[3].addChild(watchers[4]);
         watchers[3].addChild(watchers[8]);
      }
   }
}

