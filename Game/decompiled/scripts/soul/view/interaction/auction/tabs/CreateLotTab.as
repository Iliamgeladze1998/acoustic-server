package soul.view.interaction.auction.tabs
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
   import soul.event.AuctionEvent;
   import soul.model.interaction.auction.AuctionFilter;
   import soul.model.interaction.auction.AuctionModel;
   import soul.model.interaction.auction.CreateLotData;
   import soul.model.interaction.auction.LotData;
   import soul.model.interaction.auction.LotTime;
   import soul.model.inventory.InventoryModel;
   import soul.model.item.Item;
   import soul.model.location.shop.SellData;
   import soul.model.system.Configuration;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.assets.GradientLabel;
   import soul.view.common.Currency;
   import soul.view.common.CurrencyType;
   import soul.view.common.Icons;
   import soul.view.common.MoneyRenderer;
   import soul.view.interaction.auction.AuctionBackpack;
   import soul.view.interaction.auction.AuctionItemContainer;
   import soul.view.interaction.auction.MoneyEnter;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.ComboBox;
   import soul.view.ui.Component;
   import soul.view.ui.Container;
   import soul.view.ui.HBox;
   import soul.view.ui.Input;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class CreateLotTab extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const currTypes:Array = [{
         "value":CurrencyType.COPPER,
         "label":LocaleManager.getString(BundleName.INTERFACE,"currencyType." + CurrencyType.COPPER)
      },{
         "value":CurrencyType.RUBIES,
         "label":LocaleManager.getString(BundleName.INTERFACE,"currencyType." + CurrencyType.RUBIES)
      }];
      
      public var _CreateLotTab_BorderedContainer1:BorderedContainer;
      
      public var _CreateLotTab_BorderedContainer2:BorderedContainer;
      
      public var _CreateLotTab_BorderedContainer3:BorderedContainer;
      
      public var _CreateLotTab_Button11:Button1;
      
      public var _CreateLotTab_Button12:Button1;
      
      public var _CreateLotTab_CachedImage1:CachedImage;
      
      public var _CreateLotTab_CachedImage2:CachedImage;
      
      public var _CreateLotTab_CachedImage3:CachedImage;
      
      public var _CreateLotTab_GradientLabel1:GradientLabel;
      
      public var _CreateLotTab_GradientLabel2:GradientLabel;
      
      public var _CreateLotTab_GradientLabel3:GradientLabel;
      
      public var _CreateLotTab_Label1:Label;
      
      public var _CreateLotTab_Label2:Label;
      
      public var _CreateLotTab_Label3:Label;
      
      public var _CreateLotTab_Label4:Label;
      
      public var _CreateLotTab_MoneyRenderer1:MoneyRenderer;
      
      public var _CreateLotTab_MoneyRenderer2:MoneyRenderer;
      
      public var _CreateLotTab_MoneyRenderer3:MoneyRenderer;
      
      private var _998021533buyPrice:MoneyEnter;
      
      private var _94851343count:Input;
      
      private var _1005290219currencyType:ComboBox;
      
      private var _3242771item:AuctionItemContainer;
      
      private var _1177280081itemList:AuctionBackpack;
      
      private var _1922987912lotPrice:MoneyEnter;
      
      private var _1919558027lotTimes:ComboBox;
      
      private var filter:AuctionFilter;
      
      private var _104069929model:AuctionModel;
      
      private var _353720766lotTime:LotTime;
      
      private var _inventoryModel:InventoryModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CreateLotTab()
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
         bindings = this._CreateLotTab_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_auction_tabs_CreateLotTabWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return CreateLotTab[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._CreateLotTab_BorderedContainer1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         CreateLotTab._watcherSetupUtil = param1;
      }
      
      private function accept() : void
      {
         var cld:CreateLotData = new CreateLotData();
         var q:int = int(this.count.text);
         cld.itemKey = this.item.item.key;
         cld.quantity = q;
         cld.currency = this.currencyType.selectedItem.value;
         cld.startPrice = this.lotPrice.value;
         cld.buyNowPrice = this.buyPrice.value;
         cld.lotTimeId = LotTime(this.model.lotTimes[this.lotTimes.selectedIndex]).id;
         var ne:AuctionEvent = new AuctionEvent(AuctionEvent.CREATE_LOT);
         ne.createLotData = cld;
         this.model.dispatchEvent(ne);
         this.reset();
      }
      
      private function reset() : void
      {
         this.item.item = null;
         this.count.text = "";
         this.currencyType.selectedIndex = 0;
      }
      
      public function set inventoryModel(value:InventoryModel) : void
      {
         this._inventoryModel = value;
         this.generateItems();
      }
      
      private function set lotData(value:LotData) : void
      {
         this.item.allowedItems = value.inventory;
         this.generateItems();
      }
      
      private function generateItems() : void
      {
         var sd:SellData = null;
         var item:Item = null;
         if(!this._inventoryModel || !this.model || !this.model.lotData)
         {
            return;
         }
         var arr:Array = [];
         for each(sd in this.model.lotData.inventory)
         {
            item = this._inventoryModel.getItemById(sd.id);
            if(Boolean(item))
            {
               arr.push(item);
            }
         }
         this.itemList.dataProvider = arr;
      }
      
      private function getItemValue(i:Item) : int
      {
         var sd:SellData = null;
         var currency:String = null;
         var price:Number = NaN;
         if(!i || !this.model || !this.model.lotData)
         {
            return 0;
         }
         for each(sd in this.model.lotData.inventory)
         {
            if(sd.id == i.id)
            {
               currency = this.currencyType.selectedItem.value;
               return Number(sd.price[currency]);
            }
         }
         return 0;
      }
      
      private function getItemValueCoppers(i:Item) : int
      {
         var price:int = this.getItemValue(i);
         var currency:String = this.currencyType.selectedItem.value;
         if(currency == Currency.RUBIES)
         {
            price *= Configuration.coppersPerRuby;
         }
         return price;
      }
      
      private function getAllowedCurrencies(i:Item) : Array
      {
         var entry:Object = null;
         if(!i)
         {
            return null;
         }
         var arr:Array = [];
         var allowedCurrTypes:Array = this.model.allowedCurrencies[i.itemClass];
         for each(entry in currTypes)
         {
            if(allowedCurrTypes.indexOf(entry.value) > -1)
            {
               arr.push(entry);
            }
         }
         return arr;
      }
      
      private function getFeePercent(currencyType:String) : Number
      {
         return currencyType == CurrencyType.RUBIES ? this.model.endFeePercentRubies : this.model.endFeePercentCopper;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function getItemType(key:String) : String
      {
         return LocaleManager.getString(BundleName.ITEM_TYPES,key);
      }
      
      private function _CreateLotTab_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.x = 11;
         _loc1_.y = 42;
         _loc1_.width = 579;
         _loc1_.height = 404;
         _loc1_.direction = "horizontal";
         _loc1_.horizontalAlign = "right";
         _loc1_.gap = 10;
         _loc1_.padding = 8;
         _loc1_.children = [this._CreateLotTab_VBox1_c(),this._CreateLotTab_VBox3_c()];
         this._CreateLotTab_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_BorderedContainer1",this._CreateLotTab_BorderedContainer1);
         return _loc1_;
      }
      
      private function _CreateLotTab_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.gap = 5;
         _loc1_.horizontalAlign = "right";
         _loc1_.children = [this._CreateLotTab_HBox1_c(),this._CreateLotTab_GradientLabel1_i(),this._CreateLotTab_MoneyEnter1_i(),this._CreateLotTab_GradientLabel2_i(),this._CreateLotTab_MoneyEnter2_i(),this._CreateLotTab_GradientBox1_c(),this._CreateLotTab_Component2_c(),this._CreateLotTab_GradientBox2_c(),this._CreateLotTab_Component3_c(),this._CreateLotTab_GradientBox3_c(),this._CreateLotTab_HBox5_c()];
         return _loc1_;
      }
      
      private function _CreateLotTab_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.percentWidth = 100;
         _loc1_.height = 100;
         _loc1_.children = [this._CreateLotTab_AuctionItemContainer1_i(),this._CreateLotTab_Component1_c(),this._CreateLotTab_VBox2_c()];
         return _loc1_;
      }
      
      private function _CreateLotTab_AuctionItemContainer1_i() : AuctionItemContainer
      {
         var _loc1_:AuctionItemContainer = new AuctionItemContainer();
         this.item = _loc1_;
         BindingManager.executeBindings(this,"item",this.item);
         return _loc1_;
      }
      
      private function _CreateLotTab_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _CreateLotTab_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 5;
         _loc1_.children = [this._CreateLotTab_HBox2_c(),this._CreateLotTab_HBox3_c(),this._CreateLotTab_HBox4_c()];
         return _loc1_;
      }
      
      private function _CreateLotTab_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._CreateLotTab_CachedImage1_i(),this._CreateLotTab_ComboBox1_i()];
         return _loc1_;
      }
      
      private function _CreateLotTab_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._CreateLotTab_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_CachedImage1",this._CreateLotTab_CachedImage1);
         return _loc1_;
      }
      
      private function _CreateLotTab_ComboBox1_i() : ComboBox
      {
         var _loc1_:ComboBox = new ComboBox();
         _loc1_.width = 125;
         _loc1_.selectedIndex = 0;
         this.lotTimes = _loc1_;
         BindingManager.executeBindings(this,"lotTimes",this.lotTimes);
         return _loc1_;
      }
      
      private function _CreateLotTab_HBox3_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._CreateLotTab_CachedImage2_i(),this._CreateLotTab_Input1_i()];
         return _loc1_;
      }
      
      private function _CreateLotTab_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._CreateLotTab_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_CachedImage2",this._CreateLotTab_CachedImage2);
         return _loc1_;
      }
      
      private function _CreateLotTab_Input1_i() : Input
      {
         var _loc1_:Input = new Input();
         _loc1_.width = 125;
         _loc1_.leftMargin = 4;
         _loc1_.fontSize = 12;
         _loc1_.color = 0;
         _loc1_.restrict = "0-9";
         _loc1_.maxChars = 4;
         this.count = _loc1_;
         BindingManager.executeBindings(this,"count",this.count);
         return _loc1_;
      }
      
      private function _CreateLotTab_HBox4_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._CreateLotTab_CachedImage3_i(),this._CreateLotTab_ComboBox2_i()];
         return _loc1_;
      }
      
      private function _CreateLotTab_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._CreateLotTab_CachedImage3 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_CachedImage3",this._CreateLotTab_CachedImage3);
         return _loc1_;
      }
      
      private function _CreateLotTab_ComboBox2_i() : ComboBox
      {
         var _loc1_:ComboBox = new ComboBox();
         _loc1_.width = 125;
         _loc1_.selectedIndex = 0;
         this.currencyType = _loc1_;
         BindingManager.executeBindings(this,"currencyType",this.currencyType);
         return _loc1_;
      }
      
      private function _CreateLotTab_GradientLabel1_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.bgPaddingLeft = -5;
         _loc1_.fontSize = 12;
         _loc1_.verticalAlign = "middle";
         this._CreateLotTab_GradientLabel1 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_GradientLabel1",this._CreateLotTab_GradientLabel1);
         return _loc1_;
      }
      
      private function _CreateLotTab_MoneyEnter1_i() : MoneyEnter
      {
         var _loc1_:MoneyEnter = new MoneyEnter();
         this.lotPrice = _loc1_;
         BindingManager.executeBindings(this,"lotPrice",this.lotPrice);
         return _loc1_;
      }
      
      private function _CreateLotTab_GradientLabel2_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.bgPaddingLeft = -5;
         _loc1_.fontSize = 12;
         _loc1_.verticalAlign = "middle";
         this._CreateLotTab_GradientLabel2 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_GradientLabel2",this._CreateLotTab_GradientLabel2);
         return _loc1_;
      }
      
      private function _CreateLotTab_MoneyEnter2_i() : MoneyEnter
      {
         var _loc1_:MoneyEnter = new MoneyEnter();
         this.buyPrice = _loc1_;
         BindingManager.executeBindings(this,"buyPrice",this.buyPrice);
         return _loc1_;
      }
      
      private function _CreateLotTab_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.bgPaddingLeft = -5;
         _loc1_.children = [this._CreateLotTab_Label1_i(),this._CreateLotTab_MoneyRenderer1_i()];
         return _loc1_;
      }
      
      private function _CreateLotTab_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.verticalCenter = 0;
         _loc1_.fontSize = 12;
         this._CreateLotTab_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_Label1",this._CreateLotTab_Label1);
         return _loc1_;
      }
      
      private function _CreateLotTab_MoneyRenderer1_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         _loc1_.right = 0;
         _loc1_.verticalCenter = 0;
         _loc1_.fontSize = 12;
         this._CreateLotTab_MoneyRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_MoneyRenderer1",this._CreateLotTab_MoneyRenderer1);
         return _loc1_;
      }
      
      private function _CreateLotTab_Component2_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.height = 1;
         return _loc1_;
      }
      
      private function _CreateLotTab_GradientBox2_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.bgPaddingLeft = -5;
         _loc1_.children = [this._CreateLotTab_Label2_i(),this._CreateLotTab_MoneyRenderer2_i()];
         return _loc1_;
      }
      
      private function _CreateLotTab_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.verticalCenter = 0;
         _loc1_.fontSize = 12;
         this._CreateLotTab_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_Label2",this._CreateLotTab_Label2);
         return _loc1_;
      }
      
      private function _CreateLotTab_MoneyRenderer2_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         _loc1_.right = 0;
         _loc1_.verticalCenter = 0;
         _loc1_.fontSize = 12;
         this._CreateLotTab_MoneyRenderer2 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_MoneyRenderer2",this._CreateLotTab_MoneyRenderer2);
         return _loc1_;
      }
      
      private function _CreateLotTab_Component3_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentHeight = 100;
         return _loc1_;
      }
      
      private function _CreateLotTab_GradientBox3_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.bgPaddingLeft = -5;
         _loc1_.children = [this._CreateLotTab_Label3_i(),this._CreateLotTab_MoneyRenderer3_i()];
         return _loc1_;
      }
      
      private function _CreateLotTab_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.verticalCenter = 0;
         _loc1_.fontSize = 12;
         this._CreateLotTab_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_Label3",this._CreateLotTab_Label3);
         return _loc1_;
      }
      
      private function _CreateLotTab_MoneyRenderer3_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         _loc1_.right = 0;
         _loc1_.verticalCenter = 0;
         _loc1_.fontSize = 12;
         this._CreateLotTab_MoneyRenderer3 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_MoneyRenderer3",this._CreateLotTab_MoneyRenderer3);
         return _loc1_;
      }
      
      private function _CreateLotTab_HBox5_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 28;
         _loc1_.gap = 5;
         _loc1_.horizontalAlign = "right";
         _loc1_.children = [this._CreateLotTab_Button11_i(),this._CreateLotTab_Button12_i()];
         return _loc1_;
      }
      
      private function _CreateLotTab_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___CreateLotTab_Button11_click);
         this._CreateLotTab_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_Button11",this._CreateLotTab_Button11);
         return _loc1_;
      }
      
      public function ___CreateLotTab_Button11_click(event:MouseEvent) : void
      {
         this.accept();
      }
      
      private function _CreateLotTab_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___CreateLotTab_Button12_click);
         this._CreateLotTab_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_Button12",this._CreateLotTab_Button12);
         return _loc1_;
      }
      
      public function ___CreateLotTab_Button12_click(event:MouseEvent) : void
      {
         this.reset();
      }
      
      private function _CreateLotTab_VBox3_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.width = 312;
         _loc1_.percentHeight = 100;
         _loc1_.gap = 5;
         _loc1_.children = [this._CreateLotTab_BorderedContainer2_i(),this._CreateLotTab_BorderedContainer3_i()];
         return _loc1_;
      }
      
      private function _CreateLotTab_BorderedContainer2_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.padding = 8;
         _loc1_.percentWidth = 100;
         _loc1_.height = 224;
         _loc1_.children = [this._CreateLotTab_ScrollBase1_c()];
         this._CreateLotTab_BorderedContainer2 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_BorderedContainer2",this._CreateLotTab_BorderedContainer2);
         return _loc1_;
      }
      
      private function _CreateLotTab_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._CreateLotTab_AuctionBackpack1_i()];
         return _loc1_;
      }
      
      private function _CreateLotTab_AuctionBackpack1_i() : AuctionBackpack
      {
         var _loc1_:AuctionBackpack = new AuctionBackpack();
         _loc1_.width = 285;
         _loc1_.gap = 5;
         this.itemList = _loc1_;
         BindingManager.executeBindings(this,"itemList",this.itemList);
         return _loc1_;
      }
      
      private function _CreateLotTab_BorderedContainer3_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.direction = "vertical";
         _loc1_.padding = 8;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._CreateLotTab_GradientLabel3_i(),this._CreateLotTab_ScrollBase2_c()];
         this._CreateLotTab_BorderedContainer3 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_BorderedContainer3",this._CreateLotTab_BorderedContainer3);
         return _loc1_;
      }
      
      private function _CreateLotTab_GradientLabel3_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.bgPaddingLeft = -5;
         _loc1_.verticalAlign = "middle";
         _loc1_.bold = true;
         this._CreateLotTab_GradientLabel3 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_GradientLabel3",this._CreateLotTab_GradientLabel3);
         return _loc1_;
      }
      
      private function _CreateLotTab_ScrollBase2_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "on";
         _loc1_.children = [this._CreateLotTab_Label4_i()];
         return _loc1_;
      }
      
      private function _CreateLotTab_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 285;
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         this._CreateLotTab_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_CreateLotTab_Label4",this._CreateLotTab_Label4);
         return _loc1_;
      }
      
      private function _CreateLotTab_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():*
         {
            return model.lotData;
         },function(param1:*):void
         {
            lotData = param1;
         },"lotData");
         result[1] = new Binding(this,function():*
         {
            return model.lotTimes[lotTimes.selectedIndex];
         },function(param1:*):void
         {
            lotTime = param1;
         },"lotTime");
         result[2] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_CreateLotTab_BorderedContainer1.borderSkin");
         result[3] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"_CreateLotTab_BorderedContainer1.backgroundImage");
         result[4] = new Binding(this,function():Object
         {
            return Icons.time;
         },null,"_CreateLotTab_CachedImage1.source");
         result[5] = new Binding(this,function():Array
         {
            var _loc1_:* = model.lotTimes;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"lotTimes.dataProvider");
         result[6] = new Binding(this,function():Object
         {
            return Icons.quantity;
         },null,"_CreateLotTab_CachedImage2.source");
         result[7] = new Binding(this,function():Object
         {
            return Assets.chatInput;
         },null,"count.borderSkin");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = item.item.count;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"count.text");
         result[9] = new Binding(this,function():Object
         {
            return Icons.buyRuby;
         },null,"_CreateLotTab_CachedImage3.source");
         result[10] = new Binding(this,function():Boolean
         {
            return item.item != null;
         },null,"currencyType.enabled");
         result[11] = new Binding(this,function():Array
         {
            var _loc1_:* = getAllowedCurrencies(item.item);
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"currencyType.dataProvider");
         result[12] = new Binding(this,function():String
         {
            var _loc1_:* = getString("lotPrice");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CreateLotTab_GradientLabel1.text");
         result[13] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_CreateLotTab_GradientLabel1.color");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = currencyType.selectedItem.value;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"lotPrice.type");
         result[15] = new Binding(this,function():Boolean
         {
            return item.item != null;
         },null,"lotPrice.enabled");
         result[16] = new Binding(this,function():uint
         {
            return getItemValue(item.item) * uint(count.text);
         },null,"lotPrice.value");
         result[17] = new Binding(this,function():String
         {
            var _loc1_:* = getString("buyPrice");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CreateLotTab_GradientLabel2.htmlText");
         result[18] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_CreateLotTab_GradientLabel2.color");
         result[19] = new Binding(this,function():String
         {
            var _loc1_:* = currencyType.selectedItem.value;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"buyPrice.type");
         result[20] = new Binding(this,function():Boolean
         {
            return item.item != null;
         },null,"buyPrice.enabled");
         result[21] = new Binding(this,function():String
         {
            var _loc1_:* = getString("bidIncome") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CreateLotTab_Label1.text");
         result[22] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_CreateLotTab_Label1.color");
         result[23] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_CreateLotTab_MoneyRenderer1.color");
         result[24] = new Binding(this,function():uint
         {
            return lotPrice.value * (1 - getFeePercent(currencyType.selectedItem.value));
         },null,"_CreateLotTab_MoneyRenderer1.value");
         result[25] = new Binding(this,function():String
         {
            var _loc1_:* = currencyType.selectedItem.value;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CreateLotTab_MoneyRenderer1.type");
         result[26] = new Binding(this,function():String
         {
            var _loc1_:* = getString("buyIncome") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CreateLotTab_Label2.text");
         result[27] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_CreateLotTab_Label2.color");
         result[28] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_CreateLotTab_MoneyRenderer2.color");
         result[29] = new Binding(this,function():uint
         {
            return buyPrice.value * (1 - getFeePercent(currencyType.selectedItem.value));
         },null,"_CreateLotTab_MoneyRenderer2.value");
         result[30] = new Binding(this,function():String
         {
            var _loc1_:* = currencyType.selectedItem.value;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CreateLotTab_MoneyRenderer2.type");
         result[31] = new Binding(this,function():String
         {
            var _loc1_:* = getString("lotFee");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CreateLotTab_Label3.text");
         result[32] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_CreateLotTab_Label3.color");
         result[33] = new Binding(this,function():String
         {
            var _loc1_:* = model.lotFeeCurrency;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CreateLotTab_MoneyRenderer3.type");
         result[34] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_CreateLotTab_MoneyRenderer3.color");
         result[35] = new Binding(this,function():uint
         {
            return Math.round(lotTime.timeFeePercent * uint(count.text) * getItemValueCoppers(item.item) + lotTime.timeFee);
         },null,"_CreateLotTab_MoneyRenderer3.value");
         result[36] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_CreateLotTab_Button11.icon");
         result[37] = new Binding(this,function():String
         {
            var _loc1_:* = getString("createLot");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CreateLotTab_Button11.toolTip");
         result[38] = new Binding(this,function():Boolean
         {
            return item.item != null;
         },null,"_CreateLotTab_Button11.enabled");
         result[39] = new Binding(this,function():Object
         {
            return Icons.cancel;
         },null,"_CreateLotTab_Button12.icon");
         result[40] = new Binding(this,function():String
         {
            var _loc1_:* = getString("reset");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CreateLotTab_Button12.toolTip");
         result[41] = new Binding(this,function():Boolean
         {
            return item.item != null;
         },null,"_CreateLotTab_Button12.enabled");
         result[42] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_CreateLotTab_BorderedContainer2.borderSkin");
         result[43] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_CreateLotTab_BorderedContainer3.borderSkin");
         result[44] = new Binding(this,function():String
         {
            var _loc1_:* = getString("description") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CreateLotTab_GradientLabel3.text");
         result[45] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_CreateLotTab_GradientLabel3.color");
         result[46] = new Binding(this,function():String
         {
            var _loc1_:* = getString("createLot.description");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CreateLotTab_Label4.text");
         return result;
      }
      
      private function _CreateLotTab_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         this.lotData = this.model.lotData;
         this.lotTime = this.model.lotTimes[this.lotTimes.selectedIndex];
      }
      
      [Bindable(event="propertyChange")]
      public function get buyPrice() : MoneyEnter
      {
         return this._998021533buyPrice;
      }
      
      public function set buyPrice(param1:MoneyEnter) : void
      {
         var _loc2_:Object = this._998021533buyPrice;
         if(_loc2_ !== param1)
         {
            this._998021533buyPrice = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buyPrice",_loc2_,param1));
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
      public function get currencyType() : ComboBox
      {
         return this._1005290219currencyType;
      }
      
      public function set currencyType(param1:ComboBox) : void
      {
         var _loc2_:Object = this._1005290219currencyType;
         if(_loc2_ !== param1)
         {
            this._1005290219currencyType = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currencyType",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get item() : AuctionItemContainer
      {
         return this._3242771item;
      }
      
      public function set item(param1:AuctionItemContainer) : void
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
      public function get itemList() : AuctionBackpack
      {
         return this._1177280081itemList;
      }
      
      public function set itemList(param1:AuctionBackpack) : void
      {
         var _loc2_:Object = this._1177280081itemList;
         if(_loc2_ !== param1)
         {
            this._1177280081itemList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lotPrice() : MoneyEnter
      {
         return this._1922987912lotPrice;
      }
      
      public function set lotPrice(param1:MoneyEnter) : void
      {
         var _loc2_:Object = this._1922987912lotPrice;
         if(_loc2_ !== param1)
         {
            this._1922987912lotPrice = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lotPrice",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lotTimes() : ComboBox
      {
         return this._1919558027lotTimes;
      }
      
      public function set lotTimes(param1:ComboBox) : void
      {
         var _loc2_:Object = this._1919558027lotTimes;
         if(_loc2_ !== param1)
         {
            this._1919558027lotTimes = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lotTimes",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : AuctionModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:AuctionModel) : void
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
      private function get lotTime() : LotTime
      {
         return this._353720766lotTime;
      }
      
      private function set lotTime(param1:LotTime) : void
      {
         var _loc2_:Object = this._353720766lotTime;
         if(_loc2_ !== param1)
         {
            this._353720766lotTime = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lotTime",_loc2_,param1));
            }
         }
      }
   }
}

