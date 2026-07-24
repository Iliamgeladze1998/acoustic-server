package soul.view.interaction.ruby.tabs
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
   import soul.model.character.CharacterModel;
   import soul.model.item.Item;
   import soul.model.item.ItemClass;
   import soul.model.system.Configuration;
   import soul.net.ServerLayer;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.assets.GradientLabel;
   import soul.view.common.Currency;
   import soul.view.common.CurrencyType;
   import soul.view.common.Icons;
   import soul.view.common.MoneyRenderer;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Container;
   import soul.view.ui.HBox;
   import soul.view.ui.Input;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.Slider;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class RubyTab extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _RubyTab_Button11:Button1;
      
      public var _RubyTab_Button12:Button1;
      
      public var _RubyTab_Button13:Button1;
      
      public var _RubyTab_CachedImage1:CachedImage;
      
      public var _RubyTab_CachedImage2:CachedImage;
      
      public var _RubyTab_CachedImage3:CachedImage;
      
      public var _RubyTab_CachedImage4:CachedImage;
      
      public var _RubyTab_CachedImage5:CachedImage;
      
      public var _RubyTab_GradientBox2:GradientBox;
      
      public var _RubyTab_GradientLabel1:GradientLabel;
      
      public var _RubyTab_GradientLabel2:GradientLabel;
      
      public var _RubyTab_GradientLabel3:GradientLabel;
      
      public var _RubyTab_GradientLabel4:GradientLabel;
      
      public var _RubyTab_ItemRenderer1:ItemRenderer;
      
      public var _RubyTab_ItemRenderer2:ItemRenderer;
      
      public var _RubyTab_Label1:Label;
      
      public var _RubyTab_Label2:Label;
      
      public var _RubyTab_Label3:Label;
      
      public var _RubyTab_Label4:Label;
      
      public var _RubyTab_Label5:Label;
      
      public var _RubyTab_Label6:Label;
      
      public var _RubyTab_MoneyRenderer1:MoneyRenderer;
      
      public var _RubyTab_MoneyRenderer2:MoneyRenderer;
      
      private var _100358090input:Input;
      
      private var _899647263slider:Slider;
      
      private var _104069929model:CharacterModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function RubyTab()
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
         bindings = this._RubyTab_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_ruby_tabs_RubyTabWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return RubyTab[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._RubyTab_Canvas1_c(),this._RubyTab_ScrollBase1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         RubyTab._watcherSetupUtil = param1;
      }
      
      private function maximize() : void
      {
         this.slider.value = this.slider.maxValue;
      }
      
      private function cancel(r:* = null) : void
      {
         this.slider.value = 0;
      }
      
      private function accept() : void
      {
         ServerLayer.call("characterService","exchange",this.cancel,null,this.slider.value);
      }
      
      private function buyRuby() : void
      {
         Configuration.openExternalURL("pay");
      }
      
      private function earnRuby() : void
      {
         Configuration.openExternalURL("earn");
      }
      
      private function get rubyItem() : Item
      {
         var rubies:Item = new Item();
         rubies.imagePath = "money/rubies.png";
         rubies.itemClass = ItemClass.CLASS4;
         rubies.templateId = Currency.RUBIES;
         return rubies;
      }
      
      private function get moneyItem() : Item
      {
         var rubies:Item = new Item();
         rubies.imagePath = "money/copper.png";
         rubies.itemClass = ItemClass.CLASS4;
         rubies.templateId = Currency.COPPER;
         return rubies;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _RubyTab_Canvas1_c() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.x = 9;
         _loc1_.y = 9;
         _loc1_.width = 438;
         _loc1_.height = 308;
         _loc1_.children = [this._RubyTab_GradientLabel1_i(),this._RubyTab_GradientLabel2_i(),this._RubyTab_CachedImage1_i(),this._RubyTab_GradientLabel3_i(),this._RubyTab_CachedImage2_i(),this._RubyTab_GradientLabel4_i(),this._RubyTab_HBox1_c(),this._RubyTab_MoneyRenderer1_i(),this._RubyTab_MoneyRenderer2_i()];
         return _loc1_;
      }
      
      private function _RubyTab_GradientLabel1_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.fontSize = 12;
         _loc1_.verticalAlign = "middle";
         this._RubyTab_GradientLabel1 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_GradientLabel1",this._RubyTab_GradientLabel1);
         return _loc1_;
      }
      
      private function _RubyTab_GradientLabel2_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.x = 185;
         _loc1_.y = 50;
         _loc1_.width = 240;
         _loc1_.height = 24;
         _loc1_.bgPaddingLeft = -10;
         _loc1_.fontSize = 12;
         _loc1_.verticalAlign = "middle";
         _loc1_.addEventListener("click",this.___RubyTab_GradientLabel2_click);
         this._RubyTab_GradientLabel2 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_GradientLabel2",this._RubyTab_GradientLabel2);
         return _loc1_;
      }
      
      public function ___RubyTab_GradientLabel2_click(event:MouseEvent) : void
      {
         this.buyRuby();
      }
      
      private function _RubyTab_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 15;
         _loc1_.y = 35;
         _loc1_.addEventListener("click",this.___RubyTab_CachedImage1_click);
         this._RubyTab_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_CachedImage1",this._RubyTab_CachedImage1);
         return _loc1_;
      }
      
      public function ___RubyTab_CachedImage1_click(event:MouseEvent) : void
      {
         this.buyRuby();
      }
      
      private function _RubyTab_GradientLabel3_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.x = 185;
         _loc1_.y = 110;
         _loc1_.width = 240;
         _loc1_.height = 24;
         _loc1_.bgPaddingLeft = -10;
         _loc1_.fontSize = 12;
         _loc1_.verticalAlign = "middle";
         _loc1_.addEventListener("click",this.___RubyTab_GradientLabel3_click);
         this._RubyTab_GradientLabel3 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_GradientLabel3",this._RubyTab_GradientLabel3);
         return _loc1_;
      }
      
      public function ___RubyTab_GradientLabel3_click(event:MouseEvent) : void
      {
         this.earnRuby();
      }
      
      private function _RubyTab_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 15;
         _loc1_.y = 95;
         _loc1_.addEventListener("click",this.___RubyTab_CachedImage2_click);
         this._RubyTab_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_CachedImage2",this._RubyTab_CachedImage2);
         return _loc1_;
      }
      
      public function ___RubyTab_CachedImage2_click(event:MouseEvent) : void
      {
         this.earnRuby();
      }
      
      private function _RubyTab_GradientLabel4_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.y = 162;
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.fontSize = 12;
         _loc1_.verticalAlign = "middle";
         this._RubyTab_GradientLabel4 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_GradientLabel4",this._RubyTab_GradientLabel4);
         return _loc1_;
      }
      
      private function _RubyTab_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.x = 15;
         _loc1_.y = 192;
         _loc1_.gap = 45;
         _loc1_.children = [this._RubyTab_ItemRenderer1_i(),this._RubyTab_VBox1_c(),this._RubyTab_ItemRenderer2_i()];
         return _loc1_;
      }
      
      private function _RubyTab_ItemRenderer1_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         this._RubyTab_ItemRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_ItemRenderer1",this._RubyTab_ItemRenderer1);
         return _loc1_;
      }
      
      private function _RubyTab_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 15;
         _loc1_.horizontalAlign = "center";
         _loc1_.children = [this._RubyTab_HBox2_c(),this._RubyTab_HBox3_c()];
         return _loc1_;
      }
      
      private function _RubyTab_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 8;
         _loc1_.children = [this._RubyTab_Input1_i(),this._RubyTab_Slider1_i()];
         return _loc1_;
      }
      
      private function _RubyTab_Input1_i() : Input
      {
         var _loc1_:Input = new Input();
         _loc1_.width = 60;
         _loc1_.height = 21;
         _loc1_.color = 0;
         _loc1_.fontSize = 12;
         _loc1_.align = "center";
         _loc1_.restrict = "0-9";
         _loc1_.padding = 10;
         this.input = _loc1_;
         BindingManager.executeBindings(this,"input",this.input);
         return _loc1_;
      }
      
      private function _RubyTab_Slider1_i() : Slider
      {
         var _loc1_:Slider = new Slider();
         _loc1_.width = 126;
         _loc1_.height = 20;
         _loc1_.minValue = 0;
         this.slider = _loc1_;
         BindingManager.executeBindings(this,"slider",this.slider);
         return _loc1_;
      }
      
      private function _RubyTab_HBox3_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 10;
         _loc1_.children = [this._RubyTab_Button11_i(),this._RubyTab_Button12_i(),this._RubyTab_Button13_i()];
         return _loc1_;
      }
      
      private function _RubyTab_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___RubyTab_Button11_click);
         this._RubyTab_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_Button11",this._RubyTab_Button11);
         return _loc1_;
      }
      
      public function ___RubyTab_Button11_click(event:MouseEvent) : void
      {
         this.maximize();
      }
      
      private function _RubyTab_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___RubyTab_Button12_click);
         this._RubyTab_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_Button12",this._RubyTab_Button12);
         return _loc1_;
      }
      
      public function ___RubyTab_Button12_click(event:MouseEvent) : void
      {
         this.accept();
      }
      
      private function _RubyTab_Button13_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___RubyTab_Button13_click);
         this._RubyTab_Button13 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_Button13",this._RubyTab_Button13);
         return _loc1_;
      }
      
      public function ___RubyTab_Button13_click(event:MouseEvent) : void
      {
         this.cancel();
      }
      
      private function _RubyTab_ItemRenderer2_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         this._RubyTab_ItemRenderer2 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_ItemRenderer2",this._RubyTab_ItemRenderer2);
         return _loc1_;
      }
      
      private function _RubyTab_MoneyRenderer1_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         _loc1_.x = 25;
         _loc1_.y = 284;
         this._RubyTab_MoneyRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_MoneyRenderer1",this._RubyTab_MoneyRenderer1);
         return _loc1_;
      }
      
      private function _RubyTab_MoneyRenderer2_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         _loc1_.right = 25;
         _loc1_.y = 284;
         this._RubyTab_MoneyRenderer2 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_MoneyRenderer2",this._RubyTab_MoneyRenderer2);
         return _loc1_;
      }
      
      private function _RubyTab_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.x = 466;
         _loc1_.y = 3;
         _loc1_.width = 276;
         _loc1_.height = 320;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._RubyTab_VBox2_c()];
         return _loc1_;
      }
      
      private function _RubyTab_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.children = [this._RubyTab_GradientBox1_c(),this._RubyTab_Label2_i(),this._RubyTab_GradientBox2_i(),this._RubyTab_Label4_i(),this._RubyTab_GradientBox3_c(),this._RubyTab_Label6_i()];
         return _loc1_;
      }
      
      private function _RubyTab_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.width = 253;
         _loc1_.height = 34;
         _loc1_.children = [this._RubyTab_CachedImage3_i(),this._RubyTab_Label1_i()];
         return _loc1_;
      }
      
      private function _RubyTab_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.verticalCenter = 0;
         _loc1_.x = 8;
         this._RubyTab_CachedImage3 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_CachedImage3",this._RubyTab_CachedImage3);
         return _loc1_;
      }
      
      private function _RubyTab_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.verticalCenter = 0;
         _loc1_.x = 40;
         _loc1_.bold = true;
         _loc1_.fontSize = 12;
         this._RubyTab_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_Label1",this._RubyTab_Label1);
         return _loc1_;
      }
      
      private function _RubyTab_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 253;
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.padding = 5;
         this._RubyTab_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_Label2",this._RubyTab_Label2);
         return _loc1_;
      }
      
      private function _RubyTab_GradientBox2_i() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.width = 253;
         _loc1_.height = 34;
         _loc1_.children = [this._RubyTab_CachedImage4_i(),this._RubyTab_Label3_i()];
         this._RubyTab_GradientBox2 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_GradientBox2",this._RubyTab_GradientBox2);
         return _loc1_;
      }
      
      private function _RubyTab_CachedImage4_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.verticalCenter = 0;
         _loc1_.x = 8;
         this._RubyTab_CachedImage4 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_CachedImage4",this._RubyTab_CachedImage4);
         return _loc1_;
      }
      
      private function _RubyTab_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.verticalCenter = 0;
         _loc1_.x = 40;
         _loc1_.bold = true;
         this._RubyTab_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_Label3",this._RubyTab_Label3);
         return _loc1_;
      }
      
      private function _RubyTab_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 253;
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.padding = 5;
         this._RubyTab_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_Label4",this._RubyTab_Label4);
         return _loc1_;
      }
      
      private function _RubyTab_GradientBox3_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.width = 253;
         _loc1_.height = 34;
         _loc1_.children = [this._RubyTab_CachedImage5_i(),this._RubyTab_Label5_i()];
         return _loc1_;
      }
      
      private function _RubyTab_CachedImage5_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.verticalCenter = 0;
         _loc1_.x = 8;
         this._RubyTab_CachedImage5 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_CachedImage5",this._RubyTab_CachedImage5);
         return _loc1_;
      }
      
      private function _RubyTab_Label5_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.verticalCenter = 0;
         _loc1_.x = 40;
         _loc1_.bold = true;
         _loc1_.fontSize = 12;
         this._RubyTab_Label5 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_Label5",this._RubyTab_Label5);
         return _loc1_;
      }
      
      private function _RubyTab_Label6_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 253;
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.padding = 5;
         this._RubyTab_Label6 = _loc1_;
         BindingManager.executeBindings(this,"_RubyTab_Label6",this._RubyTab_Label6);
         return _loc1_;
      }
      
      private function _RubyTab_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = " - " + getString("rubies.get") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RubyTab_GradientLabel1.text");
         result[1] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_RubyTab_GradientLabel1.color");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("rubies.buy");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RubyTab_GradientLabel2.text");
         result[3] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_RubyTab_GradientLabel2.color");
         result[4] = new Binding(this,function():Object
         {
            return Assets.buyRuby;
         },null,"_RubyTab_CachedImage1.source");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = getString("rubies.earn");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RubyTab_GradientLabel3.text");
         result[6] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_RubyTab_GradientLabel3.color");
         result[7] = new Binding(this,function():Boolean
         {
            return !Configuration.hideEarn;
         },null,"_RubyTab_GradientLabel3.visible");
         result[8] = new Binding(this,function():Object
         {
            return Assets.earnRuby;
         },null,"_RubyTab_CachedImage2.source");
         result[9] = new Binding(this,function():Boolean
         {
            return !Configuration.hideEarn;
         },null,"_RubyTab_CachedImage2.visible");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = " - " + getString("rubies.exchange");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RubyTab_GradientLabel4.text");
         result[11] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_RubyTab_GradientLabel4.color");
         result[12] = new Binding(this,function():Item
         {
            return rubyItem;
         },null,"_RubyTab_ItemRenderer1.item");
         result[13] = new Binding(this,function():Object
         {
            return Assets.chatInput;
         },null,"input.borderSkin");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = int(slider.value);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"input.text");
         result[15] = new Binding(this,function():int
         {
            return model.currencies.RUBIES;
         },null,"slider.maxValue");
         result[16] = new Binding(this,function():int
         {
            return int(input.text);
         },null,"slider.value");
         result[17] = new Binding(this,function():Object
         {
            return Icons.maximize;
         },null,"_RubyTab_Button11.icon");
         result[18] = new Binding(this,function():String
         {
            var _loc1_:* = getString("maximize");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RubyTab_Button11.toolTip");
         result[19] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_RubyTab_Button12.icon");
         result[20] = new Binding(this,function():Boolean
         {
            return slider.value > 0;
         },null,"_RubyTab_Button12.enabled");
         result[21] = new Binding(this,function():String
         {
            var _loc1_:* = getString("accept");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RubyTab_Button12.toolTip");
         result[22] = new Binding(this,function():Object
         {
            return Icons.cancel;
         },null,"_RubyTab_Button13.icon");
         result[23] = new Binding(this,function():Boolean
         {
            return slider.value > 0;
         },null,"_RubyTab_Button13.enabled");
         result[24] = new Binding(this,function():String
         {
            var _loc1_:* = getString("cancel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RubyTab_Button13.toolTip");
         result[25] = new Binding(this,function():Item
         {
            return moneyItem;
         },null,"_RubyTab_ItemRenderer2.item");
         result[26] = new Binding(this,function():String
         {
            var _loc1_:* = CurrencyType.RUBIES;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RubyTab_MoneyRenderer1.type");
         result[27] = new Binding(this,function():uint
         {
            return model.currencies.RUBIES;
         },null,"_RubyTab_MoneyRenderer1.value");
         result[28] = new Binding(this,function():uint
         {
            return Colors.BUTTON_LABEL;
         },null,"_RubyTab_MoneyRenderer1.color");
         result[29] = new Binding(this,function():String
         {
            var _loc1_:* = CurrencyType.COPPER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RubyTab_MoneyRenderer2.type");
         result[30] = new Binding(this,function():uint
         {
            return slider.value * Configuration.coppersPerRuby;
         },null,"_RubyTab_MoneyRenderer2.value");
         result[31] = new Binding(this,function():uint
         {
            return Colors.BUTTON_LABEL;
         },null,"_RubyTab_MoneyRenderer2.color");
         result[32] = new Binding(this,function():Object
         {
            return Icons.buyRuby;
         },null,"_RubyTab_CachedImage3.source");
         result[33] = new Binding(this,function():String
         {
            var _loc1_:* = getString("rubies.buy");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RubyTab_Label1.text");
         result[34] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_RubyTab_Label1.color");
         result[35] = new Binding(this,function():String
         {
            var _loc1_:* = getString("rubies.buy.description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RubyTab_Label2.text");
         result[36] = new Binding(this,function():Number
         {
            return Configuration.hideEarn ? 0 : 1;
         },null,"_RubyTab_GradientBox2.scaleY");
         result[37] = new Binding(this,function():Object
         {
            return Icons.earnRuby;
         },null,"_RubyTab_CachedImage4.source");
         result[38] = new Binding(this,function():String
         {
            var _loc1_:* = getString("rubies.earn");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RubyTab_Label3.text");
         result[39] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_RubyTab_Label3.color");
         result[40] = new Binding(this,function():String
         {
            var _loc1_:* = getString("rubies.earn.description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RubyTab_Label4.text");
         result[41] = new Binding(this,function():Number
         {
            return Configuration.hideEarn ? 0 : 1;
         },null,"_RubyTab_Label4.scaleY");
         result[42] = new Binding(this,function():Object
         {
            return Icons.exchangeRuby;
         },null,"_RubyTab_CachedImage5.source");
         result[43] = new Binding(this,function():String
         {
            var _loc1_:* = getString("rubies.exchange");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RubyTab_Label5.text");
         result[44] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_RubyTab_Label5.color");
         result[45] = new Binding(this,function():String
         {
            var _loc1_:* = getString("rubies.exchange.description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_RubyTab_Label6.text");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get input() : Input
      {
         return this._100358090input;
      }
      
      public function set input(param1:Input) : void
      {
         var _loc2_:Object = this._100358090input;
         if(_loc2_ !== param1)
         {
            this._100358090input = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"input",_loc2_,param1));
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
   }
}

