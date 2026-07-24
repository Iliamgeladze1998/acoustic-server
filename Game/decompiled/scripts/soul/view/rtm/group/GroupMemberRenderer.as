package soul.view.rtm.group
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
   import soul.controller.MenuManager;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.FieldEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.character.Disposition;
   import soul.model.character.DispositionGroup;
   import soul.model.common.MenuType;
   import soul.model.field.FieldUnit;
   import soul.model.group.GroupMember;
   import soul.model.rtm.RTMModel;
   import soul.model.system.Configuration;
   import soul.view.assets.Assets;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientLabel;
   import soul.view.rtm.BarDrawer;
   import soul.view.rtm.Effects;
   import soul.view.toolTip.PartyToolTip;
   import soul.view.toolTip.ToolTipManager;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Container;
   import soul.view.ui.VBox;
   import soul.view.ui.soul_internal;
   
   use namespace soul_internal;
   use namespace mx_internal;
   
   public class GroupMemberRenderer extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _GroupMemberRenderer_BarDrawer1:BarDrawer;
      
      public var _GroupMemberRenderer_BarDrawer2:BarDrawer;
      
      public var _GroupMemberRenderer_CachedImage1:CachedImage;
      
      public var _GroupMemberRenderer_CachedImage2:CachedImage;
      
      public var _GroupMemberRenderer_CachedImage3:CachedImage;
      
      public var _GroupMemberRenderer_GradientLabel1:GradientLabel;
      
      private var _1405959847avatar:Container;
      
      private var _1833928446effects:Effects;
      
      private var _3343943mana:Container;
      
      private var _3347807menu:CachedImage;
      
      public var rtmModel:RTMModel;
      
      private var _3594628unit:GroupMember;
      
      private var _1089771118barsVisible:Boolean;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function GroupMemberRenderer()
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
         bindings = this._GroupMemberRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_rtm_group_GroupMemberRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return GroupMemberRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 200;
         this.height = 60;
         this.mouseEnabled = false;
         this.children = [this._GroupMemberRenderer_VBox1_c(),this._GroupMemberRenderer_Container2_i(),this._GroupMemberRenderer_Container3_i(),this._GroupMemberRenderer_CachedImage2_i(),this._GroupMemberRenderer_CachedImage3_i(),this._GroupMemberRenderer_CachedImage4_i()];
         this.addEventListener("creationComplete",this.___GroupMemberRenderer_Container1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      private static function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         GroupMemberRenderer._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         var avatarMask:Shape = new Shape();
         avatarMask.graphics.beginFill(0);
         avatarMask.graphics.drawEllipse(0,0,53,53);
         avatarMask.graphics.endFill();
         this.avatar.$addChild(avatarMask);
         this.avatar.mask = avatarMask;
         var manaMask:Shape = new Shape();
         manaMask.graphics.beginFill(0);
         manaMask.graphics.lineTo(17,0);
         manaMask.graphics.curveTo(40,27,17,54);
         manaMask.graphics.lineTo(0,54);
         manaMask.graphics.curveTo(25,27,0,0);
         manaMask.graphics.endFill();
         this.mana.$addChild(manaMask);
         this.mana.mask = manaMask;
         addEventListener(Event.REMOVED,this.removed);
         addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         addEventListener(MouseEvent.CLICK,this.mouseClick);
         this.menu.addEventListener(MouseEvent.CLICK,this.showMenu);
         ToolTipManager.register(this,this.unit,PartyToolTip);
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         removeEventListener(Event.REMOVED,this.removed);
         removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         removeEventListener(MouseEvent.CLICK,this.mouseClick);
         this.menu.removeEventListener(MouseEvent.CLICK,this.showMenu);
         ToolTipManager.unregister(this);
      }
      
      private function mouseOver(e:Event) : void
      {
         addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
         this.barsVisible = true;
      }
      
      private function mouseOut(e:Event) : void
      {
         removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
         this.barsVisible = false;
      }
      
      private function mouseClick(e:Event) : void
      {
         var fu:FieldUnit = null;
         var ne:FieldEvent = null;
         if(Boolean(this.rtmModel.activeAbility))
         {
            fu = new FieldUnit();
            fu.id = this.unit.id;
            fu.acceptsPositive = true;
            this.rtmModel.activeUnit = fu;
            this.rtmModel.dispatchEvent(new Event(FieldEvent.ACCEPT_ABILITY));
         }
         else
         {
            ne = new FieldEvent(FieldEvent.CS_SELECT_TARGET,false);
            ne.data = this.unit.id;
            this.rtmModel.dispatchEvent(ne);
         }
      }
      
      private function showMenu(e:MouseEvent) : void
      {
         e.stopImmediatePropagation();
         MenuManager.create(MenuType.CHARACTER_MENU,this.unit.id);
      }
      
      private function _GroupMemberRenderer_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.x = 82;
         _loc1_.mouseEnabled = false;
         _loc1_.children = [this._GroupMemberRenderer_GradientLabel1_i(),this._GroupMemberRenderer_Effects1_i()];
         return _loc1_;
      }
      
      private function _GroupMemberRenderer_GradientLabel1_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.bold = true;
         _loc1_.fontSize = 10;
         _loc1_.width = 125;
         _loc1_.bgPaddingLeft = -10;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         this._GroupMemberRenderer_GradientLabel1 = _loc1_;
         BindingManager.executeBindings(this,"_GroupMemberRenderer_GradientLabel1",this._GroupMemberRenderer_GradientLabel1);
         return _loc1_;
      }
      
      private function _GroupMemberRenderer_Effects1_i() : Effects
      {
         var _loc1_:Effects = new Effects();
         this.effects = _loc1_;
         BindingManager.executeBindings(this,"effects",this.effects);
         return _loc1_;
      }
      
      private function _GroupMemberRenderer_Container2_i() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.x = 53;
         _loc1_.y = 3;
         _loc1_.children = [this._GroupMemberRenderer_BarDrawer1_i()];
         this.mana = _loc1_;
         BindingManager.executeBindings(this,"mana",this.mana);
         return _loc1_;
      }
      
      private function _GroupMemberRenderer_BarDrawer1_i() : BarDrawer
      {
         var _loc1_:BarDrawer = new BarDrawer();
         _loc1_.backgroundColor = 0;
         _loc1_.width = 30;
         _loc1_.height = 54;
         _loc1_.barColor = 20354;
         _loc1_.labelVisible = false;
         _loc1_.direction = "UP";
         this._GroupMemberRenderer_BarDrawer1 = _loc1_;
         BindingManager.executeBindings(this,"_GroupMemberRenderer_BarDrawer1",this._GroupMemberRenderer_BarDrawer1);
         return _loc1_;
      }
      
      private function _GroupMemberRenderer_Container3_i() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.x = 14;
         _loc1_.y = 3;
         _loc1_.children = [this._GroupMemberRenderer_CachedImage1_i(),this._GroupMemberRenderer_BarDrawer2_i()];
         this.avatar = _loc1_;
         BindingManager.executeBindings(this,"avatar",this.avatar);
         return _loc1_;
      }
      
      private function _GroupMemberRenderer_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.width = 53;
         _loc1_.height = 53;
         this._GroupMemberRenderer_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_GroupMemberRenderer_CachedImage1",this._GroupMemberRenderer_CachedImage1);
         return _loc1_;
      }
      
      private function _GroupMemberRenderer_BarDrawer2_i() : BarDrawer
      {
         var _loc1_:BarDrawer = new BarDrawer();
         _loc1_.width = 53;
         _loc1_.height = 53;
         _loc1_.alpha = 0.5;
         _loc1_.barColor = 16711680;
         _loc1_.labelVisible = false;
         _loc1_.direction = "UP";
         this._GroupMemberRenderer_BarDrawer2 = _loc1_;
         BindingManager.executeBindings(this,"_GroupMemberRenderer_BarDrawer2",this._GroupMemberRenderer_BarDrawer2);
         return _loc1_;
      }
      
      private function _GroupMemberRenderer_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._GroupMemberRenderer_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_GroupMemberRenderer_CachedImage2",this._GroupMemberRenderer_CachedImage2);
         return _loc1_;
      }
      
      private function _GroupMemberRenderer_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 4;
         _loc1_.y = 3;
         this._GroupMemberRenderer_CachedImage3 = _loc1_;
         BindingManager.executeBindings(this,"_GroupMemberRenderer_CachedImage3",this._GroupMemberRenderer_CachedImage3);
         return _loc1_;
      }
      
      private function _GroupMemberRenderer_CachedImage4_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 4;
         _loc1_.y = 38;
         this.menu = _loc1_;
         BindingManager.executeBindings(this,"menu",this.menu);
         return _loc1_;
      }
      
      public function ___GroupMemberRenderer_Container1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _GroupMemberRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = unit.name;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_GroupMemberRenderer_GradientLabel1.text");
         result[1] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_GroupMemberRenderer_GradientLabel1.color");
         result[2] = new Binding(this,function():Array
         {
            var _loc1_:* = unit.effects;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"effects.effects");
         result[3] = new Binding(this,function():int
         {
            return unit.stats.MP;
         },null,"_GroupMemberRenderer_BarDrawer1.value");
         result[4] = new Binding(this,function():int
         {
            return unit.stats.MAX_MP;
         },null,"_GroupMemberRenderer_BarDrawer1.maxValue");
         result[5] = new Binding(this,function():Object
         {
            return Configuration.getSmallAvatarUrl(unit.avatarImagePath);
         },null,"_GroupMemberRenderer_CachedImage1.source");
         result[6] = new Binding(this,function():int
         {
            return unit.stats.MAX_HP - unit.stats.HP;
         },null,"_GroupMemberRenderer_BarDrawer2.value");
         result[7] = new Binding(this,function():int
         {
            return unit.stats.MAX_HP;
         },null,"_GroupMemberRenderer_BarDrawer2.maxValue");
         result[8] = new Binding(this,function():Object
         {
            return Assets.partyMemberFrame;
         },null,"_GroupMemberRenderer_CachedImage2.source");
         result[9] = new Binding(this,function():Object
         {
            return DispositionGroup.getPartyIcon(Disposition.getDispositionGroup(unit.disposition));
         },null,"_GroupMemberRenderer_CachedImage3.source");
         result[10] = new Binding(this,function():Object
         {
            return unit.leader ? Assets.partyLeader : Assets.partyOptions;
         },null,"menu.source");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get avatar() : Container
      {
         return this._1405959847avatar;
      }
      
      public function set avatar(param1:Container) : void
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
      public function get effects() : Effects
      {
         return this._1833928446effects;
      }
      
      public function set effects(param1:Effects) : void
      {
         var _loc2_:Object = this._1833928446effects;
         if(_loc2_ !== param1)
         {
            this._1833928446effects = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"effects",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mana() : Container
      {
         return this._3343943mana;
      }
      
      public function set mana(param1:Container) : void
      {
         var _loc2_:Object = this._3343943mana;
         if(_loc2_ !== param1)
         {
            this._3343943mana = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mana",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get menu() : CachedImage
      {
         return this._3347807menu;
      }
      
      public function set menu(param1:CachedImage) : void
      {
         var _loc2_:Object = this._3347807menu;
         if(_loc2_ !== param1)
         {
            this._3347807menu = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"menu",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get unit() : GroupMember
      {
         return this._3594628unit;
      }
      
      public function set unit(param1:GroupMember) : void
      {
         var _loc2_:Object = this._3594628unit;
         if(_loc2_ !== param1)
         {
            this._3594628unit = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"unit",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get barsVisible() : Boolean
      {
         return this._1089771118barsVisible;
      }
      
      private function set barsVisible(param1:Boolean) : void
      {
         var _loc2_:Object = this._1089771118barsVisible;
         if(_loc2_ !== param1)
         {
            this._1089771118barsVisible = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"barsVisible",_loc2_,param1));
            }
         }
      }
   }
}

