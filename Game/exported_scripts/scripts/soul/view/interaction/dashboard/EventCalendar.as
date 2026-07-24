package soul.view.interaction.dashboard
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.interaction.dashboard.DashboardEntry;
   import soul.model.system.Configuration;
   import soul.utils.DateUtils;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientLabel;
   import soul.view.ui.Box;
   import soul.view.ui.BoxDirection;
   import soul.view.ui.ScrollBase;
   
   public class EventCalendar extends ScrollBase
   {
      
      [Bindable("selectedEntryChanged")]
      public var selectedEntry:DashboardEntry;
      
      private var selectedChild:DashboardEntryRenderer;
      
      private var box:Box = new Box();
      
      public function EventCalendar()
      {
         super();
         backgroundColor = 0;
         backgroundAlpha = 0;
         horizontalScrollPolicy = "off";
         verticalScrollPolicy = "on";
         wheelMultiplier = 3;
         this.box.direction = BoxDirection.VERTICAL;
         this.box.gap = 2;
         this.box.padding = 4;
         addChild(this.box);
      }
      
      public function set dataProvider(value:Array) : void
      {
         var currentDate:Date = null;
         var entry:DashboardEntry = null;
         var child:DashboardEntryRenderer = null;
         var localDate:Date = null;
         var group:GradientLabel = null;
         var txt:String = null;
         this.box.removeAllChildren();
         var today:Date = new Date();
         for each(entry in value)
         {
            if(Boolean(entry.date))
            {
               localDate = Configuration.serverDateToLocal(entry.date);
               if(!currentDate || currentDate.fullYear != localDate.fullYear || currentDate.month != localDate.month || currentDate.date != localDate.date)
               {
                  currentDate = localDate;
                  group = new GradientLabel();
                  group.width = 420;
                  group.height = 26;
                  group.align = "center";
                  group.verticalAlign = "middle";
                  group.fontSize = 12;
                  group.color = Colors.GOLD_LIGHT;
                  txt = currentDate.fullYear == today.fullYear && currentDate.month == today.month && currentDate.date == today.date ? LocaleManager.getString(BundleName.INTERFACE,"today") : "";
                  txt += " " + DateUtils.formatDate("d.m.Y",currentDate);
                  group.text = txt;
                  this.box.addChild(group);
               }
            }
            child = new DashboardEntryRenderer();
            child.entry = entry;
            this.box.addChild(child);
            child.addEventListener(MouseEvent.CLICK,this.childClick);
         }
      }
      
      private function childClick(e:MouseEvent) : void
      {
         if(Boolean(this.selectedChild))
         {
            this.selectedChild.selected = false;
         }
         this.selectedChild = e.currentTarget as DashboardEntryRenderer;
         this.selectedChild.selected = true;
         this.selectedEntry = this.selectedChild.entry;
         dispatchEvent(new Event("selectedEntryChanged"));
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.filters.GlowFilter;
import mx.events.PropertyChangeEvent;
import soul.controller.locale.BundleName;
import soul.controller.locale.LocaleManager;
import soul.model.interaction.dashboard.BattlegroundEntry;
import soul.model.interaction.dashboard.CitadelEntry;
import soul.model.interaction.dashboard.DashboardEntry;
import soul.model.system.Configuration;
import soul.utils.DateUtils;
import soul.view.assets.Assets;
import soul.view.assets.Colors;
import soul.view.assets.GradientBox;
import soul.view.chat.ClanIcon;
import soul.view.common.Icons;
import soul.view.ui.BorderedContainer;
import soul.view.ui.Box;
import soul.view.ui.BoxDirection;
import soul.view.ui.CachedImage;
import soul.view.ui.Canvas;
import soul.view.ui.Component;
import soul.view.ui.Container;
import soul.view.ui.Label;

class DashboardEntryRenderer extends Canvas
{
   
   private static const SELECTED_ICON:Array = [new GlowFilter(16711680,1,4,4)];
   
   private static const SELECTED:Array = [[3717862409,127],10097673];
   
   private static const ACTIVE:Array = [[3713796611,127],6031875];
   
   private var bg:GradientBox = new GradientBox();
   
   private var box:Box = new Box();
   
   private var iconHolder:Component = new Component();
   
   private var joinedIcon:CachedImage = new CachedImage();
   
   private var time:Label = new Label();
   
   private var label:Label = new Label();
   
   private var _entry:DashboardEntry;
   
   private var _selected:Boolean;
   
   public function DashboardEntryRenderer()
   {
      super();
      backgroundColor = 0;
      backgroundAlpha = 0;
      width = 420;
      height = 26;
      this.bg.percentWidth = 100;
      this.bg.height = 20;
      this.bg.verticalCenter = 0;
      this.box.left = 0;
      this.box.percentWidth = 100;
      this.box.percentHeight = 100;
      this.box.direction = BoxDirection.HORIZONTAL;
      this.box.verticalAlign = "middle";
      this.box.gap = 15;
      this.iconHolder.width = 56;
      this.iconHolder.height = 26;
      this.joinedIcon.source = Icons.accepted;
      this.joinedIcon.x = 30;
      this.joinedIcon.y = 5;
      this.joinedIcon.visible = false;
      this.iconHolder.addChild(this.joinedIcon);
      this.time.align = "center";
      this.time.width = 45;
      this.time.height = 16;
      this.time.fontSize = 12;
      this.label.percentWidth = 100;
      this.label.fontSize = 12;
      this.time.color = this.label.color = Colors.LABEL;
      addChild(this.bg);
      addChild(this.box);
   }
   
   private function showBg() : void
   {
      if(this._selected)
      {
         this.bg.visible = true;
         this.bg.gradient = SELECTED;
      }
      else if(Boolean(this._entry) && Boolean(this._entry.active))
      {
         this.bg.visible = true;
         this.bg.gradient = ACTIVE;
      }
      else
      {
         this.bg.visible = false;
      }
   }
   
   private function propChanged(e:PropertyChangeEvent) : void
   {
      if(e.property == "joined")
      {
         this.joined = e.newValue;
      }
   }
   
   public function set entry(value:DashboardEntry) : void
   {
      var clanImage:ClanImage = null;
      var icon:CachedImage = null;
      if(Boolean(this._entry))
      {
         value.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.propChanged);
      }
      if(this._entry == value)
      {
         return;
      }
      this._entry = value;
      this._entry.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.propChanged);
      var citadelEntry:CitadelEntry = value as CitadelEntry;
      if(Boolean(citadelEntry) && citadelEntry.clanId > 0)
      {
         clanImage = new ClanImage();
         clanImage.citadelEntry = value as CitadelEntry;
         this.iconHolder.addChild(clanImage);
      }
      else
      {
         icon = new CachedImage();
         icon.source = value.icon;
         this.iconHolder.addChild(icon);
      }
      var clientDate:Date = Configuration.serverDateToLocal(value.date);
      this.time.text = DateUtils.formatDate("HH:i",clientDate);
      this.label.text = this.getEvent(value.localeId);
      this.box.addChild(this.iconHolder);
      this.box.addChild(this.time);
      this.box.addChild(this.label);
      this.joined = value is BattlegroundEntry && BattlegroundEntry(value).joined;
      this.showBg();
      updateNow();
   }
   
   public function get entry() : DashboardEntry
   {
      return this._entry;
   }
   
   private function set joined(value:Boolean) : void
   {
      this.joinedIcon.visible = value;
   }
   
   public function set selected(value:Boolean) : void
   {
      if(this._selected == value)
      {
         return;
      }
      this._selected = value;
      this.iconHolder.filters = value ? SELECTED_ICON : [];
      this.showBg();
   }
   
   private function getEvent(key:String) : String
   {
      return LocaleManager.getString(BundleName.EVENT,key);
   }
}

class ClanImage extends BorderedContainer
{
   
   private var icon:ClanIcon = new ClanIcon();
   
   public function ClanImage()
   {
      super();
      backgroundPadding = 1;
      backgroundColor = 0;
      padding = 4;
      borderSkin = Assets.simpleBorderRound;
      addChild(this.icon);
   }
   
   public function set citadelEntry(value:CitadelEntry) : void
   {
      this.icon.clanId = value.clanId;
      this.icon.toolTip = value.clanName;
   }
}
