package soul.view.interaction.character
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
   import soul.model.inventory.BodyModel;
   import soul.view.assets.Assets;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.Box;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   import soul.view.ui.controls.PopupManager;
   
   use namespace mx_internal;
   
   public class GiftPopup extends InteractionWindow implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _GiftPopup_BorderedContainer1:BorderedContainer;
      
      public var _GiftPopup_GiftsBox1:GiftsBox;
      
      public var _GiftPopup_GiftsBox2:GiftsBox;
      
      public var _GiftPopup_GiftsBox3:GiftsBox;
      
      private var _3029410body:BodyModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function GiftPopup()
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
         bindings = this._GiftPopup_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_character_GiftPopupWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return GiftPopup[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 400;
         this.height = 350;
         this.children = [this._GiftPopup_Box1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         GiftPopup._watcherSetupUtil = param1;
      }
      
      override protected function exit(e:Event) : void
      {
         PopupManager.removePopup(this);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _GiftPopup_Box1_c() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.padding = 9;
         _loc1_.children = [this._GiftPopup_BorderedContainer1_i()];
         return _loc1_;
      }
      
      private function _GiftPopup_BorderedContainer1_i() : BorderedContainer
      {
         var _loc1_:BorderedContainer = new BorderedContainer();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.padding = 3;
         _loc1_.children = [this._GiftPopup_ScrollBase1_c()];
         this._GiftPopup_BorderedContainer1 = _loc1_;
         BindingManager.executeBindings(this,"_GiftPopup_BorderedContainer1",this._GiftPopup_BorderedContainer1);
         return _loc1_;
      }
      
      private function _GiftPopup_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "on";
         _loc1_.horizontalScrollPolicy = "off";
         _loc1_.children = [this._GiftPopup_VBox1_c()];
         return _loc1_;
      }
      
      private function _GiftPopup_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.children = [this._GiftPopup_GiftsBox1_i(),this._GiftPopup_GiftsBox2_i(),this._GiftPopup_GiftsBox3_i()];
         return _loc1_;
      }
      
      private function _GiftPopup_GiftsBox1_i() : GiftsBox
      {
         var _loc1_:GiftsBox = new GiftsBox();
         _loc1_.expanded = true;
         this._GiftPopup_GiftsBox1 = _loc1_;
         BindingManager.executeBindings(this,"_GiftPopup_GiftsBox1",this._GiftPopup_GiftsBox1);
         return _loc1_;
      }
      
      private function _GiftPopup_GiftsBox2_i() : GiftsBox
      {
         var _loc1_:GiftsBox = new GiftsBox();
         this._GiftPopup_GiftsBox2 = _loc1_;
         BindingManager.executeBindings(this,"_GiftPopup_GiftsBox2",this._GiftPopup_GiftsBox2);
         return _loc1_;
      }
      
      private function _GiftPopup_GiftsBox3_i() : GiftsBox
      {
         var _loc1_:GiftsBox = new GiftsBox();
         this._GiftPopup_GiftsBox3 = _loc1_;
         BindingManager.executeBindings(this,"_GiftPopup_GiftsBox3",this._GiftPopup_GiftsBox3);
         return _loc1_;
      }
      
      private function _GiftPopup_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = getString("charInfo.button.gifts");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"this.label");
         result[1] = new Binding(this,function():Object
         {
            return Assets.shadedBorderRound;
         },null,"_GiftPopup_BorderedContainer1.borderSkin");
         result[2] = new Binding(this,function():Object
         {
            return Assets.pattern_06;
         },null,"_GiftPopup_BorderedContainer1.backgroundImage");
         result[3] = new Binding(this,function():Array
         {
            var _loc1_:* = body.awards;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_GiftPopup_GiftsBox1.dataProvider");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = getString("charInfo.button.awards");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_GiftPopup_GiftsBox1.label");
         result[5] = new Binding(this,function():Array
         {
            var _loc1_:* = body.gifts;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_GiftPopup_GiftsBox2.dataProvider");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = getString("charInfo.button.gifts");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_GiftPopup_GiftsBox2.label");
         result[7] = new Binding(this,function():Array
         {
            var _loc1_:* = body.trophies;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_GiftPopup_GiftsBox3.dataProvider");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = getString("charInfo.button.trophies");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_GiftPopup_GiftsBox3.label");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get body() : BodyModel
      {
         return this._3029410body;
      }
      
      public function set body(param1:BodyModel) : void
      {
         var _loc2_:Object = this._3029410body;
         if(_loc2_ !== param1)
         {
            this._3029410body = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"body",_loc2_,param1));
            }
         }
      }
   }
}

