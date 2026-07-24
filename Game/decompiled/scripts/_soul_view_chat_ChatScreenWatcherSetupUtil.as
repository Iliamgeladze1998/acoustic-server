package
{
   import mx.binding.IWatcherSetupUtil2;
   import mx.binding.PropertyWatcher;
   import mx.core.IFlexModuleFactory;
   import soul.view.chat.ChatScreen;
   
   [ExcludeClass]
   public class _soul_view_chat_ChatScreenWatcherSetupUtil implements IWatcherSetupUtil2
   {
      
      public function _soul_view_chat_ChatScreenWatcherSetupUtil()
      {
         super();
      }
      
      public static function init(param1:IFlexModuleFactory) : void
      {
         ChatScreen.watcherSetupUtil = new _soul_view_chat_ChatScreenWatcherSetupUtil();
      }
      
      public function setup(param1:Object, param2:Function, param3:Function, param4:Array, param5:Array) : void
      {
         param5[8] = new PropertyWatcher("model",{"propertyChange":true},[param4[5],param4[8],param4[9],param4[13],param4[16],param4[20],param4[21]],param2);
         param5[19] = new PropertyWatcher("languages",{"propertyChange":true},[param4[20]],null);
         param5[13] = new PropertyWatcher("currentMessages",{"propertyChange":true},[param4[13]],null);
         param5[9] = new PropertyWatcher("currentTab",{"propertyChange":true},[param4[5],param4[8],param4[16]],null);
         param5[10] = new PropertyWatcher("users",{"propertyChange":true},[param4[5],param4[8],param4[16]],null);
         param5[20] = new PropertyWatcher("currentLanguage",{"propertyChange":true},[param4[21]],null);
         param5[5] = new PropertyWatcher("usersVisible",{"propertyChange":true},[param4[2]],param2);
         param5[6] = new PropertyWatcher("transparentAlpha",{"propertyChange":true},[param4[3],param4[12]],param2);
         param5[15] = new PropertyWatcher("inputHover",{"propertyChange":true},[param4[15]],param2);
         param5[0] = new PropertyWatcher("box",{"propertyChange":true},[param4[0],param4[1],param4[4]],param2);
         param5[2] = new PropertyWatcher("height",{"heightChanged":true},[param4[1]],null);
         param5[1] = new PropertyWatcher("width",{"widthChanged":true},[param4[0],param4[4]],null);
         param5[3] = new PropertyWatcher("transparent",{"propertyChange":true},[param4[2],param4[3],param4[10],param4[11],param4[12],param4[14],param4[15],param4[25],param4[26],param4[27]],param2);
         param5[4] = new PropertyWatcher("selected",{"selectedChanged":true},[param4[2],param4[3],param4[10],param4[11],param4[12],param4[14],param4[15],param4[25],param4[26],param4[27]],null);
         param5[14] = new PropertyWatcher("inputVisible",{"propertyChange":true},[param4[15],param4[27]],param2);
         param5[7] = new PropertyWatcher("opaqueAlpha",{"propertyChange":true},[param4[3],param4[12]],param2);
         param5[8].updateParent(param1);
         param5[8].addChild(param5[19]);
         param5[8].addChild(param5[13]);
         param5[8].addChild(param5[9]);
         param5[9].addChild(param5[10]);
         param5[8].addChild(param5[20]);
         param5[5].updateParent(param1);
         param5[6].updateParent(param1);
         param5[15].updateParent(param1);
         param5[0].updateParent(param1);
         param5[0].addChild(param5[2]);
         param5[0].addChild(param5[1]);
         param5[3].updateParent(param1);
         param5[3].addChild(param5[4]);
         param5[14].updateParent(param1);
         param5[7].updateParent(param1);
      }
   }
}

