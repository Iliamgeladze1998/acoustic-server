package soul.view.rtm
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
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.SimpleUIEvent;
   import soul.model.common.InteractionType;
   import soul.model.interaction.dashboard.BattlegroundEntry;
   import soul.model.interaction.dashboard.DashboardModel;
   import soul.model.interaction.settings.SettingsModel;
   import soul.model.system.Configuration;
   import soul.utils.DateUtils;
   import soul.view.assets.GlitterImage;
   import soul.view.common.Icons;
   import soul.view.ui.Canvas;
   import soul.view.ui.Label;
   
   use namespace mx_internal;
   
   public class EventIcon extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const FILTERS:Array = [new GlowFilter(0,1,6,6,3)];
      
      private var _3226745icon:GlitterImage;
      
      private var _102727412label:Label;
      
      private var _104069929model:DashboardModel;
      
      private var _620925754settingsModel:SettingsModel;
      
      private var _739630300nearestEvent:BattlegroundEntry;
      
      private var timer:Timer;
      
      private var ticker:uint;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function EventIcon()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this.timer = new Timer(1000);
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         bindings = this._EventIcon_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_rtm_EventIconWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return EventIcon[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 31;
         this.height = 50;
         this.children = [this._EventIcon_GlitterImage1_i(),this._EventIcon_Label1_i()];
         this.addEventListener("click",this.___EventIcon_Canvas1_click);
         this.addEventListener("creationComplete",this.___EventIcon_Canvas1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         EventIcon._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         this.timer.addEventListener(TimerEvent.TIMER,this.tick);
         this.timer.start();
      }
      
      private function removed(e:Event) : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.tick);
      }
      
      private function onClick() : void
      {
         Interaction.toggle(InteractionType.DASHBOARD);
      }
      
      override public function set visible(value:Boolean) : void
      {
         super.visible = this.icon.visible = value;
         scaleX = value ? 1 : 0;
         if(value)
         {
            this.timer.start();
         }
         else
         {
            this.timer.stop();
         }
      }
      
      private function set nearest(e:BattlegroundEntry) : void
      {
         this.nearestEvent = e;
         clearInterval(this.ticker);
         if(Boolean(e))
         {
            this.timer.start();
            this.tick(null);
         }
         else
         {
            this.timer.stop();
            this.label.text = "";
         }
      }
      
      private function tick(e:TimerEvent) : void
      {
         if(!this.nearestEvent)
         {
            this.timer.stop();
            this.label.text = "";
            return;
         }
         var msLeft:Number = this.nearestEvent.date.time - Configuration.serverTimeDelta - new Date().time;
         if(msLeft < 0)
         {
            this.timer.stop();
            this.label.text = "";
            return;
         }
         this.label.text = DateUtils.getBuffTimeLeft(msLeft);
      }
      
      private function getTooltip(nearestEvent:BattlegroundEntry, hasNewEntry:Boolean) : String
      {
         return Boolean(nearestEvent) ? LocaleManager.getString(BundleName.EVENT,nearestEvent.localeId) : (hasNewEntry ? LocaleManager.getString(BundleName.INTERFACE,"dashboard.eventAvailable") : LocaleManager.getString(BundleName.INTERFACE,"dashboard.title"));
      }
      
      private function _EventIcon_GlitterImage1_i() : GlitterImage
      {
         var _loc1_:GlitterImage = new GlitterImage();
         _loc1_.y = 19;
         this.icon = _loc1_;
         BindingManager.executeBindings(this,"icon",this.icon);
         return _loc1_;
      }
      
      private function _EventIcon_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.horizontalCenter = 0;
         _loc1_.color = 16777215;
         _loc1_.fontSize = 10;
         this.label = _loc1_;
         BindingManager.executeBindings(this,"label",this.label);
         return _loc1_;
      }
      
      public function ___EventIcon_Canvas1_click(event:MouseEvent) : void
      {
         this.onClick();
      }
      
      public function ___EventIcon_Canvas1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _EventIcon_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Boolean
         {
            return !settingsModel.pvpEventsHidden;
         },null,"this.visible");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = getTooltip(model.nearestBgEntry,model.hasNewEntry);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"this.toolTip");
         result[2] = new Binding(this,function():*
         {
            return model.nearestBgEntry;
         },function(param1:*):void
         {
            nearest = param1;
         },"nearest");
         result[3] = new Binding(this,function():Object
         {
            return Icons.event;
         },null,"icon.source");
         result[4] = new Binding(this,function():Boolean
         {
            return model.hasNewEntry;
         },null,"icon.animated");
         result[5] = new Binding(this,function():Array
         {
            var _loc1_:* = FILTERS;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"label.filters");
         return result;
      }
      
      private function _EventIcon_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         this.nearest = this.model.nearestBgEntry;
      }
      
      [Bindable(event="propertyChange")]
      public function get icon() : GlitterImage
      {
         return this._3226745icon;
      }
      
      public function set icon(param1:GlitterImage) : void
      {
         var _loc2_:Object = this._3226745icon;
         if(_loc2_ !== param1)
         {
            this._3226745icon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"icon",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get label() : Label
      {
         return this._102727412label;
      }
      
      public function set label(param1:Label) : void
      {
         var _loc2_:Object = this._102727412label;
         if(_loc2_ !== param1)
         {
            this._102727412label = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"label",_loc2_,param1));
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
      
      [Bindable(event="propertyChange")]
      private function get nearestEvent() : BattlegroundEntry
      {
         return this._739630300nearestEvent;
      }
      
      private function set nearestEvent(param1:BattlegroundEntry) : void
      {
         var _loc2_:Object = this._739630300nearestEvent;
         if(_loc2_ !== param1)
         {
            this._739630300nearestEvent = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nearestEvent",_loc2_,param1));
            }
         }
      }
   }
}

