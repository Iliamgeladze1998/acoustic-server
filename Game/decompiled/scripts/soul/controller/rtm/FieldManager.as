package soul.controller.rtm
{
   import flash.events.Event;
   import mx.binding.utils.BindingUtils;
   import mx.binding.utils.ChangeWatcher;
   import soul.controller.IManager;
   import soul.controller.LogManager;
   import soul.controller.loading.LoadingManager;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.FieldEvent;
   import soul.event.MiniMapEvent;
   import soul.event.SettingsEvent;
   import soul.model.GameModel;
   import soul.model.buff.Effect;
   import soul.model.field.BaseUnit;
   import soul.model.field.FieldData;
   import soul.model.field.FieldUnit;
   import soul.model.field.LibraryManager;
   import soul.model.field.mapconfig.MapData;
   import soul.model.field.mapconfig.ObjectConfig;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   import soul.utils.BitmapUtils;
   import soul.view.field.IFieldView;
   
   public class FieldManager implements IManager
   {
      
      private var view:IFieldView;
      
      private var model:GameModel;
      
      private var cw:ChangeWatcher;
      
      public function FieldManager(view:IFieldView, model:GameModel)
      {
         super();
         this.view = view;
         this.model = model;
         ComponentLocator.setComponent(ComponentLocator.FIELD,this);
         this.cw = BindingUtils.bindSetter(this.myIdChanged,model.characterModel,"id",false,true);
         view.model = model.rtmModel;
         model.rtmModel.addEventListener(FieldEvent.UNSELECT_TARGET,this.unselectTarget,false,0,true);
         model.rtmModel.addEventListener(FieldEvent.CREATE_AOE,this.createAoe,false,0,true);
         model.rtmModel.addEventListener(FieldEvent.REMOVE_AOE,this.removeAoe,false,0,true);
         model.rtmModel.addEventListener(FieldEvent.USE_POINT_ABILITY_ON_UNIT,this.usePointAbilityOnUnit,false,0,true);
         model.rtmModel.addEventListener(FieldEvent.CS_MOVE_TO,this.requestMoveTo,false,0,true);
         model.rtmModel.addEventListener(FieldEvent.CS_RUN_TO,this.requestRunTo,false,0,true);
         model.rtmModel.addEventListener(FieldEvent.CS_STAND,this.requestStand,false,0,true);
         model.rtmModel.addEventListener(FieldEvent.CS_INTERACT,this.interact,false,0,true);
         model.rtmModel.addEventListener(FieldEvent.CS_SELECT_TARGET,this.requestSelectTarget,false,0,true);
         model.rtmModel.addEventListener(FieldEvent.CS_SELECT_UNIT,this.selectUnit,false,0,true);
         model.rtmModel.addEventListener(FieldEvent.CS_USE_ABILITY_ON_UNIT,this.useAbilityOnUnit,false,0,true);
         model.rtmModel.addEventListener(FieldEvent.CS_USE_ABILITY_ON_FIELD,this.useAbilityOnField,false,0,true);
         model.rtmModel.addEventListener(FieldEvent.CS_USE_ITEM_ON_UNIT,this.useItemOnUnit,false,0,true);
         model.rtmModel.addEventListener(FieldEvent.CS_USE_ITEM_ON_FIELD,this.useItemOnField,false,0,true);
         model.rtmModel.addEventListener(FieldEvent.CS_USE_ABILITY_HERE,this.useAbilityHere,false,0,true);
         model.rtmModel.addEventListener(FieldEvent.CS_USE_ITEM_HERE,this.useItemHere,false,0,true);
         model.rtmModel.addEventListener(FieldEvent.CS_USE_OBJECT,this.useObject,false,0,true);
         model.settingsModel.addEventListener(SettingsEvent.LIGHTING,this.lightingChanged,false,0,true);
         model.settingsModel.addEventListener(SettingsEvent.DAMAGE,this.damageChanged,false,0,true);
         model.settingsModel.addEventListener(SettingsEvent.FOW,this.fowChanged,false,0,true);
         model.settingsModel.addEventListener(SettingsEvent.CAMERA,this.cameraChanged,false,0,true);
         view.addEventListener(FieldEvent.LOAD_PROGRESS,this.mapLoadProgress,false,0,true);
         view.addEventListener(FieldEvent.LOAD_COMPLETE,this.mapLoadComplete,false,0,true);
         view.addEventListener(FieldEvent.LOAD_ERROR,this.mapLoadError,false,0,true);
         this.lightingChanged(null);
         this.damageChanged(null);
         this.fowChanged(null);
         this.cameraChanged(null);
      }
      
      public function reset() : void
      {
         trace("FieldManager.reset()");
         ComponentLocator.setComponent(ComponentLocator.FIELD,null);
         if(Boolean(this.cw))
         {
            this.cw.unwatch();
         }
         this.view.reset();
         this.model.rtmModel.removeEventListener(FieldEvent.UNSELECT_TARGET,this.unselectTarget);
         this.model.rtmModel.removeEventListener(FieldEvent.CREATE_AOE,this.createAoe);
         this.model.rtmModel.removeEventListener(FieldEvent.REMOVE_AOE,this.removeAoe);
         this.model.rtmModel.removeEventListener(FieldEvent.USE_POINT_ABILITY_ON_UNIT,this.usePointAbilityOnUnit);
         this.model.rtmModel.removeEventListener(FieldEvent.CS_MOVE_TO,this.requestMoveTo);
         this.model.rtmModel.removeEventListener(FieldEvent.CS_RUN_TO,this.requestRunTo);
         this.model.rtmModel.removeEventListener(FieldEvent.CS_STAND,this.requestStand);
         this.model.rtmModel.removeEventListener(FieldEvent.CS_INTERACT,this.interact);
         this.model.rtmModel.removeEventListener(FieldEvent.CS_SELECT_TARGET,this.requestSelectTarget);
         this.model.rtmModel.removeEventListener(FieldEvent.CS_SELECT_UNIT,this.selectUnit);
         this.model.rtmModel.removeEventListener(FieldEvent.CS_USE_ABILITY_ON_UNIT,this.useAbilityOnUnit);
         this.model.rtmModel.removeEventListener(FieldEvent.CS_USE_ABILITY_ON_FIELD,this.useAbilityOnField);
         this.model.rtmModel.removeEventListener(FieldEvent.CS_USE_ITEM_ON_UNIT,this.useItemOnUnit);
         this.model.rtmModel.removeEventListener(FieldEvent.CS_USE_ITEM_ON_FIELD,this.useItemOnField);
         this.model.rtmModel.removeEventListener(FieldEvent.CS_USE_ABILITY_HERE,this.useAbilityHere);
         this.model.settingsModel.removeEventListener(SettingsEvent.LIGHTING,this.lightingChanged);
         this.model.settingsModel.removeEventListener(SettingsEvent.DAMAGE,this.damageChanged);
         this.model.settingsModel.removeEventListener(SettingsEvent.FOW,this.fowChanged);
         this.view.removeEventListener(FieldEvent.LOAD_PROGRESS,this.mapLoadProgress);
         this.view.removeEventListener(FieldEvent.LOAD_COMPLETE,this.mapLoadComplete);
         this.view.removeEventListener(FieldEvent.LOAD_ERROR,this.mapLoadError);
      }
      
      public function cleanMap() : void
      {
         this.view.loadMap(null);
         LoadingManager.hide();
      }
      
      private function myIdChanged(value:String) : void
      {
         this.view.myPlayerId = value;
      }
      
      private function mapLoadProgress(e:Event) : void
      {
         LoadingManager.progress = this.view.getLoadProgress();
      }
      
      private function mapLoadError(e:Event) : void
      {
         LoadingManager.action = LocaleManager.getString(BundleName.SYSTEM,"errorLoadingLibraries");
         LogManager.report("error loading library: " + LibraryManager.libraryErrorDescription);
      }
      
      private function mapLoadComplete(e:Event) : void
      {
         LoadingManager.hide();
         ServerLayer.call("rtmService","fieldReady");
         this.model.rtmModel.dispatchEvent(new FieldEvent(FieldEvent.FIELD_READY));
      }
      
      private function unselectTarget(e:Event) : void
      {
         trace("FieldManager.unselectTarget()");
         this.view.requestSelectTarget(null);
      }
      
      private function createAoe(e:FieldEvent) : void
      {
         if(!this.model.rtmModel.activeAbility)
         {
            return;
         }
         this.view.createAoe(this.model.rtmModel.activeAbility);
      }
      
      private function removeAoe(e:FieldEvent) : void
      {
         this.view.removeAoe();
      }
      
      private function usePointAbilityOnUnit(e:FieldEvent) : void
      {
         this.view.usePointAbilityOnUnit(e.data as FieldUnit);
      }
      
      protected function lightingChanged(e:Event) : void
      {
         this.view.showLighting = this.model.settingsModel.showLighting;
      }
      
      protected function damageChanged(e:Event) : void
      {
         this.view.damageDisplay = this.model.settingsModel.damageDisplay;
      }
      
      protected function fowChanged(e:Event) : void
      {
         this.view.fowDisplay = this.model.settingsModel.fowDisplay;
      }
      
      protected function cameraChanged(e:Event) : void
      {
         this.view.cameraFollowType = this.model.settingsModel.cameraFollowType;
      }
      
      public function getMapData() : void
      {
         LoadingManager.show();
         LoadingManager.action = LocaleManager.getString(BundleName.SYSTEM,"loadingMap");
         LoadingManager.tip = LocaleManager.getRandomTip();
         ServerLayer.call("rtmService","getMapData",this.setMapData,this.mapDataNA);
      }
      
      private function requestMoveTo(e:FieldEvent) : void
      {
         ServerLayer.call("rtmService","moveTo",null,null,e.data.x,e.data.y);
      }
      
      private function requestRunTo(e:FieldEvent) : void
      {
         ServerLayer.call("rtmService","runTo",null,null,e.data.x,e.data.y);
      }
      
      private function requestStand(e:FieldEvent) : void
      {
         ServerLayer.call("rtmService","stand");
      }
      
      private function requestSelectTarget(e:FieldEvent) : void
      {
         ServerLayer.call("rtmService","selectTarget",null,null,e.data);
      }
      
      private function selectUnit(e:FieldEvent) : void
      {
         this.model.rtmModel.targetUnit = e.data;
      }
      
      private function interact(e:FieldEvent) : void
      {
         ServerLayer.call("rtmService","interact",null,null);
      }
      
      private function useAbilityOnUnit(e:FieldEvent) : void
      {
         ServerLayer.call("rtmService","useAbilityOnUnit",null,null,e.data.abilityId,e.data.targetId);
      }
      
      private function useAbilityOnField(e:FieldEvent) : void
      {
         ServerLayer.call("rtmService","useAbilityOnField",null,null,e.data.abilityId,e.data.x,e.data.y);
      }
      
      private function useItemOnUnit(e:FieldEvent) : void
      {
         ServerLayer.call("rtmService","useItemOnUnit",null,null,e.data.templateId,e.data.targetId);
      }
      
      private function useItemOnField(e:FieldEvent) : void
      {
         ServerLayer.call("rtmService","useItemOnField",null,null,e.data.templateId,e.data.x,e.data.y);
      }
      
      private function useAbilityHere(e:FieldEvent) : void
      {
         ServerLayer.call("rtmService","useAbilityHere",null,null,e.data);
      }
      
      private function useItemHere(e:FieldEvent) : void
      {
         ServerLayer.call("rtmService","useItem",null,null,e.data);
      }
      
      private function useObject(e:FieldEvent) : void
      {
         ServerLayer.call("rtmService","useObject",null,null,e.data);
      }
      
      public function mapChanged() : void
      {
         this.view.selectTarget(null);
         this.view.reset();
         BitmapUtils.clearCache();
         var e:FieldEvent = new FieldEvent(FieldEvent.MAP_LOADING);
         e.data = true;
         this.model.rtmModel.dispatchEvent(e);
         this.getMapData();
      }
      
      private function mapDataNA(r:* = null) : void
      {
         this.cleanMap();
      }
      
      private function setMapData(mapData:MapData) : void
      {
         if(!mapData)
         {
            this.mapDataNA();
            return;
         }
         this.model.rtmModel.sectorId = mapData.sectorId;
         this.model.rtmModel.mapId = mapData.mapLayout.id;
         this.model.rtmModel.mapName = LocaleManager.getMapName(this.model.rtmModel.sectorId,this.model.rtmModel.mapId);
         this.model.rtmModel.pvpState = mapData.pvpState;
         this.model.rtmModel.mapWidth = mapData.mapLayout.width;
         this.model.rtmModel.mapHeight = mapData.mapLayout.height;
         if(Boolean(mapData.mapLayout.lights))
         {
            mapData.mapLayout.lights.enabled = true;
         }
         LoadingManager.action = LocaleManager.getString(BundleName.SYSTEM,"loadingMapLibraries");
         LoadingManager.tip = LocaleManager.getRandomTip();
         this.view.loadMap(mapData);
      }
      
      public function init(data:FieldData) : void
      {
         this.view.init(data);
         var e:FieldEvent = new FieldEvent(FieldEvent.MAP_LOADING);
         e.data = false;
         this.model.rtmModel.dispatchEvent(e);
         this.model.rtmModel.mapEdge = data.edge;
         this.model.rtmModel.timeout = -1;
         this.model.rtmModel.timeout = data.timeout;
         this.changeQuestDetails(data.questDetails);
      }
      
      public function changeQuestDetails(questDetails:Array) : void
      {
         this.model.rtmModel.miniMapModel.questDetails = questDetails;
         this.model.rtmModel.miniMapModel.dispatchEvent(new MiniMapEvent(MiniMapEvent.POI_CHANGED));
      }
      
      public function selectTarget(id:String) : void
      {
         this.view.selectTarget(id);
      }
      
      public function stopAt(id:String, x:int, y:int) : void
      {
         this.view.stopAt(id,x,y);
      }
      
      public function stand(id:String) : void
      {
         this.view.stand(id);
      }
      
      public function turnTo(id:String, x:int, y:int) : void
      {
         this.view.turnTo(id,x,y);
      }
      
      public function moveTo(id:String, x:int, y:int, duration:int, movementMode:String = "") : void
      {
         this.view.moveTo(id,x,y,duration,movementMode);
      }
      
      public function startCast(id:String, castType:String, x:int, y:int, duration:int = 0) : void
      {
         this.view.startCast(id,castType,x,y,duration);
      }
      
      public function instantCast(id:String, castType:String, x:int, y:int) : void
      {
         this.view.instantCast(id,castType,x,y);
      }
      
      public function stopCast(id:String) : void
      {
         this.view.stopCast(id);
      }
      
      public function shootAt(srcId:String, x:int, y:int, visualId:String, duration:int) : void
      {
         this.view.shootAt(srcId,x,y,visualId,duration);
      }
      
      public function shootFromAt(srcX:int, srcY:int, x:int, y:int, visualId:String, duration:int) : void
      {
         this.view.shootFromAt(srcX,srcY,x,y,visualId,duration);
      }
      
      public function playEffect(id:String, effectId:String, effectLocation:String) : void
      {
         this.view.playEffect(id,effectId,effectLocation);
      }
      
      public function playEffectAt(x:int, y:int, effectId:String) : void
      {
         this.view.playEffectAt(x,y,effectId);
      }
      
      public function speak(id:String, text:String, type:String) : void
      {
         this.view.speak(id,text,type);
      }
      
      public function createObject(cfg:ObjectConfig, tooltipId:String = null) : void
      {
         this.view.createObject(cfg,tooltipId);
      }
      
      public function createEffect(id:String, libraryId:String, x:int, y:int) : void
      {
         this.view.createEffect(id,libraryId,x,y);
      }
      
      public function createUnit(unit:FieldUnit) : void
      {
         this.view.createUnit(unit);
      }
      
      public function removeUnit(id:String) : void
      {
         this.view.removeUnit(id);
      }
      
      public function updateUnit(unit:FieldUnit) : void
      {
         this.view.updateUnit(unit);
      }
      
      public function removeObject(id:*) : void
      {
         this.view.removeObject(id);
      }
      
      public function setPhase(id:String, phase:String) : void
      {
         this.view.setPhase(id,phase);
      }
      
      public function setActive(id:String, value:Boolean) : void
      {
         this.view.setActive(id,value);
      }
      
      public function setObjective(id:String, value:Boolean) : void
      {
         this.view.setObjective(id,value);
      }
      
      public function changeStats(id:String, sourceId:String, statType:String, sourceType:String, amount:int, critical:Boolean = false, absorb:int = 0) : void
      {
         this.view.changeStats(id,sourceId,statType,sourceType,amount,critical,absorb);
      }
      
      public function changeUnitProperty(id:String, property:String, value:Object) : void
      {
         this.view.changeUnitProperty(id,property,value);
      }
      
      public function setStats(id:String, statType:String, amount:int) : void
      {
         this.view.setStats(id,statType,amount);
      }
      
      public function missed(id:String, sourceId:String) : void
      {
         this.view.missed(id,sourceId);
      }
      
      public function immune(id:String, sourceId:String, element:String = null) : void
      {
         this.view.immune(id,sourceId,element);
      }
      
      public function setEffects(id:String, effects:Array) : void
      {
         this.view.setEffects(id,effects);
      }
      
      public function updateEffectHp(unitId:String, effectId:String, value:int) : void
      {
         var unit:BaseUnit = this.model.rtmModel.units[unitId];
         if(Boolean(unit))
         {
            this.updateUnitEffects(unit,effectId,value);
         }
         unit = this.model.characterModel.myUnit;
         if(Boolean(unit) && unitId == unit.id)
         {
            this.updateUnitEffects(unit,effectId,value);
         }
      }
      
      private function updateUnitEffects(unit:BaseUnit, effectId:String, value:int) : void
      {
         var effect:Effect = null;
         for each(effect in unit.effects)
         {
            if(effect.id == effectId)
            {
               effect.updateHp(value);
               return;
            }
         }
      }
      
      public function die(id:String) : void
      {
         this.view.die(id);
      }
      
      public function resurrect(id:String) : void
      {
         this.view.resurrect(id);
      }
      
      public function setQuestStatus(id:String, status:String) : void
      {
         this.view.setQuestStatus(id,status);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.MAPS,key);
      }
   }
}

