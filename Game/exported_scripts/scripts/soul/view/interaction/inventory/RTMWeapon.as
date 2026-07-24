package soul.view.interaction.inventory
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
   import soul.event.InventoryEvent;
   import soul.event.RTMEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.character.CharacterModel;
   import soul.model.cooldown.Cooldown;
   import soul.model.cooldown.CooldownModel;
   import soul.model.inventory.InventoryModel;
   import soul.model.item.Item;
   import soul.model.rtm.RTMModel;
   import soul.view.assets.Assets;
   import soul.view.assets.SimpleImageBar;
   import soul.view.ui.Canvas;
   
   use namespace mx_internal;
   
   public class RTMWeapon extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const WEAPON_SETS:Array = [[Assets.set10,Assets.set11],[Assets.set20,Assets.set21]];
      
      private var _904975636altMode:SimpleImageBar;
      
      private var _3242771item:RTMWeaponContainer;
      
      private var _49910995inventoryModel:InventoryModel;
      
      private var _340320640characterModel:CharacterModel;
      
      private var _2103504510cooldownModel:CooldownModel;
      
      private var _104069929model:RTMModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function RTMWeapon()
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
         bindings = this._RTMWeapon_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_inventory_RTMWeaponWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return RTMWeapon[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 66;
         this.height = 117;
         this.children = [this._RTMWeapon_RTMWeaponContainer1_i(),this._RTMWeapon_SimpleImageBar1_i()];
         this.addEventListener("creationComplete",this.___RTMWeapon_Canvas1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         RTMWeapon._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         this.item.addEventListener(RTMEvent.APPLY_WEAPON,this.applyWeapon);
      }
      
      private function weaponChange() : void
      {
         if(this.characterModel.alternativeIndex == this.altMode.selectedIndex)
         {
            return;
         }
         var ne:RTMEvent = new RTMEvent(RTMEvent.SELECT_WEAPON);
         ne.index = this.altMode.selectedIndex;
         this.model.dispatchEvent(ne);
      }
      
      private function applyWeapon(e:RTMEvent) : void
      {
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.EQUIP);
         ne.item = e.item;
         ne.slotIndex = this.characterModel.alternativeIndex;
         this.inventoryModel.dispatchEvent(ne);
      }
      
      private function arrowClick(e:ItemClickEvent) : void
      {
         var ne:RTMEvent = new RTMEvent(RTMEvent.SELECT_AMMO);
         ne.index = e.index;
         this.model.dispatchEvent(ne);
      }
      
      private function arrowAdd(e:InventoryEvent) : void
      {
         e.stopPropagation();
         this.model.dispatchEvent(e.clone());
      }
      
      private function arrowRemove(e:InventoryEvent) : void
      {
         e.stopPropagation();
         this.model.dispatchEvent(e.clone());
      }
      
      private function getCurrentAmmo(items:Array, index:int) : Item
      {
         if(this.item == null || index < 0 || this.inventoryModel == null)
         {
            return null;
         }
         return this.inventoryModel.getItemByShortcut(items[index]);
      }
      
      private function _RTMWeapon_RTMWeaponContainer1_i() : RTMWeaponContainer
      {
         var _loc1_:RTMWeaponContainer = new RTMWeaponContainer();
         this.item = _loc1_;
         BindingManager.executeBindings(this,"item",this.item);
         return _loc1_;
      }
      
      private function _RTMWeapon_SimpleImageBar1_i() : SimpleImageBar
      {
         var _loc1_:SimpleImageBar = new SimpleImageBar();
         _loc1_.x = -33;
         _loc1_.y = 2;
         _loc1_.direction = "vertical";
         _loc1_.gap = 1;
         _loc1_.addEventListener("itemClick",this.__altMode_itemClick);
         this.altMode = _loc1_;
         BindingManager.executeBindings(this,"altMode",this.altMode);
         return _loc1_;
      }
      
      public function __altMode_itemClick(event:ItemClickEvent) : void
      {
         this.weaponChange();
      }
      
      public function ___RTMWeapon_Canvas1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _RTMWeapon_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Item
         {
            return characterModel.alternativeIndex == 1 ? inventoryModel.body.weapon2 : inventoryModel.body.weapon1;
         },null,"item.item");
         result[1] = new Binding(this,function():Cooldown
         {
            return cooldownModel.groups.weapon;
         },null,"item.cooldown");
         result[2] = new Binding(this,function():Array
         {
            var _loc1_:* = WEAPON_SETS;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"altMode.dataProvider");
         result[3] = new Binding(this,function():int
         {
            return characterModel.alternativeIndex;
         },null,"altMode.selectedIndex");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get altMode() : SimpleImageBar
      {
         return this._904975636altMode;
      }
      
      public function set altMode(param1:SimpleImageBar) : void
      {
         var _loc2_:Object = this._904975636altMode;
         if(_loc2_ !== param1)
         {
            this._904975636altMode = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"altMode",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get item() : RTMWeaponContainer
      {
         return this._3242771item;
      }
      
      public function set item(param1:RTMWeaponContainer) : void
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
      
      [Bindable(event="propertyChange")]
      public function get cooldownModel() : CooldownModel
      {
         return this._2103504510cooldownModel;
      }
      
      public function set cooldownModel(param1:CooldownModel) : void
      {
         var _loc2_:Object = this._2103504510cooldownModel;
         if(_loc2_ !== param1)
         {
            this._2103504510cooldownModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cooldownModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : RTMModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:RTMModel) : void
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

