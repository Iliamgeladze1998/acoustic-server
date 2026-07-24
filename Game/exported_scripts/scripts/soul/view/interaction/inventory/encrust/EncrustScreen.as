package soul.view.interaction.inventory.encrust
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
   import soul.controller.Interaction;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.SimpleUIEvent;
   import soul.model.common.InteractionType;
   import soul.model.inventory.InventoryModel;
   import soul.model.item.Item;
   import soul.net.ServerLayer;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class EncrustScreen extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _EncrustScreen_BorderedContainer1:BorderedContainer;
      
      public var _EncrustScreen_Button11:Button1;
      
      public var _EncrustScreen_Button12:Button1;
      
      public var _EncrustScreen_Label1:Label;
      
      private var _344903759allowedTypes:AllowedJewelTypes;
      
      private var _3369ir:ItemRenderer;
      
      private var _1163356016jewels:Jewels;
      
      private var _3556653text:Label;
      
      private var _104069929model:InventoryModel;
      
      public var item:Item;
      
      private var sockets:Array;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function EncrustScreen()
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
         bindings = this._EncrustScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_inventory_encrust_EncrustScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return EncrustScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 350;
         this.height = 350;
         this.horizontalAlign = "center";
         this.padding = 10;
         this.gap = 5;
         this.children = [this._EncrustScreen_HBox1_c(),this._EncrustScreen_Jewels1_i(),this._EncrustScreen_BorderedContainer1_i(),this._EncrustScreen_HBox2_c()];
         this.addEventListener("creationComplete",this.___EncrustScreen_VBox1_creationComplete);
         this.addEventListener("removedFromStage",this.___EncrustScreen_VBox1_removedFromStage);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         EncrustScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("encrust.title");
         this.jewels.addEventListener(Event.CHANGE,this.onChange);
         ServerLayer.call("inventoryService","getSockets",this.setSockets,null,this.item.key);
         this.model.encrustingItem = this.item.id;
      }
      
      private function setSockets(sockets:Array) : void
      {
         this.ir.item = this.item;
         this.jewels.init(this.item,sockets);
         this.allowedTypes.allowedTypes = this.item.socketTypes;
         this.onChange(null);
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         this.model.encrustingItem = null;
         this.jewels.removeEventListener(Event.CHANGE,this.onChange);
      }
      
      private function onChange(e:Event) : void
      {
         var encrusts:Array = this.jewels.getAllJewels();
         ServerLayer.call("inventoryService","sum",this.showSum,null,this.item.key,encrusts);
      }
      
      private function showSum(r:Array) : void
      {
         var addBonuses:Object = null;
         var mulBonuses:Object = null;
         var key:String = null;
         var txt:String = "";
         if(Boolean(r))
         {
            addBonuses = r[0];
            mulBonuses = r[1];
            for(key in addBonuses)
            {
               txt += this.getString(key) + ": +" + addBonuses[key] + "\n";
            }
            for(key in mulBonuses)
            {
               txt += this.getString(key) + ": " + int(mulBonuses[key] * 100) + "%\n";
            }
         }
         this.text.text = txt;
      }
      
      private function encrust() : void
      {
         var encrusts:Array = this.jewels.getAllJewels();
         ServerLayer.call("inventoryService","encrust",this.encrustSuccess,this.encrustFailed,this.item.key,encrusts);
      }
      
      private function encrustSuccess() : void
      {
         this.close();
      }
      
      private function encrustFailed(r:* = null) : void
      {
         this.close();
      }
      
      private function close() : void
      {
         Interaction.hide(InteractionType.ENCRUST);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _EncrustScreen_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.gap = 5;
         _loc1_.children = [this._EncrustScreen_ItemRenderer1_i(),this._EncrustScreen_VBox2_c()];
         return _loc1_;
      }
      
      private function _EncrustScreen_ItemRenderer1_i() : ItemRenderer
      {
         var _loc1_:ItemRenderer = new ItemRenderer();
         this.ir = _loc1_;
         BindingManager.executeBindings(this,"ir",this.ir);
         return _loc1_;
      }
      
      private function _EncrustScreen_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.children = [this._EncrustScreen_Label1_i(),this._EncrustScreen_AllowedJewelTypes1_i()];
         return _loc1_;
      }
      
      private function _EncrustScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         _loc1_.color = 16777215;
         this._EncrustScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_EncrustScreen_Label1",this._EncrustScreen_Label1);
         return _loc1_;
      }
      
      private function _EncrustScreen_AllowedJewelTypes1_i() : AllowedJewelTypes
      {
         var _loc1_:AllowedJewelTypes = new AllowedJewelTypes();
         _loc1_.percentWidth = 100;
         this.allowedTypes = _loc1_;
         BindingManager.executeBindings(this,"allowedTypes",this.allowedTypes);
         return _loc1_;
      }
      
      private function _EncrustScreen_Jewels1_i() : Jewels
      {
         var _loc1_:Jewels = new Jewels();
         _loc1_.gap = 5;
         this.jewels = _loc1_;
         BindingManager.executeBindings(this,"jewels",this.jewels);
         return _loc1_;
      }
      
      private function _EncrustScreen_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.backgroundColor = 1;
         _loc1_.backgroundAlpha = 0.4;
         _loc1_.backgroundPadding = 2;
         _loc1_.children = [this._EncrustScreen_Label2_i()];
         this._EncrustScreen_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_EncrustScreen_BorderedContainer1",this._EncrustScreen_BorderedContainer1);
         return _loc1_;
      }
      
      private function _EncrustScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         this.text = _loc1_;
         BindingManager.executeBindings(this,"text",this.text);
         return _loc1_;
      }
      
      private function _EncrustScreen_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.percentWidth = 100;
         _loc1_.horizontalAlign = "right";
         _loc1_.children = [this._EncrustScreen_Button11_i(),this._EncrustScreen_Button12_i()];
         return _loc1_;
      }
      
      private function _EncrustScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.padding = 5;
         _loc1_.addEventListener("click",this.___EncrustScreen_Button11_click);
         this._EncrustScreen_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_EncrustScreen_Button11",this._EncrustScreen_Button11);
         return _loc1_;
      }
      
      public function ___EncrustScreen_Button11_click(event:MouseEvent) : void
      {
         this.encrust();
      }
      
      private function _EncrustScreen_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.padding = 5;
         _loc1_.addEventListener("click",this.___EncrustScreen_Button12_click);
         this._EncrustScreen_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_EncrustScreen_Button12",this._EncrustScreen_Button12);
         return _loc1_;
      }
      
      public function ___EncrustScreen_Button12_click(event:MouseEvent) : void
      {
         this.close();
      }
      
      public function ___EncrustScreen_VBox1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      public function ___EncrustScreen_VBox1_removedFromStage(event:Event) : void
      {
         this.removed(event);
      }
      
      private function _EncrustScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = getString("encrust.availableTypes") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_EncrustScreen_Label1.text");
         result[1] = new Binding(this,function():Object
         {
            return Assets.simpleBorderRound;
         },null,"_EncrustScreen_BorderedContainer1.borderSkin");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("encrust.apply");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_EncrustScreen_Button11.label");
         result[3] = new Binding(this,function():Boolean
         {
            return jewels.changed;
         },null,"_EncrustScreen_Button11.enabled");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = getString("cancel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_EncrustScreen_Button12.label");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get allowedTypes() : AllowedJewelTypes
      {
         return this._344903759allowedTypes;
      }
      
      public function set allowedTypes(param1:AllowedJewelTypes) : void
      {
         var _loc2_:Object = this._344903759allowedTypes;
         if(_loc2_ !== param1)
         {
            this._344903759allowedTypes = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allowedTypes",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ir() : ItemRenderer
      {
         return this._3369ir;
      }
      
      public function set ir(param1:ItemRenderer) : void
      {
         var _loc2_:Object = this._3369ir;
         if(_loc2_ !== param1)
         {
            this._3369ir = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ir",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get jewels() : Jewels
      {
         return this._1163356016jewels;
      }
      
      public function set jewels(param1:Jewels) : void
      {
         var _loc2_:Object = this._1163356016jewels;
         if(_loc2_ !== param1)
         {
            this._1163356016jewels = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"jewels",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get text() : Label
      {
         return this._3556653text;
      }
      
      public function set text(param1:Label) : void
      {
         var _loc2_:Object = this._3556653text;
         if(_loc2_ !== param1)
         {
            this._3556653text = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"text",_loc2_,param1));
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
   }
}

