package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.rtm.group.GroupMemberRenderer;
   
   [ExcludeClass]
   public class _soul_view_rtm_group_GroupMemberRendererWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_rtm_group_GroupMemberRendererWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         GroupMemberRenderer.watcherSetupUtil = new _soul_view_rtm_group_GroupMemberRendererWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("unit",{"propertyChange":true},[param4[0],param4[2],param4[3],param4[4],param4[5],param4[6],param4[7],param4[9],param4[10]],param2);
         param5[4] = new PropertyWatcher("stats",{"propertyChange":true},[param4[3],param4[4],param4[6],param4[7]],null);
         param5[10] = new PropertyWatcher("HP",null,[param4[6]],null);
         param5[5] = new PropertyWatcher("MP",null,[param4[3]],null);
         param5[9] = new PropertyWatcher("MAX_HP",null,[param4[6],param4[7]],null);
         param5[6] = new PropertyWatcher("MAX_MP",null,[param4[4]],null);
         param5[15] = new PropertyWatcher("leader",{"propertyChange":true},[param4[10]],null);
         param5[8] = new PropertyWatcher("avatarImagePath",{"propertyChange":true},[param4[5]],null);
         param5[1] = new PropertyWatcher("name",{"propertyChange":true},[param4[0]],null);
         param5[3] = new PropertyWatcher("effects",{"propertyChange":true},[param4[2]],null);
         param5[14] = new PropertyWatcher("disposition",{"propertyChange":true},[param4[9]],null);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[4]);
         param5[4].addChild(param5[10]);
         param5[4].addChild(param5[5]);
         param5[4].addChild(param5[9]);
         param5[4].addChild(param5[6]);
         param5[0].addChild(param5[15]);
         param5[0].addChild(param5[8]);
         param5[0].addChild(param5[1]);
         param5[0].addChild(param5[3]);
         param5[0].addChild(param5[14]);
      }
   }
}

