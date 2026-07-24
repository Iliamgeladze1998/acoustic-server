package soul.view.interaction.clan
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
   import soul.event.ClanEvent;
   import soul.model.interaction.clan.ClanModel;
   import soul.model.interaction.clan.ClanSack;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class ClanStorage extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _97299bar:ClanSacks;
      
      private var _3522358sack:ClanSackRenderer;
      
      private var _104069929model:ClanModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ClanStorage()
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
         bindings = this._ClanStorage_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_clan_ClanStorageWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ClanStorage[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.gap = 5;
         this.padding = 5;
         this.children = [this._ClanStorage_ClanSacks1_i(),this._ClanStorage_ScrollBase1_c()];
         this.addEventListener("addedToStage",this.___ClanStorage_VBox1_addedToStage);
         this.addEventListener("removedFromStage",this.___ClanStorage_VBox1_removedFromStage);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ClanStorage._watcherSetupUtil = param1;
      }
      
      private function addedToStage() : void
      {
         this.sack.addEventListener(ClanEvent.STORE_ITEM,this.delegate);
         this.sack.addEventListener(ClanEvent.TAKE_ITEM,this.delegate);
      }
      
      private function removedFromStage() : void
      {
         this.sack.removeEventListener(ClanEvent.STORE_ITEM,this.delegate);
         this.sack.removeEventListener(ClanEvent.TAKE_ITEM,this.delegate);
      }
      
      private function delegate(e:ClanEvent) : void
      {
         e.stopPropagation();
         this.model.dispatchEvent(e);
      }
      
      private function _ClanStorage_ClanSacks1_i() : ClanSacks
      {
         var _loc1_:ClanSacks = new ClanSacks();
         this.bar = _loc1_;
         BindingManager.executeBindings(this,"bar",this.bar);
         return _loc1_;
      }
      
      private function _ClanStorage_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._ClanStorage_ClanSackRenderer1_i()];
         return _loc1_;
      }
      
      private function _ClanStorage_ClanSackRenderer1_i() : ClanSackRenderer
      {
         var _loc1_:ClanSackRenderer = new ClanSackRenderer();
         this.sack = _loc1_;
         BindingManager.executeBindings(this,"sack",this.sack);
         return _loc1_;
      }
      
      public function ___ClanStorage_VBox1_addedToStage(event:Event) : void
      {
         this.addedToStage();
      }
      
      public function ___ClanStorage_VBox1_removedFromStage(event:Event) : void
      {
         this.removedFromStage();
      }
      
      private function _ClanStorage_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Array
         {
            var _loc1_:* = model.storage;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"bar.dataProvider");
         result[1] = new Binding(this,function():ClanSack
         {
            return model.storage[bar.selectedIndex];
         },null,"sack.sack");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get bar() : ClanSacks
      {
         return this._97299bar;
      }
      
      public function set bar(param1:ClanSacks) : void
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
      public function get sack() : ClanSackRenderer
      {
         return this._3522358sack;
      }
      
      public function set sack(param1:ClanSackRenderer) : void
      {
         var _loc2_:Object = this._3522358sack;
         if(_loc2_ !== param1)
         {
            this._3522358sack = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sack",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : ClanModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:ClanModel) : void
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

