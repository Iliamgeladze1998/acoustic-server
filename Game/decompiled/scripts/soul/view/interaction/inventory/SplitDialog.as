package soul.view.interaction.inventory
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
   import soul.event.InventoryEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.item.Item;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.GradientBox;
   import soul.view.common.Icons;
   import soul.view.ui.HBox;
   import soul.view.ui.Input;
   import soul.view.ui.Slider;
   import soul.view.ui.VBox;
   import soul.view.ui.controls.Window;
   
   use namespace mx_internal;
   
   public class SplitDialog extends Window implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _SplitDialog_HBox4:HBox;
      
      public var _SplitDialog_ItemRenderer1:ItemRenderer;
      
      private var _1990131276cancelButton:Button1;
      
      private var _94851343count:Input;
      
      private var _1062724170maxButton:Button1;
      
      private var _1641788370okButton:Button1;
      
      private var _899647263slider:Slider;
      
      public var slotIndex:int = -1;
      
      private var _382106123maxCount:int = 1;
      
      private var defaultCount:int = 1;
      
      private var _item:Item;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SplitDialog()
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
         bindings = this._SplitDialog_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_inventory_SplitDialogWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return SplitDialog[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._SplitDialog_VBox1_c()];
         this.addEventListener("creationComplete",this.___SplitDialog_Window1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SplitDialog._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         this.maxButton.addEventListener(MouseEvent.CLICK,this.maxClicked);
         this.okButton.addEventListener(MouseEvent.CLICK,this.okClicked);
         this.cancelButton.addEventListener(MouseEvent.CLICK,this.cancelClicked);
         this.slider.value = this.defaultCount;
      }
      
      private function maxClicked(e:Event) : void
      {
         this.slider.value = this.maxCount;
      }
      
      private function okClicked(e:MouseEvent) : void
      {
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.SPLIT);
         var i:Item = new Item();
         i.id = this.item.id;
         i.key = this.item.key;
         i.count = this.slider.value;
         i.imagePath = this.item.imagePath;
         ne.item = i;
         ne.mouseEvent = e;
         ne.slotIndex = this.slotIndex;
         dispatchEvent(ne);
      }
      
      private function cancelClicked(e:Event) : void
      {
         this.exit(e);
      }
      
      private function set _3242771item(value:Item) : void
      {
         this._item = value;
         if(this.item.count > 0)
         {
            this.maxCount = this.item.count;
         }
      }
      
      public function get item() : Item
      {
         return this._item;
      }
      
      override protected function exit(e:Event) : void
      {
         dispatchEvent(new Event(Window.DIALOG_CLOSE));
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _SplitDialog_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.width = 282;
         _loc1_.height = 125;
         _loc1_.children = [this._SplitDialog_HBox1_c(),this._SplitDialog_GradientBox1_c()];
         return _loc1_;
      }
      
      private function _SplitDialog_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 10;
         _loc1_.padding = 10;
         _loc1_.verticalAlign = "bottom";
         _loc1_.children = [this._SplitDialog_ItemRenderer1_i(),this._SplitDialog_VBox2_c()];
         return _loc1_;
      }
      
      private function _SplitDialog_ItemRenderer1_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         this._SplitDialog_ItemRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_SplitDialog_ItemRenderer1",this._SplitDialog_ItemRenderer1);
         return _loc1_;
      }
      
      private function _SplitDialog_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 10;
         _loc1_.children = [this._SplitDialog_HBox2_c(),this._SplitDialog_HBox3_c()];
         return _loc1_;
      }
      
      private function _SplitDialog_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 10;
         _loc1_.children = [this._SplitDialog_Slider1_i(),this._SplitDialog_Input1_i()];
         return _loc1_;
      }
      
      private function _SplitDialog_Slider1_i() : Slider
      {
         var _loc1_:Slider = new Slider();
         _loc1_.width = 126;
         _loc1_.height = 20;
         _loc1_.minValue = 1;
         this.slider = _loc1_;
         BindingManager.executeBindings(this,"slider",this.slider);
         return _loc1_;
      }
      
      private function _SplitDialog_Input1_i() : Input
      {
         var _loc1_:Input = new Input();
         _loc1_.width = 44;
         _loc1_.height = 21;
         _loc1_.align = "center";
         _loc1_.restrict = "0-9";
         _loc1_.color = 0;
         _loc1_.fontSize = 12;
         this.count = _loc1_;
         BindingManager.executeBindings(this,"count",this.count);
         return _loc1_;
      }
      
      private function _SplitDialog_HBox3_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 15;
         _loc1_.children = [this._SplitDialog_Button11_i(),this._SplitDialog_Button12_i(),this._SplitDialog_Button13_i()];
         return _loc1_;
      }
      
      private function _SplitDialog_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         this.maxButton = _loc1_;
         BindingManager.executeBindings(this,"maxButton",this.maxButton);
         return _loc1_;
      }
      
      private function _SplitDialog_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         this.okButton = _loc1_;
         BindingManager.executeBindings(this,"okButton",this.okButton);
         return _loc1_;
      }
      
      private function _SplitDialog_Button13_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         this.cancelButton = _loc1_;
         BindingManager.executeBindings(this,"cancelButton",this.cancelButton);
         return _loc1_;
      }
      
      private function _SplitDialog_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.padding = 10;
         _loc1_.children = [this._SplitDialog_HBox4_i()];
         return _loc1_;
      }
      
      private function _SplitDialog_HBox4_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.verticalCenter = 0;
         _loc1_.right = 0;
         _loc1_.verticalAlign = "middle";
         _loc1_.gap = 2;
         this._SplitDialog_HBox4 = _loc1_;
         BindingManager.executeBindings(this,"_SplitDialog_HBox4",this._SplitDialog_HBox4);
         return _loc1_;
      }
      
      public function ___SplitDialog_Window1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _SplitDialog_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = LocaleManager.getString(BundleName.INTERFACE,"split.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"this.label");
         result[1] = new Binding(this,null,null,"_SplitDialog_ItemRenderer1.item","item");
         result[2] = new Binding(this,function():int
         {
            return maxCount - slider.value;
         },null,"_SplitDialog_ItemRenderer1.count");
         result[3] = new Binding(this,function():int
         {
            return maxCount;
         },null,"slider.maxValue");
         result[4] = new Binding(this,function():int
         {
            return int(count.text);
         },null,"slider.value");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = slider.value;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"count.text");
         result[6] = new Binding(this,function():Object
         {
            return Assets.chatInput;
         },null,"count.borderSkin");
         result[7] = new Binding(this,function():Object
         {
            return Icons.maximize;
         },null,"maxButton.icon");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = getString("maximize");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"maxButton.toolTip");
         result[9] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"okButton.icon");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = getString("accept");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"okButton.toolTip");
         result[11] = new Binding(this,function():Object
         {
            return Icons.cancel;
         },null,"cancelButton.icon");
         result[12] = new Binding(this,function():String
         {
            var _loc1_:* = getString("cancel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"cancelButton.toolTip");
         result[13] = new Binding(this,function():String
         {
            var _loc1_:* = getString("load");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SplitDialog_HBox4.toolTip");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get cancelButton() : Button1
      {
         return this._1990131276cancelButton;
      }
      
      public function set cancelButton(param1:Button1) : void
      {
         var _loc2_:Object = this._1990131276cancelButton;
         if(_loc2_ !== param1)
         {
            this._1990131276cancelButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cancelButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get count() : Input
      {
         return this._94851343count;
      }
      
      public function set count(param1:Input) : void
      {
         var _loc2_:Object = this._94851343count;
         if(_loc2_ !== param1)
         {
            this._94851343count = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"count",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get maxButton() : Button1
      {
         return this._1062724170maxButton;
      }
      
      public function set maxButton(param1:Button1) : void
      {
         var _loc2_:Object = this._1062724170maxButton;
         if(_loc2_ !== param1)
         {
            this._1062724170maxButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get okButton() : Button1
      {
         return this._1641788370okButton;
      }
      
      public function set okButton(param1:Button1) : void
      {
         var _loc2_:Object = this._1641788370okButton;
         if(_loc2_ !== param1)
         {
            this._1641788370okButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"okButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get slider() : Slider
      {
         return this._899647263slider;
      }
      
      public function set slider(param1:Slider) : void
      {
         var _loc2_:Object = this._899647263slider;
         if(_loc2_ !== param1)
         {
            this._899647263slider = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"slider",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get maxCount() : int
      {
         return this._382106123maxCount;
      }
      
      private function set maxCount(param1:int) : void
      {
         var _loc2_:Object = this._382106123maxCount;
         if(_loc2_ !== param1)
         {
            this._382106123maxCount = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxCount",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set item(param1:Item) : void
      {
         var _loc2_:Object = this.item;
         if(_loc2_ !== param1)
         {
            this._3242771item = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"item",_loc2_,param1));
            }
         }
      }
   }
}

