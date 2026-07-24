package soul.view.field.visual.players
{
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.buff.Aura;
   import soul.model.buff.Effect;
   import soul.model.common.ElementType;
   import soul.model.field.FieldUnit;
   import soul.model.field.LibraryManager;
   import soul.model.field.QuestGiverStatus;
   import soul.model.field.StatType;
   import soul.sorting.ISortableSprite;
   import soul.sorting.Pair;
   import soul.utils.ClassUtils;
   import soul.utils.ColorUtils;
   import soul.view.AlignPosition;
   import soul.view.assets.Colors;
   import soul.view.common.Icons;
   import soul.view.field.Fov;
   import soul.view.field.visual.AnimatedSprite;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.OneFaceBitmap;
   import soul.view.field.visual.RotatingBitmap;
   import soul.view.field.visual.players.effect.EffectLocation;
   import soul.view.field.visual.players.models.Contour;
   import soul.view.field.visual.players.models.LayeredUnitBitmap;
   import soul.view.filters.HslFilter;
   import soul.view.toolTip.FieldUnitTip;
   import soul.view.toolTip.ToolTipManager;
   import soul.view.ui.CachedMovieClip;
   
   public class Player extends AnimatedSprite implements ISortableSprite
   {
      
      private static var _missLabel:String;
      
      private static var _immuneLabel:String;
      
      private static var point:Point = new Point();
      
      public var unit:FieldUnit;
      
      public var playerOverlay:PlayerOverlay = new PlayerOverlay();
      
      public var fov:Fov;
      
      public var auras:Sprite = new Sprite();
      
      private var circle:Sprite = new Sprite();
      
      private var playerUnderlay:PlayerUnderlay = new PlayerUnderlay();
      
      private var questSign:DisplayObject;
      
      private var srcLoaded:Boolean;
      
      private var currentMovementMode:String;
      
      private var _over:Boolean;
      
      private var _hslFilter:HslFilter;
      
      private var _objective:Boolean;
      
      private var _selected:Boolean;
      
      private var _myUnit:Boolean;
      
      private var p1:Point = new Point();
      
      private var p2:Point = new Point();
      
      private var pair:Pair = new Pair(this.p1,this.p2);
      
      public function Player(unit:FieldUnit)
      {
         super();
         var m:Matrix = new Matrix();
         m.createGradientBox(50,25,0,-25,-10);
         this.circle.graphics.clear();
         this.circle.graphics.beginGradientFill(GradientType.RADIAL,[0,0,0],[0.5,0.5,0],[0,128,255],m);
         this.circle.graphics.drawEllipse(-25,-10,50,25);
         this.circle.graphics.endFill();
         addChild(this.circle);
         addChild(this.playerUnderlay);
         this.circle.mouseEnabled = false;
         this.circle.mouseChildren = false;
         this.circle.cacheAsBitmap = true;
         addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
         this.playerOverlay.addEventListener(MouseEvent.CLICK,this.namePlateClicked,false,0,true);
         this.playerOverlay.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver,false,0,true);
         this.playerOverlay.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut,false,0,true);
         this.auras.visible = false;
         this.auras.mouseEnabled = this.auras.mouseChildren = false;
         this.setUnit(unit);
      }
      
      private static function get missLabel() : String
      {
         _missLabel = _missLabel || LocaleManager.getString(BundleName.INTERFACE,"miss");
         return _missLabel;
      }
      
      private static function get immuneLabel() : String
      {
         _immuneLabel = _immuneLabel || LocaleManager.getString(BundleName.INTERFACE,"immune");
         return _immuneLabel;
      }
      
      final public function setUnit(unit:FieldUnit) : void
      {
         ToolTipManager.register(this,unit,FieldUnitTip,new AlignPosition(NaN,2,NaN,36));
         this.unit = unit;
         this.playerOverlay.unit = unit;
         this.setEffects(unit.effects);
         var visualId:String = unit.visualId;
         var unitClass:Class = PlayerModelFactory.getClassByVisualId(visualId);
         if(!unitClass)
         {
            unitBitmap = new Contour();
            unitBitmap.visualId = "contour";
            this.applyBitmap();
         }
         else
         {
            unitBitmap = new unitClass();
            unitBitmap.visualId = visualId;
         }
         this.loadComplete();
         this.drawCircle();
         this.drawQuestSign();
         if(unit.character)
         {
            this.fov = new Fov(unit.sightRange);
            this.fov.x = x;
            this.fov.y = y;
         }
         this.objective = unit.objective;
      }
      
      final public function setQuestStatus(value:String) : void
      {
         if(!this.unit || this.unit.questStatus == value)
         {
            return;
         }
         this.unit.questStatus = value;
         this.drawQuestSign();
      }
      
      public function setEffects(effects:Array) : void
      {
         var effect:Effect = null;
         var aura:Aura = null;
         var visualId:String = null;
         var child:Sprite = null;
         this.unit.effects = effects;
         while(this.auras.numChildren > 0)
         {
            this.auras.removeChildAt(0);
         }
         for each(effect in effects)
         {
            aura = effect.aura;
            if(Boolean(aura))
            {
               visualId = aura.visual || "test_aura";
               child = LibraryManager.getObject(visualId,LibraryManager.mainLibrary) as Sprite;
               if(child)
               {
                  child.width = aura.radius << 1;
                  child.scaleY = child.scaleX;
                  this.auras.addChild(child);
               }
            }
         }
         this.auras.visible = this.auras.numChildren > 0;
      }
      
      final private function namePlateClicked(e:MouseEvent) : void
      {
         dispatchEvent(e);
      }
      
      final private function mouseOver(e:MouseEvent) : void
      {
         this._over = true;
         this.applyFilters();
      }
      
      final private function mouseOut(e:MouseEvent) : void
      {
         this._over = false;
         this.applyFilters();
      }
      
      private function set hslFilter(value:HslFilter) : void
      {
         if(this._hslFilter == value)
         {
            return;
         }
         this._hslFilter = value;
         this.applyFilters();
      }
      
      final private function applyFilters() : void
      {
         if(!frameBmp)
         {
            return;
         }
         var f:Array = [];
         if(Boolean(this._hslFilter))
         {
            f.push(this._hslFilter);
         }
         if(this._objective)
         {
            f.push(Colors.QUEST_OBJECTIVE_FILTER);
         }
         if(this._over)
         {
            f.push(Colors.PLAYER_HOVER_FILTER);
         }
         frameBmp.filters = f;
      }
      
      final private function loadComplete() : void
      {
         var hslFilter:HslFilter = null;
         if(this.unit.hue > 0)
         {
            hslFilter = new HslFilter();
            hslFilter.hsl = ColorUtils.hslToString(this.unit.hue);
         }
         this.hslFilter = hslFilter;
         if(unitBitmap is LayeredUnitBitmap)
         {
            LayeredUnitBitmap(unitBitmap).addEventListener(Event.COMPLETE,this.skinCreated);
            LayeredUnitBitmap(unitBitmap).initLayered(this.unit.wardrobes,this.unit.hsls);
            return;
         }
         if(unitBitmap is UnitBitmap || unitBitmap is OneFaceBitmap)
         {
            unitBitmap.addEventListener(Event.COMPLETE,this.skinCreated);
            unitBitmap.initCharacter();
            return;
         }
      }
      
      final private function skinCreated(e:Event = null) : void
      {
         this.srcLoaded = true;
         frameBmp.visible = true;
         this.applyBitmap();
         startAnimation();
         if(defaultAnimation != null)
         {
            defaultAnimation();
         }
      }
      
      final private function applyBitmap() : void
      {
         var nameHeight:int = -(Boolean(unitBitmap.nameHeight) ? unitBitmap.nameHeight : unitBitmap.frameHeight);
         this.playerOverlay.bottom = nameHeight;
         this.playerOverlay.effectLocations = RotatingBitmap(unitBitmap).effectLocations;
         if(Boolean(this.questSign))
         {
            this.questSign.y = nameHeight;
         }
         angle = 4;
         if(this.unit.dead)
         {
            this.dead();
         }
         else
         {
            this.idle();
            this.applyHitArea();
         }
      }
      
      final public function moveTo(x:Number, y:Number, type:String, duration:uint) : void
      {
         unitBitmap.pps = turnTo(x,y) / duration * 1000;
         if(type == AnimationType.RUN)
         {
            this.run();
         }
         else
         {
            this.walk();
         }
      }
      
      public function playEffect(effectId:String, location:String) : void
      {
         if(location == EffectLocation.FEET)
         {
            this.playerUnderlay.playEffect(effectId,location);
         }
         else
         {
            this.playerOverlay.playEffect(effectId,location);
         }
      }
      
      override public function idle() : void
      {
         changeAnimation(AnimationType.IDLE,true,this.idle);
      }
      
      public function dead() : void
      {
         this.unit.dead = true;
         changeAnimation(AnimationType.DEAD,true,this.dead);
         this.applyHitArea();
      }
      
      public function walk() : void
      {
         changeAnimation(AnimationType.WALK,true,this.walk);
      }
      
      public function run() : void
      {
         changeAnimation(AnimationType.RUN,true,this.run);
      }
      
      public function castStart() : void
      {
         changeAnimation(AnimationType.START_CAST,false,this.cast);
      }
      
      public function cast() : void
      {
         changeAnimation(AnimationType.CAST,true,this.cast);
      }
      
      public function castEnd() : void
      {
         changeAnimation(AnimationType.END_CAST,false,this.idle);
      }
      
      public function startBow() : void
      {
         changeAnimation(AnimationType.START_BOW,false,this.bow);
      }
      
      public function bow() : void
      {
         changeAnimation(AnimationType.BOW,true);
      }
      
      public function endBow() : void
      {
         changeAnimation(AnimationType.END_BOW,false,this.idle);
      }
      
      public function useItem() : void
      {
         changeAnimation(AnimationType.USE_ITEM,true,this.useItem);
      }
      
      public function endUse() : void
      {
         changeAnimation(AnimationType.USE_ITEM,false,defaultAnimation == this.useItem ? this.idle : null);
      }
      
      public function sword() : void
      {
         changeAnimation(AnimationType.SWORD,false,defaultAnimation == this.bow ? this.idle : null);
      }
      
      public function spear() : void
      {
         changeAnimation(AnimationType.SPEAR);
      }
      
      public function damage() : void
      {
         if(playing && !currentAnimationLooped)
         {
            return;
         }
         changeAnimation(AnimationType.DAMAGE);
      }
      
      public function die() : void
      {
         changeAnimation(AnimationType.DIE,false,this.dead);
         this.unit.dead = true;
      }
      
      public function resurrect() : void
      {
         changeAnimation(AnimationType.RESURREST,false,this.idle);
         this.unit.dead = false;
         this.applyHitArea();
      }
      
      public function missed() : void
      {
         this.playerOverlay.showFlyingText(missLabel,16777215,null);
      }
      
      public function immune(elementType:String) : void
      {
         var elementClass:Class = ElementType.getIcon(elementType) || Icons.melee;
         var icon:DisplayObject = Boolean(elementClass) ? new elementClass() : null;
         this.playerOverlay.showFlyingText(immuneLabel,16777215,icon);
      }
      
      public function changeStats(statType:String, elementType:String, amount:int, critical:Boolean = false) : void
      {
         var color:int = 0;
         var text:String = null;
         if(statType == StatType.XP)
         {
            this.playerOverlay.showFlyingText(LocaleManager.getString(BundleName.INTERFACE,"xp:") + amount,16777215,null,false,true);
            return;
         }
         var bold:Boolean = false;
         switch(statType)
         {
            case StatType.HP:
               color = amount >= 0 ? 65280 : 15610675;
               break;
            case StatType.MP:
               color = 3381708;
               break;
            case StatType.STAMINA:
               color = 13421721;
               break;
            default:
               color = 16777215;
         }
         var sign:String = amount > 0 ? "+" : "";
         text = sign + amount;
         var elementClass:Class = ElementType.getIcon(elementType) || Icons.melee;
         var icon:DisplayObject = Boolean(elementClass) ? new elementClass() : null;
         this.playerOverlay.showFlyingText(text,color,icon,critical,bold);
      }
      
      public function speak(text:String, type:String) : void
      {
         this.playerOverlay.speak(text,type);
      }
      
      public function drawCircle() : void
      {
         var circleType:String = null;
         while(this.circle.numChildren > 0)
         {
            this.circle.removeChildAt(0);
         }
         if(!this.selected && !this.myUnit)
         {
            return;
         }
         if(this._myUnit)
         {
            circleType = "circle_self";
         }
         else if(!this.unit.acceptsNegative && !this.unit.acceptsPositive)
         {
            circleType = "circle_neitral";
         }
         else if(this.unit.acceptsNegative)
         {
            circleType = "circle_hostile";
         }
         else
         {
            if(!this.unit.acceptsPositive)
            {
               return;
            }
            circleType = "circle_friendly";
         }
         var bmp:DisplayObject = LibraryManager.getObject(circleType);
         this.circle.addChild(bmp);
         bmp.x = -bmp.width / 2;
         bmp.y = -bmp.height / 2;
      }
      
      private function drawQuestSign() : void
      {
         var mcIcon:CachedMovieClip = null;
         if(Boolean(this.questSign))
         {
            this.playerOverlay.removeChild(this.questSign);
            this.questSign = null;
         }
         var iconClass:Class = QuestGiverStatus.getIcon(this.unit.questStatus);
         if(!iconClass)
         {
            return;
         }
         this.questSign = ClassUtils.getSuperclass(iconClass) == MovieClip ? CachedMovieClip.wrap(iconClass) : new iconClass();
         if(Boolean(this.questSign))
         {
            this.playerOverlay.addChild(this.questSign);
            this.questSign.y = this.playerOverlay.bottom;
            mcIcon = this.questSign as CachedMovieClip;
            if(Boolean(mcIcon))
            {
               mcIcon.gotoAndPlay(1 + int(Math.random() * mcIcon.totalFrames));
            }
         }
      }
      
      public function setStats(statType:String, amount:int) : void
      {
         this.unit.stats[statType] = amount;
         if(statType == StatType.MAX_HP || statType == StatType.HP)
         {
            this.playerOverlay.checkVisibility();
         }
      }
      
      public function set objective(value:Boolean) : void
      {
         if(this._objective == value)
         {
            return;
         }
         this._objective = value;
         this.applyFilters();
      }
      
      override public function set x(value:Number) : void
      {
         value = Math.round(value);
         super.x = this.unit.x = this.playerOverlay.x = this.auras.x = value;
         if(Boolean(this.fov))
         {
            this.fov.x = value;
         }
      }
      
      override public function set y(value:Number) : void
      {
         value = Math.round(value);
         super.y = this.unit.y = this.playerOverlay.y = this.auras.y = value;
         if(Boolean(this.fov))
         {
            this.fov.y = value;
         }
      }
      
      public function set selected(value:Boolean) : void
      {
         this._selected = value;
         this.drawCircle();
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set myUnit(value:Boolean) : void
      {
         this._myUnit = value;
         this.drawCircle();
      }
      
      public function get myUnit() : Boolean
      {
         return this._myUnit;
      }
      
      public function get modelCenter() : Point
      {
         return unitBitmap.modelCenter || new Point();
      }
      
      private function applyHitArea() : void
      {
         var s:Sprite = null;
         if(Boolean(hitArea) && Boolean(contains(hitArea)) && hitArea != this.circle)
         {
            removeChild(hitArea);
         }
         if(this.unit.dead)
         {
            this.playerOverlay.visible = false;
            mouseEnabled = false;
            return;
         }
         this.playerOverlay.visible = true;
         mouseEnabled = true;
         if(Boolean(unitBitmap.hitArea))
         {
            s = new Sprite();
            s = new Sprite();
            s.graphics.beginFill(0);
            s.graphics.drawRect(unitBitmap.hitArea.x,unitBitmap.hitArea.y,unitBitmap.hitArea.width,unitBitmap.hitArea.height);
            s.graphics.endFill();
            s.x = unitBitmap.spriteCenter.x;
            s.y = unitBitmap.spriteCenter.y;
            s.visible = false;
            s.alpha = 0.5;
            s.mouseEnabled = false;
            hitArea = s;
            addChild(hitArea);
         }
      }
      
      public function getSpriteLine() : Pair
      {
         this.p1.x = x - 25;
         this.p2.x = x + 50;
         this.p1.y = this.p2.y = y;
         return this.pair;
      }
   }
}

