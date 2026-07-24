package
{
   import mx.binding.FunctionReturnWatcher;
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.assets.Assets;
   import soul.view.astral.AstralPanel;
   
   [ExcludeClass]
   public class _soul_view_astral_AstralPanelWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_astral_AstralPanelWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         AstralPanel.watcherSetupUtil = new _soul_view_astral_AstralPanelWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         var target:Object = param1;
         var propertyGetter:Function = param2;
         var staticPropertyGetter:Function = param3;
         var bindings:Array = param4;
         var watchers:Array = param5;
         watchers[8] = new FunctionReturnWatcher("scrollMid",target,function():Array
         {
            return [];
         },null,[bindings[6]],null);
         watchers[9] = new PropertyWatcher("bitmapData",null,[bindings[6]],null);
         watchers[0] = new PropertyWatcher("model",{"propertyChange":true},[bindings[0],bindings[2],bindings[13],bindings[14],bindings[17]],propertyGetter);
         watchers[2] = new PropertyWatcher("destinaton",{"propertyChange":true},[bindings[0],bindings[17]],null);
         watchers[15] = new PropertyWatcher("circles",{"propertyChange":true},[bindings[13]],null);
         watchers[3] = new PropertyWatcher("moving",{"propertyChange":true},[bindings[0],bindings[17]],null);
         watchers[17] = new PropertyWatcher("estimation",{"propertyChange":true},[bindings[14]],null);
         watchers[1] = new PropertyWatcher("entrance",{"propertyChange":true},[bindings[0]],null);
         watchers[4] = new PropertyWatcher("buttonEnabled",{"propertyChange":true},[bindings[1],bindings[16]],propertyGetter);
         watchers[8].updateParent(Assets);
         watchers[8].addChild(watchers[9]);
         watchers[0].updateParent(target);
         watchers[0].addChild(watchers[2]);
         watchers[0].addChild(watchers[15]);
         watchers[0].addChild(watchers[3]);
         watchers[0].addChild(watchers[17]);
         watchers[0].addChild(watchers[1]);
         watchers[4].updateParent(target);
      }
   }
}

