package soul.view.interaction.ruby.tabs
{
   import flash.events.MouseEvent;
   import mx.events.PropertyChangeEvent;
   import soul.model.ability.AbilityModel;
   import soul.model.location.temple.AbilityCast;
   import soul.view.ui.Tile;
   
   public class Blessings extends Tile
   {
      
      private var _1267360574selectedBlessing:AbilityCast;
      
      public var model:AbilityModel;
      
      private var selectedChild:BlessingRenderer;
      
      public function Blessings()
      {
         super();
         padding = 10;
         gap = 20;
      }
      
      public function set dataProvider(value:Array) : void
      {
         var ac:AbilityCast = null;
         var child:BlessingRenderer = null;
         removeAllChildren();
         for each(ac in value)
         {
            child = new BlessingRenderer();
            child.model = this.model;
            child.abilityCast = ac;
            child.addEventListener(MouseEvent.CLICK,this.childClick);
            addChild(child);
         }
         this.selectChild(getChildAt(0) as BlessingRenderer);
      }
      
      private function childClick(e:MouseEvent) : void
      {
         this.selectChild(e.currentTarget as BlessingRenderer);
      }
      
      private function selectChild(child:BlessingRenderer) : void
      {
         if(Boolean(this.selectedChild))
         {
            this.selectedChild.selected = false;
         }
         this.selectedChild = child;
         this.selectedChild.selected = true;
         this.selectedBlessing = this.selectedChild.abilityCast;
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedBlessing() : AbilityCast
      {
         return this._1267360574selectedBlessing;
      }
      
      public function set selectedBlessing(param1:AbilityCast) : void
      {
         var _loc2_:Object = this._1267360574selectedBlessing;
         if(_loc2_ !== param1)
         {
            this._1267360574selectedBlessing = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedBlessing",_loc2_,param1));
            }
         }
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.filters.GlowFilter;
import soul.model.ability.AbilityModel;
import soul.model.location.temple.AbilityCast;
import soul.view.interaction.ability.AbilityRenderer;
import soul.view.ui.Component;

class BlessingRenderer extends Component
{
   
   private static const SELECTED_FILTERS:Array = [new GlowFilter(7864098)];
   
   public var model:AbilityModel;
   
   private var ar:AbilityRenderer = new AbilityRenderer();
   
   private var _abilityCast:AbilityCast;
   
   public function BlessingRenderer()
   {
      super();
      this.ar.width = this.ar.height = width = height = 48;
      this.ar.checkStats = false;
      this.ar.checkItems = false;
      addChild(this.ar);
   }
   
   public function set abilityCast(value:AbilityCast) : void
   {
      if(this._abilityCast == value)
      {
         return;
      }
      this._abilityCast = value;
      this.ar.abilityModel = this.model;
      this.ar.abilityId = value.abilityId;
   }
   
   public function get abilityCast() : AbilityCast
   {
      return this._abilityCast;
   }
   
   public function set selected(value:Boolean) : void
   {
      filters = value ? SELECTED_FILTERS : [];
   }
}
