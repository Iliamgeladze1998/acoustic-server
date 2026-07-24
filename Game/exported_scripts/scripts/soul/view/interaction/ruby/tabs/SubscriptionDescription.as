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
   import soul.model.character.CharacterModel;
   import soul.model.interaction.ruby.Subscription;
   import soul.model.interaction.ruby.SubscriptionType;
   import soul.model.system.Configuration;
   import soul.utils.DateUtils;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class SubscriptionDescription extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _SubscriptionDescription_CachedImage1:CachedImage;
      
      public var _SubscriptionDescription_Label1:Label;
      
      public var _SubscriptionDescription_Label2:Label;
      
      public var _SubscriptionDescription_Label3:Label;
      
      private var _97739box:VBox;
      
      private var _100029145icon2:CachedImage;
      
      private var _1110417474label2:Label;
      
      private var _104069929model:CharacterModel;
      
      private var _subscription:Subscription;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SubscriptionDescription()
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
         bindings = this._SubscriptionDescription_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_ruby_tabs_SubscriptionDescriptionWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return SubscriptionDescription[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.gap = 5;
         this.children = [this._SubscriptionDescription_GradientBox1_c(),this._SubscriptionDescription_GradientBox2_c(),this._SubscriptionDescription_ScrollBase1_c()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SubscriptionDescription._watcherSetupUtil = param1;
      }
      
      public function getCurSubscription(type:String, expire:Date, renew:Boolean) : String
      {
         var str:String = null;
         if(type == null)
         {
            return this.getString("subscription.noSubscription");
         }
         var date:Date = new Date();
         var period:String = DateUtils.getTimeLeft(expire.time - date.time);
         return LocaleManager.getSubscriptionName(type) + " (" + period + ") " + (renew ? this.getString("subscription.auto") : "");
      }
      
      public function set subscription(value:Subscription) : void
      {
         var bonusType:String = null;
         var bonusValue:Number = NaN;
         if(this._subscription == value)
         {
            return;
         }
         this._subscription = value;
         this.box.removeAllChildren();
         if(!value)
         {
            return;
         }
         this.icon2.source = SubscriptionType.getSmallIcon(value.type);
         this.label2.text = LocaleManager.getSubscriptionName(value.type);
         for(bonusType in value.bonus.add)
         {
            bonusValue = Number(value.bonus.add[bonusType]);
            this.box.addChild(this.createBonus(Configuration.getBonusImage(bonusType),this.getString(bonusType) + " " + (bonusValue > 0 ? "+" : "") + bonusValue));
         }
         for(bonusType in value.bonus.mult)
         {
            bonusValue = Number(value.bonus.mult[bonusType]);
            this.box.addChild(this.createBonus(Configuration.getBonusImage(bonusType),this.getString(bonusType) + " " + (bonusValue > 0 ? "+" : "") + bonusValue * 100 + "%"));
         }
         for(bonusType in value.otherBonuses)
         {
            bonusValue = Number(value.otherBonuses[bonusType]);
            this.box.addChild(this.createBonus(Configuration.getBonusImage(bonusType),this.getString(bonusType) + " " + (bonusValue > 0 ? "+" : "") + bonusValue * 100 + "%"));
         }
      }
      
      private function createBonus(src:Object, text:String) : Component
      {
         var label:Label = null;
         label = new Label();
         label.text = text;
         return label;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _SubscriptionDescription_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 50;
         _loc1_.children = [this._SubscriptionDescription_Label1_i(),this._SubscriptionDescription_HBox1_c()];
         return _loc1_;
      }
      
      private function _SubscriptionDescription_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         this._SubscriptionDescription_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_SubscriptionDescription_Label1",this._SubscriptionDescription_Label1);
         return _loc1_;
      }
      
      private function _SubscriptionDescription_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.verticalAlign = "middle";
         _loc1_.bottom = 0;
         _loc1_.padding = 5;
         _loc1_.gap = 5;
         _loc1_.children = [this._SubscriptionDescription_CachedImage1_i(),this._SubscriptionDescription_Label2_i()];
         return _loc1_;
      }
      
      private function _SubscriptionDescription_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._SubscriptionDescription_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_SubscriptionDescription_CachedImage1",this._SubscriptionDescription_CachedImage1);
         return _loc1_;
      }
      
      private function _SubscriptionDescription_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         this._SubscriptionDescription_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_SubscriptionDescription_Label2",this._SubscriptionDescription_Label2);
         return _loc1_;
      }
      
      private function _SubscriptionDescription_GradientBox2_c() : GradientBox
      {
         var _loc1_:GradientBox = null;
         _loc1_ = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 50;
         _loc1_.children = [this._SubscriptionDescription_Label3_i(),this._SubscriptionDescription_HBox2_c()];
         return _loc1_;
      }
      
      private function _SubscriptionDescription_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         this._SubscriptionDescription_Label3 = _loc1_;
         BindingManager.executeBindings(this,"_SubscriptionDescription_Label3",this._SubscriptionDescription_Label3);
         return _loc1_;
      }
      
      private function _SubscriptionDescription_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.verticalAlign = "middle";
         _loc1_.bottom = 0;
         _loc1_.padding = 5;
         _loc1_.gap = 5;
         _loc1_.children = [this._SubscriptionDescription_CachedImage2_i(),this._SubscriptionDescription_Label4_i()];
         return _loc1_;
      }
      
      private function _SubscriptionDescription_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.icon2 = _loc1_;
         BindingManager.executeBindings(this,"icon2",this.icon2);
         return _loc1_;
      }
      
      private function _SubscriptionDescription_Label4_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         this.label2 = _loc1_;
         BindingManager.executeBindings(this,"label2",this.label2);
         return _loc1_;
      }
      
      private function _SubscriptionDescription_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._SubscriptionDescription_VBox2_i()];
         return _loc1_;
      }
      
      private function _SubscriptionDescription_VBox2_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.padding = 5;
         _loc1_.gap = 2;
         this.box = _loc1_;
         BindingManager.executeBindings(this,"box",this.box);
         return _loc1_;
      }
      
      private function _SubscriptionDescription_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = " - " + getString("subscription.current") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SubscriptionDescription_Label1.text");
         result[1] = new Binding(this,function():Object
         {
            return SubscriptionType.getSmallIcon(model.subscriptionType);
         },null,"_SubscriptionDescription_CachedImage1.source");
         result[2] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_SubscriptionDescription_Label2.color");
         result[3] = new Binding(this,function():String
         {
            var _loc1_:* = getCurSubscription(model.subscriptionType,model.subscriptionExpire,model.subscriptionRenew);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SubscriptionDescription_Label2.text");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = " - " + getString("subscription.selected") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_SubscriptionDescription_Label3.text");
         result[5] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"label2.color");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get box() : VBox
      {
         return this._97739box;
      }
      
      public function set box(param1:VBox) : void
      {
         var _loc2_:Object = this._97739box;
         if(_loc2_ !== param1)
         {
            this._97739box = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"box",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get icon2() : CachedImage
      {
         return this._100029145icon2;
      }
      
      public function set icon2(param1:CachedImage) : void
      {
         var _loc2_:Object = this._100029145icon2;
         if(_loc2_ !== param1)
         {
            this._100029145icon2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"icon2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get label2() : Label
      {
         return this._1110417474label2;
      }
      
      public function set label2(param1:Label) : void
      {
         var _loc2_:Object = this._1110417474label2;
         if(_loc2_ !== param1)
         {
            this._1110417474label2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"label2",_loc2_,param1));
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
   }
}

