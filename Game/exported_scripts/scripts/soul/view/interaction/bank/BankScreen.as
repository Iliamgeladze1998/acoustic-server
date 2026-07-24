package soul.view.interaction.bank
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
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.SimpleUIEvent;
   import soul.model.character.CharacterModel;
   import soul.net.ServerLayer;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.common.CurrencyType;
   import soul.view.common.Icons;
   import soul.view.common.MoneyRenderer;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.Box;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Input;
   import soul.view.ui.Slider;
   
   use namespace mx_internal;
   
   public class BankScreen extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const SELECTED:Array = [new GlowFilter(65280)];
      
      private static const SERVICE:String = "bankService";
      
      private static const TO_BANK:uint = 1;
      
      private static const TO_BACKPACK:uint = 0;
      
      public var _BankScreen_Button11:Button1;
      
      public var _BankScreen_Button12:Button1;
      
      public var _BankScreen_Button13:Button1;
      
      public var _BankScreen_CachedImage2:CachedImage;
      
      public var _BankScreen_CachedImage3:CachedImage;
      
      public var _BankScreen_GradientBox1:GradientBox;
      
      public var _BankScreen_GradientBox2:GradientBox;
      
      public var _BankScreen_MoneyRenderer1:MoneyRenderer;
      
      public var _BankScreen_MoneyRenderer2:MoneyRenderer;
      
      private var _2121767808backpack:CachedImage;
      
      private var _3016252bank:CachedImage;
      
      private var _94851343count:Input;
      
      private var _899647263slider:Slider;
      
      private var _104069929model:CharacterModel;
      
      private var _356925201characterCoppers:uint;
      
      private var _1274013854bankCoppers:uint;
      
      private var _869412009toBank:Boolean = true;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function BankScreen()
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
         bindings = this._BankScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_bank_BankScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return BankScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 336;
         this.height = 228;
         this.children = [this._BankScreen_CachedImage1_i(),this._BankScreen_CachedImage2_i(),this._BankScreen_CachedImage3_i(),this._BankScreen_CachedImage4_i(),this._BankScreen_GradientBox1_i(),this._BankScreen_MoneyRenderer1_i(),this._BankScreen_GradientBox2_i(),this._BankScreen_MoneyRenderer2_i(),this._BankScreen_Input1_i(),this._BankScreen_Box1_c(),this._BankScreen_Slider1_i()];
         this.addEventListener("creationComplete",this.___BankScreen_Canvas1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         BankScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("bank.title");
         this.characterCoppers = this.model.currencies[CurrencyType.COPPER];
         ServerLayer.call(SERVICE,"getBank",this.setBank);
      }
      
      private function setBank(coppers:uint) : void
      {
         this.bankCoppers = coppers;
      }
      
      private function selectBank() : void
      {
         this.toBank = true;
      }
      
      private function selectBackpack() : void
      {
         this.toBank = false;
      }
      
      private function swap() : void
      {
         this.toBank = !this.toBank;
      }
      
      private function maximize() : void
      {
         this.slider.value = this.toBank ? int(this.characterCoppers) : int(this.bankCoppers);
      }
      
      private function apply() : void
      {
         var amount:uint = uint(this.slider.value);
         var method:String = this.toBank ? "store" : "take";
         ServerLayer.call(SERVICE,method,this.creationComplete,null,amount);
      }
      
      private function reset() : void
      {
         this.count.text = "";
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _BankScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.left = 30;
         _loc1_.top = 27;
         _loc1_.addEventListener("click",this.__backpack_click);
         this.backpack = _loc1_;
         BindingManager.executeBindings(this,"backpack",this.backpack);
         return _loc1_;
      }
      
      public function __backpack_click(event:MouseEvent) : void
      {
         this.selectBackpack();
      }
      
      private function _BankScreen_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.left = 150;
         _loc1_.top = 35;
         _loc1_.scaleX = -1;
         _loc1_.addEventListener("click",this.___BankScreen_CachedImage2_click);
         this._BankScreen_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_BankScreen_CachedImage2",this._BankScreen_CachedImage2);
         return _loc1_;
      }
      
      public function ___BankScreen_CachedImage2_click(event:MouseEvent) : void
      {
         this.selectBackpack();
      }
      
      private function _BankScreen_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.right = 100;
         _loc1_.top = 35;
         _loc1_.addEventListener("click",this.___BankScreen_CachedImage3_click);
         this._BankScreen_CachedImage3 = _loc1_;
         BindingManager.executeBindings(this,"_BankScreen_CachedImage3",this._BankScreen_CachedImage3);
         return _loc1_;
      }
      
      public function ___BankScreen_CachedImage3_click(event:MouseEvent) : void
      {
         this.selectBank();
      }
      
      private function _BankScreen_CachedImage4_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.right = 30;
         _loc1_.top = 27;
         _loc1_.addEventListener("click",this.__bank_click);
         this.bank = _loc1_;
         BindingManager.executeBindings(this,"bank",this.bank);
         return _loc1_;
      }
      
      public function __bank_click(event:MouseEvent) : void
      {
         this.selectBank();
      }
      
      private function _BankScreen_GradientBox1_i() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.width = 160;
         _loc1_.height = 28;
         _loc1_.top = 90;
         _loc1_.left = 3;
         this._BankScreen_GradientBox1 = _loc1_;
         BindingManager.executeBindings(this,"_BankScreen_GradientBox1",this._BankScreen_GradientBox1);
         return _loc1_;
      }
      
      private function _BankScreen_MoneyRenderer1_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         _loc1_.top = 94;
         _loc1_.left = 20;
         this._BankScreen_MoneyRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_BankScreen_MoneyRenderer1",this._BankScreen_MoneyRenderer1);
         return _loc1_;
      }
      
      private function _BankScreen_GradientBox2_i() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.width = 160;
         _loc1_.height = 28;
         _loc1_.top = 90;
         _loc1_.right = 3;
         this._BankScreen_GradientBox2 = _loc1_;
         BindingManager.executeBindings(this,"_BankScreen_GradientBox2",this._BankScreen_GradientBox2);
         return _loc1_;
      }
      
      private function _BankScreen_MoneyRenderer2_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         _loc1_.right = 20;
         _loc1_.top = 94;
         this._BankScreen_MoneyRenderer2 = _loc1_;
         BindingManager.executeBindings(this,"_BankScreen_MoneyRenderer2",this._BankScreen_MoneyRenderer2);
         return _loc1_;
      }
      
      private function _BankScreen_Input1_i() : Input
      {
         var _loc1_:Input = new Input();
         _loc1_.horizontalCenter = 0;
         _loc1_.top = 150;
         _loc1_.color = 0;
         _loc1_.restrict = "0-9";
         _loc1_.width = 80;
         _loc1_.height = 20;
         this.count = _loc1_;
         BindingManager.executeBindings(this,"count",this.count);
         return _loc1_;
      }
      
      private function _BankScreen_Box1_c() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.gap = 10;
         _loc1_.direction = "horizontal";
         _loc1_.horizontalCenter = 0;
         _loc1_.top = 180;
         _loc1_.children = [this._BankScreen_Button11_i(),this._BankScreen_Button12_i(),this._BankScreen_Button13_i()];
         return _loc1_;
      }
      
      private function _BankScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___BankScreen_Button11_click);
         this._BankScreen_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_BankScreen_Button11",this._BankScreen_Button11);
         return _loc1_;
      }
      
      public function ___BankScreen_Button11_click(event:MouseEvent) : void
      {
         this.maximize();
      }
      
      private function _BankScreen_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___BankScreen_Button12_click);
         this._BankScreen_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_BankScreen_Button12",this._BankScreen_Button12);
         return _loc1_;
      }
      
      public function ___BankScreen_Button12_click(event:MouseEvent) : void
      {
         this.apply();
      }
      
      private function _BankScreen_Button13_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___BankScreen_Button13_click);
         this._BankScreen_Button13 = _loc1_;
         BindingManager.executeBindings(this,"_BankScreen_Button13",this._BankScreen_Button13);
         return _loc1_;
      }
      
      public function ___BankScreen_Button13_click(event:MouseEvent) : void
      {
         this.reset();
      }
      
      private function _BankScreen_Slider1_i() : Slider
      {
         var _loc1_:Slider = new Slider();
         _loc1_.top = 120;
         _loc1_.horizontalCenter = 0;
         _loc1_.width = 200;
         _loc1_.minValue = 0;
         this.slider = _loc1_;
         BindingManager.executeBindings(this,"slider",this.slider);
         return _loc1_;
      }
      
      public function ___BankScreen_Canvas1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _BankScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Icons.backpack;
         },null,"backpack.source");
         result[1] = new Binding(this,function():Array
         {
            var _loc1_:* = toBank ? [] : SELECTED;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"backpack.filters");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("inventory.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"backpack.toolTip");
         result[3] = new Binding(this,function():Object
         {
            return Assets.greenArrow;
         },null,"_BankScreen_CachedImage2.source");
         result[4] = new Binding(this,function():Array
         {
            var _loc1_:* = toBank ? Colors.DISABLED_ALPHA_FILTER : [];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_BankScreen_CachedImage2.filters");
         result[5] = new Binding(this,function():Object
         {
            return Assets.greenArrow;
         },null,"_BankScreen_CachedImage3.source");
         result[6] = new Binding(this,function():Array
         {
            var _loc1_:* = toBank ? [] : Colors.DISABLED_ALPHA_FILTER;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_BankScreen_CachedImage3.filters");
         result[7] = new Binding(this,function():Object
         {
            return Icons.bank;
         },null,"bank.source");
         result[8] = new Binding(this,function():Array
         {
            var _loc1_:* = toBank ? SELECTED : [];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bank.filters");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = getString("bank.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"bank.toolTip");
         result[10] = new Binding(this,function():Array
         {
            var _loc1_:* = [[2852126720,127],0];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_BankScreen_GradientBox1.gradient");
         result[11] = new Binding(this,function():uint
         {
            return characterCoppers;
         },null,"_BankScreen_MoneyRenderer1.value");
         result[12] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_BankScreen_MoneyRenderer1.color");
         result[13] = new Binding(this,function():Array
         {
            var _loc1_:* = [0,[2852126720,127]];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_BankScreen_GradientBox2.gradient");
         result[14] = new Binding(this,function():uint
         {
            return bankCoppers;
         },null,"_BankScreen_MoneyRenderer2.value");
         result[15] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_BankScreen_MoneyRenderer2.color");
         result[16] = new Binding(this,function():Object
         {
            return Assets.chatInput;
         },null,"count.borderSkin");
         result[17] = new Binding(this,function():String
         {
            var _loc1_:* = slider.value;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"count.text");
         result[18] = new Binding(this,function():Object
         {
            return Icons.maximize;
         },null,"_BankScreen_Button11.icon");
         result[19] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_BankScreen_Button12.icon");
         result[20] = new Binding(this,function():Object
         {
            return Icons.cancel;
         },null,"_BankScreen_Button13.icon");
         result[21] = new Binding(this,function():int
         {
            return int(count.text);
         },null,"slider.value");
         result[22] = new Binding(this,function():int
         {
            return toBank ? int(characterCoppers) : int(bankCoppers);
         },null,"slider.maxValue");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get backpack() : CachedImage
      {
         return this._2121767808backpack;
      }
      
      public function set backpack(param1:CachedImage) : void
      {
         var _loc2_:Object = this._2121767808backpack;
         if(_loc2_ !== param1)
         {
            this._2121767808backpack = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"backpack",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bank() : CachedImage
      {
         return this._3016252bank;
      }
      
      public function set bank(param1:CachedImage) : void
      {
         var _loc2_:Object = this._3016252bank;
         if(_loc2_ !== param1)
         {
            this._3016252bank = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bank",_loc2_,param1));
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
      
      [Bindable(event="propertyChange")]
      private function get characterCoppers() : uint
      {
         return this._356925201characterCoppers;
      }
      
      private function set characterCoppers(param1:uint) : void
      {
         var _loc2_:Object = this._356925201characterCoppers;
         if(_loc2_ !== param1)
         {
            this._356925201characterCoppers = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"characterCoppers",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get bankCoppers() : uint
      {
         return this._1274013854bankCoppers;
      }
      
      private function set bankCoppers(param1:uint) : void
      {
         var _loc2_:Object = this._1274013854bankCoppers;
         if(_loc2_ !== param1)
         {
            this._1274013854bankCoppers = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bankCoppers",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get toBank() : Boolean
      {
         return this._869412009toBank;
      }
      
      private function set toBank(param1:Boolean) : void
      {
         var _loc2_:Object = this._869412009toBank;
         if(_loc2_ !== param1)
         {
            this._869412009toBank = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"toBank",_loc2_,param1));
            }
         }
      }
   }
}

