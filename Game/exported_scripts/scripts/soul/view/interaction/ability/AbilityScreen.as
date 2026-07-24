package soul.view.interaction.ability
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
   import soul.event.SimpleUIEvent;
   import soul.model.ability.AbilityModel;
   import soul.model.character.CharacterModel;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class AbilityScreen extends BorderedContainer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _AbilityScreen_SpellBox1:SpellBox;
      
      public var _AbilityScreen_SpellBox2:SpellBox;
      
      public var _AbilityScreen_SpellBox3:SpellBox;
      
      public var _AbilityScreen_SpellBox4:SpellBox;
      
      private var _102727412label:String;
      
      private var _259260447abilityModel:AbilityModel;
      
      private var _340320640characterModel:CharacterModel;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function AbilityScreen()
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
         bindings = this._AbilityScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_ability_AbilityScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return AbilityScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 261;
         this.height = 357;
         this.gap = 5;
         this.direction = "vertical";
         this.children = [this._AbilityScreen_ScrollBase1_c()];
         this.addEventListener("creationComplete",this.___AbilityScreen_BorderedContainer1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         AbilityScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         InteractionWindow.findInteractionParent(this).label = this.getString("abilities.title");
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _AbilityScreen_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._AbilityScreen_VBox1_c()];
         return _loc1_;
      }
      
      private function _AbilityScreen_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.gap = 3;
         _loc1_.children = [this._AbilityScreen_SpellBox1_i(),this._AbilityScreen_SpellBox2_i(),this._AbilityScreen_SpellBox3_i(),this._AbilityScreen_SpellBox4_i()];
         return _loc1_;
      }
      
      private function _AbilityScreen_SpellBox1_i() : SpellBox
      {
         var _loc1_:SpellBox = new SpellBox();
         _loc1_.schoolTab = 0;
         _loc1_.expanded = true;
         this._AbilityScreen_SpellBox1 = _loc1_;
         BindingManager.executeBindings(this,"_AbilityScreen_SpellBox1",this._AbilityScreen_SpellBox1);
         return _loc1_;
      }
      
      private function _AbilityScreen_SpellBox2_i() : SpellBox
      {
         var _loc1_:SpellBox = new SpellBox();
         _loc1_.schoolTab = 1;
         _loc1_.expanded = true;
         this._AbilityScreen_SpellBox2 = _loc1_;
         BindingManager.executeBindings(this,"_AbilityScreen_SpellBox2",this._AbilityScreen_SpellBox2);
         return _loc1_;
      }
      
      private function _AbilityScreen_SpellBox3_i() : SpellBox
      {
         var _loc1_:SpellBox = new SpellBox();
         _loc1_.schoolTab = 2;
         _loc1_.expanded = true;
         this._AbilityScreen_SpellBox3 = _loc1_;
         BindingManager.executeBindings(this,"_AbilityScreen_SpellBox3",this._AbilityScreen_SpellBox3);
         return _loc1_;
      }
      
      private function _AbilityScreen_SpellBox4_i() : SpellBox
      {
         var _loc1_:SpellBox = new SpellBox();
         _loc1_.schoolTab = 3;
         _loc1_.expanded = true;
         this._AbilityScreen_SpellBox4 = _loc1_;
         BindingManager.executeBindings(this,"_AbilityScreen_SpellBox4",this._AbilityScreen_SpellBox4);
         return _loc1_;
      }
      
      public function ___AbilityScreen_BorderedContainer1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _AbilityScreen_bindingsSetup() : Array
      {
         var _loc1_:Array = [];
         _loc1_[0] = new Binding(this,null,null,"_AbilityScreen_SpellBox1.abilityModel","abilityModel");
         _loc1_[1] = new Binding(this,null,null,"_AbilityScreen_SpellBox1.characterModel","characterModel");
         _loc1_[2] = new Binding(this,null,null,"_AbilityScreen_SpellBox2.abilityModel","abilityModel");
         _loc1_[3] = new Binding(this,null,null,"_AbilityScreen_SpellBox2.characterModel","characterModel");
         _loc1_[4] = new Binding(this,null,null,"_AbilityScreen_SpellBox3.abilityModel","abilityModel");
         _loc1_[5] = new Binding(this,null,null,"_AbilityScreen_SpellBox3.characterModel","characterModel");
         _loc1_[6] = new Binding(this,null,null,"_AbilityScreen_SpellBox4.abilityModel","abilityModel");
         _loc1_[7] = new Binding(this,null,null,"_AbilityScreen_SpellBox4.characterModel","characterModel");
         return _loc1_;
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

