package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.character.parts.StatChanger;
   
   [ExcludeClass]
   public class _soul_view_interaction_character_parts_StatChangerWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_character_parts_StatChangerWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         StatChanger.watcherSetupUtil = new _soul_view_interaction_character_parts_StatChangerWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[2] = new PropertyWatcher("modifier",{"propertyChange":true},[param4[2],param4[3],param4[4]],param2);
         param5[3] = new PropertyWatcher("value",{"propertyChange":true},[param4[3]],param2);
         param5[5] = new PropertyWatcher("available",{"propertyChange":true},[param4[6]],param2);
         param5[2].updateParent(param1);
         param5[3].updateParent(param1);
         param5[5].updateParent(param1);
      }
   }
}

