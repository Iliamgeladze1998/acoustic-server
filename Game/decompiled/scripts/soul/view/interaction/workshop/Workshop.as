package soul.view.interaction.workshop
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
   import mx.events.ItemClickEvent;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.controller.locale.LocaleManager;
   import soul.event.SimpleUIEvent;
   import soul.model.item.ItemInfoManager;
   import soul.model.location.workshop.WorkshopItem;
   import soul.net.ServerLayer;
   import soul.view.assets.Assets;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.Container;
   import soul.view.ui.ScrollBase;
   
   use namespace mx_internal;
   
   public class Workshop extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _Workshop_BorderedContainer1:BorderedContainer;
      
      private var _517874297workshopItems:WorkshopItems;
      
      private var _100526016items:Array;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function Workshop()
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
         bindings = this._Workshop_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_workshop_WorkshopWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return Workshop[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 338;
         this.height = 297;
         this.children = [this._Workshop_BorderedContainer1_i()];
         this.addEventListener("creationComplete",this.___Workshop_Container1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         Workshop._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = LocaleManager.getString("interface","workshop.title");
         this.workshopItems.addEventListener(ItemClickEvent.ITEM_CLICK,this.repairItem);
         this.getItems();
      }
      
      private function getItems(result:* = null) : void
      {
         ServerLayer.call("workshopService","getItems",this.setItems);
      }
      
      private function setItems(value:Array) : void
      {
         this.items = value;
      }
      
      private function repairItem(e:ItemClickEvent) : void
      {
         var itemId:String = WorkshopItem(this.items[e.index]).itemId;
         ServerLayer.call("workshopService","repairItem",this.getItems,null,e.index);
         ItemInfoManager.removeInfo(itemId);
      }
      
      private function _Workshop_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = null;
         _loc1_ = new BorderedContainer();
         _loc1_.x = 9;
         _loc1_.y = 9;
         _loc1_.width = 320;
         _loc1_.height = 280;
         _loc1_.padding = 10;
         _loc1_.backgroundPadding = 2;
         _loc1_.children = [this._Workshop_ScrollBase1_c()];
         this._Workshop_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_Workshop_BorderedContainer1",this._Workshop_BorderedContainer1);
         return _loc1_;
      }
      
      private function _Workshop_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._Workshop_WorkshopItems1_i()];
         return _loc1_;
      }
      
      private function _Workshop_WorkshopItems1_i() : WorkshopItems
      {
         var _loc1_:WorkshopItems = new WorkshopItems();
         _loc1_.width = 310;
         _loc1_.gap = 5;
         this.workshopItems = _loc1_;
         BindingManager.executeBindings(this,"workshopItems",this.workshopItems);
         return _loc1_;
      }
      
      public function ___Workshop_Container1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _Workshop_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"_Workshop_BorderedContainer1.backgroundImage");
         result[1] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_Workshop_BorderedContainer1.borderSkin");
         result[2] = new Binding(this,function():Array
         {
            var _loc1_:* = items;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"workshopItems.dataProvider");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get workshopItems() : WorkshopItems
      {
         return this._517874297workshopItems;
      }
      
      public function set workshopItems(param1:WorkshopItems) : void
      {
         var _loc2_:Object = this._517874297workshopItems;
         if(_loc2_ !== param1)
         {
            this._517874297workshopItems = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"workshopItems",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get items() : Array
      {
         return this._100526016items;
      }
      
      private function set items(param1:Array) : void
      {
         var _loc2_:Object = this._100526016items;
         if(_loc2_ !== param1)
         {
            this._100526016items = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"items",_loc2_,param1));
            }
         }
      }
   }
}

