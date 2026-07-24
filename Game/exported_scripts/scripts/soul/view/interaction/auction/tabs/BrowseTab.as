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
   import soul.event.SimpleUIEvent;
   import soul.model.character.ParamType;
   import soul.model.interaction.auction.AuctionData;
   import soul.model.interaction.auction.AuctionFilter;
   import soul.model.interaction.auction.AuctionModel;
   import soul.model.system.Configuration;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.common.CurrencyType;
   import soul.view.common.Icons;
   import soul.view.interaction.auction.LotList;
   import soul.view.interaction.auction.MoneyEnter;
   import soul.view.interaction.auction.PageList;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.ComboBox;
   import soul.view.ui.Component;
   import soul.view.ui.Container;
   import soul.view.ui.HBox;
   import soul.view.ui.Input;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   
   use namespace mx_internal;
   
   public class BrowseTab extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _BrowseTab_BorderedContainer1:BorderedContainer;
      
      public var _BrowseTab_Button11:Button1;
      
      public var _BrowseTab_Button12:Button1;
      
      public var _BrowseTab_Button13:Button1;
      
      public var _BrowseTab_CachedImage1:CachedImage;
      
      public var _BrowseTab_CachedImage2:CachedImage;
      
      public var _BrowseTab_CachedImage3:CachedImage;
      
      public var _BrowseTab_Label1:Label;
      
      public var _BrowseTab_Label2:Label;
      
      public var _BrowseTab_Label3:Label;
      
      public var _BrowseTab_Label4:Label;
      
      private var _2127704613itemClass:ComboBox;
      
      private var _1177533677itemType:ComboBox;
      
      private var _353482639lotList:LotList;
      
      private var _107876max:Input;
      
      private var _108114min:Input;
      
      private var _104079552money:MoneyEnter;
      
      private var _859219917pageList:PageList;
      
      public var model:AuctionModel;
      
      private var _164907692browseData:AuctionData;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function BrowseTab()
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
         bindings = this._BrowseTab_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_auction_tabs_BrowseTabWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return BrowseTab[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._BrowseTab_BorderedContainer1_i(),this._BrowseTab_GradientBox1_c()];
         this.addEventListener("creationComplete",this.___BrowseTab_Container1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         BrowseTab._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         var s:String = null;
         var itemClasses:Array = null;
         var itemTypes:Array = [{
            "value":null,
            "label":this.getItemType("ALL")
         }];
         for each(s in this.model.auctionItemTypes)
         {
            itemTypes.push({
               "value":s,
               "label":this.getItemType(s)
            });
         }
         this.itemType.dataProvider = itemTypes;
         itemClasses = [{
            "value":null,
            "label":this.getItemType("ALL")
         }];
         for each(s in this.model.auctionItemClasses)
         {
            itemClasses.push({
               "value":s,
               "label":this.getItemType(s)
            });
         }
         this.itemClass.dataProvider = itemClasses;
         this.applyFilter();
      }
      
      private function applyFilter() : void
      {
         this.model.filter = this.generateFilter();
         if(!this.model.filter)
         {
            return;
         }
         var ne:AuctionEvent = new AuctionEvent(AuctionEvent.FILTER_CHANGED);
         this.model.dispatchEvent(ne);
      }
      
      private function raise() : void
      {
         this.model.filter = this.generateFilter();
         var ne:AuctionEvent = new AuctionEvent(AuctionEvent.MAKE_BID);
         ne.lotId = this.lotList.selectedLot.id;
         ne.value = this.money.value;
         this.model.dispatchEvent(ne);
      }
      
      private function buyout() : void
      {
         this.model.filter = this.generateFilter();
         var ne:AuctionEvent = new AuctionEvent(AuctionEvent.MAKE_BID);
         ne.lotId = this.lotList.selectedLot.id;
         ne.value = this.lotList.selectedLot.buyNow;
         this.model.dispatchEvent(ne);
      }
      
      private function generateFilter() : AuctionFilter
      {
         if(!this.itemClass.selectedItem || !this.itemType.selectedItem)
         {
            return null;
         }
         var f:AuctionFilter = new AuctionFilter();
         f.minLevel = this.min.text.length < 1 ? -1 : int(this.min.text);
         f.maxLevel = this.max.text.length < 1 ? -1 : int(this.max.text);
         f.itemClass = this.itemClass.selectedItem.value;
         f.itemType = this.itemType.selectedItem.value;
         f.count = Configuration.auctionItemsPerPage;
         f.indexFrom = Math.max(0,this.pageList.page) * Configuration.auctionItemsPerPage;
         return f;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function getItemType(key:String) : String
      {
         return LocaleManager.getString(BundleName.ITEM_TYPES,key);
      }
      
      private function _BrowseTab_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = null;
         _loc1_ = new BorderedContainer();
         _loc1_.x = 11;
         _loc1_.y = 42;
         _loc1_.width = 579;
         _loc1_.height = 368;
         _loc1_.direction = "vertical";
         _loc1_.padding = 3;
         _loc1_.children = [this._BrowseTab_HBox1_c(),this._BrowseTab_HBox2_c(),this._BrowseTab_Canvas1_c()];
         this._BrowseTab_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_BrowseTab_BorderedContainer1",this._BrowseTab_BorderedContainer1);
         return _loc1_;
      }
      
      private function _BrowseTab_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.padding = 10;
         _loc1_.gap = 5;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._BrowseTab_CachedImage1_i(),this._BrowseTab_Input1_i(),this._BrowseTab_Input2_i(),this._BrowseTab_Component1_c(),this._BrowseTab_CachedImage2_i(),this._BrowseTab_ComboBox1_i(),this._BrowseTab_Component2_c(),this._BrowseTab_CachedImage3_i(),this._BrowseTab_ComboBox2_i(),this._BrowseTab_Component3_c(),this._BrowseTab_Button11_i()];
         return _loc1_;
      }
      
      private function _BrowseTab_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._BrowseTab_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_BrowseTab_CachedImage1",this._BrowseTab_CachedImage1);
         return _loc1_;
      }
      
      private function _BrowseTab_Input1_i() : Input
      {
         var _loc1_:Input = new Input();
         _loc1_.width = 35;
         _loc1_.height = 21;
         _loc1_.color = 0;
         _loc1_.fontSize = 12;
         _loc1_.align = "center";
         _loc1_.maxChars = 2;
         _loc1_.restrict = "0-9";
         _loc1_.padding = 5;
         this.min = _loc1_;
         BindingManager.executeBindings(this,"min",this.min);
         return _loc1_;
      }
      
      private function _BrowseTab_Input2_i() : Input
      {
         var _loc1_:Input = new Input();
         _loc1_.width = 35;
         _loc1_.height = 21;
         _loc1_.color = 0;
         _loc1_.fontSize = 12;
         _loc1_.align = "center";
         _loc1_.maxChars = 2;
         _loc1_.restrict = "0-9";
         _loc1_.padding = 5;
         this.max = _loc1_;
         BindingManager.executeBindings(this,"max",this.max);
         return _loc1_;
      }
      
      private function _BrowseTab_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 10;
         return _loc1_;
      }
      
      private function _BrowseTab_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._BrowseTab_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_BrowseTab_CachedImage2",this._BrowseTab_CachedImage2);
         return _loc1_;
      }
      
      private function _BrowseTab_ComboBox1_i() : ComboBox
      {
         var _loc1_:ComboBox = new ComboBox();
         _loc1_.width = 160;
         _loc1_.selectedIndex = 0;
         this.itemType = _loc1_;
         BindingManager.executeBindings(this,"itemType",this.itemType);
         return _loc1_;
      }
      
      private function _BrowseTab_Component2_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 10;
         return _loc1_;
      }
      
      private function _BrowseTab_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._BrowseTab_CachedImage3 = _loc1_;
         BindingManager.executeBindings(this,"_BrowseTab_CachedImage3",this._BrowseTab_CachedImage3);
         return _loc1_;
      }
      
      private function _BrowseTab_ComboBox2_i() : ComboBox
      {
         var _loc1_:ComboBox = new ComboBox();
         _loc1_.width = 124;
         _loc1_.selectedIndex = 0;
         this.itemClass = _loc1_;
         BindingManager.executeBindings(this,"itemClass",this.itemClass);
         return _loc1_;
      }
      
      private function _BrowseTab_Component3_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 10;
         return _loc1_;
      }
      
      private function _BrowseTab_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 51;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___BrowseTab_Button11_click);
         this._BrowseTab_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_BrowseTab_Button11",this._BrowseTab_Button11);
         return _loc1_;
      }
      
      public function ___BrowseTab_Button11_click(event:MouseEvent) : void
      {
         this.applyFilter();
      }
      
      private function _BrowseTab_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 21;
         _loc1_.gap = 1;
         _loc1_.children = [this._BrowseTab_Label1_i(),this._BrowseTab_Label2_i(),this._BrowseTab_Label3_i(),this._BrowseTab_Container2_c()];
         return _loc1_;
      }
      
      private function _BrowseTab_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 245;
         _loc1_.height = 21;
         _loc1_.align = "center";
         _loc1_.backgroundColor = 0;
         _loc1_.backgroundAlpha = 0.5;
         _loc1_.fontSize = 12;
         this._BrowseTab_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_BrowseTab_Label1",this._BrowseTab_Label1);
         return _loc1_;
      }
      
      private function _BrowseTab_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 85;
         _loc1_.height = 21;
         _loc1_.align = "center";
         _loc1_.backgroundColor = 0;
         _loc1_.backgroundAlpha = 0.5;
         _loc1_.fontSize = 12;
         this._BrowseTab_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_BrowseTab_Label2",this._BrowseTab_Label2);
         return _loc1_;
      }
      
      private function _BrowseTab_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 205;
         _loc1_.height = 21;
         _loc1_.align = "center";
         _loc1_.backgroundColor = 0;
         _loc1_.backgroundAlpha = 0.5;
         _loc1_.fontSize = 12;
         this._BrowseTab_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_BrowseTab_Label3",this._BrowseTab_Label3);
         return _loc1_;
      }
      
      private function _BrowseTab_Container2_c() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.percentWidth = 100;
         _loc1_.height = 21;
         _loc1_.backgroundColor = 0;
         _loc1_.backgroundAlpha = 0.5;
         return _loc1_;
      }
      
      private function _BrowseTab_Canvas1_c() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.padding = 5;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._BrowseTab_ScrollBase1_c()];
         return _loc1_;
      }
      
      private function _BrowseTab_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.left = 0;
         _loc1_.top = 0;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "on";
         _loc1_.wheelMultiplier = 10;
         _loc1_.children = [this._BrowseTab_LotList1_i()];
         return _loc1_;
      }
      
      private function _BrowseTab_LotList1_i() : LotList
      {
         var _loc1_:LotList = new LotList();
         this.lotList = _loc1_;
         BindingManager.executeBindings(this,"lotList",this.lotList);
         return _loc1_;
      }
      
      private function _BrowseTab_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.y = 422;
         _loc1_.width = 596;
         _loc1_.height = 24;
         _loc1_.children = [this._BrowseTab_HBox3_c()];
         return _loc1_;
      }
      
      private function _BrowseTab_HBox3_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalAlign = "middle";
         _loc1_.verticalCenter = 0;
         _loc1_.gap = 5;
         _loc1_.children = [this._BrowseTab_Component4_c(),this._BrowseTab_PageList1_i(),this._BrowseTab_Component5_c(),this._BrowseTab_Label4_i(),this._BrowseTab_MoneyEnter1_i(),this._BrowseTab_Component6_c(),this._BrowseTab_Button12_i(),this._BrowseTab_Button13_i(),this._BrowseTab_Component7_c()];
         return _loc1_;
      }
      
      private function _BrowseTab_Component4_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 30;
         return _loc1_;
      }
      
      private function _BrowseTab_PageList1_i() : PageList
      {
         var _loc1_:PageList = new PageList();
         _loc1_.addEventListener("pageChanged",this.__pageList_pageChanged);
         this.pageList = _loc1_;
         BindingManager.executeBindings(this,"pageList",this.pageList);
         return _loc1_;
      }
      
      public function __pageList_pageChanged(event:Event) : void
      {
         this.applyFilter();
      }
      
      private function _BrowseTab_Component5_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _BrowseTab_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         this._BrowseTab_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_BrowseTab_Label4",this._BrowseTab_Label4);
         return _loc1_;
      }
      
      private function _BrowseTab_MoneyEnter1_i() : MoneyEnter
      {
         var _loc1_:MoneyEnter = new MoneyEnter();
         this.money = _loc1_;
         BindingManager.executeBindings(this,"money",this.money);
         return _loc1_;
      }
      
      private function _BrowseTab_Component6_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _BrowseTab_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___BrowseTab_Button12_click);
         this._BrowseTab_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_BrowseTab_Button12",this._BrowseTab_Button12);
         return _loc1_;
      }
      
      public function ___BrowseTab_Button12_click(event:MouseEvent) : void
      {
         this.raise();
      }
      
      private function _BrowseTab_Button13_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___BrowseTab_Button13_click);
         this._BrowseTab_Button13 = _loc1_;
         BindingManager.executeBindings(this,"_BrowseTab_Button13",this._BrowseTab_Button13);
         return _loc1_;
      }
      
      public function ___BrowseTab_Button13_click(event:MouseEvent) : void
      {
         this.buyout();
      }
      
      private function _BrowseTab_Component7_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 10;
         return _loc1_;
      }
      
      public function ___BrowseTab_Container1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _BrowseTab_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_BrowseTab_BorderedContainer1.borderSkin");
         result[1] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"_BrowseTab_BorderedContainer1.backgroundImage");
         result[2] = new Binding(this,function():Object
         {
            return Icons.level;
         },null,"_BrowseTab_CachedImage1.source");
         result[3] = new Binding(this,function():Object
         {
            return Assets.chatInput;
         },null,"min.borderSkin");
         result[4] = new Binding(this,function():Object
         {
            return Assets.chatInput;
         },null,"max.borderSkin");
         result[5] = new Binding(this,function():Object
         {
            return ParamType.ac;
         },null,"_BrowseTab_CachedImage2.source");
         result[6] = new Binding(this,function():Object
         {
            return Icons.itemType;
         },null,"_BrowseTab_CachedImage3.source");
         result[7] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_BrowseTab_Button11.icon");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = getString("accept");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BrowseTab_Button11.toolTip");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = getString("itemName");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BrowseTab_Label1.text");
         result[10] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_BrowseTab_Label1.color");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = getString("time");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BrowseTab_Label2.text");
         result[12] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_BrowseTab_Label2.color");
         result[13] = new Binding(this,function():String
         {
            var _loc1_:* = getString("price");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BrowseTab_Label3.text");
         result[14] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_BrowseTab_Label3.color");
         result[15] = new Binding(this,function():Array
         {
            var _loc1_:* = browseData.lots;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"lotList.lots");
         result[16] = new Binding(this,function():int
         {
            return Math.ceil(browseData.total / Configuration.auctionItemsPerPage);
         },null,"pageList.pages");
         result[17] = new Binding(this,function():int
         {
            return browseData.indexFrom / Configuration.auctionItemsPerPage;
         },null,"pageList.page");
         result[18] = new Binding(this,function():String
         {
            var _loc1_:* = getString("raise") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BrowseTab_Label4.text");
         result[19] = new Binding(this,function():String
         {
            var _loc1_:* = Boolean(lotList.selectedLot) ? lotList.selectedLot.currency : CurrencyType.COPPER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"money.type");
         result[20] = new Binding(this,function():uint
         {
            return lotList.selectedLot.newBid;
         },null,"money.value");
         result[21] = new Binding(this,function():Boolean
         {
            return lotList.selectedLot != null;
         },null,"money.enabled");
         result[22] = new Binding(this,function():Object
         {
            return Icons.raise;
         },null,"_BrowseTab_Button12.icon");
         result[23] = new Binding(this,function():String
         {
            var _loc1_:* = getString("raise");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BrowseTab_Button12.toolTip");
         result[24] = new Binding(this,function():Boolean
         {
            return lotList.selectedLot != null && money.value >= lotList.selectedLot.newBid && !lotList.selectedLot.myLot;
         },null,"_BrowseTab_Button12.enabled");
         result[25] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_BrowseTab_Button13.icon");
         result[26] = new Binding(this,function():String
         {
            var _loc1_:* = getString("buyout");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BrowseTab_Button13.toolTip");
         result[27] = new Binding(this,function():Boolean
         {
            return lotList.selectedLot != null && lotList.selectedLot.buyNow > 0 && !lotList.selectedLot.myLot;
         },null,"_BrowseTab_Button13.enabled");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get itemClass() : ComboBox
      {
         return this._2127704613itemClass;
      }
      
      public function set itemClass(param1:ComboBox) : void
      {
         var _loc2_:Object = this._2127704613itemClass;
         if(_loc2_ !== param1)
         {
            this._2127704613itemClass = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemClass",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get itemType() : ComboBox
      {
         return this._1177533677itemType;
      }
      
      public function set itemType(param1:ComboBox) : void
      {
         var _loc2_:Object = this._1177533677itemType;
         if(_loc2_ !== param1)
         {
            this._1177533677itemType = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemType",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lotList() : LotList
      {
         return this._353482639lotList;
      }
      
      public function set lotList(param1:LotList) : void
      {
         var _loc2_:Object = this._353482639lotList;
         if(_loc2_ !== param1)
         {
            this._353482639lotList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lotList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get max() : Input
      {
         return this._107876max;
      }
      
      public function set max(param1:Input) : void
      {
         var _loc2_:Object = this._107876max;
         if(_loc2_ !== param1)
         {
            this._107876max = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"max",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get min() : Input
      {
         return this._108114min;
      }
      
      public function set min(param1:Input) : void
      {
         var _loc2_:Object = this._108114min;
         if(_loc2_ !== param1)
         {
            this._108114min = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"min",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get money() : MoneyEnter
      {
         return this._104079552money;
      }
      
      public function set money(param1:MoneyEnter) : void
      {
         var _loc2_:Object = this._104079552money;
         if(_loc2_ !== param1)
         {
            this._104079552money = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"money",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get pageList() : PageList
      {
         return this._859219917pageList;
      }
      
      public function set pageList(param1:PageList) : void
      {
         var _loc2_:Object = this._859219917pageList;
         if(_loc2_ !== param1)
         {
            this._859219917pageList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pageList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get browseData() : AuctionData
      {
         return this._164907692browseData;
      }
      
      public function set browseData(param1:AuctionData) : void
      {
         var _loc2_:Object = this._164907692browseData;
         if(_loc2_ !== param1)
         {
            this._164907692browseData = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"browseData",_loc2_,param1));
            }
         }
      }
   }
}

