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
   import soul.model.interaction.auction.AuctionData;
   import soul.model.interaction.auction.AuctionModel;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.common.CurrencyType;
   import soul.view.common.Icons;
   import soul.view.interaction.auction.LotList;
   import soul.view.interaction.auction.MoneyEnter;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.Canvas;
   import soul.view.ui.Component;
   import soul.view.ui.Container;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   
   use namespace mx_internal;
   
   public class BidTab extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _BidTab_BorderedContainer1:BorderedContainer;
      
      public var _BidTab_Button11:Button1;
      
      public var _BidTab_Button12:Button1;
      
      public var _BidTab_Label1:Label;
      
      public var _BidTab_Label2:Label;
      
      public var _BidTab_Label3:Label;
      
      public var _BidTab_Label4:Label;
      
      private var _353482639lotList:LotList;
      
      private var _104079552money:MoneyEnter;
      
      public var model:AuctionModel;
      
      private var _118416825bidData:AuctionData;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function BidTab()
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
         bindings = this._BidTab_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_auction_tabs_BidTabWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return BidTab[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._BidTab_BorderedContainer1_i(),this._BidTab_GradientBox1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         BidTab._watcherSetupUtil = param1;
      }
      
      private function raise() : void
      {
         var ne:AuctionEvent = new AuctionEvent(AuctionEvent.MAKE_BID);
         ne.lotId = this.lotList.selectedLot.id;
         ne.value = this.money.value;
         this.model.dispatchEvent(ne);
      }
      
      private function buyout() : void
      {
         var ne:AuctionEvent = new AuctionEvent(AuctionEvent.MAKE_BID);
         ne.lotId = this.lotList.selectedLot.id;
         ne.value = this.lotList.selectedLot.buyNow;
         this.model.dispatchEvent(ne);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function getItemType(key:String) : String
      {
         return LocaleManager.getString(BundleName.ITEM_TYPES,key);
      }
      
      private function _BidTab_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = null;
         _loc1_ = new BorderedContainer();
         _loc1_.x = 11;
         _loc1_.y = 42;
         _loc1_.width = 579;
         _loc1_.height = 368;
         _loc1_.direction = "vertical";
         _loc1_.padding = 3;
         _loc1_.children = [this._BidTab_HBox1_c(),this._BidTab_Canvas1_c()];
         this._BidTab_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_BidTab_BorderedContainer1",this._BidTab_BorderedContainer1);
         return _loc1_;
      }
      
      private function _BidTab_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 21;
         _loc1_.gap = 1;
         _loc1_.children = [this._BidTab_Label1_i(),this._BidTab_Label2_i(),this._BidTab_Label3_i(),this._BidTab_Container2_c()];
         return _loc1_;
      }
      
      private function _BidTab_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 245;
         _loc1_.height = 21;
         _loc1_.align = "center";
         _loc1_.backgroundColor = 0;
         _loc1_.backgroundAlpha = 0.5;
         _loc1_.fontSize = 12;
         this._BidTab_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_BidTab_Label1",this._BidTab_Label1);
         return _loc1_;
      }
      
      private function _BidTab_Label2_i() : Label
      {
         var _loc1_:Label = null;
         _loc1_ = new Label();
         _loc1_.width = 85;
         _loc1_.height = 21;
         _loc1_.align = "center";
         _loc1_.backgroundColor = 0;
         _loc1_.backgroundAlpha = 0.5;
         _loc1_.fontSize = 12;
         this._BidTab_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_BidTab_Label2",this._BidTab_Label2);
         return _loc1_;
      }
      
      private function _BidTab_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 205;
         _loc1_.height = 21;
         _loc1_.align = "center";
         _loc1_.backgroundColor = 0;
         _loc1_.backgroundAlpha = 0.5;
         _loc1_.fontSize = 12;
         this._BidTab_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_BidTab_Label3",this._BidTab_Label3);
         return _loc1_;
      }
      
      private function _BidTab_Container2_c() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.percentWidth = 100;
         _loc1_.height = 21;
         _loc1_.backgroundColor = 0;
         _loc1_.backgroundAlpha = 0.5;
         return _loc1_;
      }
      
      private function _BidTab_Canvas1_c() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.padding = 5;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._BidTab_ScrollBase1_c()];
         return _loc1_;
      }
      
      private function _BidTab_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.left = 0;
         _loc1_.top = 0;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "on";
         _loc1_.wheelMultiplier = 10;
         _loc1_.children = [this._BidTab_LotList1_i()];
         return _loc1_;
      }
      
      private function _BidTab_LotList1_i() : LotList
      {
         var _loc1_:LotList = new LotList();
         this.lotList = _loc1_;
         BindingManager.executeBindings(this,"lotList",this.lotList);
         return _loc1_;
      }
      
      private function _BidTab_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.y = 422;
         _loc1_.width = 596;
         _loc1_.height = 24;
         _loc1_.children = [this._BidTab_HBox2_c()];
         return _loc1_;
      }
      
      private function _BidTab_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalAlign = "middle";
         _loc1_.verticalCenter = 0;
         _loc1_.gap = 5;
         _loc1_.children = [this._BidTab_Component1_c(),this._BidTab_Label4_i(),this._BidTab_MoneyEnter1_i(),this._BidTab_Component2_c(),this._BidTab_Button11_i(),this._BidTab_Button12_i(),this._BidTab_Component3_c()];
         return _loc1_;
      }
      
      private function _BidTab_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _BidTab_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         this._BidTab_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_BidTab_Label4",this._BidTab_Label4);
         return _loc1_;
      }
      
      private function _BidTab_MoneyEnter1_i() : MoneyEnter
      {
         var _loc1_:MoneyEnter = new MoneyEnter();
         this.money = _loc1_;
         BindingManager.executeBindings(this,"money",this.money);
         return _loc1_;
      }
      
      private function _BidTab_Component2_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _BidTab_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___BidTab_Button11_click);
         this._BidTab_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_BidTab_Button11",this._BidTab_Button11);
         return _loc1_;
      }
      
      public function ___BidTab_Button11_click(event:MouseEvent) : void
      {
         this.raise();
      }
      
      private function _BidTab_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___BidTab_Button12_click);
         this._BidTab_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_BidTab_Button12",this._BidTab_Button12);
         return _loc1_;
      }
      
      public function ___BidTab_Button12_click(event:MouseEvent) : void
      {
         this.buyout();
      }
      
      private function _BidTab_Component3_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 10;
         return _loc1_;
      }
      
      private function _BidTab_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_BidTab_BorderedContainer1.borderSkin");
         result[1] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"_BidTab_BorderedContainer1.backgroundImage");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("itemName");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BidTab_Label1.text");
         result[3] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_BidTab_Label1.color");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = getString("time");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BidTab_Label2.text");
         result[5] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_BidTab_Label2.color");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = getString("price");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BidTab_Label3.text");
         result[7] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_BidTab_Label3.color");
         result[8] = new Binding(this,function():Array
         {
            var _loc1_:* = bidData.lots;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"lotList.lots");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = getString("raise") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BidTab_Label4.text");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = Boolean(lotList.selectedLot) ? lotList.selectedLot.currency : CurrencyType.COPPER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"money.type");
         result[11] = new Binding(this,function():uint
         {
            return lotList.selectedLot.newBid;
         },null,"money.value");
         result[12] = new Binding(this,function():Boolean
         {
            return lotList.selectedLot != null;
         },null,"money.enabled");
         result[13] = new Binding(this,function():Object
         {
            return Icons.raise;
         },null,"_BidTab_Button11.icon");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = getString("raise");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BidTab_Button11.toolTip");
         result[15] = new Binding(this,function():Boolean
         {
            return lotList.selectedLot != null && money.value >= lotList.selectedLot.newBid && !lotList.selectedLot.myLot;
         },null,"_BidTab_Button11.enabled");
         result[16] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_BidTab_Button12.icon");
         result[17] = new Binding(this,function():String
         {
            var _loc1_:* = getString("buyout");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BidTab_Button12.toolTip");
         result[18] = new Binding(this,function():Boolean
         {
            return lotList.selectedLot != null && lotList.selectedLot.buyNow > 0 && !lotList.selectedLot.myLot;
         },null,"_BidTab_Button12.enabled");
         return result;
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
      public function get bidData() : AuctionData
      {
         return this._118416825bidData;
      }
      
      public function set bidData(param1:AuctionData) : void
      {
         var _loc2_:Object = this._118416825bidData;
         if(_loc2_ !== param1)
         {
            this._118416825bidData = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bidData",_loc2_,param1));
            }
         }
      }
   }
}

