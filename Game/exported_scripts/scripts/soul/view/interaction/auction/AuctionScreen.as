package soul.view.interaction.auction
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
   import soul.event.SimpleUIEvent;
   import soul.model.character.CharacterModel;
   import soul.model.interaction.auction.AuctionData;
   import soul.model.interaction.auction.AuctionModel;
   import soul.model.inventory.InventoryModel;
   import soul.view.assets.SimpleImageBar;
   import soul.view.common.TabIcons;
   import soul.view.interaction.auction.tabs.BidTab;
   import soul.view.interaction.auction.tabs.BrowseTab;
   import soul.view.interaction.auction.tabs.CreateLotTab;
   import soul.view.interaction.auction.tabs.LotTab;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.Container;
   import soul.view.ui.ViewStack;
   
   use namespace mx_internal;
   
   public class AuctionScreen extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const TABS:Array = [[TabIcons.browse0,TabIcons.browse1],[TabIcons.bids0,TabIcons.bids1],[TabIcons.lots0,TabIcons.lots1],[TabIcons.create0,TabIcons.create1]];
      
      public var _AuctionScreen_BidTab1:BidTab;
      
      public var _AuctionScreen_BrowseTab1:BrowseTab;
      
      public var _AuctionScreen_CreateLotTab1:CreateLotTab;
      
      public var _AuctionScreen_LotTab1:LotTab;
      
      public var _AuctionScreen_ViewStack1:ViewStack;
      
      private var _97299bar:SimpleImageBar;
      
      private var _104069929model:AuctionModel;
      
      private var _49910995inventoryModel:InventoryModel;
      
      private var _340320640characterModel:CharacterModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function AuctionScreen()
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
         bindings = this._AuctionScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_auction_AuctionScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return AuctionScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 600;
         this.height = 460;
         this.children = [this._AuctionScreen_SimpleImageBar1_i(),this._AuctionScreen_ViewStack1_i()];
         this.addEventListener("creationComplete",this.___AuctionScreen_Container1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         AuctionScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("auction.title");
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _AuctionScreen_SimpleImageBar1_i() : SimpleImageBar
      {
         var _loc1_:SimpleImageBar = new SimpleImageBar();
         _loc1_.x = 13;
         _loc1_.y = 8;
         _loc1_.selectedIndex = 0;
         _loc1_.gap = 1;
         this.bar = _loc1_;
         BindingManager.executeBindings(this,"bar",this.bar);
         return _loc1_;
      }
      
      private function _AuctionScreen_ViewStack1_i() : ViewStack
      {
         var _loc1_:ViewStack = new ViewStack();
         _loc1_.children = [this._AuctionScreen_BrowseTab1_i(),this._AuctionScreen_BidTab1_i(),this._AuctionScreen_LotTab1_i(),this._AuctionScreen_CreateLotTab1_i()];
         this._AuctionScreen_ViewStack1 = _loc1_;
         BindingManager.executeBindings(this,"_AuctionScreen_ViewStack1",this._AuctionScreen_ViewStack1);
         return _loc1_;
      }
      
      private function _AuctionScreen_BrowseTab1_i() : BrowseTab
      {
         var _loc1_:BrowseTab = new BrowseTab();
         this._AuctionScreen_BrowseTab1 = _loc1_;
         BindingManager.executeBindings(this,"_AuctionScreen_BrowseTab1",this._AuctionScreen_BrowseTab1);
         return _loc1_;
      }
      
      private function _AuctionScreen_BidTab1_i() : BidTab
      {
         var _loc1_:BidTab = new BidTab();
         this._AuctionScreen_BidTab1 = _loc1_;
         BindingManager.executeBindings(this,"_AuctionScreen_BidTab1",this._AuctionScreen_BidTab1);
         return _loc1_;
      }
      
      private function _AuctionScreen_LotTab1_i() : LotTab
      {
         var _loc1_:LotTab = new LotTab();
         this._AuctionScreen_LotTab1 = _loc1_;
         BindingManager.executeBindings(this,"_AuctionScreen_LotTab1",this._AuctionScreen_LotTab1);
         return _loc1_;
      }
      
      private function _AuctionScreen_CreateLotTab1_i() : CreateLotTab
      {
         var _loc1_:CreateLotTab = new CreateLotTab();
         this._AuctionScreen_CreateLotTab1 = _loc1_;
         BindingManager.executeBindings(this,"_AuctionScreen_CreateLotTab1",this._AuctionScreen_CreateLotTab1);
         return _loc1_;
      }
      
      public function ___AuctionScreen_Container1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _AuctionScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Array
         {
            var _loc1_:* = TABS;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.dataProvider");
         result[1] = new Binding(this,function():Array
         {
            var _loc1_:* = [getString("auction.browse"),getString("auction.bids"),getString("auction.lots"),getString("auction.create")];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.toolTips");
         result[2] = new Binding(this,function():int
         {
            return bar.selectedIndex;
         },null,"_AuctionScreen_ViewStack1.selectedIndex");
         result[3] = new Binding(this,null,null,"_AuctionScreen_BrowseTab1.model","model");
         result[4] = new Binding(this,function():AuctionData
         {
            return model.browseData;
         },null,"_AuctionScreen_BrowseTab1.browseData");
         result[5] = new Binding(this,null,null,"_AuctionScreen_BidTab1.model","model");
         result[6] = new Binding(this,function():AuctionData
         {
            return model.bidData;
         },null,"_AuctionScreen_BidTab1.bidData");
         result[7] = new Binding(this,null,null,"_AuctionScreen_LotTab1.model","model");
         result[8] = new Binding(this,function():AuctionData
         {
            return model.lotData;
         },null,"_AuctionScreen_LotTab1.lotData");
         result[9] = new Binding(this,null,null,"_AuctionScreen_CreateLotTab1.model","model");
         result[10] = new Binding(this,null,null,"_AuctionScreen_CreateLotTab1.inventoryModel","inventoryModel");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get bar() : SimpleImageBar
      {
         return this._97299bar;
      }
      
      public function set bar(param1:SimpleImageBar) : void
      {
         var _loc2_:Object = this._97299bar;
         if(_loc2_ !== param1)
         {
            this._97299bar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bar",_loc2_,param1));
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
      public function get inventoryModel() : InventoryModel
      {
         return this._49910995inventoryModel;
      }
      
      public function set inventoryModel(param1:InventoryModel) : void
      {
         var _loc2_:Object = this._49910995inventoryModel;
         if(_loc2_ !== param1)
         {
            this._49910995inventoryModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inventoryModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get characterModel() : CharacterModel
      {
         return this._340320640characterModel;
      }
      
      public function set characterModel(param1:CharacterModel) : void
      {
         var _loc2_:Object = this._340320640characterModel;
         if(_loc2_ !== param1)
         {
            this._340320640characterModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"characterModel",_loc2_,param1));
            }
         }
      }
   }
}

