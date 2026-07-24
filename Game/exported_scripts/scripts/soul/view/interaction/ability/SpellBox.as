package soul.view.interaction.ability
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
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
   import soul.event.SimpleUIEvent;
   import soul.model.ability.Ability;
   import soul.model.ability.AbilityModel;
   import soul.model.ability.AbilitySchool;
   import soul.model.character.CharacterModel;
   import soul.model.character.DispositionGroup;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.ui.CachedImage;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.Tile;
   import soul.view.ui.UIAssets;
   import soul.view.ui.VBox;
   
   use namespace mx_internal;
   
   public class SpellBox extends VBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const EXPANDED:Object = UIAssets.scrollButtonUp;
      
      private static const CLOSED:Object = UIAssets.scrollButtonDown;
      
      private static const GLOW:GlowFilter = new GlowFilter(0,1,12,12,1);
      
      private var _3226745icon:CachedImage;
      
      private var _96390643schoolIcon:CachedImage;
      
      private var _96243681schoolName:Label;
      
      private var _3560110tile:Tile;
      
      private var _340320640characterModel:CharacterModel;
      
      private var _259260447abilityModel:AbilityModel;
      
      public var schoolTab:int;
      
      private var _expanded:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function SpellBox()
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
         bindings = this._SpellBox_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_ability_SpellBoxWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return SpellBox[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.width = 237;
         this.children = [this._SpellBox_GradientBox1_c()];
         this._SpellBox_Tile1_i();
         this.addEventListener("creationComplete",this.___SpellBox_VBox1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         SpellBox._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         this.abilityModel.addEventListener("abilitiesChanged",this.abilitiesChanged,false,0,true);
         this.abilitiesChanged(null);
      }
      
      private function abilitiesChanged(e:Event) : void
      {
         var schools:Array = DispositionGroup.getSchools(this.characterModel.dispositionGroup);
         var school:String = schools[this.schoolTab] || AbilitySchool.OTHER;
         this.schoolName.text = LocaleManager.getAbilitySchool(school);
         this.schoolIcon.source = AbilitySchool.getSchoolIcon(school);
         this.dataProvider = school == AbilitySchool.OTHER ? this.abilityModel.getOtherAbilities(schools) : this.abilityModel.getAbilitiesBySchool(school);
      }
      
      private function onClick() : void
      {
         this.expanded = !this.expanded;
      }
      
      public function set dataProvider(value:Array) : void
      {
         var ability:Ability = null;
         var child:AbilityContainer = null;
         this.tile.removeAllChildren();
         for each(ability in value)
         {
            child = new AbilityContainer();
            child.width = child.height = 36;
            child.ability = ability;
            this.tile.addChild(child);
         }
      }
      
      public function set expanded(value:Boolean) : void
      {
         if(this._expanded == value)
         {
            return;
         }
         this._expanded = value;
         this.icon.source = value ? EXPANDED : CLOSED;
         if(value && !contains(this.tile))
         {
            addChild(this.tile);
         }
         else if(!value && contains(this.tile))
         {
            removeChild(this.tile);
         }
      }
      
      public function get expanded() : Boolean
      {
         return this._expanded;
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _SpellBox_Tile1_i() : Tile
      {
         var _loc1_:Tile = new Tile();
         _loc1_.percentWidth = 100;
         _loc1_.padding = 10;
         _loc1_.gap = 7;
         this.tile = _loc1_;
         BindingManager.executeBindings(this,"tile",this.tile);
         return _loc1_;
      }
      
      private function _SpellBox_GradientBox1_c() : GradientBox
      {
         var _loc1_:GradientBox = new GradientBox();
         _loc1_.percentWidth = 100;
         _loc1_.height = 36;
         _loc1_.children = [this._SpellBox_HBox1_c()];
         _loc1_.addEventListener("click",this.___SpellBox_GradientBox1_click);
         return _loc1_;
      }
      
      private function _SpellBox_HBox1_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalAlign = "middle";
         _loc1_.gap = 3;
         _loc1_.padding = 3;
         _loc1_.children = [this._SpellBox_CachedImage1_i(),this._SpellBox_CachedImage2_i(),this._SpellBox_Label1_i()];
         return _loc1_;
      }
      
      private function _SpellBox_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.icon = _loc1_;
         BindingManager.executeBindings(this,"icon",this.icon);
         return _loc1_;
      }
      
      private function _SpellBox_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.schoolIcon = _loc1_;
         BindingManager.executeBindings(this,"schoolIcon",this.schoolIcon);
         return _loc1_;
      }
      
      private function _SpellBox_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.bold = true;
         this.schoolName = _loc1_;
         BindingManager.executeBindings(this,"schoolName",this.schoolName);
         return _loc1_;
      }
      
      public function ___SpellBox_GradientBox1_click(event:MouseEvent) : void
      {
         this.onClick();
      }
      
      public function ___SpellBox_VBox1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _SpellBox_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Array
         {
            var _loc1_:* = [GLOW];
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"tile.filters");
         result[1] = new Binding(this,function():Object
         {
            return CLOSED;
         },null,"icon.source");
         result[2] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"schoolName.color");
         return result;
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
      public function get schoolIcon() : CachedImage
      {
         return this._96390643schoolIcon;
      }
      
      public function set schoolIcon(param1:CachedImage) : void
      {
         var _loc2_:Object = this._96390643schoolIcon;
         if(_loc2_ !== param1)
         {
            this._96390643schoolIcon = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"schoolIcon",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get schoolName() : Label
      {
         return this._96243681schoolName;
      }
      
      public function set schoolName(param1:Label) : void
      {
         var _loc2_:Object = this._96243681schoolName;
         if(_loc2_ !== param1)
         {
            this._96243681schoolName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"schoolName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tile() : Tile
      {
         return this._3560110tile;
      }
      
      public function set tile(param1:Tile) : void
      {
         var _loc2_:Object = this._3560110tile;
         if(_loc2_ !== param1)
         {
            this._3560110tile = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tile",_loc2_,param1));
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
   }
}

