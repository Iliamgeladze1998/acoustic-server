package soul.view.interaction.instance
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
   import soul.controller.Interaction;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.SimpleUIEvent;
   import soul.model.character.CharacterModel;
   import soul.model.common.InteractionType;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class InstanceScreen extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _InstanceScreen_BorderedContainer1:BorderedContainer;
      
      public var _InstanceScreen_Button11:Button1;
      
      public var _InstanceScreen_InstanceList1:InstanceList;
      
      public var _InstanceScreen_Label1:Label;
      
      public var _InstanceScreen_Label2:Label;
      
      private var _104069929model:CharacterModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function InstanceScreen()
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
         bindings = this._InstanceScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_instance_InstanceScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return InstanceScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 350;
         this.height = 250;
         this.padding = 10;
         this.gap = 5;
         this.horizontalAlign = "center";
         this.children = [this._InstanceScreen_BorderedContainer1_i(),this._InstanceScreen_Button11_i()];
         this.addEventListener("creationComplete",this.___InstanceScreen_VBox1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         InstanceScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("instances.title");
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _InstanceScreen_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.backgroundColor = 1;
         _loc1_.backgroundPadding = 2;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.padding = 5;
         _loc1_.gap = 2;
         _loc1_.direction = "vertical";
         _loc1_.children = [this._InstanceScreen_HBox1_c(),this._InstanceScreen_InstanceList1_i()];
         this._InstanceScreen_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_InstanceScreen_BorderedContainer1",this._InstanceScreen_BorderedContainer1);
         return _loc1_;
      }
      
      private function _InstanceScreen_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.backgroundColor = 3355443;
         _loc1_.percentWidth = 100;
         _loc1_.children = [this._InstanceScreen_Label1_i(),this._InstanceScreen_Label2_i()];
         return _loc1_;
      }
      
      private function _InstanceScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 200;
         _loc1_.align = "center";
         this._InstanceScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_InstanceScreen_Label1",this._InstanceScreen_Label1);
         return _loc1_;
      }
      
      private function _InstanceScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.align = "center";
         this._InstanceScreen_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_InstanceScreen_Label2",this._InstanceScreen_Label2);
         return _loc1_;
      }
      
      private function _InstanceScreen_InstanceList1_i() : InstanceList
      {
         var _loc1_:InstanceList = new InstanceList();
         _loc1_.gap = 10;
         this._InstanceScreen_InstanceList1 = _loc1_;
         BindingManager.executeBindings(this,"_InstanceScreen_InstanceList1",this._InstanceScreen_InstanceList1);
         return _loc1_;
      }
      
      private function _InstanceScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.padding = 5;
         _loc1_.addEventListener("click",this.___InstanceScreen_Button11_click);
         this._InstanceScreen_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_InstanceScreen_Button11",this._InstanceScreen_Button11);
         return _loc1_;
      }
      
      public function ___InstanceScreen_Button11_click(event:MouseEvent) : void
      {
         Interaction.hide(InteractionType.INSTANCE);
      }
      
      public function ___InstanceScreen_VBox1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _InstanceScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.serifeBorder;
         },null,"_InstanceScreen_BorderedContainer1.borderSkin");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = getString("instanceName");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InstanceScreen_Label1.text");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("instanceCooldown");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InstanceScreen_Label2.text");
         result[3] = new Binding(this,function():Array
         {
            var _loc1_:* = model.instances;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_InstanceScreen_InstanceList1.instances");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = getString("close");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InstanceScreen_Button11.label");
         return result;
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
   }
}

