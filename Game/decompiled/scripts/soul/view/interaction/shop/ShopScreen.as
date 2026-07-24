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
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.DragEvent;
   import soul.event.ShopEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.inventory.InventoryTab;
   import soul.model.inventory.InventoryUtils;
   import soul.model.item.Item;
   import soul.model.location.shop.ShopModel;
   import soul.view.assets.Assets;
   import soul.view.assets.SimpleImageBar;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.Canvas;
   import soul.view.ui.ScrollBase;
   
   use namespace mx_internal;
   
   public class ShopScreen extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const MIN_ITEMS_TO_RENDER:int = 8;
      
      public var _ShopScreen_BorderedContainer1:BorderedContainer;
      
      private var _97299bar:SimpleImageBar;
      
      private var _1377571440buyRpt:ShopRepeater;
      
      private var _104069929model:ShopModel;
      
      public var buyItemProvider:Array;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ShopScreen()
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
         bindings = this._ShopScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_shop_ShopScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ShopScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 480;
         this.height = 362;
         this.children = [this._ShopScreen_SimpleImageBar1_i(),this._ShopScreen_BorderedContainer1_i(),this._ShopScreen_ScrollBase1_c()];
         this.addEventListener("creationComplete",this.___ShopScreen_Canvas1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ShopScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("shop.title");
         addEventListener(DragEvent.DRAG_ENTER,this.dragEnter);
         addEventListener(DragEvent.DRAG_DROP,this.dragDrop);
      }
      
      private function dragEnter(e:DragEvent) : void
      {
         var item:Item = e.dragSource.hasFormat("item") ? Item(e.dragSource.dataForFormat("item")) : null;
         if(!item || item.equipped)
         {
            return;
         }
         if(Boolean(item) && Boolean(ShopModel.sellDatas[item.id]))
         {
            SimpleDragManager.acceptDragDrop(this);
         }
      }
      
      private function dragDrop(e:DragEvent) : void
      {
         var ne:ShopEvent = null;
         var item:Item = e.dragSource.hasFormat("item") ? Item(e.dragSource.dataForFormat("item")) : null;
         if(Boolean(item))
         {
            ne = new ShopEvent(ShopEvent.OPEN_SELL_DIALOG);
            ne.item = item;
            dispatchEvent(ne);
         }
      }
      
      public function filterChange() : void
      {
         var item:Item = null;
         trace("ShopScreen.filterChange()");
         var type:String = InventoryTab.TABS[this.bar.selectedIndex];
         var items:Array = [];
         var itemCount:uint = 0;
         for each(item in this.buyItemProvider)
         {
            if(type == InventoryTab.ALL || InventoryUtils.itemIsTab(item,type))
            {
               items.push(item);
               itemCount++;
            }
         }
         this.buyRpt.dataProvider = items;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function getTips() : Array
      {
         var tab:String = null;
         var arr:Array = [];
         for each(tab in InventoryTab.TABS)
         {
            arr.push(this.getString(tab));
         }
         return arr;
      }
      
      private function _ShopScreen_SimpleImageBar1_i() : SimpleImageBar
      {
         var _loc1_:SimpleImageBar = new SimpleImageBar();
         _loc1_.x = 13;
         _loc1_.y = 8;
         _loc1_.selectedIndex = 8;
         _loc1_.gap = 1;
         _loc1_.addEventListener("click",this.__bar_click);
         this.bar = _loc1_;
         BindingManager.executeBindings(this,"bar",this.bar);
         return _loc1_;
      }
      
      public function __bar_click(event:MouseEvent) : void
      {
         this.filterChange();
      }
      
      private function _ShopScreen_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.x = 12;
         _loc1_.y = 42;
         _loc1_.width = 454;
         _loc1_.height = 305;
         this._ShopScreen_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_ShopScreen_BorderedContainer1",this._ShopScreen_BorderedContainer1);
         return _loc1_;
      }
      
      private function _ShopScreen_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.x = 22;
         _loc1_.y = 54;
         _loc1_.width = 434;
         _loc1_.height = 282;
         _loc1_.verticalScrollPolicy = "on";
         _loc1_.wheelMultiplier = 3;
         _loc1_.children = [this._ShopScreen_ShopRepeater1_i()];
         return _loc1_;
      }
      
      private function _ShopScreen_ShopRepeater1_i() : ShopRepeater
      {
         var _loc1_:ShopRepeater = new ShopRepeater();
         _loc1_.width = 420;
         _loc1_.gap = 5;
         this.buyRpt = _loc1_;
         BindingManager.executeBindings(this,"buyRpt",this.buyRpt);
         return _loc1_;
      }
      
      public function ___ShopScreen_Canvas1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _ShopScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Array
         {
            var _loc1_:* = InventoryTab.TAB_IMAGES;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.dataProvider");
         result[1] = new Binding(this,function():Array
         {
            var _loc1_:* = getTips();
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.toolTips");
         result[2] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_ShopScreen_BorderedContainer1.borderSkin");
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
      public function get buyRpt() : ShopRepeater
      {
         return this._1377571440buyRpt;
      }
      
      public function set buyRpt(param1:ShopRepeater) : void
      {
         var _loc2_:Object = this._1377571440buyRpt;
         if(_loc2_ !== param1)
         {
            this._1377571440buyRpt = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buyRpt",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : ShopModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:ShopModel) : void
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

