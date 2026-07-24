package soul.controller.interaction
{
   import flash.events.Event;
   import soul.controller.IManager;
   import soul.controller.Interaction;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.QuestEvent;
   import soul.model.common.InteractionType;
   import soul.model.condition.Condition;
   import soul.model.interaction.quest.HintEntry;
   import soul.model.interaction.quest.QuestEntry;
   import soul.model.interaction.quest.QuestModel;
   import soul.model.interaction.quest.QuestState;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   import soul.view.common.BigMessage;
   
   public class QuestManager implements IManager
   {
      
      private var model:QuestModel;
      
      public function QuestManager(model:QuestModel)
      {
         super();
         ComponentLocator.setComponent(ComponentLocator.QUEST,this);
         this.model = model;
         model.tabs = [LocaleManager.getString(BundleName.INTERFACE,"questLog.inProgress"),LocaleManager.getString(BundleName.INTERFACE,"questLog.done"),LocaleManager.getString(BundleName.INTERFACE,"questLog.hints")];
         model.addEventListener(QuestEvent.HINT_READ,this.hintRead);
         model.addEventListener(QuestEvent.QUESTS_CANCEL,this.questCancel);
         model.addEventListener(QuestEvent.QUESTS_PIN,this.questPin);
         ServerLayer.call("questService",ComponentLocator.READY);
      }
      
      public function reset() : void
      {
      }
      
      public function init(quests:Array, hints:Array = null, selectedQuestId:String = null) : void
      {
         var qe:QuestEntry = null;
         this.model.quests = quests;
         this.model.hints = hints;
         this.model.dispatchEvent(new Event(QuestEvent.QUESTS_UPDATED));
         if(Boolean(selectedQuestId))
         {
            this.model.trackedQuestId = selectedQuestId;
            qe = this.model.findQuestById(selectedQuestId);
            if(Boolean(qe))
            {
               qe.tracked = true;
            }
         }
         this.checkNewHints();
      }
      
      public function addQuest(value:QuestEntry) : void
      {
         if(!value)
         {
            return;
         }
         this.model.quests.unshift(value);
         this.model.dispatchEvent(new Event(QuestEvent.QUESTS_UPDATED));
      }
      
      public function addSubQuest(value:QuestEntry, masterQuestId:String) : void
      {
         if(!value)
         {
            return;
         }
         var masterQuest:QuestEntry = this.model.getQuestById(masterQuestId);
         if(masterQuest.subquests == null)
         {
            masterQuest.subquests = [];
         }
         masterQuest.subquests.push(value);
         this.model.dispatchEvent(new Event(QuestEvent.QUESTS_UPDATED));
      }
      
      public function changeQuest(questId:String, objective:String, value:int) : void
      {
         var qe:QuestEntry = this.model.getQuestById(questId);
         if(!qe)
         {
            return;
         }
         var qc:Condition = qe.getConditionById(objective);
         if(!qc)
         {
            return;
         }
         qc.current = value;
         if(value > 0)
         {
            BigMessage.showQuestConditionChange(qc);
         }
         this.model.dispatchEvent(new Event(QuestEvent.QUESTS_UPDATED));
      }
      
      public function changeSubQuest(questId:String, objective:String, value:int, masterQuestId:String) : void
      {
         var qe:QuestEntry = this.model.getSubQuestByMaster(questId,masterQuestId);
         if(!qe)
         {
            return;
         }
         var qc:Condition = qe.getConditionById(objective);
         if(!qc)
         {
            return;
         }
         qc.current = value;
         if(value > 0)
         {
            BigMessage.showQuestConditionChange(qc);
         }
         this.model.dispatchEvent(new Event(QuestEvent.QUESTS_UPDATED));
      }
      
      public function changeQuestState(questId:String, state:String) : void
      {
         var qe:QuestEntry = this.model.getQuestById(questId);
         if(!qe)
         {
            return;
         }
         if(Boolean(state))
         {
            this.applyQuestState(qe,state);
         }
         else
         {
            this.model.quests.splice(this.model.quests.indexOf(qe),1);
            if(Boolean(this.model.selectedQuest) && this.model.selectedQuest.questId == questId)
            {
               this.model.selectedQuest = null;
            }
         }
         this.checkCompleteQuests();
         this.model.dispatchEvent(new Event(QuestEvent.QUESTS_UPDATED));
      }
      
      public function changeSubQuestState(questId:String, state:String, masterQuestId:String) : void
      {
         var qe:QuestEntry = this.model.getSubQuestByMaster(questId,masterQuestId);
         if(!qe)
         {
            return;
         }
         this.applyQuestState(qe,state);
      }
      
      private function applyQuestState(qe:QuestEntry, state:String) : void
      {
         qe.state = state;
         var questId:String = qe.questId;
         if(state == QuestState.COMPLETE)
         {
            BigMessage.showQuestComplete(questId);
            if(questId == "quest_newbie_01")
            {
               Interaction.show(InteractionType.QUESTS);
            }
         }
         else if(state == QuestState.FAILED)
         {
            BigMessage.showQuestFailed(questId);
         }
      }
      
      public function addHint(value:HintEntry) : void
      {
         if(!value)
         {
            return;
         }
         var arr:Array = this.model.hints;
         arr.unshift(value);
         this.model.hints = null;
         this.model.hints = arr;
         this.model.hasNewHints = true;
      }
      
      public function trackQuest(questId:String) : void
      {
         var qe:QuestEntry = this.model.findQuestById(this.model.trackedQuestId);
         if(Boolean(qe))
         {
            qe.tracked = false;
         }
         qe = this.model.findQuestById(questId);
         if(Boolean(qe))
         {
            qe.tracked = true;
         }
         this.model.trackedQuestId = questId;
      }
      
      private function checkCompleteQuests() : void
      {
         var completedQuests:Boolean = false;
         var qe:QuestEntry = null;
         for each(qe in this.model.quests)
         {
            if(qe.state == QuestState.COMPLETE)
            {
               completedQuests = true;
               break;
            }
         }
         this.model.hasCompletedQuests = completedQuests;
      }
      
      private function hintRead(e:QuestEvent) : void
      {
         ServerLayer.call("questService","markHintRead",null,null,e.id);
      }
      
      private function questCancel(e:QuestEvent) : void
      {
         ServerLayer.call("questService","reset",null,null,e.id);
      }
      
      private function questPin(e:QuestEvent) : void
      {
         ServerLayer.call("questService","trackQuest",null,null,e.id);
      }
      
      private function checkNewHints() : void
      {
         var he:HintEntry = null;
         var hasNew:Boolean = false;
         for each(he in this.model.hints)
         {
            if(!he.read)
            {
               hasNew = true;
               break;
            }
         }
         this.model.hasNewHints = hasNew;
      }
   }
}

