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
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.model.inventory.BodyModel;
   import soul.model.item.Item;
   import soul.model.item.ItemShortcut;
   import soul.model.item.ItemSlot;
   import soul.view.assets.*;
   import soul.view.ui.Container;
   
   use namespace mx_internal;
   
   public class Doll extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const WEAPON_SETS:Array = [[Assets.set210,Assets.set211],[Assets.set220,Assets.set221]];
      
      private var _904975636altMode:SimpleImageBar;
      
      private var _1413683278amulet:DollItemSmall;
      
      private var _1409300624armour:DollItem;
      
      private var _93182050auto1:AutoRuneContainer;
      
      private var _93182051auto2:AutoRuneContainer;
      
      private var _93182052auto3:AutoRuneContainer;
      
      private var _93922241boots:DollItem;
      
      private var _847350419earClips:DollItemSmall;
      
      private var _1243001030gloves:DollItem;
      
      private var _1220934547helmet:DollItem;
      
      private var _108518401ring1:DollItemSmall;
      
      private var _108518402ring2:DollItemSmall;
      
      private var _108518403ring3:DollItemSmall;
      
      private var _2061225448shield1:DollItem;
      
      private var _2061225449shield2:DollItem;
      
      private var _110133191tatoo:DollItem;
      
      private var _112893312waist:DollItem;
      
      private var _1223328149weapon1:DollItem;
      
      private var _1223328150weapon2:DollItem;
      
      private var _1236240039bodyModel:BodyModel;
      
      private var _109532725slots:Array;
      
      private var _2063019719avatarImagePath:String;
      
      private var _1097452790locked:Boolean;
      
      private var _1488333531alternativeIndex:uint;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function Doll()
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
         bindings = this._Doll_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_inventory_DollWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return Doll[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._Doll_DollItemSmall1_i(),this._Doll_DollItem1_i(),this._Doll_DollItemSmall2_i(),this._Doll_DollItemSmall3_i(),this._Doll_DollItemSmall4_i(),this._Doll_DollItemSmall5_i(),this._Doll_DollItem2_i(),this._Doll_DollItem3_i(),this._Doll_SimpleImageBar1_i(),this._Doll_DollItem4_i(),this._Doll_DollItem5_i(),this._Doll_DollItem6_i(),this._Doll_DollItem7_i(),this._Doll_DollItem8_i(),this._Doll_DollItem9_i(),this._Doll_DollItem10_i(),this._Doll_AutoRuneContainer1_i(),this._Doll_AutoRuneContainer2_i(),this._Doll_AutoRuneContainer3_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         Doll._watcherSetupUtil = param1;
      }
      
      private function _Doll_DollItemSmall1_i() : DollItemSmall
      {
         var _loc1_:DollItemSmall = new DollItemSmall();
         _loc1_.slotIndex = 0;
         _loc1_.x = 96;
         _loc1_.y = 43;
         this.earClips = _loc1_;
         BindingManager.executeBindings(this,"earClips",this.earClips);
         return _loc1_;
      }
      
      private function _Doll_DollItem1_i() : DollItem
      {
         var _loc1_:DollItem = new DollItem();
         _loc1_.slotIndex = 0;
         _loc1_.x = 166;
         _loc1_.y = 18;
         this.helmet = _loc1_;
         BindingManager.executeBindings(this,"helmet",this.helmet);
         return _loc1_;
      }
      
      private function _Doll_DollItemSmall2_i() : DollItemSmall
      {
         var _loc1_:DollItemSmall = new DollItemSmall();
         _loc1_.slotIndex = 0;
         _loc1_.x = 251;
         _loc1_.y = 43;
         this.amulet = _loc1_;
         BindingManager.executeBindings(this,"amulet",this.amulet);
         return _loc1_;
      }
      
      private function _Doll_DollItemSmall3_i() : DollItemSmall
      {
         var _loc1_:DollItemSmall = new DollItemSmall();
         _loc1_.slotIndex = 0;
         _loc1_.x = 17;
         _loc1_.y = 146;
         this.ring1 = _loc1_;
         BindingManager.executeBindings(this,"ring1",this.ring1);
         return _loc1_;
      }
      
      private function _Doll_DollItemSmall4_i() : DollItemSmall
      {
         var _loc1_:DollItemSmall = new DollItemSmall();
         _loc1_.slotIndex = 1;
         _loc1_.x = 17;
         _loc1_.y = 216;
         this.ring2 = _loc1_;
         BindingManager.executeBindings(this,"ring2",this.ring2);
         return _loc1_;
      }
      
      private function _Doll_DollItemSmall5_i() : DollItemSmall
      {
         var _loc1_:DollItemSmall = new DollItemSmall();
         _loc1_.slotIndex = 2;
         _loc1_.x = 17;
         _loc1_.y = 286;
         this.ring3 = _loc1_;
         BindingManager.executeBindings(this,"ring3",this.ring3);
         return _loc1_;
      }
      
      private function _Doll_DollItem2_i() : DollItem
      {
         var _loc1_:DollItem = new DollItem();
         _loc1_.slotIndex = 0;
         _loc1_.x = 81;
         _loc1_.y = 123;
         this.weapon1 = _loc1_;
         BindingManager.executeBindings(this,"weapon1",this.weapon1);
         return _loc1_;
      }
      
      private function _Doll_DollItem3_i() : DollItem
      {
         var _loc1_:DollItem = new DollItem();
         _loc1_.slotIndex = 1;
         _loc1_.x = 81;
         _loc1_.y = 123;
         this.weapon2 = _loc1_;
         BindingManager.executeBindings(this,"weapon2",this.weapon2);
         return _loc1_;
      }
      
      private function _Doll_SimpleImageBar1_i() : SimpleImageBar
      {
         var _loc1_:SimpleImageBar = new SimpleImageBar();
         _loc1_.x = 85;
         _loc1_.y = 189;
         _loc1_.direction = "horizontal";
         _loc1_.gap = 1;
         this.altMode = _loc1_;
         BindingManager.executeBindings(this,"altMode",this.altMode);
         return _loc1_;
      }
      
      private function _Doll_DollItem4_i() : DollItem
      {
         var _loc1_:DollItem = new DollItem();
         _loc1_.slotIndex = 0;
         _loc1_.x = 251;
         _loc1_.y = 123;
         this.shield1 = _loc1_;
         BindingManager.executeBindings(this,"shield1",this.shield1);
         return _loc1_;
      }
      
      private function _Doll_DollItem5_i() : DollItem
      {
         var _loc1_:DollItem = new DollItem();
         _loc1_.slotIndex = 1;
         _loc1_.x = 251;
         _loc1_.y = 123;
         this.shield2 = _loc1_;
         BindingManager.executeBindings(this,"shield2",this.shield2);
         return _loc1_;
      }
      
      private function _Doll_DollItem6_i() : DollItem
      {
         var _loc1_:DollItem = new DollItem();
         _loc1_.slotIndex = 0;
         _loc1_.x = 81;
         _loc1_.y = 228;
         this.gloves = _loc1_;
         BindingManager.executeBindings(this,"gloves",this.gloves);
         return _loc1_;
      }
      
      private function _Doll_DollItem7_i() : DollItem
      {
         var _loc1_:DollItem = new DollItem();
         _loc1_.slotIndex = 0;
         _loc1_.x = 166;
         _loc1_.y = 103;
         this.armour = _loc1_;
         BindingManager.executeBindings(this,"armour",this.armour);
         return _loc1_;
      }
      
      private function _Doll_DollItem8_i() : DollItem
      {
         var _loc1_:DollItem = new DollItem();
         _loc1_.slotIndex = 0;
         _loc1_.x = 166;
         _loc1_.y = 188;
         this.waist = _loc1_;
         BindingManager.executeBindings(this,"waist",this.waist);
         return _loc1_;
      }
      
      private function _Doll_DollItem9_i() : DollItem
      {
         var _loc1_:DollItem = new DollItem();
         _loc1_.slotIndex = 0;
         _loc1_.x = 166;
         _loc1_.y = 273;
         this.boots = _loc1_;
         BindingManager.executeBindings(this,"boots",this.boots);
         return _loc1_;
      }
      
      private function _Doll_DollItem10_i() : DollItem
      {
         var _loc1_:DollItem = new DollItem();
         _loc1_.slotIndex = 0;
         _loc1_.x = 251;
         _loc1_.y = 228;
         this.tatoo = _loc1_;
         BindingManager.executeBindings(this,"tatoo",this.tatoo);
         return _loc1_;
      }
      
      private function _Doll_AutoRuneContainer1_i() : AutoRuneContainer
      {
         var _loc1_:AutoRuneContainer = new AutoRuneContainer();
         _loc1_.slotIndex = 0;
         _loc1_.x = 330;
         _loc1_.y = 146;
         this.auto1 = _loc1_;
         BindingManager.executeBindings(this,"auto1",this.auto1);
         return _loc1_;
      }
      
      private function _Doll_AutoRuneContainer2_i() : AutoRuneContainer
      {
         var _loc1_:AutoRuneContainer = new AutoRuneContainer();
         _loc1_.slotIndex = 1;
         _loc1_.x = 330;
         _loc1_.y = 216;
         this.auto2 = _loc1_;
         BindingManager.executeBindings(this,"auto2",this.auto2);
         return _loc1_;
      }
      
      private function _Doll_AutoRuneContainer3_i() : AutoRuneContainer
      {
         var _loc1_:AutoRuneContainer = new AutoRuneContainer();
         _loc1_.slotIndex = 2;
         _loc1_.x = 330;
         _loc1_.y = 286;
         this.auto3 = _loc1_;
         BindingManager.executeBindings(this,"auto3",this.auto3);
         return _loc1_;
      }
      
      private function _Doll_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = ItemSlot.EARCLIPS;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"earClips.itemSlot");
         result[1] = new Binding(this,function():Item
         {
            return bodyModel.earClips;
         },null,"earClips.item");
         result[2] = new Binding(this,null,null,"earClips.locked","locked");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = ItemSlot.HELMET;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"helmet.itemSlot");
         result[4] = new Binding(this,function():Item
         {
            return bodyModel.helmet;
         },null,"helmet.item");
         result[5] = new Binding(this,null,null,"helmet.locked","locked");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = ItemSlot.AMULET;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"amulet.itemSlot");
         result[7] = new Binding(this,function():Item
         {
            return bodyModel.amulet;
         },null,"amulet.item");
         result[8] = new Binding(this,null,null,"amulet.locked","locked");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = ItemSlot.RING;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"ring1.itemSlot");
         result[10] = new Binding(this,function():Item
         {
            return bodyModel.ring1;
         },null,"ring1.item");
         result[11] = new Binding(this,null,null,"ring1.locked","locked");
         result[12] = new Binding(this,function():String
         {
            var _loc1_:* = ItemSlot.RING;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"ring2.itemSlot");
         result[13] = new Binding(this,function():Item
         {
            return bodyModel.ring2;
         },null,"ring2.item");
         result[14] = new Binding(this,null,null,"ring2.locked","locked");
         result[15] = new Binding(this,function():String
         {
            var _loc1_:* = ItemSlot.RING;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"ring3.itemSlot");
         result[16] = new Binding(this,function():Item
         {
            return bodyModel.ring3;
         },null,"ring3.item");
         result[17] = new Binding(this,null,null,"ring3.locked","locked");
         result[18] = new Binding(this,function():String
         {
            var _loc1_:* = ItemSlot.WEAPON;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"weapon1.itemSlot");
         result[19] = new Binding(this,function():Boolean
         {
            return altMode.selectedIndex == 0;
         },null,"weapon1.visible");
         result[20] = new Binding(this,function():Item
         {
            return bodyModel.weapon1;
         },null,"weapon1.item");
         result[21] = new Binding(this,null,null,"weapon1.locked","locked");
         result[22] = new Binding(this,function():String
         {
            var _loc1_:* = ItemSlot.WEAPON;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"weapon2.itemSlot");
         result[23] = new Binding(this,function():Boolean
         {
            return altMode.selectedIndex == 1;
         },null,"weapon2.visible");
         result[24] = new Binding(this,function():Item
         {
            return bodyModel.weapon2;
         },null,"weapon2.item");
         result[25] = new Binding(this,null,null,"weapon2.locked","locked");
         result[26] = new Binding(this,function():Array
         {
            var _loc1_:* = WEAPON_SETS;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"altMode.dataProvider");
         result[27] = new Binding(this,null,null,"altMode.selectedIndex","alternativeIndex");
         result[28] = new Binding(this,function():String
         {
            var _loc1_:* = ItemSlot.SHIELD;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"shield1.itemSlot");
         result[29] = new Binding(this,function():Boolean
         {
            return altMode.selectedIndex == 0;
         },null,"shield1.visible");
         result[30] = new Binding(this,function():Item
         {
            return bodyModel.shield1;
         },null,"shield1.item");
         result[31] = new Binding(this,null,null,"shield1.locked","locked");
         result[32] = new Binding(this,function():String
         {
            var _loc1_:* = ItemSlot.SHIELD;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"shield2.itemSlot");
         result[33] = new Binding(this,function():Boolean
         {
            return altMode.selectedIndex == 1;
         },null,"shield2.visible");
         result[34] = new Binding(this,function():Item
         {
            return bodyModel.shield2;
         },null,"shield2.item");
         result[35] = new Binding(this,null,null,"shield2.locked","locked");
         result[36] = new Binding(this,function():String
         {
            var _loc1_:* = ItemSlot.GLOVES;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"gloves.itemSlot");
         result[37] = new Binding(this,function():Item
         {
            return bodyModel.gloves;
         },null,"gloves.item");
         result[38] = new Binding(this,null,null,"gloves.locked","locked");
         result[39] = new Binding(this,function():String
         {
            var _loc1_:* = ItemSlot.ARMOUR;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"armour.itemSlot");
         result[40] = new Binding(this,function():Item
         {
            return bodyModel.armour;
         },null,"armour.item");
         result[41] = new Binding(this,null,null,"armour.locked","locked");
         result[42] = new Binding(this,function():String
         {
            var _loc1_:* = ItemSlot.WAIST;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"waist.itemSlot");
         result[43] = new Binding(this,function():Item
         {
            return bodyModel.waist;
         },null,"waist.item");
         result[44] = new Binding(this,null,null,"waist.locked","locked");
         result[45] = new Binding(this,function():String
         {
            var _loc1_:* = ItemSlot.BOOTS;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"boots.itemSlot");
         result[46] = new Binding(this,function():Item
         {
            return bodyModel.boots;
         },null,"boots.item");
         result[47] = new Binding(this,null,null,"boots.locked","locked");
         result[48] = new Binding(this,function():String
         {
            var _loc1_:* = ItemSlot.TATOO;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"tatoo.itemSlot");
         result[49] = new Binding(this,function():Item
         {
            return bodyModel.tatoo;
         },null,"tatoo.item");
         result[50] = new Binding(this,null,null,"tatoo.locked","locked");
         result[51] = new Binding(this,null,null,"auto1.locked","locked");
         result[52] = new Binding(this,function():ItemShortcut
         {
            return slots[0];
         },null,"auto1.itemShortcut");
         result[53] = new Binding(this,null,null,"auto2.locked","locked");
         result[54] = new Binding(this,function():ItemShortcut
         {
            return slots[1];
         },null,"auto2.itemShortcut");
         result[55] = new Binding(this,null,null,"auto3.locked","locked");
         result[56] = new Binding(this,function():ItemShortcut
         {
            return slots[2];
         },null,"auto3.itemShortcut");
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
      public function get amulet() : DollItemSmall
      {
         return this._1413683278amulet;
      }
      
      public function set amulet(param1:DollItemSmall) : void
      {
         var _loc2_:Object = this._1413683278amulet;
         if(_loc2_ !== param1)
         {
            this._1413683278amulet = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"amulet",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get armour() : DollItem
      {
         return this._1409300624armour;
      }
      
      public function set armour(param1:DollItem) : void
      {
         var _loc2_:Object = this._1409300624armour;
         if(_loc2_ !== param1)
         {
            this._1409300624armour = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"armour",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get auto1() : AutoRuneContainer
      {
         return this._93182050auto1;
      }
      
      public function set auto1(param1:AutoRuneContainer) : void
      {
         var _loc2_:Object = this._93182050auto1;
         if(_loc2_ !== param1)
         {
            this._93182050auto1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"auto1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get auto2() : AutoRuneContainer
      {
         return this._93182051auto2;
      }
      
      public function set auto2(param1:AutoRuneContainer) : void
      {
         var _loc2_:Object = this._93182051auto2;
         if(_loc2_ !== param1)
         {
            this._93182051auto2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"auto2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get auto3() : AutoRuneContainer
      {
         return this._93182052auto3;
      }
      
      public function set auto3(param1:AutoRuneContainer) : void
      {
         var _loc2_:Object = this._93182052auto3;
         if(_loc2_ !== param1)
         {
            this._93182052auto3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"auto3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get boots() : DollItem
      {
         return this._93922241boots;
      }
      
      public function set boots(param1:DollItem) : void
      {
         var _loc2_:Object = this._93922241boots;
         if(_loc2_ !== param1)
         {
            this._93922241boots = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"boots",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get earClips() : DollItemSmall
      {
         return this._847350419earClips;
      }
      
      public function set earClips(param1:DollItemSmall) : void
      {
         var _loc2_:Object = this._847350419earClips;
         if(_loc2_ !== param1)
         {
            this._847350419earClips = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"earClips",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gloves() : DollItem
      {
         return this._1243001030gloves;
      }
      
      public function set gloves(param1:DollItem) : void
      {
         var _loc2_:Object = this._1243001030gloves;
         if(_loc2_ !== param1)
         {
            this._1243001030gloves = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gloves",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get helmet() : DollItem
      {
         return this._1220934547helmet;
      }
      
      public function set helmet(param1:DollItem) : void
      {
         var _loc2_:Object = this._1220934547helmet;
         if(_loc2_ !== param1)
         {
            this._1220934547helmet = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helmet",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ring1() : DollItemSmall
      {
         return this._108518401ring1;
      }
      
      public function set ring1(param1:DollItemSmall) : void
      {
         var _loc2_:Object = this._108518401ring1;
         if(_loc2_ !== param1)
         {
            this._108518401ring1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ring1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ring2() : DollItemSmall
      {
         return this._108518402ring2;
      }
      
      public function set ring2(param1:DollItemSmall) : void
      {
         var _loc2_:Object = this._108518402ring2;
         if(_loc2_ !== param1)
         {
            this._108518402ring2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ring2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ring3() : DollItemSmall
      {
         return this._108518403ring3;
      }
      
      public function set ring3(param1:DollItemSmall) : void
      {
         var _loc2_:Object = this._108518403ring3;
         if(_loc2_ !== param1)
         {
            this._108518403ring3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ring3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get shield1() : DollItem
      {
         return this._2061225448shield1;
      }
      
      public function set shield1(param1:DollItem) : void
      {
         var _loc2_:Object = this._2061225448shield1;
         if(_loc2_ !== param1)
         {
            this._2061225448shield1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"shield1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get shield2() : DollItem
      {
         return this._2061225449shield2;
      }
      
      public function set shield2(param1:DollItem) : void
      {
         var _loc2_:Object = this._2061225449shield2;
         if(_loc2_ !== param1)
         {
            this._2061225449shield2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"shield2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tatoo() : DollItem
      {
         return this._110133191tatoo;
      }
      
      public function set tatoo(param1:DollItem) : void
      {
         var _loc2_:Object = this._110133191tatoo;
         if(_loc2_ !== param1)
         {
            this._110133191tatoo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tatoo",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get waist() : DollItem
      {
         return this._112893312waist;
      }
      
      public function set waist(param1:DollItem) : void
      {
         var _loc2_:Object = this._112893312waist;
         if(_loc2_ !== param1)
         {
            this._112893312waist = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"waist",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get weapon1() : DollItem
      {
         return this._1223328149weapon1;
      }
      
      public function set weapon1(param1:DollItem) : void
      {
         var _loc2_:Object = this._1223328149weapon1;
         if(_loc2_ !== param1)
         {
            this._1223328149weapon1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"weapon1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get weapon2() : DollItem
      {
         return this._1223328150weapon2;
      }
      
      public function set weapon2(param1:DollItem) : void
      {
         var _loc2_:Object = this._1223328150weapon2;
         if(_loc2_ !== param1)
         {
            this._1223328150weapon2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"weapon2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bodyModel() : BodyModel
      {
         return this._1236240039bodyModel;
      }
      
      public function set bodyModel(param1:BodyModel) : void
      {
         var _loc2_:Object = this._1236240039bodyModel;
         if(_loc2_ !== param1)
         {
            this._1236240039bodyModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bodyModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get slots() : Array
      {
         return this._109532725slots;
      }
      
      public function set slots(param1:Array) : void
      {
         var _loc2_:Object = this._109532725slots;
         if(_loc2_ !== param1)
         {
            this._109532725slots = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"slots",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get avatarImagePath() : String
      {
         return this._2063019719avatarImagePath;
      }
      
      public function set avatarImagePath(param1:String) : void
      {
         var _loc2_:Object = this._2063019719avatarImagePath;
         if(_loc2_ !== param1)
         {
            this._2063019719avatarImagePath = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"avatarImagePath",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get locked() : Boolean
      {
         return this._1097452790locked;
      }
      
      public function set locked(param1:Boolean) : void
      {
         var _loc2_:Object = this._1097452790locked;
         if(_loc2_ !== param1)
         {
            this._1097452790locked = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"locked",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get alternativeIndex() : uint
      {
         return this._1488333531alternativeIndex;
      }
      
      public function set alternativeIndex(param1:uint) : void
      {
         var _loc2_:Object = this._1488333531alternativeIndex;
         if(_loc2_ !== param1)
         {
            this._1488333531alternativeIndex = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"alternativeIndex",_loc2_,param1));
            }
         }
      }
   }
}

