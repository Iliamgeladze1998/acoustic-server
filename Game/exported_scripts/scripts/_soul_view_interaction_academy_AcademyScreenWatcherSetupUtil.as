package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.academy.AcademyScreen;
   
   [ExcludeClass]
   public class _soul_view_interaction_academy_AcademyScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_academy_AcademyScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         AcademyScreen.watcherSetupUtil = new _soul_view_interaction_academy_AcademyScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[8] = new PropertyWatcher("model",{"propertyChange":true},[param4[6],param4[8]],param2);
         param5[6] = new PropertyWatcher("bar",{"propertyChange":true},[param4[5]],param2);
         param5[7] = new PropertyWatcher("selectedIndex",{"selectedIndexChanged":true},[param4[5]],null);
         param5[9] = new PropertyWatcher("character",{"propertyChange":true},[param4[7],param4[9]],param2);
         param5[8].updateParent(param1);
         param5[6].updateParent(param1);
         param5[6].addChild(param5[7]);
         param5[9].updateParent(param1);
      }
   }
}

