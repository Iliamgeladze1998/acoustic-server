package soul.view.interaction.loot
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
   import soul.event.LootEvent;
   import soul.model.item.Item;
   import soul.view.assets.Button1;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   import soul.view.ui.controls.Window;
   
   use namespace mx_internal;
   
   public class BindingDialog extends Window implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _BindingDialog_Button11:Button1;
      
      public var _BindingDialog_Button12:Button1;
      
      public var _BindingDialog_ItemRenderer1:ItemRenderer;
      
      public var _BindingDialog_Label1:Label;
      
      private var _3242771item:Item;
      
      private var _1422950858action:String;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function BindingDialog()
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
         bindings = this._BindingDialog_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_loot_BindingDialogWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return BindingDialog[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 282;
         this.height = 150;
         this.padding = 3;
         this.children = [this._BindingDialog_VBox1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         BindingDialog._watcherSetupUtil = param1;
      }
      
      private function confirm() : void
      {
         dispatchEvent(new LootEvent(LootEvent.CONFIRM));
      }
      
      override public function tryToConfirm(e:Event) : void
      {
         e.stopImmediatePropagation();
         this.confirm();
      }
      
      override protected function exit(e:Event) : void
      {
         super.exit(e);
         dispatchEvent(new Event(Window.DIALOG_CLOSE));
      }
      
      private function getMessage(action:String) : String
      {
         return Boolean(action) ? LocaleManager.getString(BundleName.INTERFACE,"binding." + action + ".confirmation") : null;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.CONTROLS,key);
      }
      
      private function _BindingDialog_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 10;
         _loc1_.padding = 10;
         _loc1_.verticalAlign = "bottom";
         _loc1_.percentWidth = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.children = [this._BindingDialog_HBox1_c(),this._BindingDialog_HBox2_c()];
         return _loc1_;
      }
      
      private function _BindingDialog_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 10;
         _loc1_.percentWidth = 100;
         _loc1_.children = [this._BindingDialog_ItemRenderer1_i(),this._BindingDialog_Label1_i()];
         return _loc1_;
      }
      
      private function _BindingDialog_ItemRenderer1_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         this._BindingDialog_ItemRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_BindingDialog_ItemRenderer1",this._BindingDialog_ItemRenderer1);
         return _loc1_;
      }
      
      private function _BindingDialog_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.percentWidth = 100;
         this._BindingDialog_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_BindingDialog_Label1",this._BindingDialog_Label1);
         return _loc1_;
      }
      
      private function _BindingDialog_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.children = [this._BindingDialog_Button11_i(),this._BindingDialog_Button12_i()];
         return _loc1_;
      }
      
      private function _BindingDialog_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.padding = 5;
         _loc1_.width = 100;
         _loc1_.addEventListener("click",this.___BindingDialog_Button11_click);
         this._BindingDialog_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_BindingDialog_Button11",this._BindingDialog_Button11);
         return _loc1_;
      }
      
      public function ___BindingDialog_Button11_click(event:MouseEvent) : void
      {
         this.confirm();
      }
      
      private function _BindingDialog_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.padding = 5;
         _loc1_.width = 100;
         _loc1_.addEventListener("click",this.___BindingDialog_Button12_click);
         this._BindingDialog_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_BindingDialog_Button12",this._BindingDialog_Button12);
         return _loc1_;
      }
      
      public function ___BindingDialog_Button12_click(event:MouseEvent) : void
      {
         this.exit(null);
      }
      
      private function _BindingDialog_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,null,null,"_BindingDialog_ItemRenderer1.item","item");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = getMessage(action);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BindingDialog_Label1.text");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("yesLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BindingDialog_Button11.label");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getString("noLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BindingDialog_Button12.label");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get item() : Item
      {
         return this._3242771item;
      }
      
      public function set item(param1:Item) : void
      {
         var _loc2_:Object = this._3242771item;
         if(_loc2_ !== param1)
         {
            this._3242771item = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"item",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get action() : String
      {
         return this._1422950858action;
      }
      
      public function set action(param1:String) : void
      {
         var _loc2_:Object = this._1422950858action;
         if(_loc2_ !== param1)
         {
            this._1422950858action = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"action",_loc2_,param1));
            }
         }
      }
   }
}

