package soul.view.rtm
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import soul.event.FieldEvent;
   import soul.event.MiniMapEvent;
   import soul.model.character.CharacterModel;
   import soul.model.field.FieldUnit;
   import soul.model.field.mapconfig.AspectRatio;
   import soul.model.interaction.quest.QuestDetail;
   import soul.model.rtm.MiniMapModel;
   import soul.model.rtm.RTMModel;
   import soul.view.assets.Assets;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   
   public class MiniMap extends Component
   {
      
      private static const TOP:uint = 18;
      
      private static const RADIUS:uint = 70;
      
      private static const POI_RADIUS:uint = 63;
      
      private static const CENTER:Point = new Point(72,68);
      
      private static const RAD_TO_ANG:Number = 180 / Math.PI;
      
      public var characterModel:CharacterModel;
      
      private var main:Sprite = new Sprite();
      
      private var mm:Sprite = new Sprite();
      
      private var bg:Sprite = new Sprite();
      
      private var field:Sprite = new Sprite();
      
      private var units:Sprite = new Sprite();
      
      private var msk:Sprite = new Sprite();
      
      private var frame:CachedImage = new CachedImage();
      
      private var pois:Sprite = new Sprite();
      
      private var icons:Object = {};
      
      private var _model:RTMModel;
      
      public function MiniMap()
      {
         super();
         addChild(this.main);
         this.main.addChild(this.bg);
         this.main.addChild(this.mm);
         this.main.addChild(this.msk);
         this.main.mask = this.msk;
         this.mm.addChild(this.field);
         this.mm.addChild(this.units);
         addChild(this.frame);
         this.frame.source = Assets.mapCornerBottom;
         this.frame.mouseEnabled = false;
         setActualSize(this.frame.width,this.frame.height);
         this.main.y = TOP;
         this.units.mouseEnabled = false;
         this.mm.addEventListener(MouseEvent.CLICK,this.onMouseClick,false,0,true);
         this.pois.y = TOP;
         addChild(this.pois);
         this.redraw();
      }
      
      private function watch() : void
      {
         this._model.miniMapModel.addEventListener(MiniMapEvent.MAP_CHANGED,this.mapChanged,false,0,true);
         this._model.miniMapModel.addEventListener(MiniMapEvent.POV_CHANGED,this.povChanged,false,0,true);
         this._model.miniMapModel.addEventListener(MiniMapEvent.UNITS_CHANGED,this.unitsChanged,false,0,true);
         this._model.miniMapModel.addEventListener(MiniMapEvent.UNITS_MOVED,this.unitsMoved,false,0,true);
         this._model.miniMapModel.addEventListener(MiniMapEvent.POI_CHANGED,this.poiChanged,false,0,true);
      }
      
      private function unwatch() : void
      {
         this._model.miniMapModel.removeEventListener(MiniMapEvent.MAP_CHANGED,this.mapChanged,false);
         this._model.miniMapModel.removeEventListener(MiniMapEvent.POV_CHANGED,this.povChanged,false);
         this._model.miniMapModel.removeEventListener(MiniMapEvent.UNITS_CHANGED,this.unitsChanged,false);
         this._model.miniMapModel.removeEventListener(MiniMapEvent.UNITS_MOVED,this.unitsMoved,false);
         this._model.miniMapModel.removeEventListener(MiniMapEvent.POI_CHANGED,this.poiChanged,false);
      }
      
      public function set model(value:RTMModel) : void
      {
         if(Boolean(this._model))
         {
            this.unwatch();
         }
         this._model = value;
         if(Boolean(value))
         {
            this.watch();
         }
      }
      
      private function onMouseClick(e:MouseEvent) : void
      {
         var x:Number = this.field.mouseX / MiniMapModel.SCALE;
         var y:Number = this.field.mouseY / MiniMapModel.SCALE * AspectRatio.y;
         var ne:FieldEvent = new FieldEvent(FieldEvent.CS_MOVE_TO);
         ne.data = {
            "x":x,
            "y":y
         };
         this._model.dispatchEvent(ne);
      }
      
      private function mapChanged(e:MiniMapEvent) : void
      {
         var value:Bitmap = this._model.miniMapModel.miniMapSnapshot;
         if(!value)
         {
            return;
         }
         while(this.field.numChildren > 0)
         {
            this.field.removeChildAt(0);
         }
         this.field.addChild(value);
      }
      
      private function povChanged(e:MiniMapEvent) : void
      {
         var pov:Point = this._model.miniMapModel.pov;
         if(pov == null)
         {
            return;
         }
         this.mm.x = int(width / 2 + pov.x * MiniMapModel.SCALE);
         this.mm.y = int(width / 2 + pov.y * MiniMapModel.SCALE);
         this.alignDetails();
      }
      
      private function unitsChanged(e:MiniMapEvent) : void
      {
         var id:String = null;
         var icon:MiniIcon = null;
         for(id in this.icons)
         {
            icon = this.icons[id];
            if(this._model.units[id] == null)
            {
               this.units.removeChild(icon);
               delete this.icons[id];
            }
         }
         this.unitsMoved(e);
      }
      
      private function unitsMoved(e:MiniMapEvent) : void
      {
         var unit:FieldUnit = null;
         var icon:MiniIcon = null;
         for each(unit in this._model.units)
         {
            icon = this.icons[unit.id];
            if(icon == null)
            {
               icon = new MiniIcon();
               icon.unit = unit;
               this.units.addChild(icon);
               this.icons[unit.id] = icon;
            }
            icon.x = unit.x * MiniMapModel.SCALE;
            icon.y = unit.y * MiniMapModel.SCALE;
         }
      }
      
      private function poiChanged(e:MiniMapEvent) : void
      {
         var qd:QuestDetail = null;
         var child:QuestDetailIcon = null;
         while(this.pois.numChildren > 0)
         {
            this.pois.removeChildAt(0);
         }
         for each(qd in this._model.miniMapModel.questDetails)
         {
            qd.y /= AspectRatio.y;
            child = new QuestDetailIcon();
            child.addEventListener(MouseEvent.CLICK,this.onMouseClick,false,0,true);
            child.detail = qd;
            this.pois.addChild(child);
         }
         this.alignDetails();
      }
      
      private function alignDetails() : void
      {
         var child:QuestDetailIcon = null;
         var detail:QuestDetail = null;
         var dx:int = 0;
         var dy:int = 0;
         var distance:Number = NaN;
         var minimapDistance:Number = NaN;
         var pov:Point = this._model.miniMapModel.pov;
         if(!pov)
         {
            return;
         }
         for(var i:uint = 0; i < this.pois.numChildren; i++)
         {
            child = this.pois.getChildAt(i) as QuestDetailIcon;
            if(Boolean(child))
            {
               detail = child.detail;
               dx = pov.x + detail.x;
               dy = pov.y + detail.y;
               distance = Math.sqrt(dx * dx + dy * dy);
               minimapDistance = Math.min(POI_RADIUS,distance * MiniMapModel.SCALE);
               child.x = CENTER.x + dx / distance * minimapDistance;
               child.y = CENTER.y + dy / distance * minimapDistance;
               if(minimapDistance < POI_RADIUS)
               {
                  child.rotation = 0;
                  child.inRange = true;
               }
               else
               {
                  child.rotation = Math.atan2(dy,dx) * RAD_TO_ANG;
                  child.inRange = false;
               }
            }
         }
      }
      
      private function drawBgAndMask(width:Number, height:Number) : void
      {
         this.bg.graphics.clear();
         this.bg.graphics.beginBitmapFill(new Assets.stars().bitmapData);
         this.bg.graphics.drawRect(0,0,RADIUS * 2,RADIUS * 2);
         this.bg.graphics.endFill();
         this.msk.graphics.clear();
         this.msk.graphics.beginFill(0);
         this.msk.graphics.drawCircle(RADIUS,RADIUS,RADIUS);
         this.msk.graphics.endFill();
      }
      
      override protected function redraw() : void
      {
         super.redraw();
         this.drawBgAndMask(_width,_height);
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.events.PropertyChangeEvent;
import soul.controller.locale.LocaleManager;
import soul.model.field.FieldUnit;
import soul.model.field.QuestGiverStatus;
import soul.model.interaction.quest.QuestDetail;
import soul.view.assets.Assets;
import soul.view.ui.Component;

class MiniIcon extends Sprite
{
   
   private static const HOSTILE_COLOR:int = 16711680;
   
   private static const FRIENDLY_COLOR:int = 65280;
   
   private static const FRIENDLY_NPC_COLOR:int = 30464;
   
   private static const BOTH_COLOR:int = 16776960;
   
   private static const NEUTRAL_COLOR:int = 3355630;
   
   private var _unit:FieldUnit;
   
   public function MiniIcon()
   {
      super();
   }
   
   private function clear() : void
   {
      graphics.clear();
      while(numChildren > 0)
      {
         removeChildAt(0);
      }
   }
   
   public function set unit(value:FieldUnit) : void
   {
      if(this._unit == value)
      {
         return;
      }
      if(Boolean(this._unit))
      {
         IEventDispatcher(this._unit).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.unitChanged);
      }
      this._unit = value;
      if(Boolean(this._unit))
      {
         IEventDispatcher(this._unit).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.unitChanged,false,0,true);
      }
      this.unitChanged(null);
   }
   
   private function unitChanged(e:PropertyChangeEvent) : void
   {
      var pulse:DisplayObject = null;
      var mcPulse:MovieClip = null;
      if(Boolean(e) && Boolean(e.property != "questStatus") && e.property != "objective")
      {
         return;
      }
      this.clear();
      if(!this._unit)
      {
         return;
      }
      if(this._unit.objective)
      {
         pulse = new Assets.pulse();
         mcPulse = pulse as MovieClip;
         if(Boolean(mcPulse))
         {
            mcPulse.gotoAndPlay(int(Math.random() * mcPulse.totalFrames) + 1);
         }
         addChild(pulse);
      }
      if(Boolean(this._unit.questStatus))
      {
         this.source = QuestGiverStatus.getSmallIcon(this._unit.questStatus);
      }
      else
      {
         this.color = this.getUnitColor(this._unit);
      }
   }
   
   private function set color(value:uint) : void
   {
      graphics.lineStyle(0,0);
      graphics.beginFill(value);
      graphics.drawCircle(0,0,2.5);
      graphics.endFill();
      cacheAsBitmap = true;
   }
   
   private function set source(klass:Class) : void
   {
      if(!klass)
      {
         return;
      }
      var child:DisplayObject = new klass();
      child.x = int(-child.width / 2);
      child.y = int(-child.height / 2);
      addChild(child);
      cacheAsBitmap = false;
   }
   
   private function getUnitColor(unit:FieldUnit) : uint
   {
      var teamColor:uint = 0;
      if(unit.acceptsNegative && unit.acceptsPositive)
      {
         teamColor = uint(BOTH_COLOR);
      }
      else if(unit.acceptsNegative)
      {
         teamColor = uint(HOSTILE_COLOR);
      }
      else if(unit.acceptsPositive)
      {
         teamColor = unit.character ? uint(FRIENDLY_COLOR) : uint(FRIENDLY_NPC_COLOR);
      }
      else
      {
         teamColor = uint(NEUTRAL_COLOR);
      }
      return teamColor;
   }
}

class QuestDetailIcon extends Component
{
   
   private var direction:DisplayObject = new Assets.questPoiner();
   
   private var point:DisplayObject = new Assets.pulse();
   
   private var _detail:QuestDetail;
   
   private var _inRange:Object;
   
   public function QuestDetailIcon()
   {
      super();
      addChild(this.direction);
      addChild(this.point);
      this.direction.visible = this.point.visible = false;
   }
   
   public function set detail(value:QuestDetail) : void
   {
      if(this._detail == value)
      {
         return;
      }
      this._detail = value;
      if(!value)
      {
         return;
      }
      toolTip = "<font color=\"#00FF00\">" + LocaleManager.getQuestName(value.questId) + "</font><br>" + "- " + LocaleManager.getCondition(value.objectiveType,value.objectiveId);
   }
   
   public function get detail() : QuestDetail
   {
      return this._detail;
   }
   
   public function set inRange(value:Boolean) : void
   {
      if(this._inRange == value)
      {
         return;
      }
      this._inRange = value;
      this.direction.visible = !value;
      this.point.visible = value;
   }
}
