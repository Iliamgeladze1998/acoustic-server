package soul.view.interaction.academy
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
   import soul.event.AcademyEvent;
   import soul.model.character.CharacterModel;
   import soul.model.location.academy.AcademyModel;
   import soul.model.location.academy.AcademyOptionData;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientLabel;
   import soul.view.common.Icons;
   import soul.view.common.MoneyRenderer;
   import soul.view.ui.Box;
   import soul.view.ui.Container;
   import soul.view.ui.Label;
   
   use namespace mx_internal;
   
   public class StatResetScreen extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _StatResetScreen_GradientLabel1:GradientLabel;
      
      public var _StatResetScreen_Label1:Label;
      
      public var _StatResetScreen_MoneyRenderer1:MoneyRenderer;
      
      private var _62188164btnAccept:Button1;
      
      private var _1724546052description:StatDescription;
      
      private var _1191572447selector:StatSelector;
      
      private var _104069929model:AcademyModel;
      
      private var _1564195625character:CharacterModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function StatResetScreen()
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
         bindings = this._StatResetScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_academy_StatResetScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return StatResetScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._StatResetScreen_GradientLabel1_i(),this._StatResetScreen_StatSelector1_i(),this._StatResetScreen_StatDescription1_i(),this._StatResetScreen_Box1_c(),this._StatResetScreen_Button11_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         StatResetScreen._watcherSetupUtil = param1;
      }
      
      private function applyReset() : void
      {
         var ne:AcademyEvent = new AcademyEvent(AcademyEvent.RESET_STATS);
         ne.data = this.selector.selectedType;
         this.model.dispatchEvent(ne);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _StatResetScreen_GradientLabel1_i() : GradientLabel
      {
         var _loc1_:GradientLabel = null;
         _loc1_ = new GradientLabel();
         _loc1_.x = 10;
         _loc1_.y = 10;
         _loc1_.width = 437;
         _loc1_.height = 24;
         _loc1_.padding = 2;
         _loc1_.fontSize = 12;
         this._StatResetScreen_GradientLabel1 = _loc1_;
         BindingManager.executeBindings(this,"_StatResetScreen_GradientLabel1",this._StatResetScreen_GradientLabel1);
         return _loc1_;
      }
      
      private function _StatResetScreen_StatSelector1_i() : StatSelector
      {
         var _loc1_:StatSelector = new StatSelector();
         _loc1_.x = 25;
         _loc1_.y = 50;
         _loc1_.gap = 30;
         this.selector = _loc1_;
         BindingManager.executeBindings(this,"selector",this.selector);
         return _loc1_;
      }
      
      private function _StatResetScreen_StatDescription1_i() : StatDescription
      {
         var _loc1_:StatDescription = new StatDescription();
         _loc1_.x = 467;
         _loc1_.y = 13;
         _loc1_.width = 228;
         _loc1_.height = 305;
         this.description = _loc1_;
         BindingManager.executeBindings(this,"description",this.description);
         return _loc1_;
      }
      
      private function _StatResetScreen_Box1_c() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.x = 20;
         _loc1_.y = 287;
         _loc1_.width = 232;
         _loc1_.height = 30;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._StatResetScreen_Label1_i(),this._StatResetScreen_MoneyRenderer1_i()];
         return _loc1_;
      }
      
      private function _StatResetScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         this._StatResetScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_StatResetScreen_Label1",this._StatResetScreen_Label1);
         return _loc1_;
      }
      
      private function _StatResetScreen_MoneyRenderer1_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         _loc1_.fontSize = 12;
         this._StatResetScreen_MoneyRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_StatResetScreen_MoneyRenderer1",this._StatResetScreen_MoneyRenderer1);
         return _loc1_;
      }
      
      private function _StatResetScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.x = 390;
         _loc1_.y = 287;
         _loc1_.height = 28;
         _loc1_.width = 50;
         _loc1_.addEventListener("click",this.__btnAccept_click);
         this.btnAccept = _loc1_;
         BindingManager.executeBindings(this,"btnAccept",this.btnAccept);
         return _loc1_;
      }
      
      public function __btnAccept_click(event:MouseEvent) : void
      {
         this.applyReset();
      }
      
      private function _StatResetScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = "  - " + getString("academy.selectStat") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatResetScreen_GradientLabel1.text");
         result[1] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_StatResetScreen_GradientLabel1.color");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = selector.selectedType;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"description.type");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getString("changeCost") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatResetScreen_Label1.text");
         result[4] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_StatResetScreen_Label1.color");
         result[5] = new Binding(this,function():uint
         {
            return Colors.GOLD_DARK;
         },null,"_StatResetScreen_MoneyRenderer1.color");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = model.resets[selector.selectedType].changeCurrency;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_StatResetScreen_MoneyRenderer1.type");
         result[7] = new Binding(this,function():uint
         {
            return model.resets[selector.selectedType].changePrice;
         },null,"_StatResetScreen_MoneyRenderer1.value");
         result[8] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"btnAccept.icon");
         result[9] = new Binding(this,function():Boolean
         {
            return Boolean(selector.selectedType) && AcademyOptionData(model.resets[selector.selectedType]).buttonEnabled;
         },null,"btnAccept.enabled");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get btnAccept() : Button1
      {
         return this._62188164btnAccept;
      }
      
      public function set btnAccept(param1:Button1) : void
      {
         var _loc2_:Object = this._62188164btnAccept;
         if(_loc2_ !== param1)
         {
            this._62188164btnAccept = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnAccept",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : StatDescription
      {
         return this._1724546052description;
      }
      
      public function set description(param1:StatDescription) : void
      {
         var _loc2_:Object = this._1724546052description;
         if(_loc2_ !== param1)
         {
            this._1724546052description = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"description",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selector() : StatSelector
      {
         return this._1191572447selector;
      }
      
      public function set selector(param1:StatSelector) : void
      {
         var _loc2_:Object = this._1191572447selector;
         if(_loc2_ !== param1)
         {
            this._1191572447selector = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selector",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : AcademyModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:AcademyModel) : void
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
      public function get character() : CharacterModel
      {
         return this._1564195625character;
      }
      
      public function set character(param1:CharacterModel) : void
      {
         var _loc2_:Object = this._1564195625character;
         if(_loc2_ !== param1)
         {
            this._1564195625character = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"character",_loc2_,param1));
            }
         }
      }
   }
}

