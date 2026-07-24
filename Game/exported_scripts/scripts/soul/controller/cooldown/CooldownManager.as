package soul.controller.cooldown
{
   import soul.model.cooldown.Cooldown;
   import soul.model.cooldown.CooldownData;
   import soul.model.cooldown.CooldownModel;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   
   public class CooldownManager
   {
      
      private var model:CooldownModel;
      
      public function CooldownManager(model:CooldownModel)
      {
         super();
         this.model = model;
         ComponentLocator.setComponent(ComponentLocator.COOLDOWN,this);
         ServerLayer.call("cooldownService",ComponentLocator.READY);
      }
      
      public function init(data:CooldownData) : void
      {
         this.model.groups = data.groups;
         this.model.abilities = data.abilities;
      }
      
      public function setGroupCD(value:Cooldown) : void
      {
         this.model.setGroupCd(value);
      }
      
      public function setAbilityCD(value:Cooldown) : void
      {
         this.model.setAbilityCd(value);
      }
   }
}

