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
   import soul.view.assets.Assets;
   import soul.view.common.Icons;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   
   use namespace mx_internal;
   
   [Event(name="change",type="flash.events.Event")]
   public class StatChanger extends HBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _StatChanger_BorderedContainer1:BorderedContainer;
      
      public var _StatChanger_CachedImage2:CachedImage;
      
      public var _StatChanger_CachedImage3:CachedImage;
      
      public var _StatChanger_Label2:Label;
      
      private var _3226745icon:CachedImage;
      
      private var _900811040tLabel:Label;
      
      private var _733902135available:int = 0;
      
      private var _111972721value:int;
      
      private var _615513385modifier:int = 0;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function StatChanger()
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
         bindings = this._StatChanger_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_character_parts_StatChangerWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return StatChanger[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.gap = 3;
         this.percentWidth = 100;
         this.height = 26;
         this.verticalAlign = "middle";
         this.children = [this._StatChanger_CachedImage1_i(),this._StatChanger_BorderedContainer1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         StatChanger._watcherSetupUtil = param1;
      }
      
      private function decrease() : void
      {
         --this.modifier;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function increase() : void
      {
         ++this.modifier;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function set source(value:Object) : void
      {
         this.icon.source = value;
      }
      
      public function set label(value:String) : void
      {
         this.tLabel.text = value;
      }
      
      private function _StatChanger_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.icon = _loc1_;
         BindingManager.executeBindings(this,"icon",this.icon);
         return _loc1_;
      }
      
      private function _StatChanger_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.percentWidth = 100;
         _loc1_.height = 22;
         _loc1_.verticalAlign = "middle";
         _loc1_.padding = 3;
         _loc1_.children = [this._StatChanger_Label1_i(),this._StatChanger_CachedImage2_i(),this._StatChanger_Label2_i(),this._StatChanger_CachedImage3_i()];
         this._StatChanger_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_StatChanger_BorderedContainer1",this._StatChanger_BorderedContainer1);
         return _loc1_;
      }
      
      private function _StatChanger_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.color = 11151889;
         _loc1_.fontSize = 12;
         this.tLabel = _loc1_;
         BindingManager.executeBindings(this,"tLabel",this.tLabel);
         return _loc1_;
      }
      
      private function _StatChanger_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.addEventListener("click",this.___StatChanger_CachedImage2_click);
         this._StatChanger_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_StatChanger_CachedImage2",this._StatChanger_CachedImage2);
         return _loc1_;
      }
      
      public function ___StatChanger_CachedImage2_click(event:MouseEvent) : void
      {
         this.decrease();
      }
      
      private function _StatChanger_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 33;
         _loc1_.fontSize = 12;
         _loc1_.bold = true;
         _loc1_.align = "center";
         this._StatChanger_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_StatChanger_Label2",this._StatChanger_Label2);
         return _loc1_;
      }
      
      private function _StatChanger_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.addEventListener("click",this.___StatChanger_CachedImage3_click);
         this._StatChanger_CachedImage3 = _loc1_;
         BindingManager.executeBindings(this,"_StatChanger_CachedImage3",this._StatChanger_CachedImage3);
         return _loc1_;
      }
      
      public function ___StatChanger_CachedImage3_click(event:MouseEvent) : void
      {
         this.increase();
      }
      
      private function _StatChanger_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.mailBorder;
         },null,"_StatChanger_BorderedContainer1.borderSkin");
         result[1] = new Binding(this,function():Object
         {
            return Icons.minusStats;
         },null,"_StatChanger_CachedImage2.source");
         result[2] = new Binding(this,function():Boolean
         {
            return modifier > 0;
         },null,"_StatChanger_CachedImage2.enabled");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = int(value + modifier);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatChanger_Label2.text");
         result[4] = new Binding(this,function():uint
         {
            return modifier > 0 ? 1410830 : 11151889;
         },null,"_StatChanger_Label2.color");
         result[5] = new Binding(this,function():Object
         {
            return Icons.plusStats;
         },null,"_StatChanger_CachedImage3.source");
         result[6] = new Binding(this,function():Boolean
         {
            return available > 0;
         },null,"_StatChanger_CachedImage3.enabled");
         return result;
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
      public function get available() : int
      {
         return this._733902135available;
      }
      
      public function set available(param1:int) : void
      {
         var _loc2_:Object = this._733902135available;
         if(_loc2_ !== param1)
         {
            this._733902135available = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"available",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get value() : int
      {
         return this._111972721value;
      }
      
      public function set value(param1:int) : void
      {
         var _loc2_:Object = this._111972721value;
         if(_loc2_ !== param1)
         {
            this._111972721value = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"value",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get modifier() : int
      {
         return this._615513385modifier;
      }
      
      public function set modifier(param1:int) : void
      {
         var _loc2_:Object = this._615513385modifier;
         if(_loc2_ !== param1)
         {
            this._615513385modifier = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"modifier",_loc2_,param1));
            }
         }
      }
   }
}

