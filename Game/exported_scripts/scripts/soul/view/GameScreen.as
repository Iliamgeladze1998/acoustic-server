package soul.view
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.model.GameMode;
   import soul.model.GameModel;
   import soul.model.astral.AstralModel;
   import soul.model.character.CharacterModel;
   import soul.model.chat.ChatModel;
   import soul.model.field.BaseUnit;
   import soul.model.group.GroupModel;
   import soul.model.interaction.settings.SettingsModel;
   import soul.model.interaction.social.SocialModel;
   import soul.model.inventory.InventoryModel;
   import soul.model.rtm.RTMModel;
   import soul.view.astral.AstralScreen;
   import soul.view.chat.ChatScreen;
   import soul.view.interaction.inventory.VirtualPanel;
   import soul.view.rtm.RTMScreen;
   import soul.view.rtm.group.GroupMembers;
   import soul.view.rtm.targetFrame.MyFrame;
   import soul.view.toolbar.ToolBar;
   import soul.view.ui.Canvas;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class GameScreen extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _GameScreen_ToolBar1:ToolBar;
      
      public var _GameScreen_VirtualPanel1:VirtualPanel;
      
      private var _980790617astralScreen:AstralScreen;
      
      private var _1367706280canvas:Canvas;
      
      private var _1675403804chatScreen:ChatScreen;
      
      private var _599453082groupMembers:GroupMembers;
      
      private var _1485920033myFrame:MyFrame;
      
      private var _835955383rtmScreen:RTMScreen;
      
      private var _104069929model:GameModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function GameScreen()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         bindings = this._GameScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_GameScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return GameScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.children = [this._GameScreen_Canvas1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         GameScreen._watcherSetupUtil = param1;
      }
      
      private function _GameScreen_Canvas1_i() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._GameScreen_RTMScreen1_i(),this._GameScreen_AstralScreen1_i(),this._GameScreen_GroupMembers1_i(),this._GameScreen_MyFrame1_i(),this._GameScreen_ToolBar1_i(),this._GameScreen_VirtualPanel1_i(),this._GameScreen_ChatScreen1_i()];
         this.canvas = _loc1_;
         BindingManager.executeBindings(this,"canvas",this.canvas);
         return _loc1_;
      }
      
      private function _GameScreen_RTMScreen1_i() : RTMScreen
      {
         var _loc1_:RTMScreen = new RTMScreen();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.visible = false;
         this.rtmScreen = _loc1_;
         BindingManager.executeBindings(this,"rtmScreen",this.rtmScreen);
         return _loc1_;
      }
      
      private function _GameScreen_AstralScreen1_i() : AstralScreen
      {
         var _loc1_:AstralScreen = new AstralScreen();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.visible = false;
         this.astralScreen = _loc1_;
         BindingManager.executeBindings(this,"astralScreen",this.astralScreen);
         return _loc1_;
      }
      
      private function _GameScreen_GroupMembers1_i() : GroupMembers
      {
         var _loc1_:GroupMembers = new GroupMembers();
         _loc1_.mouseEnabled = false;
         this.groupMembers = _loc1_;
         BindingManager.executeBindings(this,"groupMembers",this.groupMembers);
         return _loc1_;
      }
      
      private function _GameScreen_MyFrame1_i() : MyFrame
      {
         var _loc1_:MyFrame = new MyFrame();
         _loc1_.bottom = 0;
         _loc1_.horizontalCenter = 0;
         this.myFrame = _loc1_;
         BindingManager.executeBindings(this,"myFrame",this.myFrame);
         return _loc1_;
      }
      
      private function _GameScreen_ToolBar1_i() : ToolBar
      {
         var _loc1_:ToolBar = new ToolBar();
         _loc1_.bottom = 100;
         this._GameScreen_ToolBar1 = _loc1_;
         BindingManager.executeBindings(this,"_GameScreen_ToolBar1",this._GameScreen_ToolBar1);
         return _loc1_;
      }
      
      private function _GameScreen_VirtualPanel1_i() : VirtualPanel
      {
         var _loc1_:VirtualPanel = new VirtualPanel();
         _loc1_.bottom = 100;
         this._GameScreen_VirtualPanel1 = _loc1_;
         BindingManager.executeBindings(this,"_GameScreen_VirtualPanel1",this._GameScreen_VirtualPanel1);
         return _loc1_;
      }
      
      private function _GameScreen_ChatScreen1_i() : ChatScreen
      {
         var _loc1_:ChatScreen = new ChatScreen();
         _loc1_.bottom = 60;
         this.chatScreen = _loc1_;
         BindingManager.executeBindings(this,"chatScreen",this.chatScreen);
         return _loc1_;
      }
      
      private function _GameScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,null,null,"rtmScreen.model","model");
         result[1] = new Binding(this,function():AstralModel
         {
            return model.astralModel;
         },null,"astralScreen.model");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = model.characterModel.id;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"groupMembers.myId");
         result[3] = new Binding(this,function():GroupModel
         {
            return model.groupModel;
         },null,"groupMembers.groupModel");
         result[4] = new Binding(this,function():RTMModel
         {
            return model.rtmModel;
         },null,"groupMembers.rtmModel");
         result[5] = new Binding(this,null,null,"myFrame.model","model");
         result[6] = new Binding(this,function():Number
         {
            return model.mode == GameMode.ASTRAL ? 240 : 0;
         },null,"_GameScreen_ToolBar1.right");
         result[7] = new Binding(this,null,null,"_GameScreen_ToolBar1.model","model");
         result[8] = new Binding(this,function():Number
         {
            return model.mode == GameMode.ASTRAL ? 300 : 60;
         },null,"_GameScreen_VirtualPanel1.right");
         result[9] = new Binding(this,function():InventoryModel
         {
            return model.inventoryModel;
         },null,"_GameScreen_VirtualPanel1.model");
         result[10] = new Binding(this,function():BaseUnit
         {
            return model.characterModel.myUnit;
         },null,"_GameScreen_VirtualPanel1.myUnit");
         result[11] = new Binding(this,function():ChatModel
         {
            return model.chatModel;
         },null,"chatScreen.model");
         result[12] = new Binding(this,function():GroupModel
         {
            return model.groupModel;
         },null,"chatScreen.groupModel");
         result[13] = new Binding(this,function():SocialModel
         {
            return model.socialModel;
         },null,"chatScreen.socialModel");
         result[14] = new Binding(this,function():CharacterModel
         {
            return model.characterModel;
         },null,"chatScreen.characterModel");
         result[15] = new Binding(this,function():RTMModel
         {
            return model.rtmModel;
         },null,"chatScreen.rtmModel");
         result[16] = new Binding(this,function():SettingsModel
         {
            return model.settingsModel;
         },null,"chatScreen.settingsModel");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get astralScreen() : AstralScreen
      {
         return this._980790617astralScreen;
      }
      
      public function set astralScreen(param1:AstralScreen) : void
      {
         var _loc2_:Object = this._980790617astralScreen;
         if(_loc2_ !== param1)
         {
            this._980790617astralScreen = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"astralScreen",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get canvas() : Canvas
      {
         return this._1367706280canvas;
      }
      
      public function set canvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._1367706280canvas;
         if(_loc2_ !== param1)
         {
            this._1367706280canvas = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"canvas",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get chatScreen() : ChatScreen
      {
         return this._1675403804chatScreen;
      }
      
      public function set chatScreen(param1:ChatScreen) : void
      {
         var _loc2_:Object = this._1675403804chatScreen;
         if(_loc2_ !== param1)
         {
            this._1675403804chatScreen = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatScreen",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get groupMembers() : GroupMembers
      {
         return this._599453082groupMembers;
      }
      
      public function set groupMembers(param1:GroupMembers) : void
      {
         var _loc2_:Object = this._599453082groupMembers;
         if(_loc2_ !== param1)
         {
            this._599453082groupMembers = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"groupMembers",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myFrame() : MyFrame
      {
         return this._1485920033myFrame;
      }
      
      public function set myFrame(param1:MyFrame) : void
      {
         var _loc2_:Object = this._1485920033myFrame;
         if(_loc2_ !== param1)
         {
            this._1485920033myFrame = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myFrame",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rtmScreen() : RTMScreen
      {
         return this._835955383rtmScreen;
      }
      
      public function set rtmScreen(param1:RTMScreen) : void
      {
         var _loc2_:Object = this._835955383rtmScreen;
         if(_loc2_ !== param1)
         {
            this._835955383rtmScreen = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rtmScreen",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : GameModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:GameModel) : void
      {
         var _loc2_:Object = this._104069929model;
         if(_loc2_ !== param1)
         {
            this._104069929model = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"model",_loc2_,param1));
            }
         }
      }
   }
}

