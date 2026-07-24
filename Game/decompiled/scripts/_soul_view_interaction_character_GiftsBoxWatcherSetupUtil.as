package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.character.GiftsBox;
   
   [ExcludeClass]
   public class _soul_view_interaction_character_GiftsBoxWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_character_GiftsBoxWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         GiftsBox.watcherSetupUtil = new _soul_view_interaction_character_GiftsBoxWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

