package soul.view.toolbar
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.DropShadowFilter;
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
   import soul.controller.LogManager;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.controller.shortcut.Shortcut;
   import soul.controller.shortcut.ShortcutManager;
   import soul.event.MenuEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.GameMode;
   import soul.model.GameModel;
   import soul.model.common.InteractionType;
   import soul.model.system.Configuration;
   import soul.view.assets.GlitterImage;
   import soul.view.assets.GlowIcon;
   import soul.view.common.Icons;
   import soul.view.ui.HBox;
   import soul.view.ui.VBox;
   import soul.view.ui.controls.menu.Menu;
   
   use namespace mx_internal;
   
   public class ToolBar extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const darkGlow:Array = [new GlowFilter(0,1,1.2,1.2,20,3)];
      
      private static const iconShadow:Array = [new DropShadowFilter()];
      
      public var _ToolBar_GlitterImage1:GlitterImage;
      
      public var _ToolBar_GlowIcon1:GlowIcon;
      
      public var _ToolBar_GlowIcon2:GlowIcon;
      
      public var _ToolBar_GlowIcon3:GlowIcon;
      
      public var _ToolBar_GlowIcon4:GlowIcon;
      
      public var _ToolBar_GlowIcon5:GlowIcon;
      
      public var _ToolBar_GlowIcon6:GlowIcon;
      
      public var _ToolBar_GlowIcon7:GlowIcon;
      
      public var _ToolBar_VBox2:VBox;
      
      private var _104069929model:GameModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ToolBar()
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
         bindings = this._ToolBar_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_toolbar_ToolBarWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ToolBar[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.horizontalAlign = "right";
         this.gap = 5;
         this.padding = 5;
         this.children = [this._ToolBar_VBox2_i(),this._ToolBar_GlowIcon3_i(),this._ToolBar_GlowIcon4_i(),this._ToolBar_HBox1_c(),this._ToolBar_GlowIcon6_i(),this._ToolBar_HBox2_c()];
         this.addEventListener("creationComplete",this.___ToolBar_VBox1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ToolBar._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         ShortcutManager.addShortcutListener(Shortcut.FRIENDS,this.openFriends);
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         ShortcutManager.removeShortcutListener(Shortcut.FRIENDS,this.openFriends);
      }
      
      private function openCharacterMenu(e:Event = null) : void
      {
         Interaction.toggle(InteractionType.CHARACTER);
      }
      
      private function openBackpack(e:Event = null) : void
      {
         if(this.model.characterModel.dead)
         {
            return;
         }
         Interaction.toggle(InteractionType.INVENTORY);
      }
      
      private function openQuests(e:Event = null) : void
      {
         Interaction.toggle(InteractionType.QUESTS);
      }
      
      private function openAbilityMenu(e:Event = null) : void
      {
         Interaction.toggle(InteractionType.TALENTS);
      }
      
      private function openFriends(e:Event = null) : void
      {
         Interaction.toggle(InteractionType.SOCIAL);
      }
      
      private function openClan(e:Event = null) : void
      {
         Interaction.toggle(InteractionType.CLAN);
      }
      
      private function showSocialMenu() : void
      {
         var menuData:Array = [{
            "label":this.getString("mail.title"),
            "data":"mail"
         },{
            "label":this.getString("social.title"),
            "data":"social"
         },{
            "label":this.getString("clan.title"),
            "data":"clan"
         }];
         var menu:Menu = Menu.createMenu(stage,menuData);
         menu.addEventListener(MenuEvent.ITEM_CLICK,this.selectSystemMenu);
         menu.show(stage.mouseX - 150,stage.mouseY - 50);
      }
      
      private function openEventMenu() : void
      {
         this.openDashboard();
      }
      
      private function showSystemMenu() : void
      {
         var menuData:Array = [{
            "label":this.getString("lfg.title"),
            "data":"groupLookup"
         },{
            "label":this.getString("instances.title"),
            "data":"instances"
         },{
            "label":this.getString("reportError"),
            "data":"report"
         },{
            "label":this.getString("forum"),
            "data":"forum"
         },{
            "label":this.getString("faq"),
            "data":"faq"
         },{
            "label":this.getString("settings.title"),
            "data":"settings"
         },{
            "label":this.getString("avatars.title"),
            "data":"avatars"
         },{
            "label":this.getString("logout.title"),
            "data":"exit"
         }];
         var menu:Menu = Menu.createMenu(stage,menuData);
         menu.addEventListener(MenuEvent.ITEM_CLICK,this.selectSystemMenu);
         menu.show(stage.mouseX - 145,stage.mouseY - 120);
      }
      
      private function openRuby(e:Event = null) : void
      {
         this.openExchange(null);
         LogManager.log("RightMenu","Clicked \'Ruby\' button");
      }
      
      private function selectSystemMenu(e:MenuEvent) : void
      {
         var data:String = e.item.data;
         switch(data)
         {
            case "mail":
               this.openMail();
               break;
            case "social":
               this.openFriends();
               break;
            case "clan":
               this.openClan();
               break;
            case "dashboard":
               this.openDashboard();
               break;
            case "arena":
               this.openArena();
               break;
            case "instances":
               this.openInstances();
               break;
            case "groupLookup":
               this.openGroupLookup();
               break;
            case "hints":
               this.openHint();
               break;
            case "settings":
               this.openSettings();
               break;
            case "avatars":
               Interaction.toggle(InteractionType.AVATARS);
               break;
            case "exit":
               this.openExit();
               break;
            default:
               Configuration.openExternalURL(data,"blank");
         }
      }
      
      private function openMail() : void
      {
         Interaction.toggle(InteractionType.MAIL);
      }
      
      private function openArena(e:Event = null) : void
      {
         Interaction.toggle(InteractionType.ARENA);
      }
      
      private function openMap(e:Event) : void
      {
         Interaction.toggle(InteractionType.MAP);
      }
      
      private function openInstances(e:Event = null) : void
      {
         Interaction.toggle(InteractionType.INSTANCE);
      }
      
      private function openGroupLookup(e:Event = null) : void
      {
         Interaction.toggle(InteractionType.LFG);
      }
      
      private function openAuction() : void
      {
         Interaction.toggle(InteractionType.AUCTION);
      }
      
      private function openDashboard() : void
      {
         Interaction.toggle(InteractionType.DASHBOARD,false,true);
      }
      
      private function openExchange(e:Event) : void
      {
         Interaction.toggle(InteractionType.RUBY);
      }
      
      private function openExit(e:Event = null) : void
      {
         Interaction.toggle(InteractionType.LOGOUT);
      }
      
      private function openHint(e:Event = null) : void
      {
         Interaction.toggle(InteractionType.QUESTS,false,true);
      }
      
      private function openSettings(e:Event = null) : void
      {
         Interaction.toggle(InteractionType.SETTINGS,false,true);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _ToolBar_VBox2_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 5;
         _loc1_.children = [this._ToolBar_GlowIcon1_i(),this._ToolBar_GlowIcon2_i()];
         this._ToolBar_VBox2 = _loc1_;
         BindingManager.executeBindings(this,"_ToolBar_VBox2",this._ToolBar_VBox2);
         return _loc1_;
      }
      
      private function _ToolBar_GlowIcon1_i() : GlowIcon
      {
         var _loc1_:GlowIcon = new GlowIcon();
         _loc1_.addEventListener("click",this.___ToolBar_GlowIcon1_click);
         this._ToolBar_GlowIcon1 = _loc1_;
         BindingManager.executeBindings(this,"_ToolBar_GlowIcon1",this._ToolBar_GlowIcon1);
         return _loc1_;
      }
      
      public function ___ToolBar_GlowIcon1_click(event:MouseEvent) : void
      {
         this.openQuests();
      }
      
      private function _ToolBar_GlowIcon2_i() : GlowIcon
      {
         var _loc1_:GlowIcon = new GlowIcon();
         _loc1_.addEventListener("click",this.___ToolBar_GlowIcon2_click);
         this._ToolBar_GlowIcon2 = _loc1_;
         BindingManager.executeBindings(this,"_ToolBar_GlowIcon2",this._ToolBar_GlowIcon2);
         return _loc1_;
      }
      
      public function ___ToolBar_GlowIcon2_click(event:MouseEvent) : void
      {
         this.openAbilityMenu();
      }
      
      private function _ToolBar_GlowIcon3_i() : GlowIcon
      {
         var _loc1_:GlowIcon = new GlowIcon();
         _loc1_.addEventListener("click",this.___ToolBar_GlowIcon3_click);
         this._ToolBar_GlowIcon3 = _loc1_;
         BindingManager.executeBindings(this,"_ToolBar_GlowIcon3",this._ToolBar_GlowIcon3);
         return _loc1_;
      }
      
      public function ___ToolBar_GlowIcon3_click(event:MouseEvent) : void
      {
         this.showSocialMenu();
      }
      
      private function _ToolBar_GlowIcon4_i() : GlowIcon
      {
         var _loc1_:GlowIcon = new GlowIcon();
         _loc1_.addEventListener("click",this.___ToolBar_GlowIcon4_click);
         this._ToolBar_GlowIcon4 = _loc1_;
         BindingManager.executeBindings(this,"_ToolBar_GlowIcon4",this._ToolBar_GlowIcon4);
         return _loc1_;
      }
      
      public function ___ToolBar_GlowIcon4_click(event:MouseEvent) : void
      {
         this.openAuction();
      }
      
      private function _ToolBar_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 2;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._ToolBar_GlowIcon5_i()];
         return _loc1_;
      }
      
      private function _ToolBar_GlowIcon5_i() : GlowIcon
      {
         var _loc1_:GlowIcon = new GlowIcon();
         _loc1_.addEventListener("click",this.___ToolBar_GlowIcon5_click);
         this._ToolBar_GlowIcon5 = _loc1_;
         BindingManager.executeBindings(this,"_ToolBar_GlowIcon5",this._ToolBar_GlowIcon5);
         return _loc1_;
      }
      
      public function ___ToolBar_GlowIcon5_click(event:MouseEvent) : void
      {
         this.openEventMenu();
      }
      
      private function _ToolBar_GlowIcon6_i() : GlowIcon
      {
         var _loc1_:GlowIcon = new GlowIcon();
         _loc1_.addEventListener("click",this.___ToolBar_GlowIcon6_click);
         this._ToolBar_GlowIcon6 = _loc1_;
         BindingManager.executeBindings(this,"_ToolBar_GlowIcon6",this._ToolBar_GlowIcon6);
         return _loc1_;
      }
      
      public function ___ToolBar_GlowIcon6_click(event:MouseEvent) : void
      {
         this.openRuby();
      }
      
      private function _ToolBar_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 2;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._ToolBar_GlitterImage1_i(),this._ToolBar_GlowIcon7_i()];
         return _loc1_;
      }
      
      private function _ToolBar_GlitterImage1_i() : GlitterImage
      {
         var _loc1_:GlitterImage = new GlitterImage();
         _loc1_.addEventListener("click",this.___ToolBar_GlitterImage1_click);
         this._ToolBar_GlitterImage1 = _loc1_;
         BindingManager.executeBindings(this,"_ToolBar_GlitterImage1",this._ToolBar_GlitterImage1);
         return _loc1_;
      }
      
      public function ___ToolBar_GlitterImage1_click(event:MouseEvent) : void
      {
         this.openHint();
      }
      
      private function _ToolBar_GlowIcon7_i() : GlowIcon
      {
         var _loc1_:GlowIcon = new GlowIcon();
         _loc1_.addEventListener("click",this.___ToolBar_GlowIcon7_click);
         this._ToolBar_GlowIcon7 = _loc1_;
         BindingManager.executeBindings(this,"_ToolBar_GlowIcon7",this._ToolBar_GlowIcon7);
         return _loc1_;
      }
      
      public function ___ToolBar_GlowIcon7_click(event:MouseEvent) : void
      {
         this.showSystemMenu();
      }
      
      public function ___ToolBar_VBox1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _ToolBar_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Boolean
         {
            return model.mode == GameMode.ASTRAL;
         },null,"_ToolBar_VBox2.visible");
         result[1] = new Binding(this,function():Object
         {
            return Icons.journal;
         },null,"_ToolBar_GlowIcon1.source");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("questLog.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ToolBar_GlowIcon1.toolTip");
         result[3] = new Binding(this,function():Object
         {
            return Icons.ability;
         },null,"_ToolBar_GlowIcon2.source");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = getString("abilities.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ToolBar_GlowIcon2.toolTip");
         result[5] = new Binding(this,function():Object
         {
            return Icons.relations;
         },null,"_ToolBar_GlowIcon3.source");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = getString("social.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ToolBar_GlowIcon3.toolTip");
         result[7] = new Binding(this,function():Object
         {
            return Icons.auction;
         },null,"_ToolBar_GlowIcon4.source");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = getString("auction.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ToolBar_GlowIcon4.toolTip");
         result[9] = new Binding(this,function():Object
         {
            return Icons.events;
         },null,"_ToolBar_GlowIcon5.source");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = getString("dashboard.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ToolBar_GlowIcon5.toolTip");
         result[11] = new Binding(this,function():Object
         {
            return Icons.toolbarRuby;
         },null,"_ToolBar_GlowIcon6.source");
         result[12] = new Binding(this,function():String
         {
            var _loc1_:* = getString("real_ruby.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ToolBar_GlowIcon6.toolTip");
         result[13] = new Binding(this,function():Object
         {
            return Icons.smallHints;
         },null,"_ToolBar_GlitterImage1.source");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = getString("hints");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ToolBar_GlitterImage1.toolTip");
         result[15] = new Binding(this,function():Boolean
         {
            return model.questModel.hasNewHints;
         },null,"_ToolBar_GlitterImage1.visible");
         result[16] = new Binding(this,function():Object
         {
            return Icons.system;
         },null,"_ToolBar_GlowIcon7.source");
         result[17] = new Binding(this,function():String
         {
            var _loc1_:* = getString("system.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ToolBar_GlowIcon7.toolTip");
         return result;
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

