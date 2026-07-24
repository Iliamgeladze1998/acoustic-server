package soul.view.interaction.academy
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
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.SimpleUIEvent;
   import soul.model.character.CharacterModel;
   import soul.model.location.academy.AcademyModel;
   import soul.view.assets.Assets;
   import soul.view.assets.SimpleImageBar;
   import soul.view.common.TabIcons;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Container;
   import soul.view.ui.ViewStack;
   
   use namespace mx_internal;
   
   public class AcademyScreen extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const TABS:Array = [[TabIcons.academyClass0,TabIcons.academyClass1],[TabIcons.academyStats0,TabIcons.academyStats1]];
      
      public var _AcademyScreen_BorderedContainer1:BorderedContainer;
      
      public var _AcademyScreen_CachedImage1:CachedImage;
      
      public var _AcademyScreen_ViewStack1:ViewStack;
      
      private var _97299bar:SimpleImageBar;
      
      private var _102131072klass:ClassChangeScreen;
      
      private var _109757599stats:StatResetScreen;
      
      private var _104069929model:AcademyModel;
      
      private var _1564195625character:CharacterModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function AcademyScreen()
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
         bindings = this._AcademyScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_academy_AcademyScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return AcademyScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 727;
         this.height = 382;
         this.children = [this._AcademyScreen_SimpleImageBar1_i(),this._AcademyScreen_CachedImage1_i(),this._AcademyScreen_BorderedContainer1_i(),this._AcademyScreen_ViewStack1_i()];
         this.addEventListener("creationComplete",this.___AcademyScreen_Container1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         AcademyScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("academy.title");
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _AcademyScreen_SimpleImageBar1_i() : SimpleImageBar
      {
         var _loc1_:SimpleImageBar = new SimpleImageBar();
         _loc1_.x = 13;
         _loc1_.y = 8;
         _loc1_.selectedIndex = 0;
         _loc1_.gap = 1;
         this.bar = _loc1_;
         BindingManager.executeBindings(this,"bar",this.bar);
         return _loc1_;
      }
      
      private function _AcademyScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 12;
         _loc1_.y = 42;
         this._AcademyScreen_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_AcademyScreen_CachedImage1",this._AcademyScreen_CachedImage1);
         return _loc1_;
      }
      
      private function _AcademyScreen_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.x = 476;
         _loc1_.y = 42;
         _loc1_.width = 238;
         _loc1_.height = 326;
         this._AcademyScreen_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_AcademyScreen_BorderedContainer1",this._AcademyScreen_BorderedContainer1);
         return _loc1_;
      }
      
      private function _AcademyScreen_ViewStack1_i() : ViewStack
      {
         var _loc1_:ViewStack = new ViewStack();
         _loc1_.x = 12;
         _loc1_.y = 42;
         _loc1_.children = [this._AcademyScreen_ClassChangeScreen1_i(),this._AcademyScreen_StatResetScreen1_i()];
         this._AcademyScreen_ViewStack1 = _loc1_;
         BindingManager.executeBindings(this,"_AcademyScreen_ViewStack1",this._AcademyScreen_ViewStack1);
         return _loc1_;
      }
      
      private function _AcademyScreen_ClassChangeScreen1_i() : ClassChangeScreen
      {
         var _loc1_:ClassChangeScreen = new ClassChangeScreen();
         this.klass = _loc1_;
         BindingManager.executeBindings(this,"klass",this.klass);
         return _loc1_;
      }
      
      private function _AcademyScreen_StatResetScreen1_i() : StatResetScreen
      {
         var _loc1_:StatResetScreen = new StatResetScreen();
         this.stats = _loc1_;
         BindingManager.executeBindings(this,"stats",this.stats);
         return _loc1_;
      }
      
      public function ___AcademyScreen_Container1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _AcademyScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Array
         {
            var _loc1_:* = TABS;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.dataProvider");
         result[1] = new Binding(this,function():Array
         {
            var _loc1_:* = [getString("classChange"),getString("statsChange")];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.toolTips");
         result[2] = new Binding(this,function():Object
         {
            return Assets.panelSet;
         },null,"_AcademyScreen_CachedImage1.source");
         result[3] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_AcademyScreen_BorderedContainer1.borderSkin");
         result[4] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"_AcademyScreen_BorderedContainer1.backgroundImage");
         result[5] = new Binding(this,function():int
         {
            return bar.selectedIndex;
         },null,"_AcademyScreen_ViewStack1.selectedIndex");
         result[6] = new Binding(this,null,null,"klass.model","model");
         result[7] = new Binding(this,null,null,"klass.character","character");
         result[8] = new Binding(this,null,null,"stats.model","model");
         result[9] = new Binding(this,null,null,"stats.character","character");
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
      public function get klass() : ClassChangeScreen
      {
         return this._102131072klass;
      }
      
      public function set klass(param1:ClassChangeScreen) : void
      {
         var _loc2_:Object = this._102131072klass;
         if(_loc2_ !== param1)
         {
            this._102131072klass = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"klass",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get stats() : StatResetScreen
      {
         return this._109757599stats;
      }
      
      public function set stats(param1:StatResetScreen) : void
      {
         var _loc2_:Object = this._109757599stats;
         if(_loc2_ !== param1)
         {
            this._109757599stats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stats",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : AcademyModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:AcademyModel) : void
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
      public function get character() : CharacterModel
      {
         return this._1564195625character;
      }
      
      public function set character(param1:CharacterModel) : void
      {
         var _loc2_:Object = this._1564195625character;
         if(_loc2_ !== param1)
         {
            this._1564195625character = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"character",_loc2_,param1));
            }
         }
      }
   }
}

