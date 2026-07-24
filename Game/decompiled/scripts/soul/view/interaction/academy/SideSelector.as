package soul.view.interaction.academy
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.model.character.Side;
   import soul.view.assets.Assets;
   import soul.view.ui.Container;
   
   public class SideSelector extends Container
   {
      
      private var empire:SideChoise = new SideChoise();
      
      private var wasteland:SideChoise = new SideChoise();
      
      private var _selectedSide:String;
      
      public function SideSelector()
      {
         super();
         this.empire.source = Assets.empire;
         this.wasteland.source = Assets.wasteland;
         this.empire.x = 65;
         this.wasteland.x = 255;
         addChild(this.empire);
         addChild(this.wasteland);
         this.empire.addEventListener(MouseEvent.CLICK,this.sideClick);
         this.wasteland.addEventListener(MouseEvent.CLICK,this.sideClick);
      }
      
      private function sideClick(e:MouseEvent) : void
      {
         this.selectedSide = e.currentTarget == this.empire ? Side.GREAT_EMPIRE : Side.WASTELAND;
      }
      
      [Bindable("selectedSideChanged")]
      public function set selectedSide(value:String) : void
      {
         if(this._selectedSide == value)
         {
            return;
         }
         this._selectedSide = value;
         this.empire.selected = value == Side.GREAT_EMPIRE;
         this.wasteland.selected = value == Side.WASTELAND;
         dispatchEvent(new Event("selectedSideChanged"));
      }
      
      public function get selectedSide() : String
      {
         return this._selectedSide;
      }
      
      public function set empireEnabled(value:Boolean) : void
      {
         this.empire.enabled = value;
      }
      
      public function set wastelandEnabled(value:Boolean) : void
      {
         this.wasteland.enabled = value;
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.filters.DropShadowFilter;
import flash.filters.GlowFilter;
import soul.view.assets.Colors;
import soul.view.ui.CachedImage;
import soul.view.ui.Component;

class SideChoise extends CachedImage
{
   
   private static const SELECTED:Array = [new GlowFilter(16755200,0.75,20,20)];
   
   private static const NORMAL:Array = [new DropShadowFilter(7,45,0,0.5)];
   
   private var _selected:Boolean;
   
   public function SideChoise()
   {
      super();
      this.applyState();
   }
   
   private function applyState() : void
   {
      if(!_enabled)
      {
         filters = Colors.DISABLED_ALPHA_FILTER;
      }
      else
      {
         filters = this._selected ? SELECTED : NORMAL;
      }
   }
   
   override public function set enabled(value:Boolean) : void
   {
      if(_enabled == value)
      {
         return;
      }
      _enabled = value;
      mouseEnabled = value;
      this.applyState();
   }
   
   public function set selected(value:Boolean) : void
   {
      if(this._selected == value)
      {
         return;
      }
      this._selected = value;
      this.applyState();
   }
}
