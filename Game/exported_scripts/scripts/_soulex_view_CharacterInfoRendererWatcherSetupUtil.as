package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soulex.view.CharacterInfoRenderer;
   
   [ExcludeClass]
   public class _soulex_view_CharacterInfoRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soulex_view_CharacterInfoRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         CharacterInfoRenderer.watcherSetupUtil = new _soulex_view_CharacterInfoRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[2] = new PropertyWatcher("info",{"propertyChange":true},[param4[1],param4[2],param4[3],param4[4],param4[5],param4[6]],param2);
         param5[2].updateParent(param1);
      }
   }
}

