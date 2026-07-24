package soul.view.interaction.loot
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
   import soul.controller.shortcut.InteractShortcut;
   import soul.controller.shortcut.ShortcutManager;
   import soul.event.ItemClickEvent;
   import soul.event.LootEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.common.InteractionType;
   import soul.model.interaction.loot.LootModel;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.GradientBox;
   import soul.view.common.Icons;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class LootScreen extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _LootScreen_BorderedContainer1:BorderedContainer;
      
      public var _LootScreen_Button11:Button1;
      
      public var _LootScreen_Button12:Button1;
      
      public var _LootScreen_CachedImage1:CachedImage;
      
      public var _LootScreen_HBox1:HBox;
      
      public var _LootScreen_Label1:Label;
      
      public var _LootScreen_LootItems1:LootItems;
      
      private var _104069929model:LootModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function LootScreen()
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
         bindings = this._LootScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_loot_LootScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return LootScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 345;
         this.height = 170;
         this.padding = 3;
         this.children = [this._LootScreen_Canvas1_c(),this._LootScreen_GradientBox1_c(),this._LootScreen_Component1_c()];
         this.addEventListener("creationComplete",this.___LootScreen_VBox1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         LootScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = LocaleManager.getString(BundleName.INTERFACE,"loot.title");
         ShortcutManager.addShortcutListener(InteractShortcut.instance,this.takeAll,InteractShortcut.GATHER_ALL,false);
         addEventListener(Event.COMPLETE,this.takeAll);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
      }
      
      private function removed(e:Event) : void
      {
         ShortcutManager.removeShortcutListener(InteractShortcut.instance,this.takeAll,false);
      }
      
      private function itemClick(e:ItemClickEvent) : void
      {
         this.model.dispatchEvent(e.clone());
      }
      
      private function takeAll(e:Event = null) : Boolean
      {
         if(!stage)
         {
            trace("^^^^^^^WORKAROUND^^^^^^^^^");
            this.removed(e);
            return false;
         }
         if(!this.model.lootAllEnabled)
         {
            return false;
         }
         this.model.dispatchEvent(new LootEvent(LootEvent.TAKE_ALL));
         return true;
      }
      
      private function close() : void
      {
         Interaction.hide(InteractionType.LOOT);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _LootScreen_Canvas1_c() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.padding = 10;
         _loc1_.children = [this._LootScreen_BorderedContainer1_i()];
         return _loc1_;
      }
      
      private function _LootScreen_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.left = 0;
         _loc1_.top = 0;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.padding = 10;
         _loc1_.children = [this._LootScreen_ScrollBase1_c()];
         this._LootScreen_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_LootScreen_BorderedContainer1",this._LootScreen_BorderedContainer1);
         return _loc1_;
      }
      
      private function _LootScreen_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "on";
         _loc1_.wheelMultiplier = 10;
         _loc1_.children = [this._LootScreen_LootItems1_i()];
         return _loc1_;
      }
      
      private function _LootScreen_LootItems1_i() : LootItems
      {
         var _loc1_:LootItems = new LootItems();
         _loc1_.gap = 5;
         _loc1_.width = 290;
         _loc1_.addEventListener("itemClick",this.___LootScreen_LootItems1_itemClick);
         this._LootScreen_LootItems1 = _loc1_;
         BindingManager.executeBindings(this,"_LootScreen_LootItems1",this._LootScreen_LootItems1);
         return _loc1_;
      }
      
      public function ___LootScreen_LootItems1_itemClick(event:ItemClickEvent) : void
      {
         this.itemClick(event);
      }
      
      private function _LootScreen_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.padding = 10;
         _loc1_.children = [this._LootScreen_HBox1_i(),this._LootScreen_HBox2_c()];
         return _loc1_;
      }
      
      private function _LootScreen_HBox1_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.verticalCenter = 0;
         _loc1_.left = 0;
         _loc1_.verticalAlign = "middle";
         _loc1_.gap = 2;
         _loc1_.children = [this._LootScreen_Label1_i(),this._LootScreen_CachedImage1_i()];
         this._LootScreen_HBox1 = _loc1_;
         BindingManager.executeBindings(this,"_LootScreen_HBox1",this._LootScreen_HBox1);
         return _loc1_;
      }
      
      private function _LootScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         this._LootScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_LootScreen_Label1",this._LootScreen_Label1);
         return _loc1_;
      }
      
      private function _LootScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._LootScreen_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_LootScreen_CachedImage1",this._LootScreen_CachedImage1);
         return _loc1_;
      }
      
      private function _LootScreen_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.verticalCenter = 0;
         _loc1_.right = 0;
         _loc1_.gap = 5;
         _loc1_.children = [this._LootScreen_Button11_i(),this._LootScreen_Button12_i()];
         return _loc1_;
      }
      
      private function _LootScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___LootScreen_Button11_click);
         this._LootScreen_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_LootScreen_Button11",this._LootScreen_Button11);
         return _loc1_;
      }
      
      public function ___LootScreen_Button11_click(event:MouseEvent) : void
      {
         this.takeAll();
      }
      
      private function _LootScreen_Button12_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___LootScreen_Button12_click);
         this._LootScreen_Button12 = _loc1_;
         BindingManager.executeBindings(this,"_LootScreen_Button12",this._LootScreen_Button12);
         return _loc1_;
      }
      
      public function ___LootScreen_Button12_click(event:MouseEvent) : void
      {
         this.close();
      }
      
      private function _LootScreen_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.height = 10;
         return _loc1_;
      }
      
      public function ___LootScreen_VBox1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _LootScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_LootScreen_BorderedContainer1.borderSkin");
         result[1] = new Binding(this,function():Array
         {
            var _loc1_:* = model.items;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_LootScreen_LootItems1.dataProvider");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = getString("load");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LootScreen_HBox1.toolTip");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = model.totalWeight;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LootScreen_Label1.text");
         result[4] = new Binding(this,function():Object
         {
            return Icons.load;
         },null,"_LootScreen_CachedImage1.source");
         result[5] = new Binding(this,function():Object
         {
            return Icons.maximize;
         },null,"_LootScreen_Button11.icon");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = getString("loot.takeAll");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LootScreen_Button11.toolTip");
         result[7] = new Binding(this,function():Boolean
         {
            return model.lootAllEnabled;
         },null,"_LootScreen_Button11.enabled");
         result[8] = new Binding(this,function():Object
         {
            return Icons.cancel;
         },null,"_LootScreen_Button12.icon");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = getString("close");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_LootScreen_Button12.toolTip");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : LootModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:LootModel) : void
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

