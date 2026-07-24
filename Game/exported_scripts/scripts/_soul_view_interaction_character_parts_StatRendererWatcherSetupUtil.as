package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.character.parts.StatRenderer;
   
   [ExcludeClass]
   public class _soul_view_interaction_character_parts_StatRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_character_parts_StatRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         StatRenderer.watcherSetupUtil = new _soul_view_interaction_character_parts_StatRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[1] = new PropertyWatcher("value",{"propertyChange":true},[param4[1]],param2);
         param5[1].updateParent(param1);
      }
   }
}

