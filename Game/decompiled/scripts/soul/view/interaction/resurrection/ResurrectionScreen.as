package soul.view.interaction.resurrection
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
   import mx.utils.StringUtil;
   import soul.controller.Interaction;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.SimpleUIEvent;
   import soul.model.common.InteractionType;
   import soul.model.interaction.resurrection.ResurrectionData;
   import soul.model.interaction.resurrection.ResurrectionType;
   import soul.model.item.Item;
   import soul.model.item.ItemClass;
   import soul.net.ServerLayer;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.assets.GradientLabel;
   import soul.view.common.BattleIcons;
   import soul.view.common.Currency;
   import soul.view.common.CurrencyType;
   import soul.view.common.Icons;
   import soul.view.common.MoneyRenderer;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.TextArea;
   import soul.view.ui.UIAssets;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class ResurrectionScreen extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _ResurrectionScreen_Button11:Button1;
      
      public var _ResurrectionScreen_Button14:Button1;
      
      public var _ResurrectionScreen_CachedImage1:CachedImage;
      
      public var _ResurrectionScreen_CachedImage2:CachedImage;
      
      public var _ResurrectionScreen_CachedImage3:CachedImage;
      
      public var _ResurrectionScreen_GradientLabel1:GradientLabel;
      
      public var _ResurrectionScreen_GradientLabel2:GradientLabel;
      
      public var _ResurrectionScreen_GradientLabel3:GradientLabel;
      
      public var _ResurrectionScreen_GradientLabel4:GradientLabel;
      
      public var _ResurrectionScreen_GradientLabel5:GradientLabel;
      
      public var _ResurrectionScreen_HBox1:HBox;
      
      public var _ResurrectionScreen_ItemRenderer1:ItemRenderer;
      
      public var _ResurrectionScreen_ItemRenderer4:ItemRenderer;
      
      public var _ResurrectionScreen_ItemRenderer5:ItemRenderer;
      
      public var _ResurrectionScreen_Label1:Label;
      
      public var _ResurrectionScreen_Label4:Label;
      
      public var _ResurrectionScreen_Label6:Label;
      
      private var _1639725452freeResurrectionPlace:Label;
      
      private var _1514583077itemButton:Button1;
      
      private var _2124141651itemsCost:Label;
      
      private var _2123958541itemsItem:ItemRenderer;
      
      private var _827790049itemsPerDay:Label;
      
      private var _107053lfg:BorderedContainer;
      
      private var _390600384potions:BorderedContainer;
      
      private var _2105047350resurrectionLFGDescription:TextArea;
      
      private var _805181086resurrectionPotionDescription:TextArea;
      
      private var _934847060rubyButton:Button1;
      
      private var _495140039rubyCost:MoneyRenderer;
      
      private var _495323149rubyItem:ItemRenderer;
      
      private var _548921415rubyPerDay:Label;
      
      private var _1969045496secLeft:Label;
      
      private var interval:int;
      
      private var tickInterval:int;
      
      private var timeToEnd:uint;
      
      private var _resData:ResurrectionData;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ResurrectionScreen()
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
         bindings = this._ResurrectionScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_resurrection_ResurrectionScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ResurrectionScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 380;
         this.height = 322;
         this.children = [this._ResurrectionScreen_VBox1_c(),this._ResurrectionScreen_BorderedContainer1_i(),this._ResurrectionScreen_BorderedContainer2_i()];
         this.addEventListener("creationComplete",this.___ResurrectionScreen_Canvas1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ResurrectionScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("youAreDead");
         var rubyItem:Item = new Item();
         rubyItem.templateId = Currency.RUBIES;
         rubyItem.imagePath = "money/rubies.png";
         rubyItem.itemClass = ItemClass.CLASS6;
         this.rubyItem.item = rubyItem;
         this.rubyPerDay.text = this.getString("resurrect.perDay") + ": " + this._resData.money.current + "/" + this._resData.money.total;
         this.rubyCost.value = this._resData.money.price;
         this.rubyButton.enabled = this._resData.money.enought && this._resData.money.total > this._resData.money.current;
         var itemsItem:Item = new Item();
         itemsItem.templateId = this._resData.item.templateId;
         itemsItem.imagePath = this._resData.item.imagePath;
         itemsItem.itemClass = ItemClass.CLASS6;
         this.itemsItem.item = itemsItem;
         this.itemsPerDay.text = this.getString("resurrect.perDay") + ": " + this._resData.item.current + "/" + this._resData.item.total;
         this.itemsCost.text = this.getString("resurrect.cost") + ": " + this._resData.item.count;
         this.itemButton.enabled = this._resData.item.enough && this._resData.item.total > this._resData.item.current;
         this.tickInterval = setInterval(this.tick,1000);
      }
      
      public function set resData(value:ResurrectionData) : void
      {
         var template:String = null;
         var locations:Array = null;
         var sector:String = null;
         this._resData = value;
         this.interval = setTimeout(this.close,value.timeout);
         this.timeToEnd = getTimer() + value.timeout;
         this.freeResurrectionPlace.text = this.getString(value.resurrectAtInstance ? "ressurect.atInstanceBegin" : "resurrect.atGraveyard");
         if(Boolean(value.potionLocations) && value.potionLocations.length > 0)
         {
            this.potions.visible = true;
            template = this.getString("resurrection.potions.description");
            locations = [];
            for each(sector in value.potionLocations)
            {
               locations.push(LocaleManager.getString(BundleName.SECTOR,sector));
            }
            this.resurrectionPotionDescription.htmlText = "<font color=\"#f59a38\">" + StringUtil.substitute(template,locations.join(", ")) + "</font>";
         }
         if(value.showLFG)
         {
            this.lfg.visible = true;
            this.resurrectionLFGDescription.htmlText = this.getString("resurrection.lfg.description");
         }
      }
      
      private function resurrectFree() : void
      {
         this.resurrect(ResurrectionType.GRAVEYARD);
      }
      
      private function resurrectRuby() : void
      {
         this.resurrect(ResurrectionType.MONEY);
      }
      
      private function resurrectItem() : void
      {
         this.resurrect(ResurrectionType.ITEMS);
      }
      
      private function resurrect(type:String) : void
      {
         ServerLayer.call("characterService","resurrect",this.result,null,type);
      }
      
      private function result(success:Boolean = false) : void
      {
         if(success)
         {
            this.close();
         }
      }
      
      private function close() : void
      {
         clearTimeout(this.interval);
         clearInterval(this.tickInterval);
         Interaction.hide(InteractionType.RESURRECTION);
      }
      
      private function tick() : void
      {
         var timeLeft:uint = Math.max(this.timeToEnd - getTimer(),0) / 1000;
         this.secLeft.text = StringUtil.substitute(LocaleManager.getString(BundleName.COMMON,"seconds"),timeLeft);
      }
      
      private function openLFG() : void
      {
         Interaction.show(InteractionType.LFG);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _ResurrectionScreen_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.padding = 12;
         _loc1_.gap = 10;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._ResurrectionScreen_GradientBox1_c(),this._ResurrectionScreen_GradientLabel1_i(),this._ResurrectionScreen_HBox2_c(),this._ResurrectionScreen_HBox4_c(),this._ResurrectionScreen_HBox7_c()];
         return _loc1_;
      }
      
      private function _ResurrectionScreen_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.bgPaddingLeft = -10;
         _loc1_.percentWidth = 100;
         _loc1_.height = 36;
         _loc1_.children = [this._ResurrectionScreen_HBox1_i()];
         return _loc1_;
      }
      
      private function _ResurrectionScreen_HBox1_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.verticalCenter = 0;
         _loc1_.verticalAlign = "middle";
         _loc1_.gap = 5;
         _loc1_.children = [this._ResurrectionScreen_Label1_i(),this._ResurrectionScreen_CachedImage1_i(),this._ResurrectionScreen_CachedImage2_i(),this._ResurrectionScreen_CachedImage3_i()];
         this._ResurrectionScreen_HBox1 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_HBox1",this._ResurrectionScreen_HBox1);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         _loc1_.fontSize = 12;
         this._ResurrectionScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_Label1",this._ResurrectionScreen_Label1);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._ResurrectionScreen_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_CachedImage1",this._ResurrectionScreen_CachedImage1);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._ResurrectionScreen_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_CachedImage2",this._ResurrectionScreen_CachedImage2);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._ResurrectionScreen_CachedImage3 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_CachedImage3",this._ResurrectionScreen_CachedImage3);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_GradientLabel1_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.bgPaddingLeft = -10;
         _loc1_.fontSize = 12;
         _loc1_.verticalAlign = "middle";
         this._ResurrectionScreen_GradientLabel1 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_GradientLabel1",this._ResurrectionScreen_GradientLabel1);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 10;
         _loc1_.children = [this._ResurrectionScreen_ItemRenderer1_i(),this._ResurrectionScreen_VBox2_c()];
         _loc1_.addEventListener("click",this.___ResurrectionScreen_HBox2_click);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_ItemRenderer1_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         _loc1_.dropsShadow = false;
         this._ResurrectionScreen_ItemRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_ItemRenderer1",this._ResurrectionScreen_ItemRenderer1);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._ResurrectionScreen_GradientBox2_c(),this._ResurrectionScreen_HBox3_c()];
         return _loc1_;
      }
      
      private function _ResurrectionScreen_GradientBox2_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.bgPaddingLeft = -10;
         _loc1_.children = [this._ResurrectionScreen_Label2_i(),this._ResurrectionScreen_Label3_i()];
         return _loc1_;
      }
      
      private function _ResurrectionScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.verticalCenter = 0;
         _loc1_.bold = true;
         _loc1_.fontSize = 12;
         this.freeResurrectionPlace = _loc1_;
         BindingManager.executeBindings(this,"freeResurrectionPlace",this.freeResurrectionPlace);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.verticalCenter = 0;
         _loc1_.right = 0;
         _loc1_.bold = true;
         _loc1_.fontSize = 12;
         this.secLeft = _loc1_;
         BindingManager.executeBindings(this,"secLeft",this.secLeft);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_HBox3_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalAlign = "bottom";
         _loc1_.children = [this._ResurrectionScreen_Label4_i(),this._ResurrectionScreen_Component1_c(),this._ResurrectionScreen_Button11_i()];
         return _loc1_;
      }
      
      private function _ResurrectionScreen_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         this._ResurrectionScreen_Label4 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_Label4",this._ResurrectionScreen_Label4);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _ResurrectionScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         this._ResurrectionScreen_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_Button11",this._ResurrectionScreen_Button11);
         return _loc1_;
      }
      
      public function ___ResurrectionScreen_HBox2_click(event:MouseEvent) : void
      {
         this.resurrectFree();
      }
      
      private function _ResurrectionScreen_HBox4_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 10;
         _loc1_.children = [this._ResurrectionScreen_ItemRenderer2_i(),this._ResurrectionScreen_VBox3_c()];
         _loc1_.addEventListener("click",this.___ResurrectionScreen_HBox4_click);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_ItemRenderer2_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         this.rubyItem = _loc1_;
         BindingManager.executeBindings(this,"rubyItem",this.rubyItem);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_VBox3_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._ResurrectionScreen_GradientLabel2_i(),this._ResurrectionScreen_HBox5_c()];
         return _loc1_;
      }
      
      private function _ResurrectionScreen_GradientLabel2_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.bold = true;
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.bgPaddingLeft = -10;
         _loc1_.verticalAlign = "middle";
         this._ResurrectionScreen_GradientLabel2 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_GradientLabel2",this._ResurrectionScreen_GradientLabel2);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_HBox5_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalAlign = "bottom";
         _loc1_.children = [this._ResurrectionScreen_VBox4_c(),this._ResurrectionScreen_Component2_c(),this._ResurrectionScreen_Button12_i()];
         return _loc1_;
      }
      
      private function _ResurrectionScreen_VBox4_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.children = [this._ResurrectionScreen_Label5_i(),this._ResurrectionScreen_HBox6_c()];
         return _loc1_;
      }
      
      private function _ResurrectionScreen_Label5_i() : Label
      {
         var _loc1_:Label = new Label();
         this.rubyPerDay = _loc1_;
         BindingManager.executeBindings(this,"rubyPerDay",this.rubyPerDay);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_HBox6_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.children = [this._ResurrectionScreen_Label6_i(),this._ResurrectionScreen_MoneyRenderer1_i()];
         return _loc1_;
      }
      
      private function _ResurrectionScreen_Label6_i() : Label
      {
         var _loc1_:Label = new Label();
         this._ResurrectionScreen_Label6 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_Label6",this._ResurrectionScreen_Label6);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_MoneyRenderer1_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         this.rubyCost = _loc1_;
         BindingManager.executeBindings(this,"rubyCost",this.rubyCost);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_Component2_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _ResurrectionScreen_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         this.rubyButton = _loc1_;
         BindingManager.executeBindings(this,"rubyButton",this.rubyButton);
         return _loc1_;
      }
      
      public function ___ResurrectionScreen_HBox4_click(event:MouseEvent) : void
      {
         this.resurrectRuby();
      }
      
      private function _ResurrectionScreen_HBox7_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 10;
         _loc1_.children = [this._ResurrectionScreen_ItemRenderer3_i(),this._ResurrectionScreen_VBox5_c()];
         _loc1_.addEventListener("click",this.___ResurrectionScreen_HBox7_click);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_ItemRenderer3_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         this.itemsItem = _loc1_;
         BindingManager.executeBindings(this,"itemsItem",this.itemsItem);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_VBox5_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._ResurrectionScreen_GradientLabel3_i(),this._ResurrectionScreen_HBox8_c()];
         return _loc1_;
      }
      
      private function _ResurrectionScreen_GradientLabel3_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.bold = true;
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.bgPaddingLeft = -10;
         _loc1_.verticalAlign = "middle";
         this._ResurrectionScreen_GradientLabel3 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_GradientLabel3",this._ResurrectionScreen_GradientLabel3);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_HBox8_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalAlign = "bottom";
         _loc1_.children = [this._ResurrectionScreen_VBox6_c(),this._ResurrectionScreen_Component3_c(),this._ResurrectionScreen_Button13_i()];
         return _loc1_;
      }
      
      private function _ResurrectionScreen_VBox6_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.children = [this._ResurrectionScreen_Label7_i(),this._ResurrectionScreen_Label8_i()];
         return _loc1_;
      }
      
      private function _ResurrectionScreen_Label7_i() : Label
      {
         var _loc1_:Label = new Label();
         this.itemsPerDay = _loc1_;
         BindingManager.executeBindings(this,"itemsPerDay",this.itemsPerDay);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_Label8_i() : Label
      {
         var _loc1_:Label = new Label();
         this.itemsCost = _loc1_;
         BindingManager.executeBindings(this,"itemsCost",this.itemsCost);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_Component3_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _ResurrectionScreen_Button13_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         this.itemButton = _loc1_;
         BindingManager.executeBindings(this,"itemButton",this.itemButton);
         return _loc1_;
      }
      
      public function ___ResurrectionScreen_HBox7_click(event:MouseEvent) : void
      {
         this.resurrectItem();
      }
      
      private function _ResurrectionScreen_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.x = 380;
         _loc1_.width = 304;
         _loc1_.height = 104;
         _loc1_.direction = "vertical";
         _loc1_.padding = 3;
         _loc1_.visible = false;
         _loc1_.children = [this._ResurrectionScreen_GradientLabel4_i(),this._ResurrectionScreen_HBox9_c()];
         this.potions = _loc1_;
         BindingManager.executeBindings(this,"potions",this.potions);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_GradientLabel4_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.align = "center";
         _loc1_.percentWidth = 100;
         _loc1_.height = 18;
         _loc1_.bold = true;
         this._ResurrectionScreen_GradientLabel4 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_GradientLabel4",this._ResurrectionScreen_GradientLabel4);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_HBox9_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.padding = 9;
         _loc1_.gap = 5;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._ResurrectionScreen_ItemRenderer4_i(),this._ResurrectionScreen_TextArea1_i()];
         return _loc1_;
      }
      
      private function _ResurrectionScreen_ItemRenderer4_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         _loc1_.width = 51;
         _loc1_.height = 51;
         _loc1_.dropsShadow = false;
         this._ResurrectionScreen_ItemRenderer4 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_ItemRenderer4",this._ResurrectionScreen_ItemRenderer4);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_TextArea1_i() : TextArea
      {
         var _loc1_:TextArea = new TextArea();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         this.resurrectionPotionDescription = _loc1_;
         BindingManager.executeBindings(this,"resurrectionPotionDescription",this.resurrectionPotionDescription);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_BorderedContainer2_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.x = 380;
         _loc1_.y = 108;
         _loc1_.width = 304;
         _loc1_.height = 104;
         _loc1_.direction = "vertical";
         _loc1_.padding = 3;
         _loc1_.visible = false;
         _loc1_.children = [this._ResurrectionScreen_GradientLabel5_i(),this._ResurrectionScreen_HBox10_c()];
         this.lfg = _loc1_;
         BindingManager.executeBindings(this,"lfg",this.lfg);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_GradientLabel5_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.align = "center";
         _loc1_.percentWidth = 100;
         _loc1_.height = 18;
         _loc1_.bold = true;
         this._ResurrectionScreen_GradientLabel5 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_GradientLabel5",this._ResurrectionScreen_GradientLabel5);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_HBox10_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.padding = 9;
         _loc1_.gap = 5;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._ResurrectionScreen_ItemRenderer5_i(),this._ResurrectionScreen_VBox7_c()];
         return _loc1_;
      }
      
      private function _ResurrectionScreen_ItemRenderer5_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         _loc1_.width = 51;
         _loc1_.height = 51;
         _loc1_.dropsShadow = false;
         this._ResurrectionScreen_ItemRenderer5 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_ItemRenderer5",this._ResurrectionScreen_ItemRenderer5);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_VBox7_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.children = [this._ResurrectionScreen_TextArea2_i(),this._ResurrectionScreen_Button14_i()];
         return _loc1_;
      }
      
      private function _ResurrectionScreen_TextArea2_i() : TextArea
      {
         var _loc1_:TextArea = new TextArea();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         this.resurrectionLFGDescription = _loc1_;
         BindingManager.executeBindings(this,"resurrectionLFGDescription",this.resurrectionLFGDescription);
         return _loc1_;
      }
      
      private function _ResurrectionScreen_Button14_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.addEventListener("click",this.___ResurrectionScreen_Button14_click);
         this._ResurrectionScreen_Button14 = _loc1_;
         BindingManager.executeBindings(this,"_ResurrectionScreen_Button14",this._ResurrectionScreen_Button14);
         return _loc1_;
      }
      
      public function ___ResurrectionScreen_Button14_click(event:MouseEvent) : void
      {
         this.openLFG();
      }
      
      public function ___ResurrectionScreen_Canvas1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _ResurrectionScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = getString("resurrection.penalty.desciption");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ResurrectionScreen_HBox1.toolTip");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = getString("resurrection.penalty");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ResurrectionScreen_Label1.text");
         result[2] = new Binding(this,function():uint
         {
            return Colors.LABEL;
         },null,"_ResurrectionScreen_Label1.color");
         result[3] = new Binding(this,function():Object
         {
            return BattleIcons.melee;
         },null,"_ResurrectionScreen_CachedImage1.source");
         result[4] = new Binding(this,function():Object
         {
            return BattleIcons.ranged;
         },null,"_ResurrectionScreen_CachedImage2.source");
         result[5] = new Binding(this,function():Object
         {
            return BattleIcons.anticrit;
         },null,"_ResurrectionScreen_CachedImage3.source");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = getString("chooseResurrectionPlace");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ResurrectionScreen_GradientLabel1.text");
         result[7] = new Binding(this,function():uint
         {
            return Colors.LABEL;
         },null,"_ResurrectionScreen_GradientLabel1.color");
         result[8] = new Binding(this,function():Object
         {
            return Assets.graveyard;
         },null,"_ResurrectionScreen_ItemRenderer1.source");
         result[9] = new Binding(this,function():Object
         {
            return Assets.iconGlow;
         },null,"_ResurrectionScreen_ItemRenderer1.glowSource");
         result[10] = new Binding(this,function():uint
         {
            return Colors.GOLD_DARK;
         },null,"freeResurrectionPlace.color");
         result[11] = new Binding(this,function():uint
         {
            return Colors.GOLD_DARK;
         },null,"secLeft.color");
         result[12] = new Binding(this,function():uint
         {
            return Colors.LABEL;
         },null,"_ResurrectionScreen_Label4.color");
         result[13] = new Binding(this,function():String
         {
            var _loc1_:* = getString("resurrect.free");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ResurrectionScreen_Label4.text");
         result[14] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_ResurrectionScreen_Button11.icon");
         result[15] = new Binding(this,function():Object
         {
            return Assets.iconGlow;
         },null,"rubyItem.glowSource");
         result[16] = new Binding(this,function():String
         {
            var _loc1_:* = getString("resurrect.atPlace");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ResurrectionScreen_GradientLabel2.text");
         result[17] = new Binding(this,function():uint
         {
            return Colors.GOLD_DARK;
         },null,"_ResurrectionScreen_GradientLabel2.color");
         result[18] = new Binding(this,function():uint
         {
            return Colors.LABEL;
         },null,"rubyPerDay.color");
         result[19] = new Binding(this,function():uint
         {
            return Colors.LABEL;
         },null,"_ResurrectionScreen_Label6.color");
         result[20] = new Binding(this,function():String
         {
            var _loc1_:* = getString("resurrect.cost") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ResurrectionScreen_Label6.text");
         result[21] = new Binding(this,function():String
         {
            var _loc1_:* = CurrencyType.RUBIES;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"rubyCost.type");
         result[22] = new Binding(this,function():uint
         {
            return Colors.LABEL;
         },null,"rubyCost.color");
         result[23] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"rubyButton.icon");
         result[24] = new Binding(this,function():Object
         {
            return Assets.iconGlow;
         },null,"itemsItem.glowSource");
         result[25] = new Binding(this,function():String
         {
            var _loc1_:* = getString("resurrect.atPlace");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ResurrectionScreen_GradientLabel3.text");
         result[26] = new Binding(this,function():uint
         {
            return Colors.GOLD_DARK;
         },null,"_ResurrectionScreen_GradientLabel3.color");
         result[27] = new Binding(this,function():uint
         {
            return Colors.LABEL;
         },null,"itemsPerDay.color");
         result[28] = new Binding(this,function():uint
         {
            return Colors.LABEL;
         },null,"itemsCost.color");
         result[29] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"itemButton.icon");
         result[30] = new Binding(this,function():Object
         {
            return UIAssets.frame;
         },null,"potions.borderSkin");
         result[31] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"potions.backgroundImage");
         result[32] = new Binding(this,function():String
         {
            var _loc1_:* = getString("resurrection.potions.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ResurrectionScreen_GradientLabel4.text");
         result[33] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ResurrectionScreen_GradientLabel4.color");
         result[34] = new Binding(this,function():Object
         {
            return Assets.potion;
         },null,"_ResurrectionScreen_ItemRenderer4.source");
         result[35] = new Binding(this,function():Object
         {
            return Assets.iconGlow;
         },null,"_ResurrectionScreen_ItemRenderer4.glowSource");
         result[36] = new Binding(this,function():Object
         {
            return UIAssets.frame;
         },null,"lfg.borderSkin");
         result[37] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"lfg.backgroundImage");
         result[38] = new Binding(this,function():String
         {
            var _loc1_:* = getString("resurrection.lfg.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ResurrectionScreen_GradientLabel5.text");
         result[39] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ResurrectionScreen_GradientLabel5.color");
         result[40] = new Binding(this,function():Object
         {
            return Assets.instance;
         },null,"_ResurrectionScreen_ItemRenderer5.source");
         result[41] = new Binding(this,function():Object
         {
            return Assets.iconGlow;
         },null,"_ResurrectionScreen_ItemRenderer5.glowSource");
         result[42] = new Binding(this,function():String
         {
            var _loc1_:* = getString("lfg.title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ResurrectionScreen_Button14.label");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get freeResurrectionPlace() : Label
      {
         return this._1639725452freeResurrectionPlace;
      }
      
      public function set freeResurrectionPlace(param1:Label) : void
      {
         var _loc2_:Object = this._1639725452freeResurrectionPlace;
         if(_loc2_ !== param1)
         {
            this._1639725452freeResurrectionPlace = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"freeResurrectionPlace",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get itemButton() : Button1
      {
         return this._1514583077itemButton;
      }
      
      public function set itemButton(param1:Button1) : void
      {
         var _loc2_:Object = this._1514583077itemButton;
         if(_loc2_ !== param1)
         {
            this._1514583077itemButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get itemsCost() : Label
      {
         return this._2124141651itemsCost;
      }
      
      public function set itemsCost(param1:Label) : void
      {
         var _loc2_:Object = this._2124141651itemsCost;
         if(_loc2_ !== param1)
         {
            this._2124141651itemsCost = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemsCost",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get itemsItem() : ItemRenderer
      {
         return this._2123958541itemsItem;
      }
      
      public function set itemsItem(param1:ItemRenderer) : void
      {
         var _loc2_:Object = this._2123958541itemsItem;
         if(_loc2_ !== param1)
         {
            this._2123958541itemsItem = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemsItem",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get itemsPerDay() : Label
      {
         return this._827790049itemsPerDay;
      }
      
      public function set itemsPerDay(param1:Label) : void
      {
         var _loc2_:Object = this._827790049itemsPerDay;
         if(_loc2_ !== param1)
         {
            this._827790049itemsPerDay = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemsPerDay",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lfg() : BorderedContainer
      {
         return this._107053lfg;
      }
      
      public function set lfg(param1:BorderedContainer) : void
      {
         var _loc2_:Object = this._107053lfg;
         if(_loc2_ !== param1)
         {
            this._107053lfg = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lfg",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get potions() : BorderedContainer
      {
         return this._390600384potions;
      }
      
      public function set potions(param1:BorderedContainer) : void
      {
         var _loc2_:Object = this._390600384potions;
         if(_loc2_ !== param1)
         {
            this._390600384potions = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"potions",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get resurrectionLFGDescription() : TextArea
      {
         return this._2105047350resurrectionLFGDescription;
      }
      
      public function set resurrectionLFGDescription(param1:TextArea) : void
      {
         var _loc2_:Object = this._2105047350resurrectionLFGDescription;
         if(_loc2_ !== param1)
         {
            this._2105047350resurrectionLFGDescription = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"resurrectionLFGDescription",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get resurrectionPotionDescription() : TextArea
      {
         return this._805181086resurrectionPotionDescription;
      }
      
      public function set resurrectionPotionDescription(param1:TextArea) : void
      {
         var _loc2_:Object = this._805181086resurrectionPotionDescription;
         if(_loc2_ !== param1)
         {
            this._805181086resurrectionPotionDescription = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"resurrectionPotionDescription",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rubyButton() : Button1
      {
         return this._934847060rubyButton;
      }
      
      public function set rubyButton(param1:Button1) : void
      {
         var _loc2_:Object = this._934847060rubyButton;
         if(_loc2_ !== param1)
         {
            this._934847060rubyButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rubyButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rubyCost() : MoneyRenderer
      {
         return this._495140039rubyCost;
      }
      
      public function set rubyCost(param1:MoneyRenderer) : void
      {
         var _loc2_:Object = this._495140039rubyCost;
         if(_loc2_ !== param1)
         {
            this._495140039rubyCost = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rubyCost",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rubyItem() : ItemRenderer
      {
         return this._495323149rubyItem;
      }
      
      public function set rubyItem(param1:ItemRenderer) : void
      {
         var _loc2_:Object = this._495323149rubyItem;
         if(_loc2_ !== param1)
         {
            this._495323149rubyItem = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rubyItem",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rubyPerDay() : Label
      {
         return this._548921415rubyPerDay;
      }
      
      public function set rubyPerDay(param1:Label) : void
      {
         var _loc2_:Object = this._548921415rubyPerDay;
         if(_loc2_ !== param1)
         {
            this._548921415rubyPerDay = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rubyPerDay",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get secLeft() : Label
      {
         return this._1969045496secLeft;
      }
      
      public function set secLeft(param1:Label) : void
      {
         var _loc2_:Object = this._1969045496secLeft;
         if(_loc2_ !== param1)
         {
            this._1969045496secLeft = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"secLeft",_loc2_,param1));
            }
         }
      }
   }
}

