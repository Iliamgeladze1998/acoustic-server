package soul.controller
{
   import soul.event.ChatEvent;
   import soul.model.GameModel;
   import soul.model.chat.ChatTabModel;
   import soul.model.chat.Message;
   import soul.model.combat.AbilityApplyRecord;
   import soul.model.combat.CombatRecord;
   import soul.model.combat.DamageRecord;
   import soul.model.combat.EffectApplyRecord;
   import soul.model.combat.EffectDispelRecord;
   import soul.model.combat.EffectExpireRecord;
   import soul.model.combat.ExperienceRecord;
   import soul.model.combat.HealRecord;
   import soul.model.combat.KillRecord;
   import soul.model.combat.MissRecord;
   import soul.model.combat.StatusRecord;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   
   public class CombatManager implements IManager
   {
      
      private static const SERVICE:String = "combatService";
      
      private var model:GameModel;
      
      public function CombatManager(model:GameModel)
      {
         super();
         ComponentLocator.setComponent(ComponentLocator.COMBAT,this);
         this.model = model;
         model.chatModel.addEventListener(ChatEvent.TOGGLE_COMBAT_LOG,this.toggleEnabled);
         ServerLayer.call(SERVICE,ComponentLocator.READY);
      }
      
      public function reset() : void
      {
         this.model.chatModel.removeEventListener(ChatEvent.TOGGLE_COMBAT_LOG,this.toggleEnabled);
      }
      
      private function toggleEnabled(e:ChatEvent) : void
      {
         ServerLayer.call(SERVICE,"setEnabled",null,null,!this.model.chatModel.combatLogEnabled);
      }
      
      public function init(records:Array, enabled:Boolean) : void
      {
         var record:CombatRecord = null;
         for each(record in records)
         {
            this.addToChat(record);
         }
         this.setEnabled(enabled);
      }
      
      public function setEnabled(value:Boolean) : void
      {
         this.model.chatModel.combatLogEnabled = value;
      }
      
      public function miss(record:MissRecord) : void
      {
         this.addToChat(record);
      }
      
      public function immune(record:CombatRecord) : void
      {
         this.addToChat(record);
      }
      
      public function status(record:StatusRecord) : void
      {
         this.addToChat(record);
      }
      
      public function damage(record:DamageRecord) : void
      {
         this.addToChat(record);
      }
      
      public function heal(record:HealRecord) : void
      {
         this.addToChat(record);
      }
      
      public function kill(record:KillRecord) : void
      {
         this.addToChat(record);
      }
      
      public function experience(record:ExperienceRecord) : void
      {
         this.addToChat(record);
      }
      
      public function abilityApply(record:AbilityApplyRecord) : void
      {
         this.addToChat(record);
      }
      
      public function effectApply(record:EffectApplyRecord) : void
      {
         this.addToChat(record);
      }
      
      public function effectExpire(record:EffectExpireRecord) : void
      {
         this.addToChat(record);
      }
      
      public function effectDispel(record:EffectDispelRecord) : void
      {
         this.addToChat(record);
      }
      
      private function addToChat(record:CombatRecord) : void
      {
         var message:Message = new Message();
         message.date = new Date(record.date);
         message.text = record.toString();
         message.type = ChatTabModel.COMBAT;
         var e:ChatEvent = new ChatEvent(ChatEvent.ADD_COMBAT_MESSAGE,false);
         e.data = message;
         this.model.chatModel.dispatchEvent(e);
      }
   }
}

