package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.rtm.targetFrame.GenericFrame;
   
   [ExcludeClass]
   public class _soul_view_rtm_targetFrame_GenericFrameWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_rtm_targetFrame_GenericFrameWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         GenericFrame.watcherSetupUtil = new _soul_view_rtm_targetFrame_GenericFrameWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[0] = new PropertyWatcher("unit",{"propertyChange":true},[param4[0],param4[1],param4[2],param4[4],param4[5],param4[6],param4[7],param4[8],param4[9],param4[10],param4[12],param4[14],param4[15],param4[16]],param2);
         param5[1] = new PropertyWatcher("stats",{"propertyChange":true},[param4[1],param4[2],param4[4],param4[5],param4[6],param4[7],param4[15]],null);
         param5[7] = new PropertyWatcher("STAMINA",null,[param4[6]],null);
         param5[17] = new PropertyWatcher("LEVEL",null,[param4[15]],null);
         param5[5] = new PropertyWatcher("MP",null,[param4[4]],null);
         param5[2] = new PropertyWatcher("HP",null,[param4[1]],null);
         param5[3] = new PropertyWatcher("MAX_HP",null,[param4[2]],null);
         param5[8] = new PropertyWatcher("MAX_STAMINA",null,[param4[7]],null);
         param5[6] = new PropertyWatcher("MAX_MP",null,[param4[5]],null);
         param5[16] = new PropertyWatcher("name",{"propertyChange":true},[param4[14]],null);
         param5[14] = new PropertyWatcher("avatarImagePath",{"propertyChange":true},[param4[12]],null);
         param5[18] = new PropertyWatcher("effects",{"propertyChange":true},[param4[16]],null);
         param5[9] = new PropertyWatcher("difficulty",{"propertyChange":true},[param4[8],param4[9],param4[10]],null);
         param5[11] = new PropertyWatcher("fightMode",{"propertyChange":true},[param4[11]],param2);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[1]);
         param5[1].addChild(param5[7]);
         param5[1].addChild(param5[17]);
         param5[1].addChild(param5[5]);
         param5[1].addChild(param5[2]);
         param5[1].addChild(param5[3]);
         param5[1].addChild(param5[8]);
         param5[1].addChild(param5[6]);
         param5[0].addChild(param5[16]);
         param5[0].addChild(param5[14]);
         param5[0].addChild(param5[18]);
         param5[0].addChild(param5[9]);
         param5[11].updateParent(param1);
      }
   }
}

