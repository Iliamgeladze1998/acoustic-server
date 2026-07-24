package soul.view.interaction.dashboard
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
   import soul.model.character.DispositionGroup;
   import soul.model.interaction.dashboard.Combatant;
   import soul.view.assets.Colors;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   
   use namespace mx_internal;
   
   public class CombatantRenderer extends HBox implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _1335772033deaths:Label;
      
      private var _583380919disposition:CachedImage;
      
      private var _102052053kills:Label;
      
      private var _102865796level:Label;
      
      private var _2095657228playerName:Label;
      
      private var _109264530score:Label;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function CombatantRenderer()
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
         bindings = this._CombatantRenderer_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_interaction_dashboard_CombatantRendererWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return CombatantRenderer[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.percentWidth = 100;
         this.height = 26;
         this.gap = 10;
         this.verticalAlign = "middle";
         this.children = [this._CombatantRenderer_Component1_c(),this._CombatantRenderer_CachedImage1_i(),this._CombatantRenderer_HBox2_c(),this._CombatantRenderer_Label3_i(),this._CombatantRenderer_Label4_i(),this._CombatantRenderer_Label5_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         CombatantRenderer._watcherSetupUtil = param1;
      }
      
      public function set color(value:uint) : void
      {
         this.playerName.color = value;
      }
      
      public function set combatant(value:Combatant) : void
      {
         this.disposition.source = DispositionGroup.getIcon(value.disposition);
         this.level.text = "[" + value.level + "]";
         this.playerName.text = value.name;
         this.kills.text = "" + value.kills;
         this.deaths.text = "" + value.deaths;
         if(value.score > 0)
         {
            this.score.text = "" + value.score;
         }
      }
      
      private function _CombatantRenderer_Component1_c() : Component
      {
         return new Component();
      }
      
      private function _CombatantRenderer_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.width = 26;
         _loc1_.height = 26;
         this.disposition = _loc1_;
         BindingManager.executeBindings(this,"disposition",this.disposition);
         return _loc1_;
      }
      
      private function _CombatantRenderer_HBox2_c() : HBox
      {
         var _loc1_:HBox = new HBox();
         _loc1_.gap = 5;
         _loc1_.children = [this._CombatantRenderer_Label1_i(),this._CombatantRenderer_Label2_i()];
         return _loc1_;
      }
      
      private function _CombatantRenderer_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 26;
         this.level = _loc1_;
         BindingManager.executeBindings(this,"level",this.level);
         return _loc1_;
      }
      
      private function _CombatantRenderer_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 132;
         _loc1_.bold = true;
         this.playerName = _loc1_;
         BindingManager.executeBindings(this,"playerName",this.playerName);
         return _loc1_;
      }
      
      private function _CombatantRenderer_Label3_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 26;
         _loc1_.align = "center";
         this.kills = _loc1_;
         BindingManager.executeBindings(this,"kills",this.kills);
         return _loc1_;
      }
      
      private function _CombatantRenderer_Label4_i() : Label
      {
         var _loc1_:Label = null;
         _loc1_ = new Label();
         _loc1_.width = 26;
         _loc1_.align = "center";
         this.deaths = _loc1_;
         BindingManager.executeBindings(this,"deaths",this.deaths);
         return _loc1_;
      }
      
      private function _CombatantRenderer_Label5_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.width = 60;
         _loc1_.align = "center";
         this.score = _loc1_;
         BindingManager.executeBindings(this,"score",this.score);
         return _loc1_;
      }
      
      private function _CombatantRenderer_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"level.color");
         result[1] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"playerName.color");
         result[2] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"kills.color");
         result[3] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"deaths.color");
         result[4] = new Binding(this,function():uint
         {
            return Colors.GOLD_LIGHT;
         },null,"score.color");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get deaths() : Label
      {
         return this._1335772033deaths;
      }
      
      public function set deaths(param1:Label) : void
      {
         var _loc2_:Object = this._1335772033deaths;
         if(_loc2_ !== param1)
         {
            this._1335772033deaths = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"deaths",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get disposition() : CachedImage
      {
         return this._583380919disposition;
      }
      
      public function set disposition(param1:CachedImage) : void
      {
         var _loc2_:Object = this._583380919disposition;
         if(_loc2_ !== param1)
         {
            this._583380919disposition = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"disposition",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get kills() : Label
      {
         return this._102052053kills;
      }
      
      public function set kills(param1:Label) : void
      {
         var _loc2_:Object = this._102052053kills;
         if(_loc2_ !== param1)
         {
            this._102052053kills = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"kills",_loc2_,param1));
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
      public function get playerName() : Label
      {
         return this._2095657228playerName;
      }
      
      public function set playerName(param1:Label) : void
      {
         var _loc2_:Object = this._2095657228playerName;
         if(_loc2_ !== param1)
         {
            this._2095657228playerName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get score() : Label
      {
         return this._109264530score;
      }
      
      public function set score(param1:Label) : void
      {
         var _loc2_:Object = this._109264530score;
         if(_loc2_ !== param1)
         {
            this._109264530score = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"score",_loc2_,param1));
            }
         }
      }
   }
}

