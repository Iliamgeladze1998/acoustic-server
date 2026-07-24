package soul.view.rtm
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
   import soul.controller.shortcut.Shortcut;
   import soul.controller.shortcut.ShortcutManager;
   import soul.event.FieldEvent;
   import soul.event.RTMEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.GameModel;
   import soul.model.achievement.AchievementModel;
   import soul.model.character.CharacterModel;
   import soul.model.common.InteractionType;
   import soul.model.cooldown.CooldownModel;
   import soul.model.field.FieldUnit;
   import soul.model.interaction.lfg.GroupApplication;
   import soul.model.inventory.InventoryModel;
   import soul.model.rtm.RTMModel;
   import soul.view.assets.Assets;
   import soul.view.assets.GlowIcon;
   import soul.view.assets.SelectButton;
   import soul.view.common.Icons;
   import soul.view.field.FieldView;
   import soul.view.field.IFieldView;
   import soul.view.fps.Fps;
   import soul.view.interaction.inventory.RTMWeapon;
   import soul.view.interaction.lfg.LFGIcon;
   import soul.view.popups.EdgeSelector;
   import soul.view.rtm.errorFrame.ErrorMessages;
   import soul.view.rtm.targetFrame.TargetFrame;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Component;
   import soul.view.ui.Container;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   
   use namespace mx_internal;
   
   public class RTMScreen extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public static var fieldClass:Class = FieldView;
      
      public var _RTMScreen_AchievementAnnounce1:AchievementAnnounce;
      
      public var _RTMScreen_CachedImage1:CachedImage;
      
      public var _RTMScreen_CastBar1:CastBar;
      
      public var _RTMScreen_GlowIcon1:GlowIcon;
      
      public var _RTMScreen_GlowIcon2:GlowIcon;
      
      public var _RTMScreen_LFGIcon1:LFGIcon;
      
      public var _RTMScreen_Label1:Label;
      
      public var _RTMScreen_MapModeRenderer1:MapModeRenderer;
      
      public var _RTMScreen_MiniMap1:MiniMap;
      
      public var _RTMScreen_NearsetObjects1:NearsetObjects;
      
      public var _RTMScreen_RTMClock1:RTMClock;
      
      public var _RTMScreen_RTMTimer1:RTMTimer;
      
      public var _RTMScreen_RTMWeapon1:RTMWeapon;
      
      private var _1171830972edgeSelector:EdgeSelector;
      
      private var _522372096edgeSelectorBtn:CachedImage;
      
      private var _1992713049errorContainer:ErrorMessages;
      
      private var _427180974mapButton:CachedImage;
      
      private var _1549806286runMode:SelectButton;
      
      private var _2107729316targetFrame:TargetFrame;
      
      public var field:IFieldView;
      
      private var _104069929model:GameModel;
      
      private var stickers:Object;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function RTMScreen()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this.field = new fieldClass();
         this.stickers = {};
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         bindings = this._RTMScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_rtm_RTMScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return RTMScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._RTMScreen_Fps1_c(),this._RTMScreen_TargetFrame1_i(),this._RTMScreen_MapModeRenderer1_i(),this._RTMScreen_MiniMap1_i(),this._RTMScreen_CachedImage1_i(),this._RTMScreen_Label1_i(),this._RTMScreen_RTMClock1_i(),this._RTMScreen_CachedImage2_i(),this._RTMScreen_HBox1_c(),this._RTMScreen_Container1_c(),this._RTMScreen_SelectButton1_i(),this._RTMScreen_CachedImage3_i(),this._RTMScreen_LFGIcon1_i(),this._RTMScreen_RTMWeapon1_i(),this._RTMScreen_ErrorMessages1_i(),this._RTMScreen_AchievementAnnounce1_i(),this._RTMScreen_NearsetObjects1_i(),this._RTMScreen_CastBar1_i(),this._RTMScreen_RTMTimer1_i()];
         this.addEventListener("creationComplete",this.___RTMScreen_Canvas1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         RTMScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         var component:Component = this.field as Component;
         component.percentWidth = component.percentHeight = 100;
         addChildAt(component,0);
         addEventListener(Event.REMOVED,this.removed);
         this.runMode.addEventListener(MouseEvent.CLICK,this.switchRun);
         this.mapButton.addEventListener(MouseEvent.CLICK,this.openMap);
         this.edgeSelectorBtn.addEventListener(MouseEvent.CLICK,this.openEdgeMenu);
         this.model.rtmModel.addEventListener(FieldEvent.STICK_TARGET,this.stickTarget);
         this.model.rtmModel.addEventListener(FieldEvent.CLEAN_NPC_STICKS,this.cleanNpcSticks);
         this.model.rtmModel.addEventListener(FieldEvent.CLEAN_STICKS,this.cleanSticks);
         ShortcutManager.addShortcutListener(Shortcut.QUEST,this.openQuests,0,false);
         ShortcutManager.addShortcutListener(Shortcut.TALENTS,this.openTalents,0,false);
         ShortcutManager.addShortcutListener(Shortcut.FRIENDS,this.openFriends,0,false);
         ShortcutManager.addShortcutListener(Shortcut.MAP,this.openMap,0,false);
      }
      
      private function removed(e:Event) : void
      {
         var sticker:Sticker = null;
         if(e.target != this)
         {
            return;
         }
         this.runMode.removeEventListener(MouseEvent.CLICK,this.switchRun);
         this.mapButton.removeEventListener(MouseEvent.CLICK,this.openMap);
         this.edgeSelectorBtn.removeEventListener(MouseEvent.CLICK,this.openEdgeMenu);
         this.model.rtmModel.removeEventListener(FieldEvent.STICK_TARGET,this.stickTarget);
         this.model.rtmModel.addEventListener(FieldEvent.CLEAN_NPC_STICKS,this.cleanNpcSticks);
         this.model.rtmModel.addEventListener(FieldEvent.CLEAN_STICKS,this.cleanSticks);
         ShortcutManager.removeShortcutListener(Shortcut.QUEST,this.openQuests,false);
         ShortcutManager.removeShortcutListener(Shortcut.TALENTS,this.openTalents,false);
         ShortcutManager.removeShortcutListener(Shortcut.FRIENDS,this.openFriends,false);
         ShortcutManager.removeShortcutListener(Shortcut.MAP,this.openMap,false);
         for each(sticker in this.stickers)
         {
            this.closeSticker(sticker);
         }
         this.stickers = {};
      }
      
      private function openQuests(e:Event = null) : void
      {
         Interaction.toggle(InteractionType.QUESTS);
      }
      
      private function openAbilities(e:Event = null) : void
      {
         Interaction.toggle(InteractionType.ABILITIES);
      }
      
      private function openTalents(e:Event = null) : void
      {
         Interaction.toggle(InteractionType.TALENTS);
      }
      
      private function openFriends(e:Event = null) : void
      {
         Interaction.toggle(InteractionType.SOCIAL);
      }
      
      private function switchRun(e:Event) : void
      {
         var ne:RTMEvent = new RTMEvent(RTMEvent.SWITCH_RUN);
         this.model.rtmModel.dispatchEvent(ne);
      }
      
      private function openMap(e:Event) : void
      {
         Interaction.toggle(InteractionType.MAP);
      }
      
      private function openStats(e:Event) : void
      {
         Interaction.toggle(InteractionType.STATS);
      }
      
      private function openEdgeMenu(e:Event) : void
      {
         this.edgeSelector.show();
      }
      
      private function cleanSticks(e:FieldEvent) : void
      {
         var id:String = null;
         var sticker:Sticker = null;
         for(id in this.stickers)
         {
            sticker = this.stickers[id];
            this.closeSticker(sticker);
         }
      }
      
      private function cleanNpcSticks(e:FieldEvent) : void
      {
         var id:String = null;
         var sticker:Sticker = null;
         for(id in this.stickers)
         {
            sticker = this.stickers[id];
            if(!sticker.isPlayer)
            {
               this.closeSticker(sticker);
            }
         }
      }
      
      private function stickTarget(e:FieldEvent) : void
      {
         var characterId:String = e.data;
         var sticker:Sticker = this.stickers[characterId];
         if(Boolean(sticker))
         {
            this.closeSticker(sticker);
         }
         else
         {
            sticker = new Sticker();
            sticker.model = this.model.rtmModel;
            sticker.id = characterId;
            sticker.x = mouseX;
            sticker.y = mouseY;
            this.stickers[characterId] = sticker;
            addChild(sticker);
            sticker.addEventListener(Event.CLOSE,this.stickerWantsToClose);
         }
      }
      
      private function closeSticker(sticker:Sticker) : void
      {
         delete this.stickers[sticker.id];
         sticker.id = null;
         sticker.model = null;
         removeChild(sticker);
      }
      
      private function stickerWantsToClose(e:Event) : void
      {
         this.closeSticker(e.target as Sticker);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _RTMScreen_Fps1_c() : Fps
      {
         var _loc1_:Fps = new Fps();
         _loc1_.right = 5;
         _loc1_.bottom = 5;
         _loc1_.visible = true;
         return _loc1_;
      }
      
      private function _RTMScreen_TargetFrame1_i() : TargetFrame
      {
         var _loc1_:TargetFrame = new TargetFrame();
         _loc1_.horizontalCenter = 0;
         this.targetFrame = _loc1_;
         BindingManager.executeBindings(this,"targetFrame",this.targetFrame);
         return _loc1_;
      }
      
      private function _RTMScreen_MapModeRenderer1_i() : MapModeRenderer
      {
         var _loc1_:MapModeRenderer = new MapModeRenderer();
         _loc1_.right = 62;
         _loc1_.y = 3;
         _loc1_.width = 223;
         _loc1_.height = 17;
         this._RTMScreen_MapModeRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_RTMScreen_MapModeRenderer1",this._RTMScreen_MapModeRenderer1);
         return _loc1_;
      }
      
      private function _RTMScreen_MiniMap1_i() : MiniMap
      {
         var _loc1_:MiniMap = new MiniMap();
         _loc1_.right = 0;
         _loc1_.y = 0;
         this._RTMScreen_MiniMap1 = _loc1_;
         BindingManager.executeBindings(this,"_RTMScreen_MiniMap1",this._RTMScreen_MiniMap1);
         return _loc1_;
      }
      
      private function _RTMScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.right = 143;
         _loc1_.y = 0;
         _loc1_.mouseEnabled = false;
         this._RTMScreen_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_RTMScreen_CachedImage1",this._RTMScreen_CachedImage1);
         return _loc1_;
      }
      
      private function _RTMScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.right = 62;
         _loc1_.y = 0;
         _loc1_.width = 210;
         _loc1_.color = 14540253;
         _loc1_.fontSize = 12;
         _loc1_.truncateToFit = true;
         _loc1_.align = "center";
         this._RTMScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_RTMScreen_Label1",this._RTMScreen_Label1);
         return _loc1_;
      }
      
      private function _RTMScreen_RTMClock1_i() : RTMClock
      {
         var _loc1_:RTMClock = new RTMClock();
         _loc1_.right = 2;
         _loc1_.y = 1;
         this._RTMScreen_RTMClock1 = _loc1_;
         BindingManager.executeBindings(this,"_RTMScreen_RTMClock1",this._RTMScreen_RTMClock1);
         return _loc1_;
      }
      
      private function _RTMScreen_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.right = 258;
         _loc1_.y = 5;
         this.edgeSelectorBtn = _loc1_;
         BindingManager.executeBindings(this,"edgeSelectorBtn",this.edgeSelectorBtn);
         return _loc1_;
      }
      
      private function _RTMScreen_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.verticalAlign = "top";
         _loc1_.right = 141;
         _loc1_.y = 26;
         _loc1_.gap = -2;
         _loc1_.children = [this._RTMScreen_GlowIcon1_i(),this._RTMScreen_GlowIcon2_i()];
         return _loc1_;
      }
      
      private function _RTMScreen_GlowIcon1_i() : GlowIcon
      {
         var _loc1_:GlowIcon = new GlowIcon();
         _loc1_.addEventListener("click",this.___RTMScreen_GlowIcon1_click);
         this._RTMScreen_GlowIcon1 = _loc1_;
         BindingManager.executeBindings(this,"_RTMScreen_GlowIcon1",this._RTMScreen_GlowIcon1);
         return _loc1_;
      }
      
      public function ___RTMScreen_GlowIcon1_click(event:MouseEvent) : void
      {
         this.openQuests();
      }
      
      private function _RTMScreen_GlowIcon2_i() : GlowIcon
      {
         var _loc1_:GlowIcon = new GlowIcon();
         _loc1_.addEventListener("click",this.___RTMScreen_GlowIcon2_click);
         this._RTMScreen_GlowIcon2 = _loc1_;
         BindingManager.executeBindings(this,"_RTMScreen_GlowIcon2",this._RTMScreen_GlowIcon2);
         return _loc1_;
      }
      
      public function ___RTMScreen_GlowIcon2_click(event:MouseEvent) : void
      {
         this.openTalents();
      }
      
      private function _RTMScreen_Container1_c() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.right = 380;
         _loc1_.y = 26;
         _loc1_.children = [this._RTMScreen_EdgeSelector1_i()];
         return _loc1_;
      }
      
      private function _RTMScreen_EdgeSelector1_i() : EdgeSelector
      {
         var _loc1_:EdgeSelector = new EdgeSelector();
         this.edgeSelector = _loc1_;
         BindingManager.executeBindings(this,"edgeSelector",this.edgeSelector);
         return _loc1_;
      }
      
      private function _RTMScreen_SelectButton1_i() : SelectButton
      {
         var _loc1_:SelectButton = new SelectButton();
         _loc1_.right = 118;
         _loc1_.y = 21;
         this.runMode = _loc1_;
         BindingManager.executeBindings(this,"runMode",this.runMode);
         return _loc1_;
      }
      
      private function _RTMScreen_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.right = 3;
         _loc1_.y = 21;
         this.mapButton = _loc1_;
         BindingManager.executeBindings(this,"mapButton",this.mapButton);
         return _loc1_;
      }
      
      private function _RTMScreen_LFGIcon1_i() : LFGIcon
      {
         var _loc1_:LFGIcon = new LFGIcon();
         _loc1_.right = 120;
         _loc1_.y = 120;
         this._RTMScreen_LFGIcon1 = _loc1_;
         BindingManager.executeBindings(this,"_RTMScreen_LFGIcon1",this._RTMScreen_LFGIcon1);
         return _loc1_;
      }
      
      private function _RTMScreen_RTMWeapon1_i() : RTMWeapon
      {
         var _loc1_:RTMWeapon = new RTMWeapon();
         _loc1_.right = 0;
         _loc1_.y = 163;
         this._RTMScreen_RTMWeapon1 = _loc1_;
         BindingManager.executeBindings(this,"_RTMScreen_RTMWeapon1",this._RTMScreen_RTMWeapon1);
         return _loc1_;
      }
      
      private function _RTMScreen_ErrorMessages1_i() : ErrorMessages
      {
         var _loc1_:ErrorMessages = new ErrorMessages();
         _loc1_.right = 60;
         _loc1_.bottom = 50;
         _loc1_.width = 300;
         _loc1_.height = 150;
         this.errorContainer = _loc1_;
         BindingManager.executeBindings(this,"errorContainer",this.errorContainer);
         return _loc1_;
      }
      
      private function _RTMScreen_AchievementAnnounce1_i() : AchievementAnnounce
      {
         var _loc1_:AchievementAnnounce = new AchievementAnnounce();
         _loc1_.horizontalCenter = 0;
         _loc1_.bottom = 100;
         this._RTMScreen_AchievementAnnounce1 = _loc1_;
         BindingManager.executeBindings(this,"_RTMScreen_AchievementAnnounce1",this._RTMScreen_AchievementAnnounce1);
         return _loc1_;
      }
      
      private function _RTMScreen_NearsetObjects1_i() : NearsetObjects
      {
         var _loc1_:NearsetObjects = new NearsetObjects();
         _loc1_.horizontalCenter = 0;
         _loc1_.bottom = 90;
         this._RTMScreen_NearsetObjects1 = _loc1_;
         BindingManager.executeBindings(this,"_RTMScreen_NearsetObjects1",this._RTMScreen_NearsetObjects1);
         return _loc1_;
      }
      
      private function _RTMScreen_CastBar1_i() : CastBar
      {
         var _loc1_:CastBar = new CastBar();
         _loc1_.horizontalCenter = 0;
         _loc1_.bottom = 95;
         this._RTMScreen_CastBar1 = _loc1_;
         BindingManager.executeBindings(this,"_RTMScreen_CastBar1",this._RTMScreen_CastBar1);
         return _loc1_;
      }
      
      private function _RTMScreen_RTMTimer1_i() : RTMTimer
      {
         var _loc1_:RTMTimer = new RTMTimer();
         _loc1_.horizontalCenter = 0;
         _loc1_.y = 100;
         this._RTMScreen_RTMTimer1 = _loc1_;
         BindingManager.executeBindings(this,"_RTMScreen_RTMTimer1",this._RTMScreen_RTMTimer1);
         return _loc1_;
      }
      
      public function ___RTMScreen_Canvas1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _RTMScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():FieldUnit
         {
            return model.rtmModel.targetUnit;
         },null,"targetFrame.unit");
         result[1] = new Binding(this,function():RTMModel
         {
            return model.rtmModel;
         },null,"targetFrame.model");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = model.rtmModel.pvpState;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RTMScreen_MapModeRenderer1.status");
         result[3] = new Binding(this,function():CharacterModel
         {
            return model.characterModel;
         },null,"_RTMScreen_MiniMap1.characterModel");
         result[4] = new Binding(this,function():RTMModel
         {
            return model.rtmModel;
         },null,"_RTMScreen_MiniMap1.model");
         result[5] = new Binding(this,function():Object
         {
            return Assets.mapCornerTop;
         },null,"_RTMScreen_CachedImage1.source");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = model.rtmModel.mapName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RTMScreen_Label1.text");
         result[7] = new Binding(this,function():Array
         {
            var _loc1_:* = [new DropShadowFilter(2,45,0,1,2,2)];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_RTMScreen_Label1.filters");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = getString("serverTime");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RTMScreen_RTMClock1.toolTip");
         result[9] = new Binding(this,function():Object
         {
            return Icons.edgeButton;
         },null,"edgeSelectorBtn.source");
         result[10] = new Binding(this,function():Boolean
         {
            return model.rtmModel.mapEdge > -1;
         },null,"edgeSelectorBtn.visible");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = model.rtmModel.mapEdge > -1 ? getString("edge") + "" + (model.rtmModel.mapEdge + 1) : "";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"edgeSelectorBtn.toolTip");
         result[12] = new Binding(this,function():Object
         {
            return Icons.journal;
         },null,"_RTMScreen_GlowIcon1.source");
         result[13] = new Binding(this,function():String
         {
            var _loc1_:* = getString("questLog.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RTMScreen_GlowIcon1.toolTip");
         result[14] = new Binding(this,function():Object
         {
            return Icons.ability;
         },null,"_RTMScreen_GlowIcon2.source");
         result[15] = new Binding(this,function():String
         {
            var _loc1_:* = getString("abilities.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RTMScreen_GlowIcon2.toolTip");
         result[16] = new Binding(this,function():RTMModel
         {
            return model.rtmModel;
         },null,"edgeSelector.model");
         result[17] = new Binding(this,function():String
         {
            var _loc1_:* = getString("run");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"runMode.toolTip");
         result[18] = new Binding(this,function():Object
         {
            return Icons.runOff;
         },null,"runMode.skin");
         result[19] = new Binding(this,function():Object
         {
            return Icons.runOn;
         },null,"runMode.selectedSkin");
         result[20] = new Binding(this,function():Boolean
         {
            return model.characterModel.runMode;
         },null,"runMode.selected");
         result[21] = new Binding(this,function():Object
         {
            return Icons.map;
         },null,"mapButton.source");
         result[22] = new Binding(this,function():GroupApplication
         {
            return model.lfgModel.currentApplication;
         },null,"_RTMScreen_LFGIcon1.application");
         result[23] = new Binding(this,function():RTMModel
         {
            return model.rtmModel;
         },null,"_RTMScreen_RTMWeapon1.model");
         result[24] = new Binding(this,function():InventoryModel
         {
            return model.inventoryModel;
         },null,"_RTMScreen_RTMWeapon1.inventoryModel");
         result[25] = new Binding(this,function():CooldownModel
         {
            return model.cooldownModel;
         },null,"_RTMScreen_RTMWeapon1.cooldownModel");
         result[26] = new Binding(this,function():CharacterModel
         {
            return model.characterModel;
         },null,"_RTMScreen_RTMWeapon1.characterModel");
         result[27] = new Binding(this,function():AchievementModel
         {
            return model.achievementModel;
         },null,"_RTMScreen_AchievementAnnounce1.model");
         result[28] = new Binding(this,function():Array
         {
            var _loc1_:* = model.rtmModel.nearestObjects;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_RTMScreen_NearsetObjects1.dataProvider");
         result[29] = new Binding(this,function():RTMModel
         {
            return model.rtmModel;
         },null,"_RTMScreen_NearsetObjects1.model");
         result[30] = new Binding(this,function():int
         {
            return model.rtmModel.myUnit.castingTime;
         },null,"_RTMScreen_CastBar1.time");
         result[31] = new Binding(this,function():int
         {
            return model.rtmModel.timeout;
         },null,"_RTMScreen_RTMTimer1.timeout");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get edgeSelector() : EdgeSelector
      {
         return this._1171830972edgeSelector;
      }
      
      public function set edgeSelector(param1:EdgeSelector) : void
      {
         var _loc2_:Object = this._1171830972edgeSelector;
         if(_loc2_ !== param1)
         {
            this._1171830972edgeSelector = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"edgeSelector",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get edgeSelectorBtn() : CachedImage
      {
         return this._522372096edgeSelectorBtn;
      }
      
      public function set edgeSelectorBtn(param1:CachedImage) : void
      {
         var _loc2_:Object = this._522372096edgeSelectorBtn;
         if(_loc2_ !== param1)
         {
            this._522372096edgeSelectorBtn = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"edgeSelectorBtn",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get errorContainer() : ErrorMessages
      {
         return this._1992713049errorContainer;
      }
      
      public function set errorContainer(param1:ErrorMessages) : void
      {
         var _loc2_:Object = this._1992713049errorContainer;
         if(_loc2_ !== param1)
         {
            this._1992713049errorContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"errorContainer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapButton() : CachedImage
      {
         return this._427180974mapButton;
      }
      
      public function set mapButton(param1:CachedImage) : void
      {
         var _loc2_:Object = this._427180974mapButton;
         if(_loc2_ !== param1)
         {
            this._427180974mapButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get runMode() : SelectButton
      {
         return this._1549806286runMode;
      }
      
      public function set runMode(param1:SelectButton) : void
      {
         var _loc2_:Object = this._1549806286runMode;
         if(_loc2_ !== param1)
         {
            this._1549806286runMode = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"runMode",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get targetFrame() : TargetFrame
      {
         return this._2107729316targetFrame;
      }
      
      public function set targetFrame(param1:TargetFrame) : void
      {
         var _loc2_:Object = this._2107729316targetFrame;
         if(_loc2_ !== param1)
         {
            this._2107729316targetFrame = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"targetFrame",_loc2_,param1));
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

