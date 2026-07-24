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
   import soul.view.assets.Colors;
   import soul.view.ui.Box;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   
   use namespace mx_internal;
   
   public class StatDescription extends ScrollBase implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _1724546052description:Label;
      
      private var _110371416title:Label;
      
      private var _type:String;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function StatDescription()
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
         bindings = this._StatDescription_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_academy_StatDescriptionWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return StatDescription[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.verticalScrollPolicy = "on";
         this.horizontalScrollPolicy = "off";
         this.backgroundColor = 1;
         this.backgroundAlpha = 0;
         this.wheelMultiplier = 4;
         this.children = [this._StatDescription_Box1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         StatDescription._watcherSetupUtil = param1;
      }
      
      public function set type(value:String) : void
      {
         if(this._type == value)
         {
            return;
         }
         this._type = value;
         this.title.text = this.getString(value);
         this.description.text = this.getString(value + ".description");
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _StatDescription_Box1_c() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.direction = "vertical";
         _loc1_.horizontalAlign = "center";
         _loc1_.children = [this._StatDescription_Component1_c(),this._StatDescription_Label1_i(),this._StatDescription_Label2_i()];
         return _loc1_;
      }
      
      private function _StatDescription_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 210;
         return _loc1_;
      }
      
      private function _StatDescription_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.color = 2073890;
         _loc1_.bold = true;
         this.title = _loc1_;
         BindingManager.executeBindings(this,"title",this.title);
         return _loc1_;
      }
      
      private function _StatDescription_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.width = 210;
         _loc1_.padding = 5;
         this.description = _loc1_;
         BindingManager.executeBindings(this,"description",this.description);
         return _loc1_;
      }
      
      private function _StatDescription_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():uint
         {
            return Colors.LABEL;
         },null,"description.color");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : Label
      {
         return this._1724546052description;
      }
      
      public function set description(param1:Label) : void
      {
         var _loc2_:Object = this._1724546052description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
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

