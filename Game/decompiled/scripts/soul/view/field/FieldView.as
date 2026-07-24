package soul.view.field
{
   import com.gskinner.motion.GTween;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.BlurFilter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.utils.Timer;
   import flash.utils.clearInterval;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import soul.controller.LogManager;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.FieldEvent;
   import soul.event.MiniMapEvent;
   import soul.model.ability.Ability;
   import soul.model.field.FieldData;
   import soul.model.field.FieldUnit;
   import soul.model.field.LibraryManager;
   import soul.model.field.mapconfig.AspectRatio;
   import soul.model.field.mapconfig.MapData;
   import soul.model.field.mapconfig.MapFillZone;
   import soul.model.field.mapconfig.ObjectConfig;
   import soul.model.field.spriteconfig.ObjectLayout;
   import soul.model.field.spriteconfig.SpriteConfig;
   import soul.model.field.spriteconfig.SpritePhase;
   import soul.model.field.spriteconfig.SpriteType;
   import soul.model.interaction.settings.CameraFollowType;
   import soul.model.interaction.settings.DamageDisplay;
   import soul.model.interaction.settings.FowDisplay;
   import soul.model.rtm.MiniMapModel;
   import soul.model.rtm.RTMModel;
   import soul.model.rtm.TargetType;
   import soul.model.system.Configuration;
   import soul.net.ServerLayer;
   import soul.sorting.EdgeOrder;
   import soul.utils.BitmapUtils;
   import soul.utils.CursorUtil;
   import soul.utils.SoundUtils;
   import soul.view.console.Console;
   import soul.view.field.visual.FieldObject;
   import soul.view.field.visual.players.Player;
   import soul.view.field.visual.players.effect.EffectPlayer;
   import soul.view.field.visual.spells.Shoot;
   import soul.view.fps.Fps;
   import soul.view.sprite.SpriteSheetLoder;
   
   public class FieldView extends ManagableDrawer implements IFieldView
   {
      
      private static const CLICK_FREQ:uint = 500;
      
      private static const STAND_TIMEOUT:uint = 200;
      
      private static const FADE_TIME:uint = 1;
      
      private static const INTERACTIVE_FIND_FREQ:uint = 500;
      
      private static const deleteWithFade:Boolean = true;
      
      private static const MINIMAP_BLUR:BlurFilter = new BlurFilter(2,2);
      
      private static const RECTANGLE_LEFT_PADDING:int = -50;
      
      private static const RECTANGLE_SIZE_PADDING:int = 100;
      
      private static const ELASTIC_CAMERA_AIM_TIME:Number = 1;
      
      private static const CAMERA_MODE_CHANGE_FREQ:uint = 60000;
      
      private static const CAMERA_MODE_CHANGE_MIN_FPS:uint = 25;
      
      private static const centerPoint:Point = new Point();
      
      private var keyboardEnabled:Boolean = false;
      
      private var _myPlayerId:String;
      
      private var myPlayer:Player;
      
      private var players:Object;
      
      private var tweens:Object;
      
      private var objectUnits:Object;
      
      private var iAmMoving:Boolean;
      
      private var mcNamePlates:Sprite = new Sprite();
      
      private var namePlates:Object;
      
      private var mcSpells:Sprite = new Sprite();
      
      private var mcFov:Sprite = new Sprite();
      
      private var darkness:Shape = new Shape();
      
      private var fovs:Object = {};
      
      private var fovVisible:Boolean;
      
      private var mcAreaOfEffect:Sprite;
      
      private var selectedUnit:FieldUnit;
      
      private var showAll:Boolean = false;
      
      private var oRaisedVisible:Boolean = true;
      
      private var minimapDirty:Boolean = false;
      
      private const visibilityTimer:Timer = new Timer(500);
      
      private const visibilityRect:Rectangle = new Rectangle();
      
      private var interactiveListDirty:Boolean = false;
      
      private const interactiveTimer:Timer = new Timer(INTERACTIVE_FIND_FREQ);
      
      private var cameraDirty:Boolean;
      
      private var cameraPositionDirty:Boolean = true;
      
      private var elasticCameraAimEnd:uint;
      
      private var cameraPoint:Point = new Point();
      
      private var playerScrollRect:Rectangle = new Rectangle();
      
      private var screenRect:Rectangle = new Rectangle();
      
      private var elasticCameraTween:GTween;
      
      private var _model:RTMModel;
      
      private var _damageDisplay:uint;
      
      private var lastCameraChangeTime:uint;
      
      private var currentAutoCameraFollowType:uint = 0;
      
      private var pressTime:int;
      
      private var clickInt:int;
      
      public var _cameraFollowType:uint = 2;
      
      private var libsLoaded:Boolean = false;
      
      private var charsLoaded:Boolean = false;
      
      private var loader:LibraryManager;
      
      private var _mapData:MapData;
      
      private var _fowDisplay:uint = 0;
      
      private var _progress:Number = 0;
      
      public function FieldView()
      {
         super();
         this.loader = LibraryManager.instance;
         LibraryManager.libPath = Configuration.staticServerURL + LibraryManager.LIBS;
         focusRect = false;
         mc.addChild(this.mcSpells);
         mc.addChild(this.mcNamePlates);
         mc.addChild(this.mcFov);
         this.mcFov.mouseEnabled = this.mcFov.mouseChildren = false;
         this.mcFov.visible = false;
         this.mcFov.addChild(this.darkness);
         this.mcNamePlates.mouseEnabled = false;
         mcBg.doubleClickEnabled = true;
         addEventListener(MouseEvent.MOUSE_DOWN,this.thisMouseDown);
         mcBg.addEventListener(MouseEvent.DOUBLE_CLICK,this.doubleClick);
         mcBg.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         this.visibilityTimer.addEventListener(TimerEvent.TIMER,this.checkVisibility);
         this.interactiveTimer.addEventListener(TimerEvent.TIMER,this.makeInteractiveListDirty);
      }
      
      private static function easyning(t:Number, b:Number, c:Number, d:Number) : Number
      {
         t /= d;
         return -c * t * (t - 2) + b;
      }
      
      public function reset() : void
      {
         this.visibilityTimer.stop();
         this.clearMap();
         this._model.dispatchEvent(new FieldEvent(FieldEvent.CLEAN_NPC_STICKS));
      }
      
      override protected function clearMap() : void
      {
         var tween:GTween = null;
         this.keyboardEnabled = false;
         mc.x = 0;
         mc.y = 0;
         deepBg.x = 0;
         deepBg.y = 0;
         this.screenRect.x = 0;
         this.screenRect.y = 0;
         for each(tween in this.tweens)
         {
            tween.paused = true;
         }
         this.tweens = {};
         if(Boolean(this.elasticCameraTween))
         {
            this.elasticCameraTween.paused = true;
            this.elasticCameraTween = null;
         }
         this.myPlayer = null;
         this.players = {};
         this.objectUnits = {};
         this.namePlates = {};
         while(this.mcNamePlates.numChildren > 0)
         {
            this.mcNamePlates.removeChildAt(0);
         }
         while(this.mcFov.numChildren > 1)
         {
            this.mcFov.removeChildAt(1);
         }
         this._model.clearToProximityMap();
         this.unitChanged("*");
         this._model.units = {};
         super.clearMap();
      }
      
      override protected function drawMap() : void
      {
         drawBg();
         this.drawObjects();
         sortGroundObjects();
         drawLights();
      }
      
      override protected function drawObjects() : void
      {
         var cfg:ObjectConfig = null;
         super.drawObjects();
         for each(cfg in layout.layer.objects)
         {
            this.createObject(cfg);
         }
         this.interactiveListDirty = true;
      }
      
      private function checkVisibility(e:Event = null) : void
      {
         var fo:FieldObject = null;
         var vis:Boolean = false;
         var oldVis:Boolean = false;
         var player:Player = null;
         if(this.showAll)
         {
            return;
         }
         for each(fo in raisedObjects)
         {
            oldVis = fo.parent == mcRaised;
            vis = this.visibilityRect.intersects(fo.bounds);
            if(vis && !oldVis)
            {
               mcRaised.addChild(fo);
               edgeOrder.addSprite(fo,_sortingEnabled);
            }
            else if(oldVis && !vis)
            {
               mcRaised.removeChild(fo);
               edgeOrder.removeSprite(fo);
            }
         }
         for each(player in this.players)
         {
            oldVis = player.parent == mcRaised;
            vis = this.visibilityRect.contains(player.x,player.y);
            if(vis && !oldVis)
            {
               mcRaised.addChild(player);
               edgeOrder.addSprite(player,_sortingEnabled);
            }
            else if(oldVis && !vis)
            {
               mcRaised.removeChild(player);
               edgeOrder.removeSprite(player);
            }
         }
         if(this.iAmMoving && _sortingEnabled)
         {
            edgeOrder.reorderAll();
         }
      }
      
      private function makeInteractiveListDirty(e:Event) : void
      {
         this.interactiveListDirty = true;
      }
      
      private function createAoeHolder(radius:int) : void
      {
         this.removeAoeHolder();
         this.mcAreaOfEffect = LibraryManager.getObject("areaSpell") as Sprite;
         this.mcAreaOfEffect.mouseEnabled = false;
         this.mcAreaOfEffect.width = radius * 2;
         this.mcAreaOfEffect.height = radius;
         mcGround.addChild(this.mcAreaOfEffect);
         this.mcAreaOfEffect.startDrag(true);
      }
      
      private function removeAoeHolder() : void
      {
         if(Boolean(this.mcAreaOfEffect) && mcGround.contains(this.mcAreaOfEffect))
         {
            mcGround.removeChild(this.mcAreaOfEffect);
         }
         this.mcAreaOfEffect = null;
      }
      
      private function removeSpellCursor() : void
      {
         CursorUtil.removeAllCursors();
      }
      
      private function makeMiniMap() : void
      {
         var fo:FieldObject = null;
         var rect:Rectangle = null;
         var lights:Boolean = false;
         var fovVisible:Boolean = false;
         var bmpd:BitmapData = null;
         if(!this._model.miniMapModel)
         {
            return;
         }
         var raisedToRemove:Vector.<FieldObject> = new Vector.<FieldObject>();
         var raisedToActivate:Vector.<FieldObject> = new Vector.<FieldObject>();
         for each(fo in raisedObjects)
         {
            if(!mcRaised.contains(fo))
            {
               mcRaised.addChild(fo);
               edgeOrder.addSprite(fo,_sortingEnabled);
               raisedToRemove.push(fo);
            }
            if(fo.objective)
            {
               raisedToActivate.push(fo);
               fo.objective = false;
            }
         }
         edgeOrder.reorderAll();
         rect = scrollRect;
         scrollRect = null;
         lights = mcAmbient.visible;
         mcAmbient.visible = false;
         this.mcNamePlates.visible = false;
         fovVisible = this.mcFov.visible;
         this.mcFov.visible = false;
         bmpd = BitmapUtils.createSnapshot(mc,layout.width,layout.height,MiniMapModel.SCALE);
         this.mcNamePlates.visible = true;
         scrollRect = rect;
         mcAmbient.visible = lights;
         this.mcFov.visible = fovVisible;
         for each(fo in raisedToRemove)
         {
            mcRaised.removeChild(fo);
            edgeOrder.removeSprite(fo);
         }
         for each(fo in raisedToActivate)
         {
            fo.objective = true;
         }
         try
         {
            if(Boolean(this._model.miniMapModel.miniMapSnapshot))
            {
               this._model.miniMapModel.miniMapSnapshot.bitmapData.dispose();
            }
         }
         catch(e:Error)
         {
         }
         this._model.miniMapModel.miniMapSnapshot = new Bitmap(bmpd);
         this._model.miniMapModel.dispatchEvent(new MiniMapEvent(MiniMapEvent.MAP_CHANGED));
         this.minimapDirty = false;
      }
      
      private function makeViewPort() : void
      {
         if(Boolean(this._model) && Boolean(this.myPlayer))
         {
            this._model.miniMapModel.pov = new Point(-this.myPlayer.x,-this.myPlayer.y);
            this._model.miniMapModel.dispatchEvent(new MiniMapEvent(MiniMapEvent.POV_CHANGED));
         }
      }
      
      private function unitChanged(id:String) : void
      {
         var ne:FieldEvent = null;
         if(this._model.hasEventListener(FieldEvent.UNIT_CHANGED))
         {
            ne = new FieldEvent(FieldEvent.UNIT_CHANGED);
            ne.data = id;
            this._model.dispatchEvent(ne);
         }
      }
      
      private function unitsChanged() : void
      {
         if(Boolean(this._model))
         {
            this._model.miniMapModel.dispatchEvent(new MiniMapEvent(MiniMapEvent.UNITS_CHANGED));
         }
      }
      
      private function unitsMoved() : void
      {
         if(Boolean(this._model))
         {
            this._model.miniMapModel.dispatchEvent(new MiniMapEvent(MiniMapEvent.UNITS_MOVED));
         }
      }
      
      private function createObjectFromConfig(cfg:ObjectConfig, tooltipId:String = null) : void
      {
         var objectLayout:ObjectLayout = this.getObjectLayoutById(cfg.spriteId);
         if(!objectLayout)
         {
            return;
         }
         var sprite:FieldObject = new FieldObject(objectLayout,cfg.phase);
         var hintId:String = Boolean(cfg.id) && cfg.id.charAt(0) == "." ? cfg.id : this._model.sectorId + "." + this._model.mapId + "." + cfg.id;
         sprite.tooltipId = Boolean(tooltipId) ? tooltipId : hintId;
         sprite.id = cfg.id;
         sprite.x = cfg.x;
         sprite.y = cfg.y;
         sprite.mirrored = cfg.mirrored;
         if(objectLayout.type == SpriteType.GROUND)
         {
            mcGround.addChild(sprite);
            groundObjects.push(sprite);
         }
         else if(objectLayout.type == SpriteType.RAISED)
         {
            mcRaised.addChild(sprite);
            raisedObjects.push(sprite);
            if(Boolean(edgeOrder))
            {
               edgeOrder.addSprite(sprite,_sortingEnabled);
            }
         }
         if(cfg.active)
         {
            sprite.addEventListener(MouseEvent.CLICK,this.activeObjectClicked,false,0,true);
            sprite.interactive = true;
            if(Boolean(tooltipId))
            {
               this.mcNamePlates.addChild(sprite.namePlate);
               this.namePlates[cfg.id] = sprite.namePlate;
            }
            this._model.addToProximityMap(sprite);
            this.interactiveListDirty = true;
         }
         sprite.objective = cfg.objective;
      }
      
      private function getObjectLayoutById(id:String) : ObjectLayout
      {
         var objectLayout:ObjectLayout = null;
         if(Boolean(this._model.commonObjectLayouts) && Boolean(this._model.commonObjectLayouts[id]))
         {
            objectLayout = this._model.commonObjectLayouts[id];
         }
         else
         {
            objectLayout = objectLayouts[id];
         }
         return objectLayout;
      }
      
      private function stopPlayerTween(player:Player) : void
      {
         if(player == this.myPlayer)
         {
            this.myMoveProgress(null);
            this.iAmMoving = false;
            this.interactiveTimer.stop();
            this.interactiveListDirty = true;
         }
         var tween:GTween = this.tweens[player.unit.id];
         if(Boolean(tween))
         {
            if(player == this.myPlayer)
            {
               tween.onChange = null;
            }
            tween.paused = true;
            delete this.tweens[player.unit.id];
         }
         if(_sortingEnabled && Boolean(player.parent))
         {
            edgeOrder.moveSprite(player);
         }
      }
      
      private function elasticAimProgress(e:Event) : void
      {
         this.cameraDirty = true;
      }
      
      private function elasticAimComplete(e:Event) : void
      {
         this.elasticCameraTween = null;
         this.cameraDirty = true;
      }
      
      private function updateCameraPosition() : void
      {
         var newCameraFollowMethod:uint = 0;
         var now:uint = 0;
         var newX:Number = NaN;
         var newY:Number = NaN;
         var playerX:Number = NaN;
         var playerY:Number = NaN;
         if(this._cameraFollowType == CameraFollowType.AUTO)
         {
            newCameraFollowMethod = Fps.averageFps < CAMERA_MODE_CHANGE_MIN_FPS ? CameraFollowType.ELASTIC : CameraFollowType.ALWAYS;
            now = uint(getTimer());
            if(this.currentAutoCameraFollowType != newCameraFollowMethod && now - this.currentAutoCameraFollowType > CAMERA_MODE_CHANGE_FREQ)
            {
               this.lastCameraChangeTime = now;
               this.currentAutoCameraFollowType = newCameraFollowMethod;
            }
         }
         else
         {
            this.currentAutoCameraFollowType = this._cameraFollowType;
         }
         this.calculateScreenCenter();
         if(this.currentAutoCameraFollowType == CameraFollowType.ALWAYS)
         {
            newX = centerPoint.x;
            newY = centerPoint.y;
            if(this.cameraPoint.x != newX || this.cameraPoint.y != newY)
            {
               this.cameraPoint.x = newX;
               this.cameraPoint.y = newY;
               this.cameraDirty = true;
            }
         }
         else if(this.currentAutoCameraFollowType == CameraFollowType.ELASTIC)
         {
            if(Boolean(this.myPlayer))
            {
               playerX = this.myPlayer.x;
               playerY = this.myPlayer.y;
            }
            else
            {
               playerX = playerY = 0;
            }
            if(!this.screenRect.contains(playerX,playerY))
            {
               this.instantCenterOnPlayer();
               this.cameraDirty = true;
               return;
            }
            if(Boolean(this.elasticCameraTween))
            {
               return;
            }
            if(playerX < this.playerScrollRect.x || playerX > this.playerScrollRect.right || playerY < this.playerScrollRect.y || playerY > this.playerScrollRect.bottom)
            {
               if(this.cameraPoint.x == centerPoint.x && this.cameraPoint.y == centerPoint.y)
               {
                  return;
               }
               this.elasticCameraTween = new GTween(this.cameraPoint,ELASTIC_CAMERA_AIM_TIME,{
                  "x":centerPoint.x,
                  "y":centerPoint.y
               },{"ease":easyning});
               this.elasticCameraTween.addEventListener(Event.CHANGE,this.elasticAimProgress);
               this.elasticCameraTween.addEventListener(Event.COMPLETE,this.elasticAimComplete);
            }
         }
         this.cameraPositionDirty = false;
      }
      
      private function instantCenterOnPlayer() : void
      {
         if(Boolean(this.elasticCameraTween))
         {
            this.elasticCameraTween.paused = true;
            this.elasticCameraTween = null;
         }
         this.cameraPoint.x = centerPoint.x;
         this.cameraPoint.y = centerPoint.y;
      }
      
      private function updateCamera() : void
      {
         if(this.cameraPositionDirty)
         {
            this.updateCameraPosition();
         }
         if(!this.cameraDirty)
         {
            return;
         }
         var x:int = int(this.cameraPoint.x);
         var y:int = int(this.cameraPoint.y);
         mc.x = x;
         mc.y = y;
         this.darkness.x = -x;
         this.darkness.y = -y;
         this.visibilityRect.x = -x + RECTANGLE_LEFT_PADDING;
         this.visibilityRect.y = -y;
         this.playerScrollRect.x = -x + (width - this.playerScrollRect.width) / 2;
         this.playerScrollRect.y = -y + (height - this.playerScrollRect.height) / 2;
         this.screenRect.x = -x;
         this.screenRect.y = -y;
         if(Boolean(layout))
         {
            deepBg.x = x * layout.deepBgScrollSpeed;
            deepBg.y = y * layout.deepBgScrollSpeed;
         }
         this.checkVisibility();
         this.cameraDirty = false;
      }
      
      private function calculateScreenCenter() : void
      {
         var visWidth:Number = NaN;
         var visHeight:Number = NaN;
         var newX:int = 0;
         var newY:int = 0;
         if(Boolean(this.myPlayer))
         {
            visWidth = Math.min(width,layout.width);
            visHeight = Math.min(height,layout.height);
            newX = visWidth / 2 - this.myPlayer.x;
            newY = visHeight / 2 - this.myPlayer.y;
            newX = Math.min(newX,0);
            newY = Math.min(newY,0);
            if(layout.width < width)
            {
               newX = Math.max(newX,0);
            }
            else
            {
               newX = Math.max(newX,width - layout.width);
            }
            if(layout.height < height)
            {
               newY = Math.max(newY,0);
            }
            else
            {
               newY = Math.max(newY,height - layout.height);
            }
            centerPoint.x = newX;
            centerPoint.y = newY;
         }
         else
         {
            centerPoint.x = 0;
            centerPoint.y = 0;
         }
      }
      
      private function addedToStage(e:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.keyboardHandle);
         stage.addEventListener(Event.ENTER_FRAME,this.onFrame);
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         trace("FV removed");
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.keyboardHandle);
         stage.removeEventListener(Event.ENTER_FRAME,this.onFrame);
      }
      
      private function onFrame(e:Event) : void
      {
         var player:Player = null;
         var tween:GTween = null;
         if(this.minimapDirty)
         {
            this.makeMiniMap();
         }
         for each(player in this.players)
         {
            if(Boolean(player.parent))
            {
               player.animate();
            }
         }
         if(this.interactiveListDirty)
         {
            this._model.countNearestInteractive(this.myPlayer);
            this.interactiveListDirty = false;
         }
         var _loc4_:int = 0;
         var _loc5_:* = this.tweens;
         for each(tween in _loc5_)
         {
            this.resortUnits();
         }
         this.updateCamera();
      }
      
      override protected function onResize(e:Event) : void
      {
         super.onResize(e);
         this.visibilityRect.width = width + RECTANGLE_SIZE_PADDING;
         this.visibilityRect.height = height + RECTANGLE_SIZE_PADDING;
         this.playerScrollRect.width = width * 0.4;
         this.playerScrollRect.height = height * 0.45;
         this.playerScrollRect.x = centerPoint.x + (width - this.playerScrollRect.width) / 2;
         this.playerScrollRect.y = centerPoint.y + (height - this.playerScrollRect.height) / 2;
         this.screenRect.width = width;
         this.screenRect.height = height;
         this.darkness.graphics.clear();
         this.darkness.graphics.beginFill(Fov.COLOR);
         this.darkness.graphics.drawRect(0,0,width,height);
         this.darkness.graphics.endFill();
         if(Boolean(this.myPlayer))
         {
            this.calculateScreenCenter();
            this.instantCenterOnPlayer();
            this.cameraDirty = true;
            this.updateCamera();
            this.cameraPositionDirty = true;
         }
      }
      
      private function keyboardHandle(e:KeyboardEvent) : void
      {
         if(!this.keyboardEnabled || !this.myPlayer)
         {
            return;
         }
         var stageFocus:Object = stage.focus;
         if(stageFocus is TextField && !e.ctrlKey && !e.altKey)
         {
            return;
         }
         var step:int = 30;
         var shiftX:int = 0;
         var shiftY:int = 0;
         if(e.keyCode == 37)
         {
            shiftX = -step;
         }
         else if(e.keyCode == 39)
         {
            shiftX = step;
         }
         else if(e.keyCode == 38)
         {
            shiftY = -step;
         }
         else if(e.keyCode == 40)
         {
            shiftY = step;
         }
         if(shiftX != 0 || shiftY != 0)
         {
            this.requestMoveTo(this.myPlayer.x + shiftX,(this.myPlayer.y + shiftY) * AspectRatio.y);
         }
      }
      
      private function toggleSorting(e:Event) : void
      {
         sortingEnabled = !sortingEnabled;
         Console.trace("Sorting: " + sortingEnabled);
      }
      
      private function toggleVisibleAll(e:Event) : void
      {
         this.showAll = !this.showAll;
         Console.trace("Show All: " + this.showAll);
      }
      
      private function toggleIndexes(e:Event) : void
      {
         EdgeOrder.applyIndexes = !EdgeOrder.applyIndexes;
         Console.trace("EdgeOrder.applyIndexes=" + EdgeOrder.applyIndexes);
      }
      
      private function toggleRaised(e:Event) : void
      {
         var o:DisplayObject = null;
         this.oRaisedVisible = !this.oRaisedVisible;
         for each(o in raisedObjects)
         {
            o.visible = this.oRaisedVisible;
         }
      }
      
      private function toggleFov(e:Event) : void
      {
         this.mcFov.visible = !this.mcFov.visible;
      }
      
      private function thisMouseDown(e:MouseEvent) : void
      {
         stage.focus = this;
      }
      
      private function mouseDown(e:MouseEvent) : void
      {
         clearInterval(this.clickInt);
         this.clickInt = setInterval(this.clickField,CLICK_FREQ,null);
         this.clickField(null);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         stage.addEventListener(FocusEvent.FOCUS_OUT,this.mouseUp);
      }
      
      private function mouseUp(e:Event) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         stage.removeEventListener(FocusEvent.FOCUS_OUT,this.mouseUp);
         clearInterval(this.clickInt);
      }
      
      private function clickField(e:MouseEvent) : void
      {
         var fe:FieldEvent = null;
         var x:int = mcBg.mouseX;
         var y:int = mcBg.mouseY * AspectRatio.y;
         if(Boolean(this._model.activeAbility))
         {
            this.removeAoeHolder();
            this.removeSpellCursor();
            if(this._model.activeAbility.target == TargetType.POINT)
            {
               if(Boolean(this._model.activeItem))
               {
                  this.useItemAt(x,y,this._model.activeItem.templateId);
               }
               else
               {
                  this.useAbilityAt(x,y,this._model.activeAbility);
               }
            }
            this._model.activeAbility = null;
            this._model.activeItem = null;
         }
         else
         {
            if(Boolean(this.myPlayer) && Boolean(x == this.myPlayer.x) && y == this.myPlayer.y)
            {
               return;
            }
            this.requestMoveTo(x,y);
         }
      }
      
      private function doubleClick(e:MouseEvent) : void
      {
         if(!this.myPlayer)
         {
            return;
         }
         var x:int = mcBg.mouseX;
         var y:int = mcBg.mouseY * AspectRatio.y;
         this.requestRunTo(x,y);
      }
      
      private function resortUnits() : void
      {
         var player:Player = null;
         var tween:GTween = null;
         var tmpArray:Array = null;
         var sprite:Sprite = null;
         var i:String = null;
         if(!_sortingEnabled)
         {
            return;
         }
         for each(tween in this.tweens)
         {
            player = tween.target as Player;
            if(_sortingEnabled && Boolean(player.parent))
            {
               edgeOrder.moveSprite(player);
            }
         }
         this.unitsMoved();
         tmpArray = [];
         for each(sprite in this.namePlates)
         {
            if(Boolean(sprite))
            {
               tmpArray.push(sprite);
            }
         }
         tmpArray.sortOn("y",Array.NUMERIC);
         for(i in tmpArray)
         {
            sprite = tmpArray[i];
            this.mcNamePlates.setChildIndex(sprite,int(i));
         }
      }
      
      private function myMoveProgress(tween:GTween) : void
      {
         this.cameraPositionDirty = true;
         this.updateCamera();
         this.makeViewPort();
      }
      
      private function playerClick(e:MouseEvent) : void
      {
         var ne:FieldEvent = null;
         var player:Player = e.target as Player;
         if(!player)
         {
            return;
         }
         var unit:FieldUnit = player.unit;
         if(e.ctrlKey)
         {
            if(unit.character)
            {
               ne = new FieldEvent(FieldEvent.SHOW_MENU);
               ne.data = unit;
            }
            else
            {
               ne = new FieldEvent(FieldEvent.STICK_TARGET);
               ne.data = unit.id;
            }
            this._model.dispatchEvent(ne);
            return;
         }
         var ability:Ability = this._model.activeAbility;
         if(Boolean(ability) && ability.target == TargetType.POINT)
         {
            this.clickField(null);
            return;
         }
         if(Boolean(ability) && ability.target == TargetType.UNIT)
         {
            this._model.activeUnit = unit;
            this._model.dispatchEvent(new FieldEvent(FieldEvent.ACCEPT_ABILITY));
            return;
         }
         if(Boolean(this.selectedUnit) && this.selectedUnit.id == unit.id)
         {
            this.interact();
         }
         else if(player != this.myPlayer)
         {
            this.requestSelectTarget(unit.id);
         }
      }
      
      private function effectComplete(e:Event) : void
      {
         var effect:DisplayObject = e.target as DisplayObject;
         effect.removeEventListener(Event.COMPLETE,this.effectComplete);
         if(this.mcSpells.contains(effect))
         {
            this.mcSpells.removeChild(effect);
         }
      }
      
      private function activeObjectClicked(e:Event) : void
      {
         var id:String = null;
         var ne:FieldEvent = null;
         var unit:FieldUnit = null;
         var fo:FieldObject = e.target as FieldObject;
         if(!fo || !fo.id)
         {
            return;
         }
         if(Boolean(this._model.activeAbility))
         {
            if(this._model.activeAbility.target == TargetType.POINT)
            {
               this.clickField(null);
               return;
            }
            this.removeAoeHolder();
            this.removeSpellCursor();
            if(this._model.activeAbility.target == TargetType.OBJECT || this._model.activeAbility.target == TargetType.POINT)
            {
               if(Boolean(this._model.activeItem))
               {
                  ServerLayer.call("rtmService","useItemOnObject",null,null,this._model.activeItem.templateId,fo.id);
               }
               else
               {
                  ServerLayer.call("rtmService","useAbilityOnObject",null,null,this._model.activeAbility.id,fo.id);
               }
            }
            this._model.activeAbility = null;
         }
         else
         {
            for(id in this.objectUnits)
            {
               unit = this.objectUnits[id];
               if(Boolean(unit) && unit.objectId == fo.id)
               {
                  if(Boolean(this.selectedUnit) && this.selectedUnit.objectId == fo.id)
                  {
                     this.interact();
                  }
                  else
                  {
                     this.requestSelectTarget(unit.id);
                  }
                  return;
               }
            }
            ne = new FieldEvent(FieldEvent.CS_USE_OBJECT);
            ne.data = fo.id;
            this._model.dispatchEvent(ne);
         }
      }
      
      public function set model(value:RTMModel) : void
      {
         this._model = value;
      }
      
      public function set damageDisplay(value:uint) : void
      {
         this._damageDisplay = value;
      }
      
      public function set cameraFollowType(value:uint) : void
      {
         this._cameraFollowType = value;
      }
      
      public function set myPlayerId(id:String) : void
      {
         this._myPlayerId = id;
         if(Boolean(this.players))
         {
            this.myPlayer = this.players[id];
            this.myPlayer.myUnit = true;
            this._model.myUnit = this.myPlayer.unit;
            this.cameraPositionDirty = true;
         }
      }
      
      public function get myPlayerId() : String
      {
         return this._myPlayerId;
      }
      
      public function loadMap(mapData:MapData) : void
      {
         var mfz:MapFillZone = null;
         var objectLayout:ObjectLayout = null;
         var phase:SpritePhase = null;
         var cfg:SpriteConfig = null;
         visible = false;
         this._mapData = mapData;
         if(!mapData)
         {
            this.clearMap();
            return;
         }
         mapData.applyAspectRatio();
         objectLayouts = mapData.sprites;
         var libList:Array = [LibraryManager.mainLibrary,mapData.mapLayout.background.library];
         if(Boolean(mapData.mapLayout.deepBackground))
         {
            libList.push(mapData.mapLayout.deepBackground.library);
         }
         for each(mfz in mapData.mapLayout.fillZones)
         {
            if(Boolean(mfz.background.library) && libList.indexOf(mfz.background.library) == -1)
            {
               libList.push(mfz.background.library);
            }
         }
         for each(objectLayout in mapData.sprites)
         {
            for each(phase in objectLayout.phases)
            {
               for each(cfg in phase.sprites)
               {
                  if(libList.indexOf(cfg.library) == -1)
                  {
                     libList.push(cfg.library);
                  }
               }
            }
         }
         this.charsLoaded = this.libsLoaded = false;
         this.loader.addEventListener(LibraryManager.LOAD_ERROR,this.loadError);
         this.loader.addEventListener(LibraryManager.LIBRARY_LOADED,this.loadProgress);
         this.loader.addEventListener(LibraryManager.LOAD_COMPLETE,this.onLibrariesLoaded);
         this.loader.loadLibraries(libList);
         SpriteSheetLoder.dispatcher.addEventListener(Event.CHANGE,this.loadProgress);
         SpriteSheetLoder.dispatcher.addEventListener(Event.COMPLETE,this.onCharsLoaded);
         SpriteSheetLoder.dispatcher.addEventListener(ErrorEvent.ERROR,this.onCharsLoadError);
         SpriteSheetLoder.loadSpriteSheets(mapData.visuals);
      }
      
      private function onLibrariesLoaded(e:Event) : void
      {
         this.libsLoaded = true;
         this.loader.removeEventListener(LibraryManager.LOAD_COMPLETE,this.onLibrariesLoaded);
         this.loader.removeEventListener(LibraryManager.LIBRARY_LOADED,this.loadProgress);
         this.loader.removeEventListener(LibraryManager.LOAD_ERROR,this.loadError);
         this.checkAllLoaded();
      }
      
      private function onCharsLoaded(e:Event) : void
      {
         this.charsLoaded = true;
         SpriteSheetLoder.dispatcher.removeEventListener(Event.CHANGE,this.loadProgress);
         SpriteSheetLoder.dispatcher.removeEventListener(Event.COMPLETE,this.onCharsLoaded);
         this.checkAllLoaded();
      }
      
      private function onCharsLoadError(e:ErrorEvent) : void
      {
         LogManager.report(e.text);
      }
      
      private function loadProgress(e:Event) : void
      {
         this._progress = LibraryManager.progress * SpriteSheetLoder.progress;
         dispatchEvent(new FieldEvent(FieldEvent.LOAD_PROGRESS));
      }
      
      private function loadError(e:Event) : void
      {
         dispatchEvent(new FieldEvent(FieldEvent.LOAD_ERROR));
      }
      
      private function checkAllLoaded() : void
      {
         if(!this.libsLoaded || !this.charsLoaded)
         {
            return;
         }
         dispatchEvent(new FieldEvent(FieldEvent.LOAD_COMPLETE));
         layout = this._mapData.mapLayout;
         this.makeViewPort();
         this.visibilityTimer.start();
         this.cameraDirty = true;
      }
      
      public function set fowDisplay(value:uint) : void
      {
         if(this._fowDisplay == value)
         {
            return;
         }
         this._fowDisplay = value;
         this.applyFow();
      }
      
      private function applyFow() : void
      {
         var fov:Fov = null;
         if(!this.fovVisible)
         {
            this.mcFov.visible = false;
            this.darkness.visible = false;
            return;
         }
         switch(this._fowDisplay)
         {
            case FowDisplay.HIDDEN:
               this.mcFov.visible = false;
               break;
            case FowDisplay.LINE:
               this.mcFov.visible = true;
               this.darkness.visible = false;
               this.mcFov.blendMode = BlendMode.NORMAL;
               break;
            case FowDisplay.NORMAL:
               this.mcFov.visible = true;
               this.darkness.visible = true;
               this.mcFov.blendMode = BlendMode.MULTIPLY;
         }
         if(this._fowDisplay == FowDisplay.LINE || this._fowDisplay == FowDisplay.NORMAL)
         {
            for each(fov in this.fovs)
            {
               fov.displayMode = this._fowDisplay;
            }
         }
      }
      
      public function createAoe(ability:Ability) : void
      {
         if(ability.target != TargetType.POINT)
         {
            return;
         }
         var radius:int = Math.max(ability.radius,10);
         this.createAoeHolder(radius);
      }
      
      public function removeAoe() : void
      {
         this.removeAoeHolder();
         this.removeSpellCursor();
      }
      
      public function usePointAbilityOnUnit(unit:FieldUnit) : void
      {
         var ability:Ability = this._model.activeAbility;
         if(Boolean(ability) && Boolean(ability.target == TargetType.POINT) && Boolean(unit))
         {
            this.useAbilityAt(unit.x,unit.y * AspectRatio.y,ability);
            this._model.activeAbility = null;
            this._model.activeItem = null;
         }
         this.removeAoe();
      }
      
      private function requestMoveTo(x:int, y:int) : void
      {
         var e:FieldEvent = new FieldEvent(FieldEvent.CS_MOVE_TO);
         e.data = {
            "x":x,
            "y":y
         };
         this._model.dispatchEvent(e);
      }
      
      private function requestRunTo(x:int, y:int) : void
      {
         var e:FieldEvent = new FieldEvent(FieldEvent.CS_RUN_TO);
         e.data = {
            "x":x,
            "y":y
         };
         this._model.dispatchEvent(e);
      }
      
      private function requestStand() : void
      {
         var e:FieldEvent = new FieldEvent(FieldEvent.CS_STAND);
         this._model.dispatchEvent(e);
      }
      
      private function interact() : void
      {
         var e:FieldEvent = new FieldEvent(FieldEvent.CS_INTERACT);
         this._model.dispatchEvent(e);
      }
      
      private function useAbilityAt(x:int, y:int, ability:Ability) : void
      {
         var e:FieldEvent = new FieldEvent(FieldEvent.CS_USE_ABILITY_ON_FIELD);
         e.data = {
            "x":x,
            "y":y,
            "abilityId":ability.id
         };
         this._model.dispatchEvent(e);
      }
      
      private function useItemAt(x:int, y:int, templateId:String) : void
      {
         var e:FieldEvent = new FieldEvent(FieldEvent.CS_USE_ITEM_ON_FIELD);
         e.data = {
            "x":x,
            "y":y,
            "templateId":templateId
         };
         this._model.dispatchEvent(e);
      }
      
      public function requestSelectTarget(unitId:String) : void
      {
         var e:FieldEvent = new FieldEvent(FieldEvent.CS_SELECT_TARGET);
         e.data = unitId;
         this._model.dispatchEvent(e);
      }
      
      public function init(data:FieldData) : void
      {
         var unit:FieldUnit = null;
         var i:String = null;
         var id:String = null;
         for each(unit in data.fieldUnits)
         {
            this.addUnit(unit);
         }
         this.unitsChanged();
         for(i in data.dynamicObjects)
         {
            this.createObject(data.dynamicObjects[i],data.objectTooltips[i]);
         }
         for(id in data.phases)
         {
            this.setPhase(id,data.phases[id]);
         }
         this.minimapDirty = true;
         this.keyboardEnabled = true;
         this.fovVisible = data.fovEnabled;
         this.applyFow();
      }
      
      public function selectTarget(id:String) : void
      {
         var player:Player = null;
         if(Boolean(this.selectedUnit))
         {
            player = this.players[this.selectedUnit.id];
            if(Boolean(player))
            {
               player.selected = false;
            }
         }
         var unit:FieldUnit = this.objectUnits[id];
         if(Boolean(unit))
         {
            this.selectedUnit = unit;
         }
         else
         {
            player = this.players[id];
            if(Boolean(player))
            {
               player.selected = true;
               this.selectedUnit = player.unit;
            }
            else
            {
               this.selectedUnit = null;
            }
         }
         var e:FieldEvent = new FieldEvent(FieldEvent.CS_SELECT_UNIT);
         if(Boolean(this.selectedUnit))
         {
            e.data = this.selectedUnit;
         }
         this._model.dispatchEvent(e);
      }
      
      public function stopAt(id:String, x:int, y:int) : void
      {
         y /= AspectRatio.y;
         var player:Player = this.players[id];
         if(!player)
         {
            return;
         }
         player.x = x;
         player.y = y;
         this.stopPlayerTween(player);
      }
      
      public function stand(id:String) : void
      {
         var player:Player = this.players[id];
         if(!player)
         {
            return;
         }
         if(player.unit.dead)
         {
            return;
         }
         player.unit.castingTime = 0;
         this.stopPlayerTween(player);
         player.idle();
      }
      
      public function turnTo(id:String, x:int, y:int) : void
      {
         y /= AspectRatio.y;
         var player:Player = this.players[id];
         if(!player)
         {
            return;
         }
         player.turnTo(x,y);
      }
      
      public function moveTo(id:String, x:int, y:int, duration:uint, movementMode:String = "") : void
      {
         if(duration == 0)
         {
            return;
         }
         y /= AspectRatio.y;
         var player:Player = this.players[id];
         if(!player)
         {
            return;
         }
         this.stopPlayerTween(player);
         var tween:GTween = new GTween(player,duration / 1000,{
            "x":x,
            "y":y
         });
         this.tweens[id] = tween;
         player.moveTo(x,y,movementMode,duration);
         if(player == this.myPlayer)
         {
            this.interactiveTimer.start();
            this.iAmMoving = true;
            tween.onChange = this.myMoveProgress;
            this.myMoveProgress(null);
         }
      }
      
      public function startCast(id:String, castType:String, dx:int, dy:int, duration:int = 0) : void
      {
         var player:Player = this.players[id];
         if(!player)
         {
            return;
         }
         player.unit.castingTime = duration;
         dy /= AspectRatio.y;
         if(dx != 0 || dy != 0)
         {
            player.turnTo(player.x + dx,player.y + dy);
         }
         switch(castType)
         {
            case "bow":
               player.startBow();
               break;
            case "use":
               player.useItem();
               break;
            case "sword":
               player.idle();
               break;
            default:
            case "spell":
               player.castStart();
         }
      }
      
      public function instantCast(id:String, castType:String, dx:int, dy:int) : void
      {
         var player:Player = this.players[id];
         if(!player)
         {
            return;
         }
         dy /= AspectRatio.y;
         player.unit.castingTime = 0;
         if(dx != 0 || dy != 0)
         {
            player.turnTo(player.x + dx,player.y + dy);
         }
         switch(castType)
         {
            case "use":
               player.endUse();
               break;
            case "bow":
               player.endBow();
               break;
            case "spear":
               player.spear();
               break;
            case "sword":
               player.sword();
               break;
            case "spell":
               player.castEnd();
               break;
            default:
               player.idle();
         }
      }
      
      public function stopCast(id:String) : void
      {
         this.stand(id);
      }
      
      public function shootAt(srcId:String, x:int, y:int, visualId:String, duration:int) : void
      {
         var src:Point = null;
         if(duration <= 0)
         {
            return;
         }
         var objectUnit:FieldUnit = this.objectUnits[srcId];
         if(Boolean(objectUnit))
         {
            src = new Point(objectUnit.x,objectUnit.y - Shoot.VERICAL_GAP);
         }
         var srcPlayer:Player = this.players[srcId];
         if(Boolean(srcPlayer))
         {
            src = new Point(srcPlayer.x + srcPlayer.modelCenter.x,srcPlayer.y + srcPlayer.modelCenter.y);
         }
         if(!src)
         {
            return;
         }
         y /= AspectRatio.y;
         var shoot:Shoot = Shoot.createFromType(visualId);
         shoot.x = src.x;
         shoot.y = src.y;
         this.mcSpells.addChild(shoot);
         shoot.addEventListener(Event.COMPLETE,this.effectComplete);
         SoundUtils.play(SoundUtils.SHOOT);
         shoot.shoot(x - shoot.x,y - shoot.y - Shoot.VERICAL_GAP,duration);
      }
      
      public function shootFromAt(srcX:int, srcY:int, x:int, y:int, visualId:String, duration:int) : void
      {
         if(duration <= 0)
         {
            return;
         }
         y /= AspectRatio.y;
         srcY /= AspectRatio.y;
         var shoot:Shoot = Shoot.createFromType(visualId);
         shoot.x = srcX;
         shoot.y = srcY - Shoot.VERICAL_GAP;
         this.mcSpells.addChild(shoot);
         shoot.addEventListener(Event.COMPLETE,this.effectComplete);
         SoundUtils.play(SoundUtils.SHOOT);
         shoot.shoot(x - srcX,y - srcY,duration);
      }
      
      public function playEffect(id:String, effectId:String, effectLocation:String) : void
      {
         var player:Player = this.players[id];
         if(!player)
         {
            return;
         }
         player.playEffect(effectId,effectLocation);
      }
      
      public function playEffectAt(x:int, y:int, effectId:String) : void
      {
         y /= AspectRatio.y;
         var effectPlayer:EffectPlayer = new EffectPlayer();
         effectPlayer.x = x;
         effectPlayer.y = y;
         this.mcSpells.addChild(effectPlayer);
         effectPlayer.addEventListener(Event.COMPLETE,this.effectComplete);
         effectPlayer.play(effectId);
      }
      
      public function speak(id:String, text:String, type:String) : void
      {
         var player:Player = this.players[id];
         if(!player)
         {
            return;
         }
         player.speak(LocaleManager.getString(BundleName.SPEECH,text),type);
      }
      
      public function createObject(cfg:ObjectConfig, tooltipId:String = null) : void
      {
         cfg.y /= AspectRatio.y;
         this.createObjectFromConfig(cfg,tooltipId);
      }
      
      public function removeObject(id:String) : void
      {
         var sprite:FieldObject = null;
         var namePlate:Sprite = this.namePlates[id];
         if(Boolean(namePlate))
         {
            this.namePlates[id] = null;
            if(this.mcNamePlates.contains(namePlate))
            {
               this.mcNamePlates.removeChild(namePlate);
            }
         }
         for each(sprite in raisedObjects)
         {
            if(sprite.id == id)
            {
               if(mcRaised.contains(sprite))
               {
                  mcRaised.removeChild(sprite);
               }
               raisedObjects.splice(raisedObjects.indexOf(sprite),1);
               if(Boolean(edgeOrder))
               {
                  edgeOrder.removeSprite(sprite);
               }
               sprite.dispose();
               if(sprite.interactive)
               {
                  this.interactiveListDirty = true;
                  this._model.removeFromProximityMap(sprite);
               }
               return;
            }
         }
         for each(sprite in groundObjects)
         {
            if(sprite.id == id)
            {
               mcGround.removeChild(sprite);
               groundObjects.splice(groundObjects.indexOf(sprite),1);
               sprite.dispose();
               if(sprite.interactive)
               {
                  this.interactiveListDirty = true;
                  this._model.removeFromProximityMap(sprite);
               }
               return;
            }
         }
      }
      
      private function getObjectById(id:String) : FieldObject
      {
         var o:FieldObject = null;
         for each(o in raisedObjects)
         {
            if(o.id == id)
            {
               return o;
            }
         }
         for each(o in groundObjects)
         {
            if(o.id == id)
            {
               return o;
            }
         }
         return null;
      }
      
      public function setPhase(id:String, phase:String) : void
      {
         var fo:FieldObject = this.getObjectById(id);
         if(!fo)
         {
            return;
         }
         fo.setPhase(phase);
      }
      
      public function setActive(id:String, value:Boolean) : void
      {
         var fo:FieldObject = this.getObjectById(id);
         if(!fo)
         {
            return;
         }
         fo.interactive = value;
         if(value)
         {
            this._model.addToProximityMap(fo);
         }
         else
         {
            this._model.removeFromProximityMap(fo);
         }
         if(value && !fo.hasEventListener(MouseEvent.CLICK))
         {
            fo.addEventListener(MouseEvent.CLICK,this.activeObjectClicked);
         }
         else if(!value && fo.hasEventListener(MouseEvent.CLICK))
         {
            fo.removeEventListener(MouseEvent.CLICK,this.activeObjectClicked);
         }
         if(value)
         {
            this.mcNamePlates.addChild(fo.namePlate);
            this.namePlates[fo.id] = fo.namePlate;
         }
         else
         {
            delete this.namePlates[fo.id];
            if(this.mcNamePlates.contains(fo.namePlate))
            {
               this.mcNamePlates.removeChild(fo.namePlate);
            }
         }
      }
      
      public function setObjective(id:String, value:Boolean) : void
      {
         var fo:FieldObject = this.getObjectById(id);
         if(!fo)
         {
            return;
         }
         fo.objective = value;
      }
      
      public function createEffect(id:String, libraryId:String, x:int, y:int) : void
      {
         y /= AspectRatio.y;
      }
      
      public function createUnit(unit:FieldUnit) : void
      {
         this.addUnit(unit);
         this.unitChanged(unit.id);
         this.unitsChanged();
      }
      
      private function addUnit(unit:FieldUnit) : void
      {
         this._model.units[unit.id] = unit;
         this.unitChanged(unit.id);
         if(!unit.character)
         {
            unit.name = LocaleManager.getString(BundleName.NPC,unit.name);
         }
         if(Boolean(unit.objectId))
         {
            unit.y /= AspectRatio.y;
            this.objectUnits[unit.id] = unit;
            return;
         }
         var player:Player = new Player(unit);
         this.players[unit.id] = player;
         player.x = unit.x;
         player.y = unit.y / AspectRatio.y;
         player.mouseEnabled = true;
         player.addEventListener(MouseEvent.CLICK,this.playerClick,false,0,true);
         mcRaised.addChild(player);
         edgeOrder.addSprite(player,_sortingEnabled);
         var namePlate:Sprite = player.playerOverlay;
         this.mcNamePlates.addChild(namePlate);
         this.namePlates[unit.id] = namePlate;
         mcGround.addChild(player.auras);
         if(this.myPlayerId == unit.id)
         {
            this.addUnitFov(unit.id,player.fov);
            edgeOrder.reorderAll();
            this.myPlayer = player;
            this._model.myUnit = unit;
            this.myPlayer.myUnit = true;
            this.myMoveProgress(null);
            visible = true;
            this.interactiveListDirty = true;
         }
      }
      
      public function removeUnit(id:String) : void
      {
         delete this._model.units[id];
         this.unitChanged(id);
         this.unitsChanged();
         if(Boolean(this.objectUnits[id]))
         {
            delete this.objectUnits[id];
            return;
         }
         if(id == this.myPlayerId)
         {
            this.myPlayer = null;
         }
         var player:Player = this.players[id];
         if(Boolean(player))
         {
            this.stopPlayerTween(player);
            if(mcGround.contains(player.auras))
            {
               mcGround.removeChild(player.auras);
            }
            if(deleteWithFade)
            {
               new GTween(player,FADE_TIME,{"alpha":0}).onComplete = this.fadeComplete;
            }
            else
            {
               this.removePlayer(player);
            }
            delete this.players[id];
         }
         var namePlate:Sprite = this.namePlates[id];
         if(Boolean(namePlate))
         {
            if(this.mcNamePlates.contains(namePlate))
            {
               this.mcNamePlates.removeChild(namePlate);
            }
            delete this.namePlates[id];
         }
         this.removeUnitFov(id);
      }
      
      private function fadeComplete(tween:GTween) : void
      {
         var player:Player = tween.target as Player;
         this.removePlayer(player);
      }
      
      private function addUnitFov(id:String, fov:Fov) : void
      {
         if(!fov)
         {
            return;
         }
         fov.displayMode = this._fowDisplay;
         this.mcFov.addChild(fov);
         this.fovs[id] = fov;
      }
      
      private function removeUnitFov(id:String) : void
      {
         var fov:Fov = this.fovs[id];
         if(Boolean(fov))
         {
            this.mcFov.removeChild(fov);
            delete this.fovs[id];
         }
      }
      
      private function removePlayer(player:Player) : void
      {
         if(mcRaised.contains(player))
         {
            mcRaised.removeChild(player);
         }
         if(Boolean(edgeOrder))
         {
            edgeOrder.removeSprite(player);
         }
      }
      
      public function updateUnit(unit:FieldUnit) : void
      {
         if(!unit)
         {
            return;
         }
         var id:String = unit.id;
         unit.y /= AspectRatio.y;
         if(id == this.myPlayerId)
         {
            this._model.myUnit = unit;
         }
         if(Boolean(this._model.targetUnit) && id == this._model.targetUnit.id)
         {
            this._model.targetUnit = unit;
         }
         this._model.units[id] = unit;
         this.unitChanged(id);
         var player:Player = this.players[id];
         if(!player)
         {
            return;
         }
         this.removeUnitFov(id);
         player.setUnit(unit);
         this.addUnitFov(id,player.fov);
      }
      
      public function missed(id:String, sourceId:String) : void
      {
         if(!this.damageSourceVisible(sourceId,id))
         {
            return;
         }
         var player:Player = this.players[id];
         if(!player)
         {
            return;
         }
         SoundUtils.play(SoundUtils.MISS);
         player.missed();
      }
      
      public function immune(id:String, sourceId:String, element:String = null) : void
      {
         if(!this.damageSourceVisible(sourceId,id))
         {
            return;
         }
         var player:Player = this.players[id];
         if(!player)
         {
            return;
         }
         SoundUtils.play(SoundUtils.IMMUNE);
         player.immune(element);
      }
      
      public function changeStats(id:String, sourceId:String, statType:String, elementType:String, amount:int, critical:Boolean, absorb:int = 0) : void
      {
         if(!this.damageSourceVisible(sourceId,id))
         {
            return;
         }
         var player:Player = this.players[id];
         if(!player)
         {
            return;
         }
         if(amount < 0)
         {
            player.damage();
            SoundUtils.play(SoundUtils.OUCH);
         }
         player.changeStats(statType,elementType,amount,critical);
      }
      
      private function damageSourceVisible(source:String, target:String) : Boolean
      {
         if(this._damageDisplay == DamageDisplay.NO_DISPLAY)
         {
            return false;
         }
         if(this._damageDisplay == DamageDisplay.PLAYER_DISPLAY && target != this._myPlayerId && source != this._myPlayerId)
         {
            return false;
         }
         return true;
      }
      
      public function changeUnitProperty(id:String, property:String, value:Object) : void
      {
         var player:Player = this.players[id];
         var unit:FieldUnit = Boolean(player) ? player.unit : this.objectUnits[id];
         if(!unit)
         {
            return;
         }
         unit[property] = value;
         if(Boolean(player))
         {
            player.drawCircle();
            if(property == "objective")
            {
               player.objective = value;
            }
            else if(property == "sightRange")
            {
               player.fov.updateSize(int(value));
            }
         }
      }
      
      public function setStats(id:String, statType:String, amount:int) : void
      {
         var unit:FieldUnit = null;
         var player:Player = this.players[id];
         if(Boolean(player))
         {
            player.setStats(statType,amount);
         }
         else
         {
            unit = this.objectUnits[id];
            if(Boolean(unit))
            {
               unit.stats[statType] = amount;
            }
         }
      }
      
      public function setEffects(id:String, effects:Array) : void
      {
         var player:Player = this.players[id];
         if(!player)
         {
            return;
         }
         player.setEffects(effects);
      }
      
      public function die(id:String) : void
      {
         var player:Player = this.players[id];
         if(!player)
         {
            return;
         }
         player.die();
      }
      
      public function resurrect(id:String) : void
      {
         var player:Player = this.players[id];
         if(!player)
         {
            return;
         }
         player.resurrect();
      }
      
      public function setQuestStatus(id:String, status:String) : void
      {
         var player:Player = this.players[id];
         if(!player)
         {
            return;
         }
         player.setQuestStatus(status);
      }
      
      public function getLoadProgress() : Number
      {
         return this._progress;
      }
   }
}

