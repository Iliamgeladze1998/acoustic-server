package soul.view.interaction.auction
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
   import soul.model.interaction.auction.Lot;
   import soul.model.item.Item;
   import soul.utils.DateUtils;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.common.MoneyRenderer;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class LotRenderer extends GradientBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const SELECTED_FILTERS:Array = [new GlowFilter(7864098)];
      
      public var _LotRenderer_HBox3:HBox;
      
      public var _LotRenderer_Label1:Label;
      
      public var _LotRenderer_Label2:Label;
      
      public var _LotRenderer_Label3:Label;
      
      public var _LotRenderer_Label4:Label;
      
      public var _LotRenderer_Label5:Label;
      
      public var _LotRenderer_Label6:Label;
      
      public var _LotRenderer_MoneyRenderer1:MoneyRenderer;
      
      public var _LotRenderer_MoneyRenderer2:MoneyRenderer;
      
      private var _3242771item:ItemRenderer;
      
      private var _107345lot:Lot;
      
      private var _selected:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function LotRenderer()
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
         bindings = this._LotRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_auction_LotRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return LotRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 540;
         this.height = 51;
         this.backgroundColor = 0;
         this.backgroundAlpha = 1;
         this.children = [this._LotRenderer_HBox1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         LotRenderer._watcherSetupUtil = param1;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(this._selected == value)
         {
            return;
         }
         this._selected = value;
         this.item.filters = value ? SELECTED_FILTERS : [];
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      private function getItemName(item:Item) : String
      {
         return LocaleManager.getItemName(item.templateId,item.suffixId,item.locId);
      }
      
      private function getTimeLeft(value:Number) : String
      {
         return DateUtils.getTimeLeft(value);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _LotRenderer_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._LotRenderer_ItemRenderer1_i(),this._LotRenderer_VBox1_c(),this._LotRenderer_Label3_i(),this._LotRenderer_Label4_i(),this._LotRenderer_VBox2_c()];
         return _loc1_;
      }
      
      private function _LotRenderer_ItemRenderer1_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         _loc1_.width = 51;
         _loc1_.height = 51;
         this.item = _loc1_;
         BindingManager.executeBindings(this,"item",this.item);
         return _loc1_;
      }
      
      private function _LotRenderer_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.width = 155;
         _loc1_.percentHeight = 100;
         _loc1_.verticalAlign = "middle";
         _loc1_.padding = 5;
         _loc1_.children = [this._LotRenderer_Label1_i(),this._LotRenderer_Label2_i()];
         return _loc1_;
      }
      
      private function _LotRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.height = 20;
         this._LotRenderer_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_LotRenderer_Label1",this._LotRenderer_Label1);
         return _loc1_;
      }
      
      private function _LotRenderer_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.color = 65280;
         this._LotRenderer_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_LotRenderer_Label2",this._LotRenderer_Label2);
         return _loc1_;
      }
      
      private function _LotRenderer_Label3_i() : Label
      {
         var _loc1_:Label = null;
         _loc1_ = new Label();
         _loc1_.width = 30;
         _loc1_.height = 24;
         _loc1_.align = "center";
         this._LotRenderer_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_LotRenderer_Label3",this._LotRenderer_Label3);
         return _loc1_;
      }
      
      private function _LotRenderer_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 85;
         _loc1_.height = 24;
         _loc1_.align = "center";
         _loc1_.truncateToFit = true;
         this._LotRenderer_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_LotRenderer_Label4",this._LotRenderer_Label4);
         return _loc1_;
      }
      
      private function _LotRenderer_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.width = 210;
         _loc1_.percentHeight = 100;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._LotRenderer_HBox2_c(),this._LotRenderer_HBox3_i()];
         return _loc1_;
      }
      
      private function _LotRenderer_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 22;
         _loc1_.children = [this._LotRenderer_Label5_i(),this._LotRenderer_MoneyRenderer1_i()];
         return _loc1_;
      }
      
      private function _LotRenderer_Label5_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         this._LotRenderer_Label5 = _loc1_;
         BindingManager.executeBindings(this,"_LotRenderer_Label5",this._LotRenderer_Label5);
         return _loc1_;
      }
      
      private function _LotRenderer_MoneyRenderer1_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         this._LotRenderer_MoneyRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_LotRenderer_MoneyRenderer1",this._LotRenderer_MoneyRenderer1);
         return _loc1_;
      }
      
      private function _LotRenderer_HBox3_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 22;
         _loc1_.children = [this._LotRenderer_Label6_i(),this._LotRenderer_MoneyRenderer2_i()];
         this._LotRenderer_HBox3 = _loc1_;
         BindingManager.executeBindings(this,"_LotRenderer_HBox3",this._LotRenderer_HBox3);
         return _loc1_;
      }
      
      private function _LotRenderer_Label6_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         this._LotRenderer_Label6 = _loc1_;
         BindingManager.executeBindings(this,"_LotRenderer_Label6",this._LotRenderer_Label6);
         return _loc1_;
      }
      
      private function _LotRenderer_MoneyRenderer2_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         this._LotRenderer_MoneyRenderer2 = _loc1_;
         BindingManager.executeBindings(this,"_LotRenderer_MoneyRenderer2",this._LotRenderer_MoneyRenderer2);
         return _loc1_;
      }
      
      private function _LotRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Item
         {
            return lot.item;
         },null,"item.item");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = getItemName(lot.item);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LotRenderer_Label1.text");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("myLot");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LotRenderer_Label2.text");
         result[3] = new Binding(this,function():Boolean
         {
            return lot.myLot;
         },null,"_LotRenderer_Label2.visible");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = lot.level;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LotRenderer_Label3.text");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = getTimeLeft(lot.lotTime);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LotRenderer_Label4.text");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = getString(lot.myBid > 0 ? "yourStake" : "bidPrice") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LotRenderer_Label5.text");
         result[7] = new Binding(this,function():uint
         {
            return lot.myBid > 0 ? 65280 : Colors.LABEL;
         },null,"_LotRenderer_Label5.color");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = lot.currency;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LotRenderer_MoneyRenderer1.type");
         result[9] = new Binding(this,function():uint
         {
            return lot.myBid > 0 ? uint(lot.myBid) : uint(lot.currentBid);
         },null,"_LotRenderer_MoneyRenderer1.value");
         result[10] = new Binding(this,function():Boolean
         {
            return lot.buyNow > 0;
         },null,"_LotRenderer_HBox3.visible");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = getString("buyPrice") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LotRenderer_Label6.text");
         result[12] = new Binding(this,function():String
         {
            var _loc1_:* = lot.currency;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LotRenderer_MoneyRenderer2.type");
         result[13] = new Binding(this,function():uint
         {
            return lot.buyNow;
         },null,"_LotRenderer_MoneyRenderer2.value");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get item() : ItemRenderer
      {
         return this._3242771item;
      }
      
      public function set item(param1:ItemRenderer) : void
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
      public function get lot() : Lot
      {
         return this._107345lot;
      }
      
      public function set lot(param1:Lot) : void
      {
         var _loc2_:Object = this._107345lot;
         if(_loc2_ !== param1)
         {
            this._107345lot = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lot",_loc2_,param1));
            }
         }
      }
   }
}

