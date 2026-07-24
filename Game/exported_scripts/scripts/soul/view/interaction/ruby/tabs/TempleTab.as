package soul.view.interaction.ruby.tabs
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
   import soul.model.ability.AbilityModel;
   import soul.model.character.CharacterModel;
   import soul.model.location.temple.HealData;
   import soul.net.ServerLayer;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.assets.GradientLabel;
   import soul.view.common.CurrencyType;
   import soul.view.common.Icons;
   import soul.view.common.MoneyRenderer;
   import soul.view.interaction.ability.AbilityRenderer;
   import soul.view.ui.Canvas;
   import soul.view.ui.Component;
   import soul.view.ui.Container;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class TempleTab extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _TempleTab_AbilityRenderer1:AbilityRenderer;
      
      public var _TempleTab_Button11:Button1;
      
      public var _TempleTab_GradientLabel1:GradientLabel;
      
      public var _TempleTab_Label1:Label;
      
      public var _TempleTab_Label2:Label;
      
      public var _TempleTab_Label3:Label;
      
      public var _TempleTab_MoneyRenderer1:MoneyRenderer;
      
      private var _1053429836blessings:Blessings;
      
      private var _104069929model:CharacterModel;
      
      private var _259260447abilityModel:AbilityModel;
      
      private var _1187203101availBlessings:Array;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function TempleTab()
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
         bindings = this._TempleTab_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_ruby_tabs_TempleTabWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return TempleTab[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._TempleTab_VBox1_c(),this._TempleTab_ScrollBase2_c()];
         this.addEventListener("added",this.___TempleTab_Container1_added);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         TempleTab._watcherSetupUtil = param1;
      }
      
      private function onAdded(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         callLater(this.getHealData);
      }
      
      private function getHealData() : void
      {
         ServerLayer.call("templeService","getHealData",this.setHealData);
      }
      
      private function setHealData(value:HealData) : void
      {
         this.availBlessings = value.availEffects;
      }
      
      private function accept() : void
      {
         ServerLayer.call("templeService","castEffect",null,null,this.blessings.selectedBlessing.id);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _TempleTab_VBox1_c() : VBox
      {
         var _loc1_:VBox = null;
         _loc1_ = new VBox();
         _loc1_.x = 9;
         _loc1_.y = 9;
         _loc1_.width = 438;
         _loc1_.height = 308;
         _loc1_.gap = 3;
         _loc1_.children = [this._TempleTab_GradientLabel1_i(),this._TempleTab_ScrollBase1_c(),this._TempleTab_Component1_c(),this._TempleTab_Canvas1_c()];
         return _loc1_;
      }
      
      private function _TempleTab_GradientLabel1_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.fontSize = 12;
         _loc1_.verticalAlign = "middle";
         this._TempleTab_GradientLabel1 = _loc1_;
         BindingManager.executeBindings(this,"_TempleTab_GradientLabel1",this._TempleTab_GradientLabel1);
         return _loc1_;
      }
      
      private function _TempleTab_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "on";
         _loc1_.children = [this._TempleTab_Blessings1_i()];
         return _loc1_;
      }
      
      private function _TempleTab_Blessings1_i() : Blessings
      {
         var _loc1_:Blessings = new Blessings();
         _loc1_.width = 420;
         this.blessings = _loc1_;
         BindingManager.executeBindings(this,"blessings",this.blessings);
         return _loc1_;
      }
      
      private function _TempleTab_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.height = 8;
         return _loc1_;
      }
      
      private function _TempleTab_Canvas1_c() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.percentWidth = 100;
         _loc1_.height = 32;
         _loc1_.padding = 5;
         _loc1_.children = [this._TempleTab_HBox1_c(),this._TempleTab_Button11_i()];
         return _loc1_;
      }
      
      private function _TempleTab_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.left = 17;
         _loc1_.verticalCenter = 0;
         _loc1_.gap = 5;
         _loc1_.children = [this._TempleTab_Label1_i(),this._TempleTab_MoneyRenderer1_i()];
         return _loc1_;
      }
      
      private function _TempleTab_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         this._TempleTab_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_TempleTab_Label1",this._TempleTab_Label1);
         return _loc1_;
      }
      
      private function _TempleTab_MoneyRenderer1_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         _loc1_.x = 25;
         _loc1_.y = 284;
         _loc1_.fontSize = 12;
         this._TempleTab_MoneyRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_TempleTab_MoneyRenderer1",this._TempleTab_MoneyRenderer1);
         return _loc1_;
      }
      
      private function _TempleTab_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.right = 5;
         _loc1_.verticalCenter = 0;
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___TempleTab_Button11_click);
         this._TempleTab_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_TempleTab_Button11",this._TempleTab_Button11);
         return _loc1_;
      }
      
      public function ___TempleTab_Button11_click(event:MouseEvent) : void
      {
         this.accept();
      }
      
      private function _TempleTab_ScrollBase2_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.x = 466;
         _loc1_.y = 3;
         _loc1_.width = 276;
         _loc1_.height = 320;
         _loc1_.horizontalScrollPolicy = "off";
         _loc1_.verticalScrollPolicy = "on";
         _loc1_.children = [this._TempleTab_VBox2_c()];
         return _loc1_;
      }
      
      private function _TempleTab_VBox2_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.children = [this._TempleTab_GradientBox1_c(),this._TempleTab_Label3_i()];
         return _loc1_;
      }
      
      private function _TempleTab_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.width = 253;
         _loc1_.height = 34;
         _loc1_.children = [this._TempleTab_AbilityRenderer1_i(),this._TempleTab_Label2_i()];
         return _loc1_;
      }
      
      private function _TempleTab_AbilityRenderer1_i() : AbilityRenderer
      {
         var _loc1_:AbilityRenderer = new AbilityRenderer();
         _loc1_.x = 8;
         _loc1_.verticalCenter = 0;
         _loc1_.width = 26;
         _loc1_.height = 26;
         _loc1_.checkItems = false;
         _loc1_.checkStats = false;
         this._TempleTab_AbilityRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_TempleTab_AbilityRenderer1",this._TempleTab_AbilityRenderer1);
         return _loc1_;
      }
      
      private function _TempleTab_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.verticalCenter = 0;
         _loc1_.x = 40;
         _loc1_.bold = true;
         this._TempleTab_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_TempleTab_Label2",this._TempleTab_Label2);
         return _loc1_;
      }
      
      private function _TempleTab_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.percentWidth = 100;
         _loc1_.multiline = true;
         _loc1_.wordWrap = true;
         _loc1_.padding = 5;
         this._TempleTab_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_TempleTab_Label3",this._TempleTab_Label3);
         return _loc1_;
      }
      
      public function ___TempleTab_Container1_added(event:Event) : void
      {
         this.onAdded(event);
      }
      
      private function _TempleTab_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = " - " + getString("blessing.choice") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TempleTab_GradientLabel1.text");
         result[1] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_TempleTab_GradientLabel1.color");
         result[2] = new Binding(this,null,null,"blessings.model","abilityModel");
         result[3] = new Binding(this,function():Array
         {
            var _loc1_:* = availBlessings;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"blessings.dataProvider");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = getString("blessing.cost") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TempleTab_Label1.text");
         result[5] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_TempleTab_Label1.color");
         result[6] = new Binding(this,function():String
         {
            var _loc1_:* = CurrencyType.RUBIES;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TempleTab_MoneyRenderer1.type");
         result[7] = new Binding(this,function():uint
         {
            return blessings.selectedBlessing.price;
         },null,"_TempleTab_MoneyRenderer1.value");
         result[8] = new Binding(this,function():uint
         {
            return Colors.BUTTON_LABEL;
         },null,"_TempleTab_MoneyRenderer1.color");
         result[9] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_TempleTab_Button11.icon");
         result[10] = new Binding(this,function():Boolean
         {
            return blessings.selectedBlessing != null && model.currencies.RUBIES >= blessings.selectedBlessing.price;
         },null,"_TempleTab_Button11.enabled");
         result[11] = new Binding(this,function():String
         {
            var _loc1_:* = getString("accept");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TempleTab_Button11.toolTip");
         result[12] = new Binding(this,null,null,"_TempleTab_AbilityRenderer1.abilityModel","abilityModel");
         result[13] = new Binding(this,function():String
         {
            var _loc1_:* = blessings.selectedBlessing.abilityId;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TempleTab_AbilityRenderer1.abilityId");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = LocaleManager.getAbilityName(blessings.selectedBlessing.abilityId);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TempleTab_Label2.text");
         result[15] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_TempleTab_Label2.color");
         result[16] = new Binding(this,function():String
         {
            var _loc1_:* = LocaleManager.getAbilityDescription(blessings.selectedBlessing.abilityId);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TempleTab_Label3.text");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get blessings() : Blessings
      {
         return this._1053429836blessings;
      }
      
      public function set blessings(param1:Blessings) : void
      {
         var _loc2_:Object = this._1053429836blessings;
         if(_loc2_ !== param1)
         {
            this._1053429836blessings = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"blessings",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : CharacterModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:CharacterModel) : void
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
      public function get abilityModel() : AbilityModel
      {
         return this._259260447abilityModel;
      }
      
      public function set abilityModel(param1:AbilityModel) : void
      {
         var _loc2_:Object = this._259260447abilityModel;
         if(_loc2_ !== param1)
         {
            this._259260447abilityModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"abilityModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get availBlessings() : Array
      {
         return this._1187203101availBlessings;
      }
      
      private function set availBlessings(param1:Array) : void
      {
         var _loc2_:Object = this._1187203101availBlessings;
         if(_loc2_ !== param1)
         {
            this._1187203101availBlessings = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"availBlessings",_loc2_,param1));
            }
         }
      }
   }
}

