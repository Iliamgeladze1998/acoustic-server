package soul.view.interaction.dashboard
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
   import soul.event.DashboardEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.interaction.dashboard.DashboardEntry;
   import soul.model.interaction.dashboard.DashboardModel;
   import soul.model.interaction.settings.SettingsModel;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.SimpleImageBar;
   import soul.view.common.Icons;
   import soul.view.common.TabIcons;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Checkbox;
   import soul.view.ui.Container;
   
   use namespace mx_internal;
   
   public class DashboardScreen extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const tabImages:Array = [[TabIcons.sword2,TabIcons.sword1],[TabIcons.citadel0,TabIcons.citadel1]];
      
      public var _DashboardScreen_BorderedContainer1:BorderedContainer;
      
      public var _DashboardScreen_CachedImage1:CachedImage;
      
      public var _DashboardScreen_EventDescription1:EventDescription;
      
      private var _92819628bJoin:Button1;
      
      private var _1416017035bLeave:Button1;
      
      private var _97299bar:SimpleImageBar;
      
      private var _178324674calendar:EventCalendar;
      
      private var _1042418502showSubscription:Checkbox;
      
      private var _104069929model:DashboardModel;
      
      private var _620925754settingsModel:SettingsModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function DashboardScreen()
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
         bindings = this._DashboardScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_dashboard_DashboardScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return DashboardScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 768;
         this.height = 382;
         this.children = [this._DashboardScreen_SimpleImageBar1_i(),this._DashboardScreen_CachedImage1_i(),this._DashboardScreen_BorderedContainer1_i(),this._DashboardScreen_EventCalendar1_i(),this._DashboardScreen_EventDescription1_i(),this._DashboardScreen_Checkbox1_i(),this._DashboardScreen_Button11_i(),this._DashboardScreen_Button12_i()];
         this.addEventListener("creationComplete",this.___DashboardScreen_Container1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         DashboardScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("dashboard.title");
         this.model.dispatchEvent(new DashboardEvent(DashboardEvent.GET_ENTRIES));
      }
      
      private function onChangeSubscription() : void
      {
         this.settingsModel.pvpEventsHidden = !this.showSubscription.selected;
      }
      
      private function join() : void
      {
         this.bJoin.enabled = false;
         var ne:DashboardEvent = new DashboardEvent(DashboardEvent.JOIN);
         ne.entry = this.calendar.selectedEntry;
         this.model.dispatchEvent(ne);
      }
      
      private function leave() : void
      {
         this.bLeave.enabled = false;
         var ne:DashboardEvent = new DashboardEvent(DashboardEvent.LEAVE);
         ne.entry = this.calendar.selectedEntry;
         this.model.dispatchEvent(ne);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _DashboardScreen_SimpleImageBar1_i() : SimpleImageBar
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
      
      private function _DashboardScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 12;
         _loc1_.y = 42;
         this._DashboardScreen_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_DashboardScreen_CachedImage1",this._DashboardScreen_CachedImage1);
         return _loc1_;
      }
      
      private function _DashboardScreen_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.x = 476;
         _loc1_.y = 42;
         _loc1_.width = 277;
         _loc1_.height = 326;
         this._DashboardScreen_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_DashboardScreen_BorderedContainer1",this._DashboardScreen_BorderedContainer1);
         return _loc1_;
      }
      
      private function _DashboardScreen_EventCalendar1_i() : EventCalendar
      {
         var _loc1_:EventCalendar = new EventCalendar();
         _loc1_.x = 22;
         _loc1_.y = 52;
         _loc1_.width = 436;
         _loc1_.height = 262;
         this.calendar = _loc1_;
         BindingManager.executeBindings(this,"calendar",this.calendar);
         return _loc1_;
      }
      
      private function _DashboardScreen_EventDescription1_i() : EventDescription
      {
         var _loc1_:EventDescription = new EventDescription();
         _loc1_.x = 479;
         _loc1_.y = 45;
         _loc1_.width = 270;
         _loc1_.height = 320;
         this._DashboardScreen_EventDescription1 = _loc1_;
         BindingManager.executeBindings(this,"_DashboardScreen_EventDescription1",this._DashboardScreen_EventDescription1);
         return _loc1_;
      }
      
      private function _DashboardScreen_Checkbox1_i() : Checkbox
      {
         var _loc1_:Checkbox = new Checkbox();
         _loc1_.x = 27;
         _loc1_.y = 332;
         _loc1_.addEventListener("change",this.__showSubscription_change);
         this.showSubscription = _loc1_;
         BindingManager.executeBindings(this,"showSubscription",this.showSubscription);
         return _loc1_;
      }
      
      public function __showSubscription_change(event:Event) : void
      {
         this.onChangeSubscription();
      }
      
      private function _DashboardScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.x = 340;
         _loc1_.y = 330;
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.__bJoin_click);
         this.bJoin = _loc1_;
         BindingManager.executeBindings(this,"bJoin",this.bJoin);
         return _loc1_;
      }
      
      public function __bJoin_click(event:MouseEvent) : void
      {
         this.join();
      }
      
      private function _DashboardScreen_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.x = 400;
         _loc1_.y = 330;
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.__bLeave_click);
         this.bLeave = _loc1_;
         BindingManager.executeBindings(this,"bLeave",this.bLeave);
         return _loc1_;
      }
      
      public function __bLeave_click(event:MouseEvent) : void
      {
         this.leave();
      }
      
      public function ___DashboardScreen_Container1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _DashboardScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Array
         {
            var _loc1_:* = tabImages;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.dataProvider");
         result[1] = new Binding(this,function():Array
         {
            var _loc1_:* = [getString("events.battle"),getString("events.citadel")];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.toolTips");
         result[2] = new Binding(this,function():Object
         {
            return Assets.panelSet;
         },null,"_DashboardScreen_CachedImage1.source");
         result[3] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_DashboardScreen_BorderedContainer1.borderSkin");
         result[4] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"_DashboardScreen_BorderedContainer1.backgroundImage");
         result[5] = new Binding(this,function():Array
         {
            var _loc1_:* = bar.selectedIndex == 1 ? model.citadelEntries : model.bgEntries;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"calendar.dataProvider");
         result[6] = new Binding(this,function():DashboardEntry
         {
            return calendar.selectedEntry;
         },null,"_DashboardScreen_EventDescription1.entry");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = getString("dashboard.subscription");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"showSubscription.label");
         result[8] = new Binding(this,function():Boolean
         {
            return !settingsModel.pvpEventsHidden;
         },null,"showSubscription.selected");
         result[9] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"bJoin.icon");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = getString("accept");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"bJoin.toolTip");
         result[11] = new Binding(this,function():Boolean
         {
            return calendar.selectedEntry != null && calendar.selectedEntry.canBeAccepted;
         },null,"bJoin.enabled");
         result[12] = new Binding(this,function():Boolean
         {
            return bar.selectedIndex == 0;
         },null,"bJoin.visible");
         result[13] = new Binding(this,function():Object
         {
            return Icons.cancel;
         },null,"bLeave.icon");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = getString("decline");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"bLeave.toolTip");
         result[15] = new Binding(this,function():Boolean
         {
            return calendar.selectedEntry != null && calendar.selectedEntry.canBeDenied;
         },null,"bLeave.enabled");
         result[16] = new Binding(this,function():Boolean
         {
            return bar.selectedIndex == 0;
         },null,"bLeave.visible");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get bJoin() : Button1
      {
         return this._92819628bJoin;
      }
      
      public function set bJoin(param1:Button1) : void
      {
         var _loc2_:Object = this._92819628bJoin;
         if(_loc2_ !== param1)
         {
            this._92819628bJoin = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bJoin",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bLeave() : Button1
      {
         return this._1416017035bLeave;
      }
      
      public function set bLeave(param1:Button1) : void
      {
         var _loc2_:Object = this._1416017035bLeave;
         if(_loc2_ !== param1)
         {
            this._1416017035bLeave = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bLeave",_loc2_,param1));
            }
         }
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
      public function get calendar() : EventCalendar
      {
         return this._178324674calendar;
      }
      
      public function set calendar(param1:EventCalendar) : void
      {
         var _loc2_:Object = this._178324674calendar;
         if(_loc2_ !== param1)
         {
            this._178324674calendar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"calendar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get showSubscription() : Checkbox
      {
         return this._1042418502showSubscription;
      }
      
      public function set showSubscription(param1:Checkbox) : void
      {
         var _loc2_:Object = this._1042418502showSubscription;
         if(_loc2_ !== param1)
         {
            this._1042418502showSubscription = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showSubscription",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : DashboardModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:DashboardModel) : void
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
      public function get settingsModel() : SettingsModel
      {
         return this._620925754settingsModel;
      }
      
      public function set settingsModel(param1:SettingsModel) : void
      {
         var _loc2_:Object = this._620925754settingsModel;
         if(_loc2_ !== param1)
         {
            this._620925754settingsModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"settingsModel",_loc2_,param1));
            }
         }
      }
   }
}

