package soul.view.interaction.talents
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
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.CloseEvent;
   import soul.event.SimpleUIEvent;
   import soul.event.TalentEvent;
   import soul.model.ability.AbilityModel;
   import soul.model.character.CharacterModel;
   import soul.model.talents.Talent;
   import soul.model.talents.TalentData;
   import soul.model.talents.TalentsModel;
   import soul.net.ServerLayer;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.Container;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.controls.Alert;
   
   use namespace mx_internal;
   
   public class TalentScreen extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _TalentScreen_CachedImage1:CachedImage;
      
      public var _TalentScreen_Label1:Label;
      
      public var _TalentScreen_Label2:Label;
      
      private var _2095990867btnReset:Button1;
      
      private var _3568542tree:TalentTree;
      
      private var _102727412label:String;
      
      private var _104069929model:TalentsModel;
      
      private var _259260447abilityModel:AbilityModel;
      
      private var _340320640characterModel:CharacterModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function TalentScreen()
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
         bindings = this._TalentScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_talents_TalentScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return TalentScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 785;
         this.height = 455;
         this.children = [this._TalentScreen_Container2_c()];
         this.addEventListener("creationComplete",this.___TalentScreen_Container1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         TalentScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("talentsMenu.title");
         this.tree.addEventListener(TalentEvent.PURCHASE,this.onTalentPurchase);
         this.getTalents();
      }
      
      private function getTalents(result:Object = null) : void
      {
         ServerLayer.call("talentService","getPersonalityTalents",this.setTalents);
      }
      
      private function setTalents(value:TalentData) : void
      {
         this.model.load(value);
         this.tree.talents = this.model.talents;
      }
      
      private function onTalentPurchase(e:TalentEvent) : void
      {
         var changes:Object = {};
         var talentId:String = e.id;
         var talent:Talent = this.model.getTalentById(talentId);
         if(!talent)
         {
            return;
         }
         changes[talentId] = talent.ranks + 1;
         ServerLayer.call("talentService","setTalents",this.getTalents,null,changes);
      }
      
      private function resetTalents() : void
      {
         var priceTemplate:String = null;
         var message:String = this.getString("talents.reset.text");
         if(this.model.changePrice > 0)
         {
            priceTemplate = this.getString("talents.reset.price");
            message += "\n" + StringUtil.substitute(priceTemplate,this.model.changePrice,LocaleManager.getString(BundleName.ITEMS,this.model.changeCurrency));
         }
         Alert.show(message,this.getString("talents.reset.title"),Alert.YES | Alert.NO,null,this.resetConfirm);
      }
      
      private function resetConfirm(e:CloseEvent) : void
      {
         if(Boolean(e.detail & Alert.YES))
         {
            ServerLayer.call("talentService","reset",this.getTalents);
         }
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _TalentScreen_Container2_c() : Container
      {
         var _loc1_:Container = new Container();
         _loc1_.children = [this._TalentScreen_CachedImage1_i(),this._TalentScreen_TalentTree1_i(),this._TalentScreen_HBox1_c()];
         return _loc1_;
      }
      
      private function _TalentScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._TalentScreen_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_TalentScreen_CachedImage1",this._TalentScreen_CachedImage1);
         return _loc1_;
      }
      
      private function _TalentScreen_TalentTree1_i() : TalentTree
      {
         var _loc1_:TalentTree = new TalentTree();
         _loc1_.x = 7;
         _loc1_.y = 7;
         this.tree = _loc1_;
         BindingManager.executeBindings(this,"tree",this.tree);
         return _loc1_;
      }
      
      private function _TalentScreen_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.x = 13;
         _loc1_.y = 416;
         _loc1_.width = 754;
         _loc1_.verticalAlign = "middle";
         _loc1_.gap = 10;
         _loc1_.children = [this._TalentScreen_Button11_i(),this._TalentScreen_Component1_c(),this._TalentScreen_Label1_i(),this._TalentScreen_Label2_i()];
         return _loc1_;
      }
      
      private function _TalentScreen_Button11_i() : Button1
      {
         var _loc1_:Button1 = null;
         _loc1_ = new Button1();
         _loc1_.width = 109;
         _loc1_.height = 27;
         _loc1_.addEventListener("click",this.__btnReset_click);
         this.btnReset = _loc1_;
         BindingManager.executeBindings(this,"btnReset",this.btnReset);
         return _loc1_;
      }
      
      public function __btnReset_click(event:MouseEvent) : void
      {
         this.resetTalents();
      }
      
      private function _TalentScreen_Component1_c() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.percentWidth = 100;
         return _loc1_;
      }
      
      private function _TalentScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.fontSize = 12;
         this._TalentScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_TalentScreen_Label1",this._TalentScreen_Label1);
         return _loc1_;
      }
      
      private function _TalentScreen_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.color = 16777215;
         _loc1_.bold = true;
         _loc1_.fontSize = 12;
         this._TalentScreen_Label2 = _loc1_;
         BindingManager.executeBindings(this,"_TalentScreen_Label2",this._TalentScreen_Label2);
         return _loc1_;
      }
      
      public function ___TalentScreen_Container1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _TalentScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.talentPanel;
         },null,"_TalentScreen_CachedImage1.source");
         result[1] = new Binding(this,null,null,"tree.abilityModel","abilityModel");
         result[2] = new Binding(this,function():uint
         {
            return characterModel.properties.LEVEL;
         },null,"tree.level");
         result[3] = new Binding(this,function():uint
         {
            return model.pointsAvailable;
         },null,"tree.pointsAvailable");
         result[4] = new Binding(this,function():String
         {
            var _loc1_:* = getString("reset");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"btnReset.label");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = getString("character.additionalPointsLarge") + ":";
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TalentScreen_Label1.text");
         result[6] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"_TalentScreen_Label1.color");
         result[7] = new Binding(this,function():String
         {
            var _loc1_:* = model.pointsAvailable;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_TalentScreen_Label2.text");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get btnReset() : Button1
      {
         return this._2095990867btnReset;
      }
      
      public function set btnReset(param1:Button1) : void
      {
         var _loc2_:Object = this._2095990867btnReset;
         if(_loc2_ !== param1)
         {
            this._2095990867btnReset = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnReset",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tree() : TalentTree
      {
         return this._3568542tree;
      }
      
      public function set tree(param1:TalentTree) : void
      {
         var _loc2_:Object = this._3568542tree;
         if(_loc2_ !== param1)
         {
            this._3568542tree = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tree",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get label() : String
      {
         return this._102727412label;
      }
      
      public function set label(param1:String) : void
      {
         var _loc2_:Object = this._102727412label;
         if(_loc2_ !== param1)
         {
            this._102727412label = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"label",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : TalentsModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:TalentsModel) : void
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
      public function get characterModel() : CharacterModel
      {
         return this._340320640characterModel;
      }
      
      public function set characterModel(param1:CharacterModel) : void
      {
         var _loc2_:Object = this._340320640characterModel;
         if(_loc2_ !== param1)
         {
            this._340320640characterModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"characterModel",_loc2_,param1));
            }
         }
      }
   }
}

