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
   import soul.model.character.CharPropertyType;
   import soul.model.character.CharacterModel;
   import soul.model.interaction.ruby.Subscription;
   import soul.model.interaction.ruby.SubscriptionType;
   import soul.model.system.Configuration;
   import soul.net.ServerLayer;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.assets.GradientLabel;
   import soul.view.common.CurrencyType;
   import soul.view.common.Icons;
   import soul.view.common.MoneyRenderer;
   import soul.view.common.OptionGroup;
   import soul.view.ui.Canvas;
   import soul.view.ui.Checkbox;
   import soul.view.ui.Container;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   
   use namespace mx_internal;
   
   public class SubscriptionTab extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _SubscriptionTab_Button11:Button1;
      
      public var _SubscriptionTab_GradientBox1:GradientBox;
      
      public var _SubscriptionTab_GradientLabel1:GradientLabel;
      
      public var _SubscriptionTab_GradientLabel2:GradientLabel;
      
      public var _SubscriptionTab_Label1:Label;
      
      public var _SubscriptionTab_MoneyRenderer1:MoneyRenderer;
      
      public var _SubscriptionTab_SubscriptionDescription1:SubscriptionDescription;
      
      private var _98629247group:OptionGroup;
      
      private var _1217487446hidden:Checkbox;
      
      private var _110250375terms:Terms;
      
      private var _104069929model:CharacterModel;
      
      private var _1910031992enoughRubies:Boolean;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SubscriptionTab()
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
         bindings = this._SubscriptionTab_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_ruby_tabs_SubscriptionTabWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return SubscriptionTab[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.children = [this._SubscriptionTab_Canvas1_c(),this._SubscriptionTab_GradientBox1_i(),this._SubscriptionTab_SubscriptionDescription1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SubscriptionTab._watcherSetupUtil = param1;
      }
      
      private function getOptions(level:int) : Array
      {
         var sub:Subscription = null;
         if(level == 0)
         {
            return null;
         }
         var arr:Array = [];
         for each(sub in Configuration.subscriptions)
         {
            arr.push({
               "label":LocaleManager.getSubscriptionName(sub.type).toUpperCase(),
               "value":sub.type,
               "source":SubscriptionType.getIcon(sub.type),
               "enabled":sub.maxLevel >= level && sub.minLevel <= level
            });
         }
         return arr;
      }
      
      private function accept() : void
      {
         ServerLayer.call("characterService","buySubscription",null,null,this.terms.subscription.type,this.terms.selectedIndex,this.terms.autoRenew);
      }
      
      private function hiddenChange() : void
      {
         if(!this.model || this.hidden.selected == this.model.subscriptionHidden)
         {
            return;
         }
         this.hidden.enabled = false;
         ServerLayer.call("characterService","setSubscriptionHidden",this.hideResult,null,this.hidden.selected);
      }
      
      private function hideResult(value:Boolean) : void
      {
         this.model.subscriptionHidden = value;
         this.hidden.enabled = true;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function getSubscriptionTerm(index:int) : String
      {
         return index > -1 ? this.getString("subscription.term") + ": " + this.getString("subscription.term" + index) : this.getString("subscription.term.select");
      }
      
      private function _SubscriptionTab_Canvas1_c() : Canvas
      {
         var _loc1_:Canvas = null;
         _loc1_ = new Canvas();
         _loc1_.x = 9;
         _loc1_.y = 9;
         _loc1_.width = 438;
         _loc1_.height = 308;
         _loc1_.children = [this._SubscriptionTab_GradientLabel1_i(),this._SubscriptionTab_OptionGroup1_i(),this._SubscriptionTab_GradientLabel2_i(),this._SubscriptionTab_Terms1_i(),this._SubscriptionTab_Canvas2_c()];
         return _loc1_;
      }
      
      private function _SubscriptionTab_GradientLabel1_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.fontSize = 12;
         _loc1_.verticalAlign = "middle";
         this._SubscriptionTab_GradientLabel1 = _loc1_;
         BindingManager.executeBindings(this,"_SubscriptionTab_GradientLabel1",this._SubscriptionTab_GradientLabel1);
         return _loc1_;
      }
      
      private function _SubscriptionTab_OptionGroup1_i() : OptionGroup
      {
         var _loc1_:OptionGroup = new OptionGroup();
         _loc1_.horizontalCenter = 0;
         _loc1_.top = 40;
         _loc1_.gap = 30;
         this.group = _loc1_;
         BindingManager.executeBindings(this,"group",this.group);
         return _loc1_;
      }
      
      private function _SubscriptionTab_GradientLabel2_i() : GradientLabel
      {
         var _loc1_:GradientLabel = new GradientLabel();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.y = 160;
         _loc1_.fontSize = 12;
         _loc1_.verticalAlign = "middle";
         this._SubscriptionTab_GradientLabel2 = _loc1_;
         BindingManager.executeBindings(this,"_SubscriptionTab_GradientLabel2",this._SubscriptionTab_GradientLabel2);
         return _loc1_;
      }
      
      private function _SubscriptionTab_Terms1_i() : Terms
      {
         var _loc1_:Terms = new Terms();
         _loc1_.y = 190;
         _loc1_.percentWidth = 100;
         _loc1_.height = 66;
         _loc1_.padding = 10;
         this.terms = _loc1_;
         BindingManager.executeBindings(this,"terms",this.terms);
         return _loc1_;
      }
      
      private function _SubscriptionTab_Canvas2_c() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         _loc1_.percentWidth = 100;
         _loc1_.y = 278;
         _loc1_.height = 28;
         _loc1_.padding = 5;
         _loc1_.children = [this._SubscriptionTab_HBox1_c(),this._SubscriptionTab_Button11_i()];
         return _loc1_;
      }
      
      private function _SubscriptionTab_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.left = 17;
         _loc1_.verticalCenter = 0;
         _loc1_.gap = 5;
         _loc1_.children = [this._SubscriptionTab_Label1_i(),this._SubscriptionTab_MoneyRenderer1_i()];
         return _loc1_;
      }
      
      private function _SubscriptionTab_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         this._SubscriptionTab_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_SubscriptionTab_Label1",this._SubscriptionTab_Label1);
         return _loc1_;
      }
      
      private function _SubscriptionTab_MoneyRenderer1_i() : MoneyRenderer
      {
         var _loc1_:MoneyRenderer = new MoneyRenderer();
         _loc1_.x = 25;
         _loc1_.y = 284;
         _loc1_.fontSize = 12;
         this._SubscriptionTab_MoneyRenderer1 = _loc1_;
         BindingManager.executeBindings(this,"_SubscriptionTab_MoneyRenderer1",this._SubscriptionTab_MoneyRenderer1);
         return _loc1_;
      }
      
      private function _SubscriptionTab_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.right = 5;
         _loc1_.verticalCenter = 0;
         _loc1_.width = 50;
         _loc1_.height = 28;
         _loc1_.addEventListener("click",this.___SubscriptionTab_Button11_click);
         this._SubscriptionTab_Button11 = _loc1_;
         BindingManager.executeBindings(this,"_SubscriptionTab_Button11",this._SubscriptionTab_Button11);
         return _loc1_;
      }
      
      public function ___SubscriptionTab_Button11_click(event:MouseEvent) : void
      {
         this.accept();
      }
      
      private function _SubscriptionTab_GradientBox1_i() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.x = 450;
         _loc1_.y = -30;
         _loc1_.width = 308;
         _loc1_.height = 23;
         _loc1_.children = [this._SubscriptionTab_Checkbox1_i()];
         this._SubscriptionTab_GradientBox1 = _loc1_;
         BindingManager.executeBindings(this,"_SubscriptionTab_GradientBox1",this._SubscriptionTab_GradientBox1);
         return _loc1_;
      }
      
      private function _SubscriptionTab_Checkbox1_i() : Checkbox
      {
         var _loc1_:Checkbox = new Checkbox();
         _loc1_.verticalCenter = 0;
         _loc1_.x = 20;
         _loc1_.addEventListener("change",this.__hidden_change);
         this.hidden = _loc1_;
         BindingManager.executeBindings(this,"hidden",this.hidden);
         return _loc1_;
      }
      
      public function __hidden_change(event:Event) : void
      {
         this.hiddenChange();
      }
      
      private function _SubscriptionTab_SubscriptionDescription1_i() : SubscriptionDescription
      {
         var _loc1_:SubscriptionDescription = new SubscriptionDescription();
         _loc1_.x = 466;
         _loc1_.y = 3;
         _loc1_.width = 276;
         _loc1_.height = 320;
         this._SubscriptionTab_SubscriptionDescription1 = _loc1_;
         BindingManager.executeBindings(this,"_SubscriptionTab_SubscriptionDescription1",this._SubscriptionTab_SubscriptionDescription1);
         return _loc1_;
      }
      
      private function _SubscriptionTab_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():*
         {
            return terms.selectedIndex != -1 && model.currencies.RUBIES >= terms.selectedValue;
         },function(param1:*):void
         {
            enoughRubies = param1;
         },"enoughRubies");
         result[1] = new Binding(this,function():String
         {
            var _loc1_:* = " - " + getString("subscription") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SubscriptionTab_GradientLabel1.text");
         result[2] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_SubscriptionTab_GradientLabel1.color");
         result[3] = new Binding(this,function():Array
         {
            var _loc1_:* = getOptions(model.properties[CharPropertyType.LEVEL]);
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"group.dataProvider");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = " - " + getSubscriptionTerm(terms.selectedIndex);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SubscriptionTab_GradientLabel2.text");
         result[5] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_SubscriptionTab_GradientLabel2.color");
         result[6] = new Binding(this,function():Subscription
         {
            return Configuration.subscriptions[group.selectedIndex];
         },null,"terms.subscription");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = getString("subscription.cost") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SubscriptionTab_Label1.text");
         result[8] = new Binding(this,function():uint
         {
            return enoughRubies ? Colors.GOLD_LIGHT : 16711680;
         },null,"_SubscriptionTab_Label1.color");
         result[9] = new Binding(this,function():String
         {
            var _loc1_:* = CurrencyType.RUBIES;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SubscriptionTab_MoneyRenderer1.type");
         result[10] = new Binding(this,function():uint
         {
            return terms.selectedValue;
         },null,"_SubscriptionTab_MoneyRenderer1.value");
         result[11] = new Binding(this,function():uint
         {
            return enoughRubies ? Colors.BUTTON_LABEL : 16711680;
         },null,"_SubscriptionTab_MoneyRenderer1.color");
         result[12] = new Binding(this,function():Object
         {
            return Icons.accept;
         },null,"_SubscriptionTab_Button11.icon");
         result[13] = new Binding(this,function():Boolean
         {
            return enoughRubies;
         },null,"_SubscriptionTab_Button11.enabled");
         result[14] = new Binding(this,function():String
         {
            var _loc1_:* = getString("accept");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SubscriptionTab_Button11.toolTip");
         result[15] = new Binding(this,function():Array
         {
            var _loc1_:* = [0,[1996488704,30]];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"_SubscriptionTab_GradientBox1.gradient");
         result[16] = new Binding(this,function():Boolean
         {
            return model.subscriptionHidden;
         },null,"hidden.selected");
         result[17] = new Binding(this,function():String
         {
            var _loc1_:* = getString("subscription.hidden");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"hidden.label");
         result[18] = new Binding(this,null,null,"_SubscriptionTab_SubscriptionDescription1.model","model");
         result[19] = new Binding(this,function():Subscription
         {
            return Configuration.subscriptions[group.selectedIndex];
         },null,"_SubscriptionTab_SubscriptionDescription1.subscription");
         return result;
      }
      
      private function _SubscriptionTab_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         this.enoughRubies = this.terms.selectedIndex != -1 && this.model.currencies.RUBIES >= this.terms.selectedValue;
      }
      
      [Bindable(event="propertyChange")]
      public function get group() : OptionGroup
      {
         return this._98629247group;
      }
      
      public function set group(param1:OptionGroup) : void
      {
         var _loc2_:Object = this._98629247group;
         if(_loc2_ !== param1)
         {
            this._98629247group = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"group",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hidden() : Checkbox
      {
         return this._1217487446hidden;
      }
      
      public function set hidden(param1:Checkbox) : void
      {
         var _loc2_:Object = this._1217487446hidden;
         if(_loc2_ !== param1)
         {
            this._1217487446hidden = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hidden",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get terms() : Terms
      {
         return this._110250375terms;
      }
      
      public function set terms(param1:Terms) : void
      {
         var _loc2_:Object = this._110250375terms;
         if(_loc2_ !== param1)
         {
            this._110250375terms = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"terms",_loc2_,param1));
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
      private function get enoughRubies() : Boolean
      {
         return this._1910031992enoughRubies;
      }
      
      private function set enoughRubies(param1:Boolean) : void
      {
         var _loc2_:Object = this._1910031992enoughRubies;
         if(_loc2_ !== param1)
         {
            this._1910031992enoughRubies = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enoughRubies",_loc2_,param1));
            }
         }
      }
   }
}

