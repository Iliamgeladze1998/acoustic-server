package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.rtm.group.GroupMemberOfflineRenderer;
   
   [ExcludeClass]
   public class _soul_view_rtm_group_GroupMemberOfflineRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_rtm_group_GroupMemberOfflineRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         GroupMemberOfflineRenderer.watcherSetupUtil = new _soul_view_rtm_group_GroupMemberOfflineRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("unit",{"propertyChange":true},[param4[0],param4[3]],param2);
         param5[1] = new PropertyWatcher("name",{"propertyChange":true},[param4[0]],null);
         param5[6] = new PropertyWatcher("disposition",{"propertyChange":true},[param4[3]],null);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[1]);
         param5[0].addChild(param5[6]);
      }
   }
}

