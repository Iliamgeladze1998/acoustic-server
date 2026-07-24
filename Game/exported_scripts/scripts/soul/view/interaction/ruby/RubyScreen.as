package soul.view.interaction.ruby
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
   import mx.events.ItemClickEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.controller.LogManager;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.SimpleUIEvent;
   import soul.model.ability.AbilityModel;
   import soul.model.character.CharacterModel;
   import soul.model.system.Configuration;
   import soul.net.ServerLayer;
   import soul.view.assets.Assets;
   import soul.view.assets.SimpleImageBar;
   import soul.view.common.TabIcons;
   import soul.view.interaction.ruby.tabs.RubyTab;
   import soul.view.interaction.ruby.tabs.SubscriptionTab;
   import soul.view.interaction.ruby.tabs.TempleTab;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Container;
   import soul.view.ui.ViewStack;
   import soul.view.ui.controls.Alert;
   
   use namespace mx_internal;
   
   public class RubyScreen extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const TABS:Array = [[TabIcons.exchange0,TabIcons.exchange1],[TabIcons.subscribe0,TabIcons.subscribe1],[TabIcons.temple0,TabIcons.temple1]];
      
      public var _RubyScreen_BorderedContainer1:BorderedContainer;
      
      public var _RubyScreen_CachedImage1:CachedImage;
      
      public var _RubyScreen_RubyTab1:RubyTab;
      
      public var _RubyScreen_SubscriptionTab1:SubscriptionTab;
      
      public var _RubyScreen_TempleTab1:TempleTab;
      
      public var _RubyScreen_ViewStack1:ViewStack;
      
      private var _97299bar:SimpleImageBar;
      
      private var _104069929model:CharacterModel;
      
      private var _259260447abilityModel:AbilityModel;
      
      private var _220498682selectedTab:int = 0;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function RubyScreen()
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
         bindings = this._RubyScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_ruby_RubyScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return RubyScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 770;
         this.height = 382;
         this.children = [this._RubyScreen_SimpleImageBar1_i(),this._RubyScreen_CachedImage1_i(),this._RubyScreen_BorderedContainer1_i(),this._RubyScreen_ViewStack1_i()];
         this.addEventListener("creationComplete",this.___RubyScreen_Container1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         RubyScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("currencyType.RUBIES");
         ServerLayer.call("characterService","getPaymentToken",this.setToken,this.setTokenFault);
      }
      
      private function setToken(value:String) : void
      {
         Configuration.portalToken = value;
      }
      
      private function setTokenFault(value:* = null) : void
      {
         Alert.show("Could not get token, some transactions can not work");
      }
      
      private function tabSelected() : void
      {
         var component:String = null;
         var message:String = null;
         if(this.bar.selectedIndex > 0)
         {
            component = "RubyScreen";
            message = "Selected tab " + (this.bar.selectedIndex == 1 ? "subscription" : "blessing");
            LogManager.log(component,message);
         }
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _RubyScreen_SimpleImageBar1_i() : SimpleImageBar
      {
         var _loc1_:SimpleImageBar = new SimpleImageBar();
         _loc1_.x = 13;
         _loc1_.y = 8;
         _loc1_.gap = 1;
         _loc1_.addEventListener("itemClick",this.__bar_itemClick);
         this.bar = _loc1_;
         BindingManager.executeBindings(this,"bar",this.bar);
         return _loc1_;
      }
      
      public function __bar_itemClick(event:ItemClickEvent) : void
      {
         this.tabSelected();
      }
      
      private function _RubyScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 12;
         _loc1_.y = 42;
         this._RubyScreen_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_RubyScreen_CachedImage1",this._RubyScreen_CachedImage1);
         return _loc1_;
      }
      
      private function _RubyScreen_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.x = 476;
         _loc1_.y = 42;
         _loc1_.width = 281;
         _loc1_.height = 326;
         this._RubyScreen_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_RubyScreen_BorderedContainer1",this._RubyScreen_BorderedContainer1);
         return _loc1_;
      }
      
      private function _RubyScreen_ViewStack1_i() : ViewStack
      {
         var _loc1_:ViewStack = null;
         _loc1_ = new ViewStack();
         _loc1_.x = 12;
         _loc1_.y = 42;
         _loc1_.children = [this._RubyScreen_RubyTab1_i(),this._RubyScreen_SubscriptionTab1_i(),this._RubyScreen_TempleTab1_i()];
         this._RubyScreen_ViewStack1 = _loc1_;
         BindingManager.executeBindings(this,"_RubyScreen_ViewStack1",this._RubyScreen_ViewStack1);
         return _loc1_;
      }
      
      private function _RubyScreen_RubyTab1_i() : RubyTab
      {
         var _loc1_:RubyTab = new RubyTab();
         this._RubyScreen_RubyTab1 = _loc1_;
         BindingManager.executeBindings(this,"_RubyScreen_RubyTab1",this._RubyScreen_RubyTab1);
         return _loc1_;
      }
      
      private function _RubyScreen_SubscriptionTab1_i() : SubscriptionTab
      {
         var _loc1_:SubscriptionTab = new SubscriptionTab();
         this._RubyScreen_SubscriptionTab1 = _loc1_;
         BindingManager.executeBindings(this,"_RubyScreen_SubscriptionTab1",this._RubyScreen_SubscriptionTab1);
         return _loc1_;
      }
      
      private function _RubyScreen_TempleTab1_i() : TempleTab
      {
         var _loc1_:TempleTab = new TempleTab();
         this._RubyScreen_TempleTab1 = _loc1_;
         BindingManager.executeBindings(this,"_RubyScreen_TempleTab1",this._RubyScreen_TempleTab1);
         return _loc1_;
      }
      
      public function ___RubyScreen_Container1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _RubyScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,null,null,"bar.selectedIndex","selectedTab");
         result[1] = new Binding(this,function():Array
         {
            var _loc1_:* = TABS;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.dataProvider");
         result[2] = new Binding(this,function():Array
         {
            var _loc1_:* = [getString("rubies.get"),getString("subscription"),getString("blessing")];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.toolTips");
         result[3] = new Binding(this,function():Object
         {
            return Assets.panelSet;
         },null,"_RubyScreen_CachedImage1.source");
         result[4] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_RubyScreen_BorderedContainer1.borderSkin");
         result[5] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"_RubyScreen_BorderedContainer1.backgroundImage");
         result[6] = new Binding(this,function():int
         {
            return bar.selectedIndex;
         },null,"_RubyScreen_ViewStack1.selectedIndex");
         result[7] = new Binding(this,null,null,"_RubyScreen_RubyTab1.model","model");
         result[8] = new Binding(this,null,null,"_RubyScreen_SubscriptionTab1.model","model");
         result[9] = new Binding(this,null,null,"_RubyScreen_TempleTab1.abilityModel","abilityModel");
         result[10] = new Binding(this,null,null,"_RubyScreen_TempleTab1.model","model");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get bar() : SimpleImageBar
      {
         return this._97299bar;
      }
      
      public function set bar(param1:SimpleImageBar) : void
      {
         var _loc2_:Object = this._97299bar;
         if(_loc2_ !== param1)
         {
            this._97299bar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : CharacterModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:CharacterModel) : void
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
      
      [Bindable(event="propertyChange")]
      public function get abilityModel() : AbilityModel
      {
         return this._259260447abilityModel;
      }
      
      public function set abilityModel(param1:AbilityModel) : void
      {
         var _loc2_:Object = this._259260447abilityModel;
         if(_loc2_ !== param1)
         {
            this._259260447abilityModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"abilityModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedTab() : int
      {
         return this._220498682selectedTab;
      }
      
      public function set selectedTab(param1:int) : void
      {
         var _loc2_:Object = this._220498682selectedTab;
         if(_loc2_ !== param1)
         {
            this._220498682selectedTab = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedTab",_loc2_,param1));
            }
         }
      }
   }
}

