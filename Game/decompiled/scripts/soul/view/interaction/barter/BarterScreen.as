package soul.view.interaction.barter
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
   import soul.event.BarterEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.character.CharacterModel;
   import soul.model.interaction.barter.BarterModel;
   import soul.model.item.Item;
   import soul.model.system.Configuration;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.RoundImage;
   import soul.view.common.CurrencyType;
   import soul.view.common.Icons;
   import soul.view.common.MoneyRenderer;
   import soul.view.interaction.auction.MoneyEnter;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.UIAssets;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class BarterScreen extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _BarterScreen_BorderedContainer1:BorderedContainer;
      
      public var _BarterScreen_BorderedContainer2:BorderedContainer;
      
      public var _BarterScreen_CachedImage1:CachedImage;
      
      public var _BarterScreen_CachedImage2:CachedImage;
      
      public var _BarterScreen_CachedImage3:CachedImage;
      
      public var _BarterScreen_CachedImage4:CachedImage;
      
      public var _BarterScreen_CachedImage5:CachedImage;
      
      public var _BarterScreen_CachedImage6:CachedImage;
      
      public var _BarterScreen_Canvas2:Canvas;
      
      public var _BarterScreen_Label1:Label;
      
      public var _BarterScreen_Label2:Label;
      
      public var _BarterScreen_Label3:Label;
      
      public var _BarterScreen_Label4:Label;
      
      public var _BarterScreen_MoneyRenderer1:MoneyRenderer;
      
      public var _BarterScreen_MoneyRenderer2:MoneyRenderer;
      
      public var _BarterScreen_RoundImage1:RoundImage;
      
      public var _BarterScreen_RoundImage2:RoundImage;
      
      private var _1354723047copper:MoneyEnter;
      
      private var _1488753969myItem0:BarterItem;
      
      private var _1488753970myItem1:BarterItem;
      
      private var _1488753971myItem2:BarterItem;
      
      private var _1488753972myItem3:BarterItem;
      
      private var _389159243readyButton:Button1;
      
      private var _2088879401remoteItem0:ItemRenderer;
      
      private var _2088879400remoteItem1:ItemRenderer;
      
      private var _2088879399remoteItem2:ItemRenderer;
      
      private var _2088879398remoteItem3:ItemRenderer;
      
      private var _920168456rubies:MoneyEnter;
      
      private var _104069929model:BarterModel;
      
      private var _340320640characterModel:CharacterModel;
      
      private var buttonTimer:Timer;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function BarterScreen()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this.buttonTimer = new Timer(1500);
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         bindings = this._BarterScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_barter_BarterScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return BarterScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 331;
         this.height = 387;
         this.children = [this._BarterScreen_VBox1_c(),this._BarterScreen_Canvas2_i(),this._BarterScreen_Canvas3_c(),this._BarterScreen_Canvas4_c(),this._BarterScreen_CachedImage6_i()];
         this.addEventListener("creationComplete",this.___BarterScreen_Canvas1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         BarterScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("barter.title");
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         addEventListener(BarterEvent.OFFER_ITEM,this.delegate,false,0,true);
         this.copper.addEventListener("valueChanged",this.moneyOfferChanged,false,0,true);
         this.rubies.addEventListener("valueChanged",this.moneyOfferChanged,false,0,true);
         this.buttonTimer.addEventListener(TimerEvent.TIMER,this.enableButton,false,0,true);
         this.model.dispatchEvent(new BarterEvent(BarterEvent.INIT));
      }
      
      private function onRemoved(e:Event) : void
      {
         var child:BarterItem = null;
         if(e.target != this)
         {
            return;
         }
         for(var i:int = 0; i < 4; i++)
         {
            child = this["myItem" + i];
            if(Boolean(child.item))
            {
               child.item.locked = false;
            }
         }
         this.model.clean();
         this.model.dispatchEvent(new Event(Event.CANCEL));
      }
      
      private function delegate(e:BarterEvent) : void
      {
         e.stopPropagation();
         this.model.dispatchEvent(e.clone());
      }
      
      private function moneyOfferChanged(e:Event) : void
      {
         var enter:MoneyEnter = e.currentTarget as MoneyEnter;
         if(this.characterModel.currencies[enter.type] < enter.value)
         {
            enter.value = this.characterModel.currencies[enter.type];
            return;
         }
         var ne:BarterEvent = new BarterEvent(BarterEvent.OFFER_MONEY);
         ne.currency = enter.type;
         ne.amount = enter.value;
         this.model.dispatchEvent(ne);
      }
      
      private function ready() : void
      {
         var ne:BarterEvent = new BarterEvent(BarterEvent.READY);
         ne.ready = !this.model.iAmReady;
         this.model.dispatchEvent(ne);
         this.readyButton.enabled = false;
         this.buttonTimer.start();
      }
      
      private function enableButton(e:TimerEvent) : void
      {
         this.readyButton.enabled = true;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _BarterScreen_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.gap = 10;
         _loc1_.horizontalAlign = "center";
         _loc1_.padding = 12;
         _loc1_.children = [this._BarterScreen_BorderedContainer1_i(),this._BarterScreen_BorderedContainer2_i(),this._BarterScreen_Button11_i()];
         return _loc1_;
      }
      
      private function _BarterScreen_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 50;
         _loc1_.direction = "vertical";
         _loc1_.gap = 5;
         _loc1_.padding = 3;
         _loc1_.horizontalAlign = "center";
         _loc1_.children = [this._BarterScreen_HBox1_c(),this._BarterScreen_HBox2_c(),this._BarterScreen_HBox3_c()];
         this._BarterScreen_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_BorderedContainer1",this._BarterScreen_BorderedContainer1);
         return _loc1_;
      }
      
      private function _BarterScreen_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 43;
         _loc1_.padding = 5;
         _loc1_.backgroundColor = 0;
         _loc1_.backgroundAlpha = 0.2;
         _loc1_.children = [this._BarterScreen_Component1_c(),this._BarterScreen_VBox2_c(),this._BarterScreen_CachedImage1_i()];
         return _loc1_;
      }
      
      private function _BarterScreen_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 40;
         return _loc1_;
      }
      
      private function _BarterScreen_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.children = [this._BarterScreen_Label1_i(),this._BarterScreen_Label2_i()];
         return _loc1_;
      }
      
      private function _BarterScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         _loc1_.height = 17;
         this._BarterScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_Label1",this._BarterScreen_Label1);
         return _loc1_;
      }
      
      private function _BarterScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         this._BarterScreen_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_Label2",this._BarterScreen_Label2);
         return _loc1_;
      }
      
      private function _BarterScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._BarterScreen_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_CachedImage1",this._BarterScreen_CachedImage1);
         return _loc1_;
      }
      
      private function _BarterScreen_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.children = [this._BarterScreen_BarterItem1_i(),this._BarterScreen_BarterItem2_i(),this._BarterScreen_BarterItem3_i(),this._BarterScreen_BarterItem4_i()];
         return _loc1_;
      }
      
      private function _BarterScreen_BarterItem1_i() : BarterItem
      {
         var _loc1_:BarterItem = new BarterItem();
         _loc1_.slotIndex = 0;
         this.myItem0 = _loc1_;
         BindingManager.executeBindings(this,"myItem0",this.myItem0);
         return _loc1_;
      }
      
      private function _BarterScreen_BarterItem2_i() : BarterItem
      {
         var _loc1_:BarterItem = new BarterItem();
         _loc1_.slotIndex = 1;
         this.myItem1 = _loc1_;
         BindingManager.executeBindings(this,"myItem1",this.myItem1);
         return _loc1_;
      }
      
      private function _BarterScreen_BarterItem3_i() : BarterItem
      {
         var _loc1_:BarterItem = new BarterItem();
         _loc1_.slotIndex = 2;
         this.myItem2 = _loc1_;
         BindingManager.executeBindings(this,"myItem2",this.myItem2);
         return _loc1_;
      }
      
      private function _BarterScreen_BarterItem4_i() : BarterItem
      {
         var _loc1_:BarterItem = new BarterItem();
         _loc1_.slotIndex = 3;
         this.myItem3 = _loc1_;
         BindingManager.executeBindings(this,"myItem3",this.myItem3);
         return _loc1_;
      }
      
      private function _BarterScreen_HBox3_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.padding = 5;
         _loc1_.percentWidth = 100;
         _loc1_.horizontalAlign = "right";
         _loc1_.children = [this._BarterScreen_MoneyEnter1_i(),this._BarterScreen_MoneyEnter2_i()];
         return _loc1_;
      }
      
      private function _BarterScreen_MoneyEnter1_i() : MoneyEnter
      {
         var _loc1_:MoneyEnter = new MoneyEnter();
         this.copper = _loc1_;
         BindingManager.executeBindings(this,"copper",this.copper);
         return _loc1_;
      }
      
      private function _BarterScreen_MoneyEnter2_i() : MoneyEnter
      {
         var _loc1_:MoneyEnter = new MoneyEnter();
         this.rubies = _loc1_;
         BindingManager.executeBindings(this,"rubies",this.rubies);
         return _loc1_;
      }
      
      private function _BarterScreen_BorderedContainer2_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = null;
         _loc1_ = new BorderedContainer();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 50;
         _loc1_.direction = "vertical";
         _loc1_.gap = 5;
         _loc1_.padding = 3;
         _loc1_.horizontalAlign = "center";
         _loc1_.children = [this._BarterScreen_HBox4_c(),this._BarterScreen_HBox5_c(),this._BarterScreen_HBox6_c()];
         this._BarterScreen_BorderedContainer2 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_BorderedContainer2",this._BarterScreen_BorderedContainer2);
         return _loc1_;
      }
      
      private function _BarterScreen_HBox4_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 43;
         _loc1_.padding = 5;
         _loc1_.backgroundColor = 0;
         _loc1_.backgroundAlpha = 0.2;
         _loc1_.children = [this._BarterScreen_Component2_c(),this._BarterScreen_VBox3_c(),this._BarterScreen_CachedImage2_i()];
         return _loc1_;
      }
      
      private function _BarterScreen_Component2_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.width = 40;
         return _loc1_;
      }
      
      private function _BarterScreen_VBox3_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.children = [this._BarterScreen_Label3_i(),this._BarterScreen_Label4_i()];
         return _loc1_;
      }
      
      private function _BarterScreen_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         _loc1_.height = 17;
         this._BarterScreen_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_Label3",this._BarterScreen_Label3);
         return _loc1_;
      }
      
      private function _BarterScreen_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         this._BarterScreen_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_Label4",this._BarterScreen_Label4);
         return _loc1_;
      }
      
      private function _BarterScreen_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._BarterScreen_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_CachedImage2",this._BarterScreen_CachedImage2);
         return _loc1_;
      }
      
      private function _BarterScreen_HBox5_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.children = [this._BarterScreen_ItemRenderer1_i(),this._BarterScreen_ItemRenderer2_i(),this._BarterScreen_ItemRenderer3_i(),this._BarterScreen_ItemRenderer4_i()];
         return _loc1_;
      }
      
      private function _BarterScreen_ItemRenderer1_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         this.remoteItem0 = _loc1_;
         BindingManager.executeBindings(this,"remoteItem0",this.remoteItem0);
         return _loc1_;
      }
      
      private function _BarterScreen_ItemRenderer2_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         this.remoteItem1 = _loc1_;
         BindingManager.executeBindings(this,"remoteItem1",this.remoteItem1);
         return _loc1_;
      }
      
      private function _BarterScreen_ItemRenderer3_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         this.remoteItem2 = _loc1_;
         BindingManager.executeBindings(this,"remoteItem2",this.remoteItem2);
         return _loc1_;
      }
      
      private function _BarterScreen_ItemRenderer4_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         this.remoteItem3 = _loc1_;
         BindingManager.executeBindings(this,"remoteItem3",this.remoteItem3);
         return _loc1_;
      }
      
      private function _BarterScreen_HBox6_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.padding = 5;
         _loc1_.percentWidth = 100;
         _loc1_.horizontalAlign = "right";
         _loc1_.children = [this._BarterScreen_MoneyRenderer1_i(),this._BarterScreen_MoneyRenderer2_i()];
         return _loc1_;
      }
      
      private function _BarterScreen_MoneyRenderer1_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         this._BarterScreen_MoneyRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_MoneyRenderer1",this._BarterScreen_MoneyRenderer1);
         return _loc1_;
      }
      
      private function _BarterScreen_MoneyRenderer2_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         this._BarterScreen_MoneyRenderer2 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_MoneyRenderer2",this._BarterScreen_MoneyRenderer2);
         return _loc1_;
      }
      
      private function _BarterScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 130;
         _loc1_.addEventListener("click",this.__readyButton_click);
         this.readyButton = _loc1_;
         BindingManager.executeBindings(this,"readyButton",this.readyButton);
         return _loc1_;
      }
      
      public function __readyButton_click(event:MouseEvent) : void
      {
         this.ready();
      }
      
      private function _BarterScreen_Canvas2_i() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.backgroundColor = 16711680;
         _loc1_.backgroundAlpha = 0.2;
         _loc1_.x = 13;
         _loc1_.y = 180;
         _loc1_.width = 305;
         _loc1_.height = 154;
         _loc1_.children = [this._BarterScreen_CachedImage3_i()];
         this._BarterScreen_Canvas2 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_Canvas2",this._BarterScreen_Canvas2);
         return _loc1_;
      }
      
      private function _BarterScreen_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.verticalCenter = 12;
         _loc1_.horizontalCenter = 12;
         this._BarterScreen_CachedImage3 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_CachedImage3",this._BarterScreen_CachedImage3);
         return _loc1_;
      }
      
      private function _BarterScreen_Canvas3_c() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.x = 5;
         _loc1_.y = 5;
         _loc1_.children = [this._BarterScreen_RoundImage1_i(),this._BarterScreen_CachedImage4_i()];
         return _loc1_;
      }
      
      private function _BarterScreen_RoundImage1_i() : RoundImage
      {
         var _loc1_:RoundImage = new RoundImage();
         _loc1_.x = 3;
         _loc1_.y = 3;
         _loc1_.backgroundColor = 0;
         _loc1_.width = 51;
         _loc1_.height = 51;
         this._BarterScreen_RoundImage1 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_RoundImage1",this._BarterScreen_RoundImage1);
         return _loc1_;
      }
      
      private function _BarterScreen_CachedImage4_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._BarterScreen_CachedImage4 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_CachedImage4",this._BarterScreen_CachedImage4);
         return _loc1_;
      }
      
      private function _BarterScreen_Canvas4_c() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.x = 5;
         _loc1_.y = 172;
         _loc1_.children = [this._BarterScreen_RoundImage2_i(),this._BarterScreen_CachedImage5_i()];
         return _loc1_;
      }
      
      private function _BarterScreen_RoundImage2_i() : RoundImage
      {
         var _loc1_:RoundImage = new RoundImage();
         _loc1_.x = 3;
         _loc1_.y = 3;
         _loc1_.backgroundColor = 0;
         _loc1_.width = 51;
         _loc1_.height = 51;
         this._BarterScreen_RoundImage2 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_RoundImage2",this._BarterScreen_RoundImage2);
         return _loc1_;
      }
      
      private function _BarterScreen_CachedImage5_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._BarterScreen_CachedImage5 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_CachedImage5",this._BarterScreen_CachedImage5);
         return _loc1_;
      }
      
      private function _BarterScreen_CachedImage6_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.x = 100;
         _loc1_.y = 346;
         _loc1_.width = 130;
         _loc1_.height = 29;
         _loc1_.mouseEnabled = false;
         this._BarterScreen_CachedImage6 = _loc1_;
         BindingManager.executeBindings(this,"_BarterScreen_CachedImage6",this._BarterScreen_CachedImage6);
         return _loc1_;
      }
      
      public function ___BarterScreen_Canvas1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _BarterScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_BarterScreen_BorderedContainer1.borderSkin");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = characterModel.name;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BarterScreen_Label1.text");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("barter.items") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BarterScreen_Label2.text");
         result[3] = new Binding(this,function():Object
         {
            return Icons.ready;
         },null,"_BarterScreen_CachedImage1.source");
         result[4] = new Binding(this,function():Boolean
         {
            return model.iAmReady;
         },null,"_BarterScreen_CachedImage1.visible");
         result[5] = new Binding(this,function():Item
         {
            return model.myItem0;
         },null,"myItem0.item");
         result[6] = new Binding(this,function():Item
         {
            return model.myItem1;
         },null,"myItem1.item");
         result[7] = new Binding(this,function():Item
         {
            return model.myItem2;
         },null,"myItem2.item");
         result[8] = new Binding(this,function():Item
         {
            return model.myItem3;
         },null,"myItem3.item");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = CurrencyType.COPPER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"copper.type");
         result[10] = new Binding(this,function():uint
         {
            return model.myCopper;
         },null,"copper.value");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = CurrencyType.RUBIES;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"rubies.type");
         result[12] = new Binding(this,function():uint
         {
            return model.myRubies;
         },null,"rubies.value");
         result[13] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_BarterScreen_BorderedContainer2.borderSkin");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = model.opponentName;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BarterScreen_Label3.text");
         result[15] = new Binding(this,function():String
         {
            var _loc1_:* = getString("barter.items") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BarterScreen_Label4.text");
         result[16] = new Binding(this,function():Object
         {
            return Icons.ready;
         },null,"_BarterScreen_CachedImage2.source");
         result[17] = new Binding(this,function():Boolean
         {
            return model.opponentReady;
         },null,"_BarterScreen_CachedImage2.visible");
         result[18] = new Binding(this,function():Item
         {
            return model.opponentItem0;
         },null,"remoteItem0.item");
         result[19] = new Binding(this,function():Item
         {
            return model.opponentItem1;
         },null,"remoteItem1.item");
         result[20] = new Binding(this,function():Item
         {
            return model.opponentItem2;
         },null,"remoteItem2.item");
         result[21] = new Binding(this,function():Item
         {
            return model.opponentItem3;
         },null,"remoteItem3.item");
         result[22] = new Binding(this,function():String
         {
            var _loc1_:* = CurrencyType.COPPER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BarterScreen_MoneyRenderer1.type");
         result[23] = new Binding(this,function():uint
         {
            return model.opponentCopper;
         },null,"_BarterScreen_MoneyRenderer1.value");
         result[24] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_BarterScreen_MoneyRenderer1.color");
         result[25] = new Binding(this,function():String
         {
            var _loc1_:* = CurrencyType.RUBIES;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_BarterScreen_MoneyRenderer2.type");
         result[26] = new Binding(this,function():uint
         {
            return model.opponentRubies;
         },null,"_BarterScreen_MoneyRenderer2.value");
         result[27] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_BarterScreen_MoneyRenderer2.color");
         result[28] = new Binding(this,function():Object
         {
            return Icons.readySmall;
         },null,"readyButton.icon");
         result[29] = new Binding(this,function():String
         {
            var _loc1_:* = getString("accept");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"readyButton.label");
         result[30] = new Binding(this,function():String
         {
            var _loc1_:* = getString("barter.accept");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"readyButton.toolTip");
         result[31] = new Binding(this,function():Boolean
         {
            return model.waiting;
         },null,"_BarterScreen_Canvas2.visible");
         result[32] = new Binding(this,function():Object
         {
            return UIAssets.loading;
         },null,"_BarterScreen_CachedImage3.source");
         result[33] = new Binding(this,function():Object
         {
            return Configuration.getSmallAvatarUrl(characterModel.avatarImagePath);
         },null,"_BarterScreen_RoundImage1.source");
         result[34] = new Binding(this,function():Object
         {
            return Assets.roundFrame;
         },null,"_BarterScreen_CachedImage4.source");
         result[35] = new Binding(this,function():Object
         {
            return Configuration.getSmallAvatarUrl(model.opponentImage);
         },null,"_BarterScreen_RoundImage2.source");
         result[36] = new Binding(this,function():Object
         {
            return Assets.roundFrame;
         },null,"_BarterScreen_CachedImage5.source");
         result[37] = new Binding(this,function():Object
         {
            return Assets.barterItemGlow;
         },null,"_BarterScreen_CachedImage6.source");
         result[38] = new Binding(this,function():Boolean
         {
            return (myItem0.item != null || myItem1.item != null || myItem2.item != null || myItem3.item != null) && readyButton.enabled;
         },null,"_BarterScreen_CachedImage6.visible");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get copper() : MoneyEnter
      {
         return this._1354723047copper;
      }
      
      public function set copper(param1:MoneyEnter) : void
      {
         var _loc2_:Object = this._1354723047copper;
         if(_loc2_ !== param1)
         {
            this._1354723047copper = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"copper",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myItem0() : BarterItem
      {
         return this._1488753969myItem0;
      }
      
      public function set myItem0(param1:BarterItem) : void
      {
         var _loc2_:Object = this._1488753969myItem0;
         if(_loc2_ !== param1)
         {
            this._1488753969myItem0 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myItem0",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myItem1() : BarterItem
      {
         return this._1488753970myItem1;
      }
      
      public function set myItem1(param1:BarterItem) : void
      {
         var _loc2_:Object = this._1488753970myItem1;
         if(_loc2_ !== param1)
         {
            this._1488753970myItem1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myItem1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myItem2() : BarterItem
      {
         return this._1488753971myItem2;
      }
      
      public function set myItem2(param1:BarterItem) : void
      {
         var _loc2_:Object = this._1488753971myItem2;
         if(_loc2_ !== param1)
         {
            this._1488753971myItem2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myItem2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myItem3() : BarterItem
      {
         return this._1488753972myItem3;
      }
      
      public function set myItem3(param1:BarterItem) : void
      {
         var _loc2_:Object = this._1488753972myItem3;
         if(_loc2_ !== param1)
         {
            this._1488753972myItem3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myItem3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get readyButton() : Button1
      {
         return this._389159243readyButton;
      }
      
      public function set readyButton(param1:Button1) : void
      {
         var _loc2_:Object = this._389159243readyButton;
         if(_loc2_ !== param1)
         {
            this._389159243readyButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"readyButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get remoteItem0() : ItemRenderer
      {
         return this._2088879401remoteItem0;
      }
      
      public function set remoteItem0(param1:ItemRenderer) : void
      {
         var _loc2_:Object = this._2088879401remoteItem0;
         if(_loc2_ !== param1)
         {
            this._2088879401remoteItem0 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"remoteItem0",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get remoteItem1() : ItemRenderer
      {
         return this._2088879400remoteItem1;
      }
      
      public function set remoteItem1(param1:ItemRenderer) : void
      {
         var _loc2_:Object = this._2088879400remoteItem1;
         if(_loc2_ !== param1)
         {
            this._2088879400remoteItem1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"remoteItem1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get remoteItem2() : ItemRenderer
      {
         return this._2088879399remoteItem2;
      }
      
      public function set remoteItem2(param1:ItemRenderer) : void
      {
         var _loc2_:Object = this._2088879399remoteItem2;
         if(_loc2_ !== param1)
         {
            this._2088879399remoteItem2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"remoteItem2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get remoteItem3() : ItemRenderer
      {
         return this._2088879398remoteItem3;
      }
      
      public function set remoteItem3(param1:ItemRenderer) : void
      {
         var _loc2_:Object = this._2088879398remoteItem3;
         if(_loc2_ !== param1)
         {
            this._2088879398remoteItem3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"remoteItem3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rubies() : MoneyEnter
      {
         return this._920168456rubies;
      }
      
      public function set rubies(param1:MoneyEnter) : void
      {
         var _loc2_:Object = this._920168456rubies;
         if(_loc2_ !== param1)
         {
            this._920168456rubies = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rubies",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : BarterModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:BarterModel) : void
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

