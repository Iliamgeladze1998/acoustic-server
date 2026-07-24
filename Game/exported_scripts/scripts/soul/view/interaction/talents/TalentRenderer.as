package soul.view.interaction.talents
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
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
   import soul.model.system.Configuration;
   import soul.model.talents.Talent;
   import soul.model.talents.TalentRankDetail;
   import soul.view.assets.Assets;
   import soul.view.assets.Button1;
   import soul.view.interaction.ability.AbilityContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   
   use namespace mx_internal;
   
   public class TalentRenderer extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const DISABLED_FILTER:Array = [new ColorMatrixFilter([0.333,0.333,0.333,0,0,0.333,0.333,0.333,0,0,0.333,0.333,0.333,0,0,0,0,0,1,0])];
      
      private static const LABEL_GLOW:Array = [new GlowFilter(0,1,4,4,4)];
      
      public var _TalentRenderer_CachedImage2:CachedImage;
      
      private var _1200507606ability:AbilityContainer;
      
      private var _3059661cost:Label;
      
      private var _1557721666details:HBox;
      
      private var _3226745icon:CachedImage;
      
      private var _102727412label:Label;
      
      private var _102865796level:Label;
      
      private var _563971436plusButton:Button1;
      
      public var abilityModel:AbilityModel;
      
      public var characterLevel:uint;
      
      public var pointsAvailable:uint;
      
      private var nextRankDetail:TalentRankDetail;
      
      private var _talent:Talent;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function TalentRenderer()
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
         bindings = this._TalentRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_talents_TalentRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return TalentRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 124;
         this.height = 95;
         this.backgroundColor = 0;
         this.children = [this._TalentRenderer_AbilityContainer1_i(),this._TalentRenderer_CachedImage1_i(),this._TalentRenderer_HBox1_i(),this._TalentRenderer_CachedImage2_i(),this._TalentRenderer_Label1_i(),this._TalentRenderer_Button11_i(),this._TalentRenderer_Label2_i(),this._TalentRenderer_Label3_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         TalentRenderer._watcherSetupUtil = param1;
      }
      
      private function plus() : void
      {
         if(!this.nextRankDetail)
         {
            return;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function set talent(value:Talent) : void
      {
         var levelEnough:Boolean = false;
         var plusVisible:Boolean = false;
         var trd:TalentRankDetail = null;
         var trr:TalentRankRenderer = null;
         this._talent = value;
         if(!value)
         {
            return;
         }
         this.label.text = LocaleManager.getString(BundleName.TALENTS,value.id);
         var currentRankIndex:int = value.ranks > 0 ? int(value.ranks - 1) : 0;
         var currentRankDetail:TalentRankDetail = value.rankDetails[currentRankIndex];
         this.nextRankDetail = value.rankDetails[value.ranks];
         if(Boolean(this.nextRankDetail))
         {
            this.cost.text = String(this.nextRankDetail.cost);
            levelEnough = this.nextRankDetail.level <= this.characterLevel;
            if(!levelEnough)
            {
               this.level.text = this.getString("lvl") + ": " + this.nextRankDetail.level;
            }
            plusVisible = this.nextRankDetail.cost <= this.pointsAvailable && levelEnough;
            this.enabled = value.ranks > 0 || plusVisible;
            this.plusButton.visible = plusVisible;
         }
         if(Boolean(currentRankDetail.ability))
         {
            this.ability.visible = true;
            this.icon.visible = false;
            this.ability.ability = this.abilityModel.getAbilityById(currentRankDetail.ability);
         }
         else
         {
            this.ability.visible = false;
            this.icon.visible = true;
            this.icon.source = Configuration.getTalentIconUrl(value.id);
         }
         for(var i:uint = 0; i < value.rankDetails.length; i++)
         {
            trd = value.rankDetails[i];
            if(!trd)
            {
               break;
            }
            trd.talentId = value.id;
            trr = new TalentRankRenderer();
            trr.rank = i;
            trr.abilityModel = this.abilityModel;
            trr.detail = value.rankDetails[i];
            trr.learned = i < value.ranks;
            this.details.addChild(trr);
         }
      }
      
      public function get talent() : Talent
      {
         return this._talent;
      }
      
      override public function set enabled(value:Boolean) : void
      {
         filters = value ? [] : DISABLED_FILTER;
         alpha = value ? 1 : 0.7;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _TalentRenderer_AbilityContainer1_i() : AbilityContainer
      {
         var _loc1_:AbilityContainer = new AbilityContainer();
         _loc1_.width = 41;
         _loc1_.height = 41;
         _loc1_.x = 8;
         _loc1_.y = 26;
         _loc1_.borderSkin = "null";
         _loc1_.glowSource = "null";
         this.ability = _loc1_;
         BindingManager.executeBindings(this,"ability",this.ability);
         return _loc1_;
      }
      
      private function _TalentRenderer_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.width = 41;
         _loc1_.height = 41;
         _loc1_.x = 8;
         _loc1_.y = 26;
         _loc1_.showIcon = true;
         this.icon = _loc1_;
         BindingManager.executeBindings(this,"icon",this.icon);
         return _loc1_;
      }
      
      private function _TalentRenderer_HBox1_i() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.x = 2;
         _loc1_.y = 81;
         _loc1_.gap = 2;
         this.details = _loc1_;
         BindingManager.executeBindings(this,"details",this.details);
         return _loc1_;
      }
      
      private function _TalentRenderer_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.mouseEnabled = false;
         this._TalentRenderer_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_TalentRenderer_CachedImage2",this._TalentRenderer_CachedImage2);
         return _loc1_;
      }
      
      private function _TalentRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.truncateToFit = true;
         _loc1_.x = 3;
         _loc1_.y = 3;
         _loc1_.width = 120;
         _loc1_.color = 15658734;
         this.label = _loc1_;
         BindingManager.executeBindings(this,"label",this.label);
         return _loc1_;
      }
      
      private function _TalentRenderer_Button11_i() : Button1
      {
         var _loc1_:Button1 = new Button1();
         _loc1_.x = 67;
         _loc1_.y = 24;
         _loc1_.width = 30;
         _loc1_.height = 30;
         _loc1_.visible = false;
         _loc1_.addEventListener("click",this.__plusButton_click);
         this.plusButton = _loc1_;
         BindingManager.executeBindings(this,"plusButton",this.plusButton);
         return _loc1_;
      }
      
      public function __plusButton_click(event:MouseEvent) : void
      {
         this.plus();
      }
      
      private function _TalentRenderer_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 98;
         _loc1_.y = 30;
         _loc1_.width = 18;
         _loc1_.align = "right";
         _loc1_.color = 14540253;
         this.cost = _loc1_;
         BindingManager.executeBindings(this,"cost",this.cost);
         return _loc1_;
      }
      
      private function _TalentRenderer_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.x = 55;
         _loc1_.y = 55;
         _loc1_.width = 61;
         _loc1_.align = "right";
         _loc1_.color = 14540253;
         this.level = _loc1_;
         BindingManager.executeBindings(this,"level",this.level);
         return _loc1_;
      }
      
      private function _TalentRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Object
         {
            return Assets.talentFrame;
         },null,"_TalentRenderer_CachedImage2.source");
         result[1] = new Binding(this,function():Object
         {
            return Assets.talentPlus;
         },null,"plusButton.icon");
         result[2] = new Binding(this,function():Array
         {
            var _loc1_:* = LABEL_GLOW;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"cost.filters");
         result[3] = new Binding(this,function():Array
         {
            var _loc1_:* = LABEL_GLOW;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"level.filters");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get ability() : AbilityContainer
      {
         return this._1200507606ability;
      }
      
      public function set ability(param1:AbilityContainer) : void
      {
         var _loc2_:Object = this._1200507606ability;
         if(_loc2_ !== param1)
         {
            this._1200507606ability = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ability",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cost() : Label
      {
         return this._3059661cost;
      }
      
      public function set cost(param1:Label) : void
      {
         var _loc2_:Object = this._3059661cost;
         if(_loc2_ !== param1)
         {
            this._3059661cost = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cost",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get details() : HBox
      {
         return this._1557721666details;
      }
      
      public function set details(param1:HBox) : void
      {
         var _loc2_:Object = this._1557721666details;
         if(_loc2_ !== param1)
         {
            this._1557721666details = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"details",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get icon() : CachedImage
      {
         return this._3226745icon;
      }
      
      public function set icon(param1:CachedImage) : void
      {
         var _loc2_:Object = this._3226745icon;
         if(_loc2_ !== param1)
         {
            this._3226745icon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"icon",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get label() : Label
      {
         return this._102727412label;
      }
      
      public function set label(param1:Label) : void
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
      public function get level() : Label
      {
         return this._102865796level;
      }
      
      public function set level(param1:Label) : void
      {
         var _loc2_:Object = this._102865796level;
         if(_loc2_ !== param1)
         {
            this._102865796level = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"level",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get plusButton() : Button1
      {
         return this._563971436plusButton;
      }
      
      public function set plusButton(param1:Button1) : void
      {
         var _loc2_:Object = this._563971436plusButton;
         if(_loc2_ !== param1)
         {
            this._563971436plusButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"plusButton",_loc2_,param1));
            }
         }
      }
   }
}

