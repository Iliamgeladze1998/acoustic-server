package soul.view.interaction.clan
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.model.interaction.clan.ClanSack;
   import soul.view.ui.HBox;
   
   [Event(name="selectedIndexChanged",type="flash.events.Event")]
   public class ClanSacks extends HBox
   {
      
      private var selectedChild:SackIconRenderer;
      
      private var _selectedIndex:int = -1;
      
      public function ClanSacks()
      {
         super();
      }
      
      public function set dataProvider(value:Array) : void
      {
         var sack:ClanSack = null;
         var child:SackIconRenderer = null;
         removeAllChildren();
         var firstAvailableIndex:int = -1;
         for(var i:int = 0; i < value.length; i++)
         {
            sack = value[i];
            child = new SackIconRenderer();
            child.sack = sack;
            if(sack.enabled && firstAvailableIndex == -1)
            {
               firstAvailableIndex = i;
            }
            child.addEventListener(MouseEvent.CLICK,this.childClicked);
            addChild(child);
         }
         if(firstAvailableIndex != -1)
         {
            this.selectedIndex = firstAvailableIndex;
         }
      }
      
      private function childClicked(e:MouseEvent) : void
      {
         var child:SackIconRenderer = e.target as SackIconRenderer;
         if(!child || !child.enabled)
         {
            return;
         }
         this.selectedIndex = getChildIndex(child);
      }
      
      [Bindable("selectedIndexChanged")]
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(value:int) : void
      {
         if(this._selectedIndex == value)
         {
            return;
         }
         var child:SackIconRenderer = getChildAt(value) as SackIconRenderer;
         if(Boolean(child))
         {
            this._selectedIndex = value;
            if(Boolean(this.selectedChild))
            {
               this.selectedChild.selected = false;
            }
            this.selectedChild = child;
            child.selected = true;
            dispatchEvent(new Event("selectedIndexChanged"));
         }
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import soul.controller.locale.BundleName;
import soul.controller.locale.LocaleManager;
import soul.model.interaction.clan.ClanSack;
import soul.model.interaction.clan.StaticClanRole;
import soul.view.assets.Assets;
import soul.view.assets.Colors;
import soul.view.ui.CachedImage;
import soul.view.ui.Component;

class SackIconRenderer extends Component
{
   
   private var splash:CachedImage = new CachedImage();
   
   private var icon:CachedImage = new CachedImage();
   
   private var _sack:ClanSack;
   
   public function SackIconRenderer()
   {
      super();
      mouseChildren = false;
      width = 50;
      height = 46;
      this.splash.source = Assets.clanSackEmpty;
      this.icon.x = 5;
      this.icon.y = 2;
      addChild(this.splash);
      addChild(this.icon);
      this.selected = false;
   }
   
   public function get sack() : ClanSack
   {
      return this._sack;
   }
   
   public function set sack(value:ClanSack) : void
   {
      if(this._sack == value)
      {
         return;
      }
      this._sack = value;
      var role:String = value.role;
      this.icon.source = StaticClanRole.getSackIcon(role);
      toolTip = Boolean(value) ? LocaleManager.getString(BundleName.INTERFACE,"clan.storage." + role) : null;
      if(!value.enabled)
      {
         filters = Colors.DISABLED_FILTER;
      }
   }
   
   public function set selected(value:Boolean) : void
   {
      this.icon.alpha = value ? 1 : 0.7;
   }
   
   override public function get enabled() : Boolean
   {
      return Boolean(this._sack) ? Boolean(this._sack.enabled) : false;
   }
}
