package soul.view.interaction.clan
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.model.interaction.clan.ClanBonus;
   import soul.view.ui.Tile;
   
   [Event(name="change",type="flash.events.Event")]
   public class ClanBonuses extends Tile
   {
      
      public var selectedBonus:ClanBonus;
      
      private var _dataProvider:Array;
      
      public function ClanBonuses()
      {
         super();
         padding = 5;
         gap = 5;
      }
      
      public function unselect() : void
      {
         this.selectChild(null);
      }
      
      public function set dataPovider(value:Array) : void
      {
         var bonus:ClanBonus = null;
         var child:ClanBonusRenderer = null;
         if(this._dataProvider == value)
         {
            return;
         }
         this._dataProvider = value;
         removeAllChildren();
         for each(bonus in value)
         {
            child = new ClanBonusRenderer();
            child.bonus = bonus;
            child.addEventListener(MouseEvent.CLICK,this.childClick);
            addChild(child);
         }
      }
      
      private function childClick(e:Event) : void
      {
         var child:ClanBonusRenderer = e.currentTarget as ClanBonusRenderer;
         if(child.selected)
         {
            this.selectChild(null);
            this.selectedBonus = null;
         }
         else
         {
            this.selectChild(child);
            this.selectedBonus = child.bonus;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function selectChild(selectedChild:ClanBonusRenderer) : void
      {
         var child:ClanBonusRenderer = null;
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i) as ClanBonusRenderer;
            if(child == selectedChild)
            {
               child.selected = true;
            }
            else
            {
               child.selected = false;
            }
         }
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.filters.GlowFilter;
import mx.events.PropertyChangeEvent;
import soul.controller.locale.LocaleManager;
import soul.model.interaction.clan.ClanBonus;
import soul.model.system.Configuration;
import soul.view.assets.Assets;
import soul.view.toolTip.ToolTipManager;
import soul.view.ui.CachedImage;
import soul.view.ui.Component;
import soul.view.ui.Label;

class ClanBonusRenderer extends Component
{
   
   private static const selectedFilters:Array = [new GlowFilter(7864098)];
   
   private static const labelFilters:Array = [new GlowFilter(0,1,4,4,5)];
   
   private var bg:CachedImage = new CachedImage();
   
   private var icon:CachedImage = new CachedImage();
   
   private var label:Label = new Label();
   
   private var _bonus:ClanBonus;
   
   private var _selected:Boolean;
   
   public function ClanBonusRenderer()
   {
      super();
      width = 50;
      height = 70;
      this.label.y = 52;
      this.label.filters = labelFilters;
      this.label.width = 50;
      this.label.height = 20;
      this.label.align = "center";
      this.bg.source = Assets.clanBonusFrame;
      this.icon.x = 3;
      this.icon.y = 3;
      addChild(this.bg);
      addChild(this.icon);
      addChild(this.label);
   }
   
   public function set bonus(value:ClanBonus) : void
   {
      this._bonus = value;
      IEventDispatcher(this._bonus).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.bonusUpdated);
      this.bonusUpdated();
   }
   
   public function get bonus() : ClanBonus
   {
      return this._bonus;
   }
   
   private function bonusUpdated(e:Event = null) : void
   {
      this.icon.source = Configuration.getImage(this._bonus.imagePath);
      ToolTipManager.register(this,LocaleManager.getItemName(this._bonus.localeId) + "\n\n" + LocaleManager.getItemDescription(this._bonus.localeId));
      this.label.text = this._bonus.rank + "/" + this._bonus.max;
   }
   
   public function set selected(value:Boolean) : void
   {
      this._selected = value;
      this.bg.filters = value ? selectedFilters : [];
   }
   
   public function get selected() : Boolean
   {
      return this._selected;
   }
}
