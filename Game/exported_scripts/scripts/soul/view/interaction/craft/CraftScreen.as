package soul.view.interaction.craft
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
   import soul.event.CraftEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.interaction.craft.CraftModel;
   import soul.model.interaction.craft.Recipe;
   import soul.model.inventory.InventoryModel;
   import soul.model.item.Item;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.popups.InteractionWindow;
   import soul.view.rtm.CastBar;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   import soul.view.ui.Input;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class CraftScreen extends HBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _CraftScreen_BorderedContainer1:BorderedContainer;
      
      public var _CraftScreen_BorderedContainer2:BorderedContainer;
      
      public var _CraftScreen_Button11:Button1;
      
      public var _CraftScreen_Button12:Button1;
      
      public var _CraftScreen_Button13:Button1;
      
      public var _CraftScreen_Button14:Button1;
      
      public var _CraftScreen_ComponentsRenderer1:ComponentsRenderer;
      
      public var _CraftScreen_ItemRenderer1:ItemRenderer;
      
      public var _CraftScreen_Label1:Label;
      
      public var _CraftScreen_Label2:Label;
      
      public var _CraftScreen_Label3:Label;
      
      public var _CraftScreen_VBox2:VBox;
      
      private var _555306068castBar:CastBar;
      
      private var _94851343count:Input;
      
      private var _3322014list:RecipeList;
      
      private var _104069929model:CraftModel;
      
      public var inventoryModel:InventoryModel;
      
      private var _1664373938craftInProgress:Boolean;
      
      private var _2079904826availableCount:uint;
      
      private var _1817809929selectedRecipe:Recipe;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CraftScreen()
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
         bindings = this._CraftScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_craft_CraftScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return CraftScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 600;
         this.height = 400;
         this.padding = 9;
         this.gap = 5;
         this.children = [this._CraftScreen_VBox1_c(),this._CraftScreen_BorderedContainer2_i()];
         this.addEventListener("creationComplete",this.___CraftScreen_HBox1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         CraftScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = LocaleManager.getString(BundleName.INTERFACE,"craft.title");
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         this.model.addEventListener(CraftEvent.CRAFT_STARTED,this.craftStarted);
         this.model.addEventListener(CraftEvent.CRAFT_CANCELED,this.craftCanceled);
         this.model.addEventListener(CraftEvent.CRAFT_FINISHED,this.craftFinished);
         this.onCountChange();
      }
      
      private function removed(e:Event) : void
      {
         this.model.removeEventListener(CraftEvent.CRAFT_STARTED,this.craftStarted);
         this.model.removeEventListener(CraftEvent.CRAFT_CANCELED,this.craftCanceled);
         this.model.removeEventListener(CraftEvent.CRAFT_FINISHED,this.craftFinished);
      }
      
      private function selectedItemChanged() : void
      {
         var recipe:Recipe = this.list.selectedItem as Recipe;
         this.selectedRecipe = recipe;
         this.onCountChange();
      }
      
      private function decrease() : void
      {
         this.count.text = String(uint(this.count.text) - 1);
         this.onCountChange();
      }
      
      private function increase() : void
      {
         this.count.text = String(uint(this.count.text) + 1);
         this.onCountChange();
      }
      
      private function onCountChange() : void
      {
         if(!this.selectedRecipe)
         {
            return;
         }
         var count:int = int(this.count.text);
         if(count < 1)
         {
            count = 1;
         }
         if(count > this.selectedRecipe.availableCount)
         {
            count = int(this.selectedRecipe.availableCount);
         }
         this.count.text = String(count);
      }
      
      private function craftAll() : void
      {
         if(!this.selectedRecipe)
         {
            return;
         }
         this.count.text = String(this.selectedRecipe.availableCount);
         this.craft();
      }
      
      private function craftOrStop() : void
      {
         if(this.model.craftInProgress)
         {
            this.stopCraft();
         }
         else
         {
            this.craft();
         }
      }
      
      private function craft() : void
      {
         if(!this.selectedRecipe)
         {
            return;
         }
         this.onCountChange();
         this.model.iterationsLeft = uint(this.count.text);
         this.model.recipeCrafting = this.selectedRecipe;
         if(this.model.iterationsLeft < 1 || !this.model.recipeCrafting)
         {
            return;
         }
         this.craftInProgress = true;
         var e:CraftEvent = new CraftEvent(CraftEvent.CRAFT);
         this.model.dispatchEvent(e);
      }
      
      private function stopCraft() : void
      {
         var e:CraftEvent = new CraftEvent(CraftEvent.CANCEL);
         this.model.dispatchEvent(e);
      }
      
      protected function craftStarted(e:CraftEvent) : void
      {
         this.castBar.time = uint(e.time);
      }
      
      protected function craftCanceled(e:CraftEvent) : void
      {
         this.craftInProgress = false;
         this.castBar.time = 0;
         this.craftInProgress = false;
      }
      
      protected function craftFinished(e:CraftEvent) : void
      {
         this.onCountChange();
         this.castBar.time = 0;
         this.craftInProgress = false;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _CraftScreen_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 50;
         _loc1_.percentHeight = 100;
         _loc1_.children = [this._CraftScreen_Label1_i(),this._CraftScreen_BorderedContainer1_i()];
         return _loc1_;
      }
      
      private function _CraftScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.height = 40;
         _loc1_.fontSize = 20;
         _loc1_.multiline = true;
         _loc1_.align = "center";
         this._CraftScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_CraftScreen_Label1",this._CraftScreen_Label1);
         return _loc1_;
      }
      
      private function _CraftScreen_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.padding = 3;
         _loc1_.children = [this._CraftScreen_RecipeList1_i()];
         this._CraftScreen_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_CraftScreen_BorderedContainer1",this._CraftScreen_BorderedContainer1);
         return _loc1_;
      }
      
      private function _CraftScreen_RecipeList1_i() : RecipeList
      {
         var _loc1_:RecipeList = new RecipeList();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "on";
         _loc1_.addEventListener("selectedItemChanged",this.__list_selectedItemChanged);
         this.list = _loc1_;
         BindingManager.executeBindings(this,"list",this.list);
         return _loc1_;
      }
      
      public function __list_selectedItemChanged(event:Event) : void
      {
         this.selectedItemChanged();
      }
      
      private function _CraftScreen_BorderedContainer2_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 50;
         _loc1_.gap = 5;
         _loc1_.padding = 9;
         _loc1_.direction = "vertical";
         _loc1_.horizontalAlign = "center";
         _loc1_.children = [this._CraftScreen_VBox2_i(),this._CraftScreen_CastBar1_i(),this._CraftScreen_HBox3_c()];
         this._CraftScreen_BorderedContainer2 = _loc1_;
         BindingManager.executeBindings(this,"_CraftScreen_BorderedContainer2",this._CraftScreen_BorderedContainer2);
         return _loc1_;
      }
      
      private function _CraftScreen_VBox2_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.backgroundAlpha = 0.2;
         _loc1_.gap = 3;
         _loc1_.children = [this._CraftScreen_HBox2_c(),this._CraftScreen_Component1_c(),this._CraftScreen_Label3_i(),this._CraftScreen_ScrollBase1_c()];
         this._CraftScreen_VBox2 = _loc1_;
         BindingManager.executeBindings(this,"_CraftScreen_VBox2",this._CraftScreen_VBox2);
         return _loc1_;
      }
      
      private function _CraftScreen_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.children = [this._CraftScreen_ItemRenderer1_i(),this._CraftScreen_Label2_i()];
         return _loc1_;
      }
      
      private function _CraftScreen_ItemRenderer1_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         this._CraftScreen_ItemRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_CraftScreen_ItemRenderer1",this._CraftScreen_ItemRenderer1);
         return _loc1_;
      }
      
      private function _CraftScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         this._CraftScreen_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_CraftScreen_Label2",this._CraftScreen_Label2);
         return _loc1_;
      }
      
      private function _CraftScreen_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.backgroundColor = 0;
         _loc1_.height = 1;
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _CraftScreen_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         this._CraftScreen_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_CraftScreen_Label3",this._CraftScreen_Label3);
         return _loc1_;
      }
      
      private function _CraftScreen_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._CraftScreen_ComponentsRenderer1_i()];
         return _loc1_;
      }
      
      private function _CraftScreen_ComponentsRenderer1_i() : ComponentsRenderer
      {
         var _loc1_:ComponentsRenderer = new ComponentsRenderer();
         this._CraftScreen_ComponentsRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_CraftScreen_ComponentsRenderer1",this._CraftScreen_ComponentsRenderer1);
         return _loc1_;
      }
      
      private function _CraftScreen_CastBar1_i() : CastBar
      {
         var _loc1_:CastBar = new CastBar();
         this.castBar = _loc1_;
         BindingManager.executeBindings(this,"castBar",this.castBar);
         return _loc1_;
      }
      
      private function _CraftScreen_HBox3_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.verticalAlign = "middle";
         _loc1_.gap = 1;
         _loc1_.children = [this._CraftScreen_Button11_i(),this._CraftScreen_Button12_i(),this._CraftScreen_Input1_i(),this._CraftScreen_Button13_i(),this._CraftScreen_Button14_i()];
         return _loc1_;
      }
      
      private function _CraftScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.percentWidth = 100;
         _loc1_.addEventListener("click",this.___CraftScreen_Button11_click);
         this._CraftScreen_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_CraftScreen_Button11",this._CraftScreen_Button11);
         return _loc1_;
      }
      
      public function ___CraftScreen_Button11_click(event:MouseEvent) : void
      {
         this.craftAll();
      }
      
      private function _CraftScreen_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.label = "<";
         _loc1_.width = 14;
         _loc1_.addEventListener("click",this.___CraftScreen_Button12_click);
         this._CraftScreen_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_CraftScreen_Button12",this._CraftScreen_Button12);
         return _loc1_;
      }
      
      public function ___CraftScreen_Button12_click(event:MouseEvent) : void
      {
         this.decrease();
      }
      
      private function _CraftScreen_Input1_i() : Input
      {
         var _loc1_:Input = new Input();
         _loc1_.restrict = "0-9";
         _loc1_.maxChars = 3;
         _loc1_.width = 30;
         _loc1_.percentHeight = 100;
         _loc1_.fontSize = 12;
         _loc1_.align = "center";
         _loc1_.verticalAlign = "middle";
         _loc1_.addEventListener("change",this.__count_change);
         this.count = _loc1_;
         BindingManager.executeBindings(this,"count",this.count);
         return _loc1_;
      }
      
      public function __count_change(event:Event) : void
      {
         this.onCountChange();
      }
      
      private function _CraftScreen_Button13_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.label = ">";
         _loc1_.width = 14;
         _loc1_.addEventListener("click",this.___CraftScreen_Button13_click);
         this._CraftScreen_Button13 = _loc1_;
         BindingManager.executeBindings(this,"_CraftScreen_Button13",this._CraftScreen_Button13);
         return _loc1_;
      }
      
      public function ___CraftScreen_Button13_click(event:MouseEvent) : void
      {
         this.increase();
      }
      
      private function _CraftScreen_Button14_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.percentWidth = 100;
         _loc1_.addEventListener("click",this.___CraftScreen_Button14_click);
         this._CraftScreen_Button14 = _loc1_;
         BindingManager.executeBindings(this,"_CraftScreen_Button14",this._CraftScreen_Button14);
         return _loc1_;
      }
      
      public function ___CraftScreen_Button14_click(event:MouseEvent) : void
      {
         this.craftOrStop();
      }
      
      public function ___CraftScreen_HBox1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _CraftScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():*
         {
            return selectedRecipe.availableCount;
         },function(param1:*):void
         {
            availableCount = param1;
         },"availableCount");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = getString("craft." + model.craftType);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CraftScreen_Label1.htmlText");
         result[2] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_CraftScreen_BorderedContainer1.borderSkin");
         result[3] = new Binding(this,function():Object
         {
            return model.recipes;
         },null,"list.dataProvider");
         result[4] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_CraftScreen_BorderedContainer2.borderSkin");
         result[5] = new Binding(this,function():Boolean
         {
            return selectedRecipe != null;
         },null,"_CraftScreen_VBox2.visible");
         result[6] = new Binding(this,function():Item
         {
            return selectedRecipe.realItem;
         },null,"_CraftScreen_ItemRenderer1.item");
         result[7] = new Binding(this,function():int
         {
            return selectedRecipe.count;
         },null,"_CraftScreen_ItemRenderer1.count");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = LocaleManager.getItemName(selectedRecipe.item.templateId);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CraftScreen_Label2.text");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = getString("craft.components") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CraftScreen_Label3.text");
         result[10] = new Binding(this,function():Array
         {
            var _loc1_:* = selectedRecipe.components;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_CraftScreen_ComponentsRenderer1.dataProvider");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = getString("craft.all") + " (" + availableCount + ")";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CraftScreen_Button11.label");
         result[12] = new Binding(this,function():Boolean
         {
            return availableCount > 0 && !craftInProgress;
         },null,"_CraftScreen_Button11.enabled");
         result[13] = new Binding(this,function():Boolean
         {
            return int(count.text) > 1;
         },null,"_CraftScreen_Button12.enabled");
         result[14] = new Binding(this,function():Object
         {
            return Assets.chatInput;
         },null,"count.borderSkin");
         result[15] = new Binding(this,function():Boolean
         {
            return selectedRecipe != null;
         },null,"count.enabled");
         result[16] = new Binding(this,function():Boolean
         {
            return int(count.text) < availableCount;
         },null,"_CraftScreen_Button13.enabled");
         result[17] = new Binding(this,function():String
         {
            var _loc1_:* = getString(model.craftInProgress ? "craft.cancel" : "craft.create");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_CraftScreen_Button14.label");
         result[18] = new Binding(this,function():Boolean
         {
            return availableCount > 0 && !craftInProgress || model.craftInProgress;
         },null,"_CraftScreen_Button14.enabled");
         return result;
      }
      
      private function _CraftScreen_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         this.availableCount = this.selectedRecipe.availableCount;
      }
      
      [Bindable(event="propertyChange")]
      public function get castBar() : CastBar
      {
         return this._555306068castBar;
      }
      
      public function set castBar(param1:CastBar) : void
      {
         var _loc2_:Object = this._555306068castBar;
         if(_loc2_ !== param1)
         {
            this._555306068castBar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"castBar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get count() : Input
      {
         return this._94851343count;
      }
      
      public function set count(param1:Input) : void
      {
         var _loc2_:Object = this._94851343count;
         if(_loc2_ !== param1)
         {
            this._94851343count = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"count",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get list() : RecipeList
      {
         return this._3322014list;
      }
      
      public function set list(param1:RecipeList) : void
      {
         var _loc2_:Object = this._3322014list;
         if(_loc2_ !== param1)
         {
            this._3322014list = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"list",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : CraftModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:CraftModel) : void
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
      private function get craftInProgress() : Boolean
      {
         return this._1664373938craftInProgress;
      }
      
      private function set craftInProgress(param1:Boolean) : void
      {
         var _loc2_:Object = this._1664373938craftInProgress;
         if(_loc2_ !== param1)
         {
            this._1664373938craftInProgress = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"craftInProgress",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get availableCount() : uint
      {
         return this._2079904826availableCount;
      }
      
      private function set availableCount(param1:uint) : void
      {
         var _loc2_:Object = this._2079904826availableCount;
         if(_loc2_ !== param1)
         {
            this._2079904826availableCount = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"availableCount",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get selectedRecipe() : Recipe
      {
         return this._1817809929selectedRecipe;
      }
      
      private function set selectedRecipe(param1:Recipe) : void
      {
         var _loc2_:Object = this._1817809929selectedRecipe;
         if(_loc2_ !== param1)
         {
            this._1817809929selectedRecipe = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedRecipe",_loc2_,param1));
            }
         }
      }
   }
}

