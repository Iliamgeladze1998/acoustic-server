package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.avatar.AvatarScreen;
   
   [ExcludeClass]
   public class _soul_view_avatar_AvatarScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_avatar_AvatarScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         AvatarScreen.watcherSetupUtil = new _soul_view_avatar_AvatarScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[7] = new PropertyWatcher("selectedAvatar",{"propertyChange":true},[param4[8],param4[11],param4[12],param4[14]],param2);
         param5[7].updateParent(param1);
      }
   }
}

