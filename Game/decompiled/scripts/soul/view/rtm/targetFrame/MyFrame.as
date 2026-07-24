package soul.view.rtm.targetFrame
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.GlowFilter;
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
   import soul.controller.MenuManager;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.controller.shortcut.Shortcut;
   import soul.controller.shortcut.ShortcutManager;
   import soul.event.FieldEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.GameModel;
   import soul.model.common.InteractionType;
   import soul.model.common.MenuType;
   import soul.model.field.BaseUnit;
   import soul.model.interaction.dashboard.DashboardModel;
   import soul.model.interaction.settings.SettingsModel;
   import soul.model.rtm.RTMModel;
   import soul.model.system.Configuration;
   import soul.view.assets.Assets;
   import soul.view.assets.GlitterImage;
   import soul.view.assets.GlowIcon;
   import soul.view.common.Icons;
   import soul.view.rtm.BarDrawer;
   import soul.view.rtm.Effects;
   import soul.view.rtm.EventIcon;
   import soul.view.rtm.ShortcutPanel;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   
   use namespace mx_internal;
   
   public class MyFrame extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const fightFilter:Array = [new GlowFilter(16711680,1,6,6,3,2,true)];
      
      public var _MyFrame_BarDrawer1:BarDrawer;
      
      public var _MyFrame_BarDrawer2:BarDrawer;
      
      public var _MyFrame_BarDrawer3:BarDrawer;
      
      public var _MyFrame_CachedImage2:CachedImage;
      
      public var _MyFrame_CachedImage3:CachedImage;
      
      public var _MyFrame_Effects1:Effects;
      
      public var _MyFrame_EventIcon1:EventIcon;
      
      public var _MyFrame_GlitterImage1:GlitterImage;
      
      public var _MyFrame_GlitterImage2:GlitterImage;
      
      public var _MyFrame_GlitterImage3:GlitterImage;
      
      public var _MyFrame_GlitterImage4:GlitterImage;
      
      public var _MyFrame_GlowIcon1:GlowIcon;
      
      public var _MyFrame_GlowIcon2:GlowIcon;
      
      public var _MyFrame_Label1:Label;
      
      public var _MyFrame_ShortcutPanel1:ShortcutPanel;
      
      public var _MyFrame_ShortcutPanel2:ShortcutPanel;
      
      public var _MyFrame_XpBar1:XpBar;
      
      private var _1405959847avatar:CachedImage;
      
      private var _104069929model:GameModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function MyFrame()
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
         bindings = this._MyFrame_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_rtm_targetFrame_MyFrameWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return MyFrame[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 546;
         this.height = 91;
         this.children = [this._MyFrame_BarDrawer1_i(),this._MyFrame_BarDrawer2_i(),this._MyFrame_BarDrawer3_i(),this._MyFrame_XpBar1_i(),this._MyFrame_CachedImage1_i(),this._MyFrame_CachedImage2_i(),this._MyFrame_Label1_i(),this._MyFrame_GlitterImage1_i(),this._MyFrame_CachedImage3_i(),this._MyFrame_GlowIcon1_i(),this._MyFrame_GlowIcon2_i(),this._MyFrame_Effects1_i(),this._MyFrame_HBox1_c(),this._MyFrame_Canvas2_c()];
         this.addEventListener("creationComplete",this.___MyFrame_Canvas1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         MyFrame._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         addEventListener(Event.REMOVED,this.removed);
         ShortcutManager.addShortcutListener(Shortcut.CHARACTER,this.openCharacterMenu,0,false);
         ShortcutManager.addShortcutListener(Shortcut.BACKPACK,this.openBackpack,0,false);
         var avatarMask:Shape = new Shape();
         avatarMask.graphics.beginFill(0);
         avatarMask.graphics.drawEllipse(0,0,this.avatar.width,this.avatar.height);
         avatarMask.graphics.endFill();
         this.avatar.addChild(avatarMask);
         this.avatar.mask = avatarMask;
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         ShortcutManager.removeShortcutListener(Shortcut.CHARACTER,this.openCharacterMenu,false);
         ShortcutManager.removeShortcutListener(Shortcut.BACKPACK,this.openBackpack,false);
      }
      
      private function openCharacterMenu(e:Event = null) : void
      {
         Interaction.toggle(InteractionType.CHARACTER);
      }
      
      private function openMail() : void
      {
         Interaction.toggle(InteractionType.MAIL);
      }
      
      private function openBackpack(e:Event = null) : void
      {
         if(this.model.characterModel.dead)
         {
            return;
         }
         Interaction.toggle(InteractionType.INVENTORY);
      }
      
      private function avatarClick() : void
      {
         var model:RTMModel = this.model.rtmModel;
         if(Boolean(model.activeAbility))
         {
            if(Boolean(model.myUnit) && model.myUnit.accepts(model.activeAbility))
            {
               model.activeUnit = model.myUnit;
               model.dispatchEvent(new Event(FieldEvent.ACCEPT_ABILITY));
            }
         }
      }
      
      private function menuClick() : void
      {
         MenuManager.create(MenuType.SELF_MENU);
      }
      
      private function getXP(xp:Number) : String
      {
         var s:String = String(Math.round(xp * 100) / 100);
         var dotIndex:int = s.indexOf(".");
         return dotIndex == -1 ? s + ".00" : (s.length - dotIndex < 3 ? s + "0" : s);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _MyFrame_BarDrawer1_i() : BarDrawer
      {
         var _loc1_:BarDrawer = null;
         _loc1_ = new BarDrawer();
         _loc1_.x = 213;
         _loc1_.y = 4;
         _loc1_.height = 17;
         _loc1_.width = 116;
         _loc1_.barColor = 8285001;
         _loc1_.labelVisible = false;
         _loc1_.backgroundColor = 0;
         this._MyFrame_BarDrawer1 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_BarDrawer1",this._MyFrame_BarDrawer1);
         return _loc1_;
      }
      
      private function _MyFrame_BarDrawer2_i() : BarDrawer
      {
         var _loc1_:BarDrawer = new BarDrawer();
         _loc1_.x = 2;
         _loc1_.y = 14;
         _loc1_.height = 10;
         _loc1_.width = 218;
         _loc1_.alertsActive = true;
         _loc1_.labelVisible = true;
         _loc1_.backgroundColor = 0;
         this._MyFrame_BarDrawer2 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_BarDrawer2",this._MyFrame_BarDrawer2);
         return _loc1_;
      }
      
      private function _MyFrame_BarDrawer3_i() : BarDrawer
      {
         var _loc1_:BarDrawer = new BarDrawer();
         _loc1_.x = 330;
         _loc1_.y = 14;
         _loc1_.height = 10;
         _loc1_.width = 214;
         _loc1_.barColor = 20354;
         _loc1_.labelVisible = true;
         _loc1_.backgroundColor = 0;
         this._MyFrame_BarDrawer3 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_BarDrawer3",this._MyFrame_BarDrawer3);
         return _loc1_;
      }
      
      private function _MyFrame_XpBar1_i() : XpBar
      {
         var _loc1_:XpBar = new XpBar();
         _loc1_.x = 2;
         _loc1_.y = 81;
         _loc1_.height = 7;
         _loc1_.width = 543;
         this._MyFrame_XpBar1 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_XpBar1",this._MyFrame_XpBar1);
         return _loc1_;
      }
      
      private function _MyFrame_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 243;
         _loc1_.y = 13;
         _loc1_.width = 60;
         _loc1_.height = 60;
         _loc1_.addEventListener("click",this.__avatar_click);
         this.avatar = _loc1_;
         BindingManager.executeBindings(this,"avatar",this.avatar);
         return _loc1_;
      }
      
      public function __avatar_click(event:MouseEvent) : void
      {
         this.avatarClick();
      }
      
      private function _MyFrame_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.mouseEnabled = false;
         this._MyFrame_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_CachedImage2",this._MyFrame_CachedImage2);
         return _loc1_;
      }
      
      private function _MyFrame_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 207;
         _loc1_.y = 20;
         _loc1_.fontSize = 10;
         _loc1_.width = 24;
         _loc1_.height = 17;
         _loc1_.align = "center";
         _loc1_.bold = true;
         this._MyFrame_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_Label1",this._MyFrame_Label1);
         return _loc1_;
      }
      
      private function _MyFrame_GlitterImage1_i() : GlitterImage
      {
         var _loc1_:GlitterImage = new GlitterImage();
         _loc1_.x = 209;
         _loc1_.y = 19;
         this._MyFrame_GlitterImage1 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_GlitterImage1",this._MyFrame_GlitterImage1);
         return _loc1_;
      }
      
      private function _MyFrame_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 316;
         _loc1_.y = 19;
         _loc1_.addEventListener("click",this.___MyFrame_CachedImage3_click);
         this._MyFrame_CachedImage3 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_CachedImage3",this._MyFrame_CachedImage3);
         return _loc1_;
      }
      
      public function ___MyFrame_CachedImage3_click(event:MouseEvent) : void
      {
         this.menuClick();
      }
      
      private function _MyFrame_GlowIcon1_i() : GlowIcon
      {
         var _loc1_:GlowIcon = new GlowIcon();
         _loc1_.x = 205;
         _loc1_.y = 43;
         _loc1_.addEventListener("click",this.___MyFrame_GlowIcon1_click);
         this._MyFrame_GlowIcon1 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_GlowIcon1",this._MyFrame_GlowIcon1);
         return _loc1_;
      }
      
      public function ___MyFrame_GlowIcon1_click(event:MouseEvent) : void
      {
         this.openCharacterMenu();
      }
      
      private function _MyFrame_GlowIcon2_i() : GlowIcon
      {
         var _loc1_:GlowIcon = new GlowIcon();
         _loc1_.x = 306;
         _loc1_.y = 43;
         _loc1_.addEventListener("click",this.___MyFrame_GlowIcon2_click);
         this._MyFrame_GlowIcon2 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_GlowIcon2",this._MyFrame_GlowIcon2);
         return _loc1_;
      }
      
      public function ___MyFrame_GlowIcon2_click(event:MouseEvent) : void
      {
         this.openBackpack();
      }
      
      private function _MyFrame_Effects1_i() : Effects
      {
         var _loc1_:Effects = new Effects();
         _loc1_.bottom = 81;
         _loc1_.left = 2;
         _loc1_.textPosition = "top";
         this._MyFrame_Effects1 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_Effects1",this._MyFrame_Effects1);
         return _loc1_;
      }
      
      private function _MyFrame_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.bottom = 81;
         _loc1_.right = 2;
         _loc1_.verticalAlign = "bottom";
         _loc1_.children = [this._MyFrame_GlitterImage2_i(),this._MyFrame_GlitterImage3_i(),this._MyFrame_GlitterImage4_i(),this._MyFrame_EventIcon1_i()];
         return _loc1_;
      }
      
      private function _MyFrame_GlitterImage2_i() : GlitterImage
      {
         var _loc1_:GlitterImage = new GlitterImage();
         _loc1_.animated = true;
         _loc1_.addEventListener("click",this.___MyFrame_GlitterImage2_click);
         this._MyFrame_GlitterImage2 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_GlitterImage2",this._MyFrame_GlitterImage2);
         return _loc1_;
      }
      
      public function ___MyFrame_GlitterImage2_click(event:MouseEvent) : void
      {
         this.openMail();
      }
      
      private function _MyFrame_GlitterImage3_i() : GlitterImage
      {
         var _loc1_:GlitterImage = new GlitterImage();
         _loc1_.animated = true;
         _loc1_.addEventListener("click",this.___MyFrame_GlitterImage3_click);
         this._MyFrame_GlitterImage3 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_GlitterImage3",this._MyFrame_GlitterImage3);
         return _loc1_;
      }
      
      public function ___MyFrame_GlitterImage3_click(event:MouseEvent) : void
      {
         this.openCharacterMenu();
      }
      
      private function _MyFrame_GlitterImage4_i() : GlitterImage
      {
         var _loc1_:GlitterImage = new GlitterImage();
         _loc1_.animated = true;
         _loc1_.addEventListener("click",this.___MyFrame_GlitterImage4_click);
         this._MyFrame_GlitterImage4 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_GlitterImage4",this._MyFrame_GlitterImage4);
         return _loc1_;
      }
      
      public function ___MyFrame_GlitterImage4_click(event:MouseEvent) : void
      {
         this.openCharacterMenu();
      }
      
      private function _MyFrame_EventIcon1_i() : EventIcon
      {
         var _loc1_:EventIcon = new EventIcon();
         this._MyFrame_EventIcon1 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_EventIcon1",this._MyFrame_EventIcon1);
         return _loc1_;
      }
      
      private function _MyFrame_Canvas2_c() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.bottom = 13;
         _loc1_.horizontalCenter = 0;
         _loc1_.children = [this._MyFrame_ShortcutPanel1_i(),this._MyFrame_ShortcutPanel2_i()];
         return _loc1_;
      }
      
      private function _MyFrame_ShortcutPanel1_i() : ShortcutPanel
      {
         var _loc1_:ShortcutPanel = new ShortcutPanel();
         _loc1_.bottom = 0;
         _loc1_.right = 69;
         _loc1_.locked = true;
         this._MyFrame_ShortcutPanel1 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_ShortcutPanel1",this._MyFrame_ShortcutPanel1);
         return _loc1_;
      }
      
      private function _MyFrame_ShortcutPanel2_i() : ShortcutPanel
      {
         var _loc1_:ShortcutPanel = new ShortcutPanel();
         _loc1_.bottom = 0;
         _loc1_.x = 69;
         _loc1_.locked = true;
         this._MyFrame_ShortcutPanel2 = _loc1_;
         BindingManager.executeBindings(this,"_MyFrame_ShortcutPanel2",this._MyFrame_ShortcutPanel2);
         return _loc1_;
      }
      
      public function ___MyFrame_Canvas1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _MyFrame_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():int
         {
            return model.characterModel.myUnit.stats.STAMINA;
         },null,"_MyFrame_BarDrawer1.value");
         result[1] = new Binding(this,function():int
         {
            return model.characterModel.myUnit.stats.MAX_STAMINA;
         },null,"_MyFrame_BarDrawer1.maxValue");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("STAMINA");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_MyFrame_BarDrawer1.toolTip");
         result[3] = new Binding(this,function():Array
         {
            var _loc1_:* = BarDrawer.HP_COLORS;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_MyFrame_BarDrawer2.colors");
         result[4] = new Binding(this,function():int
         {
            return model.characterModel.myUnit.stats.HP;
         },null,"_MyFrame_BarDrawer2.value");
         result[5] = new Binding(this,function():int
         {
            return model.characterModel.myUnit.stats.MAX_HP;
         },null,"_MyFrame_BarDrawer2.maxValue");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = BarDrawer.LEFT;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_MyFrame_BarDrawer2.direction");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = getString("HP");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_MyFrame_BarDrawer2.toolTip");
         result[8] = new Binding(this,function():int
         {
            return model.characterModel.myUnit.stats.MP;
         },null,"_MyFrame_BarDrawer3.value");
         result[9] = new Binding(this,function():int
         {
            return model.characterModel.myUnit.stats.MAX_MP;
         },null,"_MyFrame_BarDrawer3.maxValue");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = getString("MP");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_MyFrame_BarDrawer3.toolTip");
         result[11] = new Binding(this,function():int
         {
            return model.characterModel.properties.XP;
         },null,"_MyFrame_XpBar1.value");
         result[12] = new Binding(this,function():String
         {
            var _loc1_:* = getString("XP") + ": " + getXP(model.characterModel.properties.XP) + "%";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_MyFrame_XpBar1.toolTip");
         result[13] = new Binding(this,function():Array
         {
            var _loc1_:* = model.characterModel.fightMode ? fightFilter : [];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"avatar.filters");
         result[14] = new Binding(this,function():Object
         {
            return Configuration.getSmallAvatarUrl(model.characterModel.myUnit.avatarImagePath);
         },null,"avatar.source");
         result[15] = new Binding(this,function():Object
         {
            return Assets.centerFrame;
         },null,"_MyFrame_CachedImage2.source");
         result[16] = new Binding(this,function():String
         {
            var _loc1_:* = model.characterModel.myUnit.stats.LEVEL;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_MyFrame_Label1.text");
         result[17] = new Binding(this,function():Boolean
         {
            return !model.characterModel.fightMode;
         },null,"_MyFrame_Label1.visible");
         result[18] = new Binding(this,function():Object
         {
            return Icons.combat;
         },null,"_MyFrame_GlitterImage1.source");
         result[19] = new Binding(this,function():Boolean
         {
            return model.characterModel.fightMode;
         },null,"_MyFrame_GlitterImage1.visible");
         result[20] = new Binding(this,function():Object
         {
            return model.groupModel.leader && model.groupModel.members.length > 1 ? Icons.crown : Icons.menu;
         },null,"_MyFrame_CachedImage3.source");
         result[21] = new Binding(this,function():Object
         {
            return Icons.infoSmall;
         },null,"_MyFrame_GlowIcon1.source");
         result[22] = new Binding(this,function():String
         {
            var _loc1_:* = getString("character.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_MyFrame_GlowIcon1.toolTip");
         result[23] = new Binding(this,function():Object
         {
            return Icons.sackSmall;
         },null,"_MyFrame_GlowIcon2.source");
         result[24] = new Binding(this,function():String
         {
            var _loc1_:* = getString("backpack.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_MyFrame_GlowIcon2.toolTip");
         result[25] = new Binding(this,function():Boolean
         {
            return !model.characterModel.dead;
         },null,"_MyFrame_GlowIcon2.enabled");
         result[26] = new Binding(this,function():Array
         {
            var _loc1_:* = model.characterModel.myUnit.effects;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_MyFrame_Effects1.effects");
         result[27] = new Binding(this,function():Object
         {
            return Icons.mail;
         },null,"_MyFrame_GlitterImage2.source");
         result[28] = new Binding(this,function():String
         {
            var _loc1_:* = getString("youHaveNewMail");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_MyFrame_GlitterImage2.toolTip");
         result[29] = new Binding(this,function():Boolean
         {
            return model.mailModel.hasNewMail;
         },null,"_MyFrame_GlitterImage2.visible");
         result[30] = new Binding(this,function():Object
         {
            return Icons.newStats;
         },null,"_MyFrame_GlitterImage3.source");
         result[31] = new Binding(this,function():Boolean
         {
            return model.characterModel.additionalPoints.STATS > 0;
         },null,"_MyFrame_GlitterImage3.visible");
         result[32] = new Binding(this,function():String
         {
            var _loc1_:* = getString("youHaveUnspentPoints");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_MyFrame_GlitterImage3.toolTip");
         result[33] = new Binding(this,function():Object
         {
            return Icons.broken;
         },null,"_MyFrame_GlitterImage4.source");
         result[34] = new Binding(this,function():Boolean
         {
            return model.inventoryModel.hasBrokenItemsWorn;
         },null,"_MyFrame_GlitterImage4.visible");
         result[35] = new Binding(this,function():String
         {
            var _loc1_:* = getString("youHaveBrokenItem");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_MyFrame_GlitterImage4.toolTip");
         result[36] = new Binding(this,function():SettingsModel
         {
            return model.settingsModel;
         },null,"_MyFrame_EventIcon1.settingsModel");
         result[37] = new Binding(this,function():DashboardModel
         {
            return model.dashboardModel;
         },null,"_MyFrame_EventIcon1.model");
         result[38] = new Binding(this,function():Array
         {
            var _loc1_:* = ["1","2","3","4","5","6","7","8","9","0"];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_MyFrame_ShortcutPanel1.hotKeys");
         result[39] = new Binding(this,function():uint
         {
            return ShortcutPanel.LEFT;
         },null,"_MyFrame_ShortcutPanel1.panelType");
         result[40] = new Binding(this,function():BaseUnit
         {
            return model.characterModel.myUnit;
         },null,"_MyFrame_ShortcutPanel1.myUnit");
         result[41] = new Binding(this,null,null,"_MyFrame_ShortcutPanel1.model","model");
         result[42] = new Binding(this,function():Array
         {
            var _loc1_:* = model.characterModel.abilitySlots;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_MyFrame_ShortcutPanel1.shortcuts");
         result[43] = new Binding(this,function():Array
         {
            var _loc1_:* = ["q","w","e","r","t","y","u","i"];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_MyFrame_ShortcutPanel2.hotKeys");
         result[44] = new Binding(this,function():uint
         {
            return ShortcutPanel.RIGHT;
         },null,"_MyFrame_ShortcutPanel2.panelType");
         result[45] = new Binding(this,function():BaseUnit
         {
            return model.characterModel.myUnit;
         },null,"_MyFrame_ShortcutPanel2.myUnit");
         result[46] = new Binding(this,null,null,"_MyFrame_ShortcutPanel2.model","model");
         result[47] = new Binding(this,function():Array
         {
            var _loc1_:* = model.characterModel.belt;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_MyFrame_ShortcutPanel2.shortcuts");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get avatar() : CachedImage
      {
         return this._1405959847avatar;
      }
      
      public function set avatar(param1:CachedImage) : void
      {
         var _loc2_:Object = this._1405959847avatar;
         if(_loc2_ !== param1)
         {
            this._1405959847avatar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"avatar",_loc2_,param1));
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

