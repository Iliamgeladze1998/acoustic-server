package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.core.IFlexModuleFactory;
   import soul.view.interaction.ability.SpellBox;
   
   [ExcludeClass]
   public class _soul_view_interaction_ability_SpellBoxWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_interaction_ability_SpellBoxWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         SpellBox.watcherSetupUtil = new _soul_view_interaction_ability_SpellBoxWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
      }
   }
}

