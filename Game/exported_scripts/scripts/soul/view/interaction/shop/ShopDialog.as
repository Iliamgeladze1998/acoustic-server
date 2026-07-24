package soul.view.interaction.shop
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
   import soul.event.ShopEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.character.CharacterModel;
   import soul.model.location.shop.ShopItem;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.GradientBox;
   import soul.view.common.Icons;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.ui.HBox;
   import soul.view.ui.Input;
   import soul.view.ui.Slider;
   import soul.view.ui.VBox;
   import soul.view.ui.controls.Window;
   
   use namespace mx_internal;
   
   public class ShopDialog extends Window implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _ShopDialog_ItemRenderer1:ItemRenderer;
      
      public var _ShopDialog_SimpleShopDialogPriceBox1:SimpleShopDialogPriceBox;
      
      private var _1990131276cancelButton:Button1;
      
      private var _94851343count:Input;
      
      private var _1062724170maxButton:Button1;
      
      private var _1641788370okButton:Button1;
      
      private var _899647263slider:Slider;
      
      private var _382106123maxCount:int = 1;
      
      private var defaultCount:int = 1;
      
      private var _item:ShopItem;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ShopDialog()
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
         bindings = this._ShopDialog_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_shop_ShopDialogWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ShopDialog[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 282;
         this.height = 150;
         this.padding = 3;
         this.children = [this._ShopDialog_HBox1_c(),this._ShopDialog_GradientBox1_c()];
         this.addEventListener("creationComplete",this.___ShopDialog_Window1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ShopDialog._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         this.maxButton.addEventListener(MouseEvent.CLICK,this.maxClicked);
         this.okButton.addEventListener(MouseEvent.CLICK,this.okClicked);
         this.cancelButton.addEventListener(MouseEvent.CLICK,this.exit);
         this.slider.value = this.defaultCount;
      }
      
      private function maxClicked(e:MouseEvent) : void
      {
         this.slider.value = this.maxCount;
      }
      
      private function okClicked(e:Event) : void
      {
         var ne:ShopEvent = null;
         if(int(this.item.id) > 0)
         {
            ne = new ShopEvent(ShopEvent.SELL_ITEM);
            ne.item = this.item;
            ne.count = this.slider.value;
         }
         else
         {
            ne = new ShopEvent(ShopEvent.BUY_ITEM);
            ne.templateId = this.item.templateId;
            ne.count = this.slider.value;
         }
         dispatchEvent(ne);
      }
      
      private function set _3242771item(value:ShopItem) : void
      {
         this._item = value;
         if(value.count > 0)
         {
            this.maxCount = value.count;
            if(int(this.item.id) > 0)
            {
               this.defaultCount = this.maxCount;
            }
         }
      }
      
      public function get item() : ShopItem
      {
         return this._item;
      }
      
      public function set characterModel(value:CharacterModel) : void
      {
         var currency:String = null;
         var priceValue:int = 0;
         var maxByCurrency:int = 0;
         var max:int = this.item.count;
         for(currency in this.item.price)
         {
            priceValue = int(this.item.price[currency]);
            if(priceValue > 0)
            {
               maxByCurrency = value.currencies[currency] / priceValue;
               max = Math.min(max,maxByCurrency);
            }
         }
         this.maxCount = Math.max(1,max);
         if(int(this.item.id) > 0)
         {
            this.defaultCount = this.maxCount;
         }
      }
      
      override public function tryToConfirm(e:Event) : void
      {
         e.stopImmediatePropagation();
         this.okClicked(null);
      }
      
      override protected function exit(e:Event) : void
      {
         dispatchEvent(new Event(Window.DIALOG_CLOSE));
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _ShopDialog_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 10;
         _loc1_.padding = 10;
         _loc1_.verticalAlign = "bottom";
         _loc1_.children = [this._ShopDialog_ItemRenderer1_i(),this._ShopDialog_VBox1_c()];
         return _loc1_;
      }
      
      private function _ShopDialog_ItemRenderer1_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         this._ShopDialog_ItemRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_ShopDialog_ItemRenderer1",this._ShopDialog_ItemRenderer1);
         return _loc1_;
      }
      
      private function _ShopDialog_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 10;
         _loc1_.children = [this._ShopDialog_HBox2_c(),this._ShopDialog_HBox3_c()];
         return _loc1_;
      }
      
      private function _ShopDialog_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 10;
         _loc1_.children = [this._ShopDialog_Slider1_i(),this._ShopDialog_Input1_i()];
         return _loc1_;
      }
      
      private function _ShopDialog_Slider1_i() : Slider
      {
         var _loc1_:Slider = new Slider();
         _loc1_.width = 126;
         _loc1_.height = 20;
         _loc1_.minValue = 1;
         this.slider = _loc1_;
         BindingManager.executeBindings(this,"slider",this.slider);
         return _loc1_;
      }
      
      private function _ShopDialog_Input1_i() : Input
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
      
      private function _ShopDialog_HBox3_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 15;
         _loc1_.children = [this._ShopDialog_Button11_i(),this._ShopDialog_Button12_i(),this._ShopDialog_Button13_i()];
         return _loc1_;
      }
      
      private function _ShopDialog_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         this.maxButton = _loc1_;
         BindingManager.executeBindings(this,"maxButton",this.maxButton);
         return _loc1_;
      }
      
      private function _ShopDialog_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         this.okButton = _loc1_;
         BindingManager.executeBindings(this,"okButton",this.okButton);
         return _loc1_;
      }
      
      private function _ShopDialog_Button13_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         this.cancelButton = _loc1_;
         BindingManager.executeBindings(this,"cancelButton",this.cancelButton);
         return _loc1_;
      }
      
      private function _ShopDialog_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.padding = 10;
         _loc1_.children = [this._ShopDialog_SimpleShopDialogPriceBox1_i()];
         return _loc1_;
      }
      
      private function _ShopDialog_SimpleShopDialogPriceBox1_i() : SimpleShopDialogPriceBox
      {
         var _loc1_:SimpleShopDialogPriceBox = new SimpleShopDialogPriceBox();
         _loc1_.verticalCenter = 0;
         _loc1_.left = 0;
         _loc1_.direction = "horizontal";
         _loc1_.gap = 3;
         _loc1_.horizontalAlign = "left";
         _loc1_.verticalAlign = "middle";
         this._ShopDialog_SimpleShopDialogPriceBox1 = _loc1_;
         BindingManager.executeBindings(this,"_ShopDialog_SimpleShopDialogPriceBox1",this._ShopDialog_SimpleShopDialogPriceBox1);
         return _loc1_;
      }
      
      public function ___ShopDialog_Window1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _ShopDialog_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = getString(int(item.id) > 0 ? "sell.title" : "buy.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"this.label");
         result[1] = new Binding(this,null,null,"_ShopDialog_ItemRenderer1.item","item");
         result[2] = new Binding(this,function():int
         {
            return maxCount;
         },null,"slider.maxValue");
         result[3] = new Binding(this,function():int
         {
            return int(count.text);
         },null,"slider.value");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = slider.value;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"count.text");
         result[5] = new Binding(this,function():Object
         {
            return Assets.chatInput;
         },null,"count.borderSkin");
         result[6] = new Binding(this,function():Object
         {
            return Icons.maximize;
         },null,"maxButton.icon");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = getString("maximize");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"maxButton.toolTip");
         result[8] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"okButton.icon");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = getString("accept");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"okButton.toolTip");
         result[10] = new Binding(this,function():Object
         {
            return Icons.cancel;
         },null,"cancelButton.icon");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = getString("cancel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"cancelButton.toolTip");
         result[12] = new Binding(this,function():int
         {
            return slider.value;
         },null,"_ShopDialog_SimpleShopDialogPriceBox1.count");
         result[13] = new Binding(this,function():Object
         {
            return item.price;
         },null,"_ShopDialog_SimpleShopDialogPriceBox1.price");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = getString("cost");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ShopDialog_SimpleShopDialogPriceBox1.toolTip");
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
      public function set item(param1:ShopItem) : void
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

