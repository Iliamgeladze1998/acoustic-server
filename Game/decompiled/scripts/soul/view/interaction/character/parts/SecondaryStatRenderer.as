package soul.view.interaction.character.parts
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
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   
   use namespace mx_internal;
   
   public class SecondaryStatRenderer extends HBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _900811040tLabel:Label;
      
      private var _891565731tValue:Label;
      
      private var _1808450477highlighted:Boolean;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SecondaryStatRenderer()
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
         bindings = this._SecondaryStatRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_character_parts_SecondaryStatRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return SecondaryStatRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.gap = 3;
         this.percentWidth = 100;
         this.height = 20;
         this.children = [this._SecondaryStatRenderer_Component1_c(),this._SecondaryStatRenderer_Label1_i(),this._SecondaryStatRenderer_Label2_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SecondaryStatRenderer._watcherSetupUtil = param1;
      }
      
      public function set label(value:String) : void
      {
         this.tLabel.text = value;
      }
      
      public function set value(value:String) : void
      {
         this.tValue.text = value;
      }
      
      private function _SecondaryStatRenderer_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 30;
         return _loc1_;
      }
      
      private function _SecondaryStatRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.color = 0;
         this.tLabel = _loc1_;
         BindingManager.executeBindings(this,"tLabel",this.tLabel);
         return _loc1_;
      }
      
      private function _SecondaryStatRenderer_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         _loc1_.bold = true;
         this.tValue = _loc1_;
         BindingManager.executeBindings(this,"tValue",this.tValue);
         return _loc1_;
      }
      
      private function _SecondaryStatRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():uint
         {
            return highlighted ? 1410830 : 11151889;
         },null,"tValue.color");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get tLabel() : Label
      {
         return this._900811040tLabel;
      }
      
      public function set tLabel(param1:Label) : void
      {
         var _loc2_:Object = this._900811040tLabel;
         if(_loc2_ !== param1)
         {
            this._900811040tLabel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tLabel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tValue() : Label
      {
         return this._891565731tValue;
      }
      
      public function set tValue(param1:Label) : void
      {
         var _loc2_:Object = this._891565731tValue;
         if(_loc2_ !== param1)
         {
            this._891565731tValue = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tValue",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get highlighted() : Boolean
      {
         return this._1808450477highlighted;
      }
      
      public function set highlighted(param1:Boolean) : void
      {
         var _loc2_:Object = this._1808450477highlighted;
         if(_loc2_ !== param1)
         {
            this._1808450477highlighted = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"highlighted",_loc2_,param1));
            }
         }
      }
   }
}

