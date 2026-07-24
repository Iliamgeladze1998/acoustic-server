package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.craft.CraftScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_craft_CraftScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_craft_CraftScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         CraftScreen.watcherSetupUtil = new _soul_view_interaction_craft_CraftScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[3] = new PropertyWatcher("model",{"propertyChange":true},[param4[1],param4[3],param4[17],param4[18]],param2);
         param5[6] = new PropertyWatcher("recipes",{
            "propertyChange":true,
            "recipesChanged":true
         },[param4[3]],null);
         param5[4] = new PropertyWatcher("craftType",{"propertyChange":true},[param4[1]],null);
         param5[21] = new PropertyWatcher("craftInProgress",{"propertyChange":true},[param4[17],param4[18]],null);
         param5[17] = new PropertyWatcher("count",{"propertyChange":true},[param4[13],param4[16]],param2);
         param5[18] = new PropertyWatcher("text",{"textChanged":true},[param4[13],param4[16]],null);
         param5[16] = new PropertyWatcher("craftInProgress",{"propertyChange":true},[param4[12],param4[18]],param2);
         param5[15] = new PropertyWatcher("availableCount",{"propertyChange":true},[param4[11],param4[12],param4[16],param4[18]],param2);
         param5[0] = new PropertyWatcher("selectedRecipe",{"propertyChange":true},[param4[0],param4[5],param4[6],param4[7],param4[8],param4[10],param4[15]],param2);
         param5[7] = new PropertyWatcher("realItem",null,[param4[6]],null);
         param5[1] = new PropertyWatcher("availableCount",{"propertyChange":true},[param4[0]],null);
         param5[3].updateParent(param1);
         param5[3].addChild(param5[6]);
         param5[3].addChild(param5[4]);
         param5[3].addChild(param5[21]);
         param5[17].updateParent(param1);
         param5[17].addChild(param5[18]);
         param5[16].updateParent(param1);
         param5[15].updateParent(param1);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[7]);
         param5[0].addChild(param5[1]);
      }
   }
}

