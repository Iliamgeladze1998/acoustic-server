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
   import soul.model.interaction.dashboard.DashboardEntry;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.ui.Box;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Component;
   import soul.view.ui.Container;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   
   use namespace mx_internal;
   
   public class EventDescription extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const WIDTH:uint = 250;
      
      private var _97739box:Box;
      
      private var _3226745icon:CachedImage;
      
      private var _110371416title:Label;
      
      private var _entry:DashboardEntry;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function EventDescription()
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
         bindings = this._EventDescription_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_dashboard_EventDescriptionWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return EventDescription[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.visible = false;
         this.children = [this._EventDescription_GradientBox1_c(),this._EventDescription_ScrollBase1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         EventDescription._watcherSetupUtil = param1;
      }
      
      public function set entry(value:DashboardEntry) : void
      {
         var descriptor:Component = null;
         if(this._entry == value)
         {
            return;
         }
         this._entry = value;
         visible = value != null;
         this.box.removeAllChildren();
         if(!value)
         {
            return;
         }
         this.title.text = this.getEvent(value.localeId);
         this.icon.source = value.icon;
         var descriptors:Vector.<Component> = value.getDescriptors();
         for each(descriptor in descriptors)
         {
            this.box.addChild(descriptor);
         }
      }
      
      private function getEvent(key:String) : String
      {
         return LocaleManager.getString(BundleName.EVENT,key);
      }
      
      private function _EventDescription_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 37;
         _loc1_.children = [this._EventDescription_Container1_c(),this._EventDescription_Label1_i()];
         return _loc1_;
      }
      
      private function _EventDescription_Container1_c() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.width = 26;
         _loc1_.left = 10;
         _loc1_.height = 26;
         _loc1_.verticalCenter = 0;
         _loc1_.children = [this._EventDescription_CachedImage1_i()];
         return _loc1_;
      }
      
      private function _EventDescription_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.icon = _loc1_;
         BindingManager.executeBindings(this,"icon",this.icon);
         return _loc1_;
      }
      
      private function _EventDescription_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.left = 40;
         _loc1_.verticalCenter = 0;
         _loc1_.bold = true;
         _loc1_.fontSize = 12;
         this.title = _loc1_;
         BindingManager.executeBindings(this,"title",this.title);
         return _loc1_;
      }
      
      private function _EventDescription_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.horizontalScrollPolicy = "off";
         _loc1_.verticalScrollPolicy = "on";
         _loc1_.y = 41;
         _loc1_.width = 265;
         _loc1_.height = 275;
         _loc1_.backgroundColor = 0;
         _loc1_.backgroundAlpha = 0;
         _loc1_.wheelMultiplier = 4;
         _loc1_.children = [this._EventDescription_Box1_i()];
         return _loc1_;
      }
      
      private function _EventDescription_Box1_i() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.direction = "vertical";
         _loc1_.padding = 5;
         _loc1_.gap = 5;
         this.box = _loc1_;
         BindingManager.executeBindings(this,"box",this.box);
         return _loc1_;
      }
      
      private function _EventDescription_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"title.color");
         result[1] = new Binding(this,function():Number
         {
            return WIDTH;
         },null,"box.width");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get box() : Box
      {
         return this._97739box;
      }
      
      public function set box(param1:Box) : void
      {
         var _loc2_:Object = this._97739box;
         if(_loc2_ !== param1)
         {
            this._97739box = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"box",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get icon() : CachedImage
      {
         return this._3226745icon;
      }
      
      public function set icon(param1:CachedImage) : void
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
      public function get title() : Label
      {
         return this._110371416title;
      }
      
      public function set title(param1:Label) : void
      {
         var _loc2_:Object = this._110371416title;
         if(_loc2_ !== param1)
         {
            this._110371416title = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"title",_loc2_,param1));
            }
         }
      }
   }
}

