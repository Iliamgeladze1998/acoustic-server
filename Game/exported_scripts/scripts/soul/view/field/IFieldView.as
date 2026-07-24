package soul.view.field
{
   import flash.events.IEventDispatcher;
   import soul.model.ability.Ability;
   import soul.model.field.FieldData;
   import soul.model.field.FieldUnit;
   import soul.model.field.mapconfig.MapData;
   import soul.model.field.mapconfig.ObjectConfig;
   import soul.model.rtm.RTMModel;
   
   public interface IFieldView extends IEventDispatcher
   {
      
      function reset() : void;
      
      function loadMap(param1:MapData) : void;
      
      function init(param1:FieldData) : void;
      
      function requestSelectTarget(param1:String) : void;
      
      function createAoe(param1:Ability) : void;
      
      function removeAoe() : void;
      
      function usePointAbilityOnUnit(param1:FieldUnit) : void;
      
      function selectTarget(param1:String) : void;
      
      function stopAt(param1:String, param2:int, param3:int) : void;
      
      function stand(param1:String) : void;
      
      function turnTo(param1:String, param2:int, param3:int) : void;
      
      function moveTo(param1:String, param2:int, param3:int, param4:uint, param5:String = "") : void;
      
      function startCast(param1:String, param2:String, param3:int, param4:int, param5:int = 0) : void;
      
      function instantCast(param1:String, param2:String, param3:int, param4:int) : void;
      
      function stopCast(param1:String) : void;
      
      function shootAt(param1:String, param2:int, param3:int, param4:String, param5:int) : void;
      
      function shootFromAt(param1:int, param2:int, param3:int, param4:int, param5:String, param6:int) : void;
      
      function playEffect(param1:String, param2:String, param3:String) : void;
      
      function playEffectAt(param1:int, param2:int, param3:String) : void;
      
      function speak(param1:String, param2:String, param3:String) : void;
      
      function createObject(param1:ObjectConfig, param2:String = null) : void;
      
      function createEffect(param1:String, param2:String, param3:int, param4:int) : void;
      
      function createUnit(param1:FieldUnit) : void;
      
      function removeUnit(param1:String) : void;
      
      function updateUnit(param1:FieldUnit) : void;
      
      function removeObject(param1:String) : void;
      
      function setPhase(param1:String, param2:String) : void;
      
      function setActive(param1:String, param2:Boolean) : void;
      
      function setObjective(param1:String, param2:Boolean) : void;
      
      function changeStats(param1:String, param2:String, param3:String, param4:String, param5:int, param6:Boolean, param7:int = 0) : void;
      
      function changeUnitProperty(param1:String, param2:String, param3:Object) : void;
      
      function setStats(param1:String, param2:String, param3:int) : void;
      
      function missed(param1:String, param2:String) : void;
      
      function immune(param1:String, param2:String, param3:String = null) : void;
      
      function setEffects(param1:String, param2:Array) : void;
      
      function die(param1:String) : void;
      
      function resurrect(param1:String) : void;
      
      function setQuestStatus(param1:String, param2:String) : void;
      
      function getLoadProgress() : Number;
      
      function set myPlayerId(param1:String) : void;
      
      function set model(param1:RTMModel) : void;
      
      function set showLighting(param1:Boolean) : void;
      
      function set damageDisplay(param1:uint) : void;
      
      function set fowDisplay(param1:uint) : void;
      
      function set cameraFollowType(param1:uint) : void;
   }
}

