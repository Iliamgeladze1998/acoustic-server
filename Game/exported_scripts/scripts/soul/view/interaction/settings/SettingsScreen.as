package soul.view.interaction.settings
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.DropShadowFilter;
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
   import soul.controller.Interaction;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.GameEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.common.InteractionType;
   import soul.model.interaction.settings.CameraFollowType;
   import soul.model.interaction.settings.DamageDisplay;
   import soul.model.interaction.settings.FowDisplay;
   import soul.model.interaction.settings.SettingsModel;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.GradientBox;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.Canvas;
   import soul.view.ui.Checkbox;
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.RadioButton;
   import soul.view.ui.RadioButtonGroup;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class SettingsScreen extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const SHADOW:Array = [new DropShadowFilter(2,45,0,1,0,0,1)];
      
      public var _SettingsScreen_BorderedContainer1:BorderedContainer;
      
      public var _SettingsScreen_Button12:Button1;
      
      public var _SettingsScreen_Label1:Label;
      
      public var _SettingsScreen_Label2:Label;
      
      public var _SettingsScreen_Label3:Label;
      
      public var _SettingsScreen_Label4:Label;
      
      public var _SettingsScreen_RadioButton1:RadioButton;
      
      public var _SettingsScreen_RadioButton2:RadioButton;
      
      public var _SettingsScreen_RadioButton3:RadioButton;
      
      public var _SettingsScreen_RadioButton4:RadioButton;
      
      public var _SettingsScreen_RadioButton5:RadioButton;
      
      public var _SettingsScreen_RadioButton6:RadioButton;
      
      public var _SettingsScreen_RadioButton7:RadioButton;
      
      public var _SettingsScreen_RadioButton8:RadioButton;
      
      public var _SettingsScreen_RadioButton9:RadioButton;
      
      private var _1943129152applyButton:Button1;
      
      private var _2036953690cameraGroup:RadioButtonGroup;
      
      private var _1990244730cbFullscreen:Checkbox;
      
      private var _800606288damageGroup:RadioButtonGroup;
      
      private var _582634065fowGroup:RadioButtonGroup;
      
      private var _170535940lighing:Checkbox;
      
      private var _104069929model:SettingsModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SettingsScreen()
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
         bindings = this._SettingsScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_settings_SettingsScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return SettingsScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 400;
         this.height = 420;
         this.padding = 9;
         this.children = [this._SettingsScreen_BorderedContainer1_i()];
         this._SettingsScreen_RadioButtonGroup3_i();
         this._SettingsScreen_RadioButtonGroup1_i();
         this._SettingsScreen_RadioButtonGroup2_i();
         this.addEventListener("creationComplete",this.___SettingsScreen_Canvas1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SettingsScreen._watcherSetupUtil = param1;
      }
      
      protected function creationComplete() : void
      {
         InteractionWindow.setLabelToInteractionParent(this,this.getString("settings.title"));
         this.applyButton.enabled = false;
      }
      
      private function onChange() : void
      {
         this.applyButton.enabled = true;
      }
      
      private function changeFullScreen() : void
      {
         this.model.dispatchEvent(new GameEvent(GameEvent.SWITCH_FULLSCREEN));
      }
      
      private function apply() : void
      {
         this.model.showLighting = this.lighing.selected;
         this.model.damageDisplay = uint(this.damageGroup.selectedValue);
         this.model.fowDisplay = uint(this.fowGroup.selectedValue);
         this.model.cameraFollowType = uint(this.cameraGroup.selectedValue);
         this.applyButton.enabled = false;
         if(this.cbFullscreen.selected != this.model.fullScreen)
         {
            this.changeFullScreen();
         }
      }
      
      private function close() : void
      {
         Interaction.hide(InteractionType.SETTINGS);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _SettingsScreen_RadioButtonGroup3_i() : RadioButtonGroup
      {
         var _loc1_:RadioButtonGroup = new RadioButtonGroup();
         _loc1_.addEventListener("change",this.__cameraGroup_change);
         this.cameraGroup = _loc1_;
         BindingManager.executeBindings(this,"cameraGroup",this.cameraGroup);
         return _loc1_;
      }
      
      public function __cameraGroup_change(event:Event) : void
      {
         this.onChange();
      }
      
      private function _SettingsScreen_RadioButtonGroup1_i() : RadioButtonGroup
      {
         var _loc1_:RadioButtonGroup = new RadioButtonGroup();
         _loc1_.addEventListener("change",this.__damageGroup_change);
         this.damageGroup = _loc1_;
         BindingManager.executeBindings(this,"damageGroup",this.damageGroup);
         return _loc1_;
      }
      
      public function __damageGroup_change(event:Event) : void
      {
         this.onChange();
      }
      
      private function _SettingsScreen_RadioButtonGroup2_i() : RadioButtonGroup
      {
         var _loc1_:RadioButtonGroup = new RadioButtonGroup();
         _loc1_.addEventListener("change",this.__fowGroup_change);
         this.fowGroup = _loc1_;
         BindingManager.executeBindings(this,"fowGroup",this.fowGroup);
         return _loc1_;
      }
      
      public function __fowGroup_change(event:Event) : void
      {
         this.onChange();
      }
      
      private function _SettingsScreen_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.direction = "vertical";
         _loc1_.left = 0;
         _loc1_.top = 0;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.padding = 3;
         _loc1_.children = [this._SettingsScreen_GradientBox1_c(),this._SettingsScreen_VBox1_c(),this._SettingsScreen_GradientBox2_c(),this._SettingsScreen_VBox2_c(),this._SettingsScreen_GradientBox3_c(),this._SettingsScreen_VBox3_c(),this._SettingsScreen_GradientBox4_c(),this._SettingsScreen_VBox4_c(),this._SettingsScreen_Component1_c(),this._SettingsScreen_HBox1_c(),this._SettingsScreen_Component2_c()];
         this._SettingsScreen_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_SettingsScreen_BorderedContainer1",this._SettingsScreen_BorderedContainer1);
         return _loc1_;
      }
      
      private function _SettingsScreen_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 20;
         _loc1_.children = [this._SettingsScreen_Label1_i()];
         return _loc1_;
      }
      
      private function _SettingsScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         _loc1_.horizontalCenter = 0;
         this._SettingsScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_SettingsScreen_Label1",this._SettingsScreen_Label1);
         return _loc1_;
      }
      
      private function _SettingsScreen_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.padding = 5;
         _loc1_.gap = 2;
         _loc1_.children = [this._SettingsScreen_RadioButton1_i(),this._SettingsScreen_RadioButton2_i(),this._SettingsScreen_RadioButton3_i()];
         return _loc1_;
      }
      
      private function _SettingsScreen_RadioButton1_i() : RadioButton
      {
         var _loc1_:RadioButton = new RadioButton();
         this._SettingsScreen_RadioButton1 = _loc1_;
         BindingManager.executeBindings(this,"_SettingsScreen_RadioButton1",this._SettingsScreen_RadioButton1);
         return _loc1_;
      }
      
      private function _SettingsScreen_RadioButton2_i() : RadioButton
      {
         var _loc1_:RadioButton = new RadioButton();
         this._SettingsScreen_RadioButton2 = _loc1_;
         BindingManager.executeBindings(this,"_SettingsScreen_RadioButton2",this._SettingsScreen_RadioButton2);
         return _loc1_;
      }
      
      private function _SettingsScreen_RadioButton3_i() : RadioButton
      {
         var _loc1_:RadioButton = new RadioButton();
         this._SettingsScreen_RadioButton3 = _loc1_;
         BindingManager.executeBindings(this,"_SettingsScreen_RadioButton3",this._SettingsScreen_RadioButton3);
         return _loc1_;
      }
      
      private function _SettingsScreen_GradientBox2_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 20;
         _loc1_.children = [this._SettingsScreen_Label2_i()];
         return _loc1_;
      }
      
      private function _SettingsScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         _loc1_.horizontalCenter = 0;
         this._SettingsScreen_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_SettingsScreen_Label2",this._SettingsScreen_Label2);
         return _loc1_;
      }
      
      private function _SettingsScreen_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.padding = 5;
         _loc1_.gap = 2;
         _loc1_.children = [this._SettingsScreen_Checkbox1_i(),this._SettingsScreen_Checkbox2_i()];
         return _loc1_;
      }
      
      private function _SettingsScreen_Checkbox1_i() : Checkbox
      {
         var _loc1_:Checkbox = new Checkbox();
         _loc1_.addEventListener("change",this.__lighing_change);
         this.lighing = _loc1_;
         BindingManager.executeBindings(this,"lighing",this.lighing);
         return _loc1_;
      }
      
      public function __lighing_change(event:Event) : void
      {
         this.onChange();
      }
      
      private function _SettingsScreen_Checkbox2_i() : Checkbox
      {
         var _loc1_:Checkbox = new Checkbox();
         _loc1_.bottom = 0;
         _loc1_.addEventListener("change",this.__cbFullscreen_change);
         this.cbFullscreen = _loc1_;
         BindingManager.executeBindings(this,"cbFullscreen",this.cbFullscreen);
         return _loc1_;
      }
      
      public function __cbFullscreen_change(event:Event) : void
      {
         this.onChange();
      }
      
      private function _SettingsScreen_GradientBox3_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 20;
         _loc1_.children = [this._SettingsScreen_Label3_i()];
         return _loc1_;
      }
      
      private function _SettingsScreen_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         _loc1_.horizontalCenter = 0;
         this._SettingsScreen_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_SettingsScreen_Label3",this._SettingsScreen_Label3);
         return _loc1_;
      }
      
      private function _SettingsScreen_VBox3_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.padding = 5;
         _loc1_.gap = 2;
         _loc1_.children = [this._SettingsScreen_RadioButton4_i(),this._SettingsScreen_RadioButton5_i(),this._SettingsScreen_RadioButton6_i()];
         return _loc1_;
      }
      
      private function _SettingsScreen_RadioButton4_i() : RadioButton
      {
         var _loc1_:RadioButton = new RadioButton();
         this._SettingsScreen_RadioButton4 = _loc1_;
         BindingManager.executeBindings(this,"_SettingsScreen_RadioButton4",this._SettingsScreen_RadioButton4);
         return _loc1_;
      }
      
      private function _SettingsScreen_RadioButton5_i() : RadioButton
      {
         var _loc1_:RadioButton = new RadioButton();
         this._SettingsScreen_RadioButton5 = _loc1_;
         BindingManager.executeBindings(this,"_SettingsScreen_RadioButton5",this._SettingsScreen_RadioButton5);
         return _loc1_;
      }
      
      private function _SettingsScreen_RadioButton6_i() : RadioButton
      {
         var _loc1_:RadioButton = new RadioButton();
         this._SettingsScreen_RadioButton6 = _loc1_;
         BindingManager.executeBindings(this,"_SettingsScreen_RadioButton6",this._SettingsScreen_RadioButton6);
         return _loc1_;
      }
      
      private function _SettingsScreen_GradientBox4_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 20;
         _loc1_.children = [this._SettingsScreen_Label4_i()];
         return _loc1_;
      }
      
      private function _SettingsScreen_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         _loc1_.horizontalCenter = 0;
         this._SettingsScreen_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_SettingsScreen_Label4",this._SettingsScreen_Label4);
         return _loc1_;
      }
      
      private function _SettingsScreen_VBox4_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.padding = 5;
         _loc1_.gap = 2;
         _loc1_.children = [this._SettingsScreen_RadioButton7_i(),this._SettingsScreen_RadioButton8_i(),this._SettingsScreen_RadioButton9_i()];
         return _loc1_;
      }
      
      private function _SettingsScreen_RadioButton7_i() : RadioButton
      {
         var _loc1_:RadioButton = new RadioButton();
         this._SettingsScreen_RadioButton7 = _loc1_;
         BindingManager.executeBindings(this,"_SettingsScreen_RadioButton7",this._SettingsScreen_RadioButton7);
         return _loc1_;
      }
      
      private function _SettingsScreen_RadioButton8_i() : RadioButton
      {
         var _loc1_:RadioButton = new RadioButton();
         this._SettingsScreen_RadioButton8 = _loc1_;
         BindingManager.executeBindings(this,"_SettingsScreen_RadioButton8",this._SettingsScreen_RadioButton8);
         return _loc1_;
      }
      
      private function _SettingsScreen_RadioButton9_i() : RadioButton
      {
         var _loc1_:RadioButton = new RadioButton();
         this._SettingsScreen_RadioButton9 = _loc1_;
         BindingManager.executeBindings(this,"_SettingsScreen_RadioButton9",this._SettingsScreen_RadioButton9);
         return _loc1_;
      }
      
      private function _SettingsScreen_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentHeight = 100;
         return _loc1_;
      }
      
      private function _SettingsScreen_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.percentWidth = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.children = [this._SettingsScreen_Button11_i(),this._SettingsScreen_Button12_i()];
         return _loc1_;
      }
      
      private function _SettingsScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.percentWidth = 30;
         _loc1_.addEventListener("click",this.__applyButton_click);
         this.applyButton = _loc1_;
         BindingManager.executeBindings(this,"applyButton",this.applyButton);
         return _loc1_;
      }
      
      public function __applyButton_click(event:MouseEvent) : void
      {
         this.apply();
      }
      
      private function _SettingsScreen_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.percentWidth = 30;
         _loc1_.addEventListener("click",this.___SettingsScreen_Button12_click);
         this._SettingsScreen_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_SettingsScreen_Button12",this._SettingsScreen_Button12);
         return _loc1_;
      }
      
      public function ___SettingsScreen_Button12_click(event:MouseEvent) : void
      {
         this.close();
      }
      
      private function _SettingsScreen_Component2_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.height = 9;
         return _loc1_;
      }
      
      public function ___SettingsScreen_Canvas1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _SettingsScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return model.damageDisplay;
         },null,"damageGroup.selectedValue");
         result[1] = new Binding(this,function():Object
         {
            return model.fowDisplay;
         },null,"fowGroup.selectedValue");
         result[2] = new Binding(this,function():Object
         {
            return model.cameraFollowType;
         },null,"cameraGroup.selectedValue");
         result[3] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_SettingsScreen_BorderedContainer1.borderSkin");
         result[4] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"_SettingsScreen_BorderedContainer1.backgroundImage");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = getString("combat.settings");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_Label1.text");
         result[6] = new Binding(this,function():Array
         {
            var _loc1_:* = SHADOW;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_SettingsScreen_Label1.filters");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = getString("player_damage.label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton1.label");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = getString("player_damage.description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton1.toolTip");
         result[9] = new Binding(this,null,null,"_SettingsScreen_RadioButton1.group","damageGroup");
         result[10] = new Binding(this,function():Object
         {
            return DamageDisplay.PLAYER_DISPLAY;
         },null,"_SettingsScreen_RadioButton1.value");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = getString("all_damage.label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton2.label");
         result[12] = new Binding(this,function():String
         {
            var _loc1_:* = getString("all_damage.description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton2.toolTip");
         result[13] = new Binding(this,null,null,"_SettingsScreen_RadioButton2.group","damageGroup");
         result[14] = new Binding(this,function():Object
         {
            return DamageDisplay.ALL_DISPLAY;
         },null,"_SettingsScreen_RadioButton2.value");
         result[15] = new Binding(this,function():String
         {
            var _loc1_:* = getString("no_damage.label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton3.label");
         result[16] = new Binding(this,function():String
         {
            var _loc1_:* = getString("no_damage.description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton3.toolTip");
         result[17] = new Binding(this,null,null,"_SettingsScreen_RadioButton3.group","damageGroup");
         result[18] = new Binding(this,function():Object
         {
            return DamageDisplay.NO_DISPLAY;
         },null,"_SettingsScreen_RadioButton3.value");
         result[19] = new Binding(this,function():String
         {
            var _loc1_:* = getString("game.settings");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_Label2.text");
         result[20] = new Binding(this,function():Array
         {
            var _loc1_:* = SHADOW;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_SettingsScreen_Label2.filters");
         result[21] = new Binding(this,function():String
         {
            var _loc1_:* = getString("lighting.label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"lighing.label");
         result[22] = new Binding(this,function():String
         {
            var _loc1_:* = getString("lighting.description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"lighing.toolTip");
         result[23] = new Binding(this,function():Boolean
         {
            return model.showLighting;
         },null,"lighing.selected");
         result[24] = new Binding(this,function():String
         {
            var _loc1_:* = getString("fullscreen.switch");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"cbFullscreen.label");
         result[25] = new Binding(this,function():String
         {
            var _loc1_:* = getString("fullscreen.description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"cbFullscreen.toolTip");
         result[26] = new Binding(this,function():Boolean
         {
            return model.fullScreen;
         },null,"cbFullscreen.selected");
         result[27] = new Binding(this,function():Boolean
         {
            return model.fullScreenAllowed;
         },null,"cbFullscreen.enabled");
         result[28] = new Binding(this,function():String
         {
            var _loc1_:* = getString("fow.settings");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_Label3.text");
         result[29] = new Binding(this,function():Array
         {
            var _loc1_:* = SHADOW;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_SettingsScreen_Label3.filters");
         result[30] = new Binding(this,function():String
         {
            var _loc1_:* = getString("fow_enabled.label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton4.label");
         result[31] = new Binding(this,function():String
         {
            var _loc1_:* = getString("fow_enabled.description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton4.toolTip");
         result[32] = new Binding(this,null,null,"_SettingsScreen_RadioButton4.group","fowGroup");
         result[33] = new Binding(this,function():Object
         {
            return FowDisplay.NORMAL;
         },null,"_SettingsScreen_RadioButton4.value");
         result[34] = new Binding(this,function():String
         {
            var _loc1_:* = getString("fow_line.label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton5.label");
         result[35] = new Binding(this,function():String
         {
            var _loc1_:* = getString("fow_line.description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton5.toolTip");
         result[36] = new Binding(this,null,null,"_SettingsScreen_RadioButton5.group","fowGroup");
         result[37] = new Binding(this,function():Object
         {
            return FowDisplay.LINE;
         },null,"_SettingsScreen_RadioButton5.value");
         result[38] = new Binding(this,function():String
         {
            var _loc1_:* = getString("fow_hidden.label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton6.label");
         result[39] = new Binding(this,function():String
         {
            var _loc1_:* = getString("fow_hidden.description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton6.toolTip");
         result[40] = new Binding(this,null,null,"_SettingsScreen_RadioButton6.group","fowGroup");
         result[41] = new Binding(this,function():Object
         {
            return FowDisplay.HIDDEN;
         },null,"_SettingsScreen_RadioButton6.value");
         result[42] = new Binding(this,function():String
         {
            var _loc1_:* = getString("camera.settings");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_Label4.text");
         result[43] = new Binding(this,function():Array
         {
            var _loc1_:* = SHADOW;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_SettingsScreen_Label4.filters");
         result[44] = new Binding(this,function():String
         {
            var _loc1_:* = getString("camera_follow_always.label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton7.label");
         result[45] = new Binding(this,function():String
         {
            var _loc1_:* = getString("camera_follow_always.description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton7.toolTip");
         result[46] = new Binding(this,null,null,"_SettingsScreen_RadioButton7.group","cameraGroup");
         result[47] = new Binding(this,function():Object
         {
            return CameraFollowType.ALWAYS;
         },null,"_SettingsScreen_RadioButton7.value");
         result[48] = new Binding(this,function():String
         {
            var _loc1_:* = getString("camera_follow_auto.label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton8.label");
         result[49] = new Binding(this,function():String
         {
            var _loc1_:* = getString("camera_follow_auto.description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton8.toolTip");
         result[50] = new Binding(this,null,null,"_SettingsScreen_RadioButton8.group","cameraGroup");
         result[51] = new Binding(this,function():Object
         {
            return CameraFollowType.AUTO;
         },null,"_SettingsScreen_RadioButton8.value");
         result[52] = new Binding(this,function():String
         {
            var _loc1_:* = getString("camera_follow_elastic.label");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton9.label");
         result[53] = new Binding(this,function():String
         {
            var _loc1_:* = getString("camera_follow_elastic.description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_RadioButton9.toolTip");
         result[54] = new Binding(this,null,null,"_SettingsScreen_RadioButton9.group","cameraGroup");
         result[55] = new Binding(this,function():Object
         {
            return CameraFollowType.ELASTIC;
         },null,"_SettingsScreen_RadioButton9.value");
         result[56] = new Binding(this,function():String
         {
            var _loc1_:* = getString("apply");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"applyButton.label");
         result[57] = new Binding(this,function():String
         {
            var _loc1_:* = getString("close");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SettingsScreen_Button12.label");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get applyButton() : Button1
      {
         return this._1943129152applyButton;
      }
      
      public function set applyButton(param1:Button1) : void
      {
         var _loc2_:Object = this._1943129152applyButton;
         if(_loc2_ !== param1)
         {
            this._1943129152applyButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"applyButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cameraGroup() : RadioButtonGroup
      {
         return this._2036953690cameraGroup;
      }
      
      public function set cameraGroup(param1:RadioButtonGroup) : void
      {
         var _loc2_:Object = this._2036953690cameraGroup;
         if(_loc2_ !== param1)
         {
            this._2036953690cameraGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cameraGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cbFullscreen() : Checkbox
      {
         return this._1990244730cbFullscreen;
      }
      
      public function set cbFullscreen(param1:Checkbox) : void
      {
         var _loc2_:Object = this._1990244730cbFullscreen;
         if(_loc2_ !== param1)
         {
            this._1990244730cbFullscreen = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cbFullscreen",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get damageGroup() : RadioButtonGroup
      {
         return this._800606288damageGroup;
      }
      
      public function set damageGroup(param1:RadioButtonGroup) : void
      {
         var _loc2_:Object = this._800606288damageGroup;
         if(_loc2_ !== param1)
         {
            this._800606288damageGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"damageGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fowGroup() : RadioButtonGroup
      {
         return this._582634065fowGroup;
      }
      
      public function set fowGroup(param1:RadioButtonGroup) : void
      {
         var _loc2_:Object = this._582634065fowGroup;
         if(_loc2_ !== param1)
         {
            this._582634065fowGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fowGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lighing() : Checkbox
      {
         return this._170535940lighing;
      }
      
      public function set lighing(param1:Checkbox) : void
      {
         var _loc2_:Object = this._170535940lighing;
         if(_loc2_ !== param1)
         {
            this._170535940lighing = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lighing",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : SettingsModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:SettingsModel) : void
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

