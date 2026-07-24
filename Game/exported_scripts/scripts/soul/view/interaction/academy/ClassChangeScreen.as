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
   import soul.model.character.Disposition;
   import soul.model.location.academy.AcademyModel;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientLabel;
   import soul.view.common.Icons;
   import soul.view.common.MoneyRenderer;
   import soul.view.ui.Box;
   import soul.view.ui.Container;
   import soul.view.ui.Label;
   
   use namespace mx_internal;
   
   public class ClassChangeScreen extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _ClassChangeScreen_GradientLabel1:GradientLabel;
      
      public var _ClassChangeScreen_GradientLabel2:GradientLabel;
      
      public var _ClassChangeScreen_Label1:Label;
      
      public var _ClassChangeScreen_MoneyRenderer1:MoneyRenderer;
      
      private var _62188164btnAccept:Button1;
      
      private var _1998517897classSelector:ClassSelector;
      
      private var _1724546052description:ClassDescription;
      
      private var _1121259946sideSelector:SideSelector;
      
      private var _104069929model:AcademyModel;
      
      private var _1564195625character:CharacterModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ClassChangeScreen()
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
         bindings = this._ClassChangeScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_academy_ClassChangeScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ClassChangeScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._ClassChangeScreen_GradientLabel1_i(),this._ClassChangeScreen_GradientLabel2_i(),this._ClassChangeScreen_SideSelector1_i(),this._ClassChangeScreen_ClassSelector1_i(),this._ClassChangeScreen_ClassDescription1_i(),this._ClassChangeScreen_Box1_c(),this._ClassChangeScreen_Button11_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ClassChangeScreen._watcherSetupUtil = param1;
      }
      
      private function applyClass() : void
      {
         var ne:AcademyEvent = new AcademyEvent(AcademyEvent.CHANGE_DISPOSITION);
         ne.data = Disposition.getBySideAndClass(this.sideSelector.selectedSide,this.classSelector.selectedClass);
         this.model.dispatchEvent(ne);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _ClassChangeScreen_GradientLabel1_i() : GradientLabel
      {
         var _loc1_:GradientLabel = null;
         _loc1_ = new GradientLabel();
         _loc1_.x = 10;
         _loc1_.y = 10;
         _loc1_.width = 437;
         _loc1_.height = 24;
         _loc1_.padding = 2;
         _loc1_.fontSize = 12;
         this._ClassChangeScreen_GradientLabel1 = _loc1_;
         BindingManager.executeBindings(this,"_ClassChangeScreen_GradientLabel1",this._ClassChangeScreen_GradientLabel1);
         return _loc1_;
      }
      
      private function _ClassChangeScreen_GradientLabel2_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.x = 10;
         _loc1_.y = 140;
         _loc1_.width = 437;
         _loc1_.height = 24;
         _loc1_.padding = 2;
         _loc1_.fontSize = 12;
         this._ClassChangeScreen_GradientLabel2 = _loc1_;
         BindingManager.executeBindings(this,"_ClassChangeScreen_GradientLabel2",this._ClassChangeScreen_GradientLabel2);
         return _loc1_;
      }
      
      private function _ClassChangeScreen_SideSelector1_i() : SideSelector
      {
         var _loc1_:SideSelector = new SideSelector();
         _loc1_.x = 10;
         _loc1_.y = 32;
         this.sideSelector = _loc1_;
         BindingManager.executeBindings(this,"sideSelector",this.sideSelector);
         return _loc1_;
      }
      
      private function _ClassChangeScreen_ClassSelector1_i() : ClassSelector
      {
         var _loc1_:ClassSelector = new ClassSelector();
         _loc1_.x = 25;
         _loc1_.y = 172;
         _loc1_.gap = 30;
         this.classSelector = _loc1_;
         BindingManager.executeBindings(this,"classSelector",this.classSelector);
         return _loc1_;
      }
      
      private function _ClassChangeScreen_ClassDescription1_i() : ClassDescription
      {
         var _loc1_:ClassDescription = new ClassDescription();
         _loc1_.x = 467;
         _loc1_.y = 13;
         _loc1_.width = 228;
         _loc1_.height = 305;
         this.description = _loc1_;
         BindingManager.executeBindings(this,"description",this.description);
         return _loc1_;
      }
      
      private function _ClassChangeScreen_Box1_c() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.x = 20;
         _loc1_.y = 287;
         _loc1_.width = 232;
         _loc1_.height = 30;
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._ClassChangeScreen_Label1_i(),this._ClassChangeScreen_MoneyRenderer1_i()];
         return _loc1_;
      }
      
      private function _ClassChangeScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         this._ClassChangeScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_ClassChangeScreen_Label1",this._ClassChangeScreen_Label1);
         return _loc1_;
      }
      
      private function _ClassChangeScreen_MoneyRenderer1_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         _loc1_.fontSize = 12;
         this._ClassChangeScreen_MoneyRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_ClassChangeScreen_MoneyRenderer1",this._ClassChangeScreen_MoneyRenderer1);
         return _loc1_;
      }
      
      private function _ClassChangeScreen_Button11_i() : Button1
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
         this.applyClass();
      }
      
      private function _ClassChangeScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = "  - " + getString("chooseSide") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClassChangeScreen_GradientLabel1.text");
         result[1] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClassChangeScreen_GradientLabel1.color");
         result[2] = new Binding(this,function():String
         {
            var _loc1_:* = "  - " + getString("chooseClass") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClassChangeScreen_GradientLabel2.text");
         result[3] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClassChangeScreen_GradientLabel2.color");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = character.side;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"sideSelector.selectedSide");
         result[5] = new Binding(this,function():Boolean
         {
            return model.empireAllowed;
         },null,"sideSelector.empireEnabled");
         result[6] = new Binding(this,function():Boolean
         {
            return model.wastelandAllowed;
         },null,"sideSelector.wastelandEnabled");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = character.dispositionGroup;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"classSelector.selectedClass");
         result[8] = new Binding(this,function():String
         {
            var _loc1_:* = character.sex;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"description.sex");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = sideSelector.selectedSide;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"description.side");
         result[10] = new Binding(this,function():String
         {
            var _loc1_:* = classSelector.selectedClass;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"description.klass");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = getString("changeCost") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClassChangeScreen_Label1.text");
         result[12] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_ClassChangeScreen_Label1.color");
         result[13] = new Binding(this,function():uint
         {
            return Colors.GOLD_DARK;
         },null,"_ClassChangeScreen_MoneyRenderer1.color");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = model.presets.changeCurrency;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ClassChangeScreen_MoneyRenderer1.type");
         result[15] = new Binding(this,function():uint
         {
            return model.presets.changePrice;
         },null,"_ClassChangeScreen_MoneyRenderer1.value");
         result[16] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"btnAccept.icon");
         result[17] = new Binding(this,function():Boolean
         {
            return character.currencies[model.presets.changeCurrency] >= model.presets.changePrice;
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
      public function get classSelector() : ClassSelector
      {
         return this._1998517897classSelector;
      }
      
      public function set classSelector(param1:ClassSelector) : void
      {
         var _loc2_:Object = this._1998517897classSelector;
         if(_loc2_ !== param1)
         {
            this._1998517897classSelector = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"classSelector",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get description() : ClassDescription
      {
         return this._1724546052description;
      }
      
      public function set description(param1:ClassDescription) : void
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
      public function get sideSelector() : SideSelector
      {
         return this._1121259946sideSelector;
      }
      
      public function set sideSelector(param1:SideSelector) : void
      {
         var _loc2_:Object = this._1121259946sideSelector;
         if(_loc2_ !== param1)
         {
            this._1121259946sideSelector = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sideSelector",_loc2_,param1));
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

