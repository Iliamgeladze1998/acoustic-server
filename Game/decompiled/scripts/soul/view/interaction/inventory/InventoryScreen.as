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
   import mx.core.DragSource;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.controller.Interaction;
   import soul.controller.LogManager;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.ClanEvent;
   import soul.event.DragEvent;
   import soul.event.InventoryEvent;
   import soul.event.ShopEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.character.CharacterModel;
   import soul.model.common.InteractionType;
   import soul.model.inventory.InventoryModel;
   import soul.model.inventory.Sack;
   import soul.model.item.Item;
   import soul.model.location.shop.ShopModel;
   import soul.model.system.Configuration;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientLabel;
   import soul.view.common.Currency;
   import soul.view.common.Icons;
   import soul.view.common.MoneyRenderer;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   import soul.view.ui.controls.PopupManager;
   import soul.view.ui.controls.Window;
   
   use namespace mx_internal;
   
   public class InventoryScreen extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const GRADIENT:Array = [0,2566914048,2566914048,2566914048,2566914048];
      
      public var _InventoryScreen_Button11:Button1;
      
      public var _InventoryScreen_CachedImage1:CachedImage;
      
      public var _InventoryScreen_CachedImage2:CachedImage;
      
      public var _InventoryScreen_CachedImage3:CachedImage;
      
      public var _InventoryScreen_CachedImage4:CachedImage;
      
      public var _InventoryScreen_GradientLabel1:GradientLabel;
      
      public var _InventoryScreen_HBox2:HBox;
      
      public var _InventoryScreen_HBox3:HBox;
      
      public var _InventoryScreen_Label1:Label;
      
      public var _InventoryScreen_Label2:Label;
      
      public var _InventoryScreen_MoneyRenderer1:MoneyRenderer;
      
      private var _2121767808backpack:Backpack;
      
      private var _97299bar:SackBar;
      
      private var _104069929model:InventoryModel;
      
      private var _340320640characterModel:CharacterModel;
      
      public var shopModel:ShopModel;
      
      private var popup:DropDialog;
      
      private var splitDialog:SplitDialog;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function InventoryScreen()
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
         bindings = this._InventoryScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_inventory_InventoryScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return InventoryScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 480;
         this.height = 456;
         this.padding = 10;
         this.gap = 5;
         this.backgroundColor = 0;
         this.backgroundAlpha = 0;
         this.children = [this._InventoryScreen_Canvas1_c(),this._InventoryScreen_HBox4_c()];
         this.addEventListener("creationComplete",this.___InventoryScreen_VBox1_creationComplete);
         this.addEventListener("addedToStage",this.___InventoryScreen_VBox1_addedToStage);
         this.addEventListener("removedFromStage",this.___InventoryScreen_VBox1_removedFromStage);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         InventoryScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.setLabelToInteractionParent(this,this.getString("inventory.title"));
      }
      
      private function addedToStage() : void
      {
         addEventListener(InventoryEvent.TAKEOFF,this.delegate);
         addEventListener(InventoryEvent.TAKEOFF_TO_SACK,this.delegate);
         addEventListener(InventoryEvent.TAKEOFF_TO_SLOT,this.delegate);
         addEventListener(InventoryEvent.EQUIP,this.delegate);
         addEventListener(InventoryEvent.EQUIP_TO_SLOT,this.delegate);
         addEventListener(InventoryEvent.CHANGE_SLOT,this.delegate);
         addEventListener(InventoryEvent.CHANGE_BODY_SLOT,this.delegate);
         addEventListener(InventoryEvent.CHANGE_SACK,this.delegate);
         addEventListener(InventoryEvent.DROP,this.dropItem);
         addEventListener(InventoryEvent.USE,this.delegate);
         addEventListener(InventoryEvent.GET_SOCKETS,this.delegate);
         addEventListener(InventoryEvent.SPLIT_START,this.splitItem);
         addEventListener(InventoryEvent.SPLIT,this.delegate);
         addEventListener(InventoryEvent.SPLIT_TO_SACK,this.delegate);
         addEventListener(ShopEvent.OPEN_SELL_DIALOG,this.openSellDialog);
         addEventListener(DragEvent.DRAG_ENTER,this.dragEnter);
         addEventListener(DragEvent.DRAG_DROP,this.dragDrop);
         addEventListener(ClanEvent.TAKE_ITEM,this.delegate);
         this.model.dispatchEvent(new InventoryEvent(InventoryEvent.INVENTORY_VISIBLE));
      }
      
      private function removedFromStage() : void
      {
         this.model.dispatchEvent(new InventoryEvent(InventoryEvent.INVENTORY_HIDDEN));
      }
      
      private function getMoney() : void
      {
         Interaction.show(InteractionType.RUBY);
         LogManager.log("InventoryScreen","Clicked \'money.get\' button");
      }
      
      private function delegate(e:Event) : void
      {
         e.stopPropagation();
         this.model.dispatchEvent(e.clone());
      }
      
      private function dropItem(e:InventoryEvent) : void
      {
         e.stopPropagation();
         this.popup = new DropDialog();
         this.popup.addEventListener(Window.DIALOG_CLOSE,this.closeDialog);
         this.popup.addEventListener(InventoryEvent.DROP,this.dropConfirm);
         this.popup.item = e.item;
         PopupManager.addPopup(this.popup,null,true);
         PopupManager.centerPopup(this.popup);
      }
      
      private function dropConfirm(e:InventoryEvent) : void
      {
         this.closeDialog(null);
         this.delegate(e);
      }
      
      private function closeDialog(e:Event) : void
      {
         if(!this.popup)
         {
            return;
         }
         PopupManager.removePopup(this.popup);
         this.popup = null;
      }
      
      private function splitItem(e:InventoryEvent) : void
      {
         e.stopPropagation();
         this.splitDialog = new SplitDialog();
         this.splitDialog.addEventListener(Window.DIALOG_CLOSE,this.splitClose);
         this.splitDialog.addEventListener(InventoryEvent.SPLIT,this.splitConfirm);
         this.splitDialog.item = e.item;
         this.splitDialog.slotIndex = e.slotIndex;
         PopupManager.addPopup(this.splitDialog,null,true);
         PopupManager.centerPopup(this.splitDialog);
      }
      
      private function splitClose(e:Event) : void
      {
         if(!this.splitDialog)
         {
            return;
         }
         PopupManager.removePopup(this.splitDialog);
         this.splitDialog = null;
      }
      
      private function splitConfirm(e:InventoryEvent) : void
      {
         var image:CachedImage = null;
         var ds:DragSource = null;
         var item:Item = e.item;
         if(e.slotIndex > -1)
         {
            this.delegate(e);
         }
         else
         {
            image = new CachedImage();
            image.source = Configuration.getItemImageUrl(item.imagePath);
            ds = new DragSource();
            ds.addData(item,"splitItem");
            SimpleDragManager.doDrag(this,ds,e.mouseEvent,image);
         }
         this.splitClose(null);
      }
      
      private function openSellDialog(e:ShopEvent) : void
      {
         e.stopPropagation();
         var ne:ShopEvent = new ShopEvent(e.type);
         ne.item = e.item;
         this.shopModel.dispatchEvent(ne);
      }
      
      private function dragEnter(e:DragEvent) : void
      {
         var item:Item = Item(e.dragSource.dataForFormat("item"));
         if(Boolean(e.dragSource.dataForFormat("shopItem")) || Boolean(e.dragSource.dataForFormat("storageItem")) || Boolean(item) && Boolean(!item.key))
         {
            SimpleDragManager.acceptDragDrop(this);
         }
      }
      
      private function dragDrop(e:DragEvent) : void
      {
         var ne:InventoryEvent = null;
         var storageSlotIndex:int = 0;
         var sack:String = null;
         var ce:ClanEvent = null;
         var item:Item = Item(e.dragSource.dataForFormat("item"));
         var storageItem:Item = Item(e.dragSource.dataForFormat("storageItem"));
         if(Boolean(item))
         {
            ne = new InventoryEvent(InventoryEvent.TAKEOFF);
            ne.item = item;
            this.model.dispatchEvent(ne);
         }
         else if(Boolean(storageItem))
         {
            storageSlotIndex = e.dragSource.dataForFormat("slotIndex") as int;
            sack = e.dragSource.dataForFormat("sack") as String;
            ce = new ClanEvent(ClanEvent.TAKE_ITEM);
            ce.data = [sack,storageSlotIndex,null];
            this.model.dispatchEvent(ce);
         }
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _InventoryScreen_Canvas1_c() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.padding = 5;
         _loc1_.children = [this._InventoryScreen_CachedImage1_i(),this._InventoryScreen_VBox2_c(),this._InventoryScreen_HBox1_c()];
         return _loc1_;
      }
      
      private function _InventoryScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._InventoryScreen_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_InventoryScreen_CachedImage1",this._InventoryScreen_CachedImage1);
         return _loc1_;
      }
      
      private function _InventoryScreen_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.padding = 12;
         _loc1_.gap = -10;
         _loc1_.left = 0;
         _loc1_.top = -15;
         _loc1_.children = [this._InventoryScreen_SackBar1_i(),this._InventoryScreen_Backpack1_i()];
         return _loc1_;
      }
      
      private function _InventoryScreen_SackBar1_i() : SackBar
      {
         var _loc1_:SackBar = new SackBar();
         this.bar = _loc1_;
         BindingManager.executeBindings(this,"bar",this.bar);
         return _loc1_;
      }
      
      private function _InventoryScreen_Backpack1_i() : Backpack
      {
         var _loc1_:Backpack = new Backpack();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 5;
         this.backpack = _loc1_;
         BindingManager.executeBindings(this,"backpack",this.backpack);
         return _loc1_;
      }
      
      private function _InventoryScreen_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 55;
         _loc1_.bottom = 0;
         _loc1_.verticalAlign = "middle";
         _loc1_.left = 20;
         _loc1_.gap = 10;
         _loc1_.children = [this._InventoryScreen_MoneyRenderer1_i(),this._InventoryScreen_HBox2_i(),this._InventoryScreen_HBox3_i()];
         return _loc1_;
      }
      
      private function _InventoryScreen_MoneyRenderer1_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         this._InventoryScreen_MoneyRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_InventoryScreen_MoneyRenderer1",this._InventoryScreen_MoneyRenderer1);
         return _loc1_;
      }
      
      private function _InventoryScreen_HBox2_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 3;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._InventoryScreen_Label1_i(),this._InventoryScreen_CachedImage2_i()];
         this._InventoryScreen_HBox2 = _loc1_;
         BindingManager.executeBindings(this,"_InventoryScreen_HBox2",this._InventoryScreen_HBox2);
         return _loc1_;
      }
      
      private function _InventoryScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.minWidth = 40;
         _loc1_.align = "right";
         this._InventoryScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_InventoryScreen_Label1",this._InventoryScreen_Label1);
         return _loc1_;
      }
      
      private function _InventoryScreen_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._InventoryScreen_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_InventoryScreen_CachedImage2",this._InventoryScreen_CachedImage2);
         return _loc1_;
      }
      
      private function _InventoryScreen_HBox3_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 3;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._InventoryScreen_Label2_i(),this._InventoryScreen_CachedImage3_i()];
         this._InventoryScreen_HBox3 = _loc1_;
         BindingManager.executeBindings(this,"_InventoryScreen_HBox3",this._InventoryScreen_HBox3);
         return _loc1_;
      }
      
      private function _InventoryScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.minWidth = 40;
         _loc1_.align = "right";
         this._InventoryScreen_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_InventoryScreen_Label2",this._InventoryScreen_Label2);
         return _loc1_;
      }
      
      private function _InventoryScreen_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._InventoryScreen_CachedImage3 = _loc1_;
         BindingManager.executeBindings(this,"_InventoryScreen_CachedImage3",this._InventoryScreen_CachedImage3);
         return _loc1_;
      }
      
      private function _InventoryScreen_HBox4_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.verticalAlign = "middle";
         _loc1_.gap = -1;
         _loc1_.children = [this._InventoryScreen_Canvas2_c(),this._InventoryScreen_Button11_i()];
         return _loc1_;
      }
      
      private function _InventoryScreen_Canvas2_c() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._InventoryScreen_GradientLabel1_i(),this._InventoryScreen_CachedImage4_i()];
         return _loc1_;
      }
      
      private function _InventoryScreen_GradientLabel1_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.leftMargin = 60;
         _loc1_.verticalCenter = 0;
         _loc1_.fontSize = 13;
         _loc1_.bold = true;
         this._InventoryScreen_GradientLabel1 = _loc1_;
         BindingManager.executeBindings(this,"_InventoryScreen_GradientLabel1",this._InventoryScreen_GradientLabel1);
         return _loc1_;
      }
      
      private function _InventoryScreen_CachedImage4_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.verticalCenter = 0;
         this._InventoryScreen_CachedImage4 = _loc1_;
         BindingManager.executeBindings(this,"_InventoryScreen_CachedImage4",this._InventoryScreen_CachedImage4);
         return _loc1_;
      }
      
      private function _InventoryScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.x = 291;
         _loc1_.y = 356;
         _loc1_.width = 110;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___InventoryScreen_Button11_click);
         this._InventoryScreen_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_InventoryScreen_Button11",this._InventoryScreen_Button11);
         return _loc1_;
      }
      
      public function ___InventoryScreen_Button11_click(event:MouseEvent) : void
      {
         this.getMoney();
      }
      
      public function ___InventoryScreen_VBox1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      public function ___InventoryScreen_VBox1_addedToStage(event:Event) : void
      {
         this.addedToStage();
      }
      
      public function ___InventoryScreen_VBox1_removedFromStage(event:Event) : void
      {
         this.removedFromStage();
      }
      
      private function _InventoryScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():*
         {
            return bar.selectedIndex;
         },function(param1:*):void
         {
            model.selectedSack = param1;
         },"model.selectedSack");
         result[1] = new Binding(this,function():Object
         {
            return Assets.panelSetBig;
         },null,"_InventoryScreen_CachedImage1.source");
         result[2] = new Binding(this,function():Vector.<Sack>
         {
            return model.sacks;
         },null,"bar.dataProvider");
         result[3] = new Binding(this,function():Sack
         {
            return model.sacks[bar.selectedIndex];
         },null,"backpack.dataProvider");
         result[4] = new Binding(this,function():uint
         {
            return characterModel.currencies.COPPER;
         },null,"_InventoryScreen_MoneyRenderer1.value");
         result[5] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_InventoryScreen_MoneyRenderer1.color");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = getString("currencyType.RUBIES");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InventoryScreen_HBox2.toolTip");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = characterModel.currencies.RUBIES;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InventoryScreen_Label1.text");
         result[8] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_InventoryScreen_Label1.color");
         result[9] = new Binding(this,function():Object
         {
            return Currency.rubiesImg;
         },null,"_InventoryScreen_CachedImage2.source");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = getString("currencyType.PVP");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InventoryScreen_HBox3.toolTip");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = characterModel.currencies.PVP;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InventoryScreen_Label2.text");
         result[12] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_InventoryScreen_Label2.color");
         result[13] = new Binding(this,function():Object
         {
            return Currency.pvpImg;
         },null,"_InventoryScreen_CachedImage3.source");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = getString("notEnoughMoney");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InventoryScreen_GradientLabel1.text");
         result[15] = new Binding(this,function():Array
         {
            var _loc1_:* = GRADIENT;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_InventoryScreen_GradientLabel1.gradient");
         result[16] = new Binding(this,function():uint
         {
            return Colors.BUTTON_LABEL;
         },null,"_InventoryScreen_GradientLabel1.color");
         result[17] = new Binding(this,function():Object
         {
            return Icons.ruby;
         },null,"_InventoryScreen_CachedImage4.source");
         result[18] = new Binding(this,function():String
         {
            var _loc1_:* = getString("money.get");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_InventoryScreen_Button11.label");
         return result;
      }
      
      private function _InventoryScreen_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         this.model.selectedSack = this.bar.selectedIndex;
      }
      
      [Bindable(event="propertyChange")]
      public function get backpack() : Backpack
      {
         return this._2121767808backpack;
      }
      
      public function set backpack(param1:Backpack) : void
      {
         var _loc2_:Object = this._2121767808backpack;
         if(_loc2_ !== param1)
         {
            this._2121767808backpack = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"backpack",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bar() : SackBar
      {
         return this._97299bar;
      }
      
      public function set bar(param1:SackBar) : void
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
      public function get model() : InventoryModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:InventoryModel) : void
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

