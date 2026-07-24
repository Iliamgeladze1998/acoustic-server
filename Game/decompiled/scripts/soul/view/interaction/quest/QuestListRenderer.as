package soul.view.interaction.quest
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.event.QuestEvent;
   import soul.model.interaction.quest.QuestEntry;
   import soul.view.ui.VBox;
   
   public class QuestListRenderer extends VBox
   {
      
      public var selectedQuest:QuestEntry;
      
      private var _questList:Array;
      
      public function QuestListRenderer()
      {
         super();
      }
      
      public function set questList(value:Array) : void
      {
         var trackedQuest:QuestListItem = null;
         var trackedQuestHub:QuestListItem = null;
         var qli:QuestListItem = null;
         var sqli:QuestListItem = null;
         var qe:QuestEntry = null;
         var ne:QuestEvent = null;
         removeAllChildren();
         this._questList = value;
         for each(qe in value)
         {
            qli = new QuestListItem();
            qli.questEntry = qe;
            qli.addEventListener(MouseEvent.CLICK,this.itemClick);
            addChild(qli);
            if(qe == this.selectedQuest)
            {
               trackedQuest = qli;
            }
            else if(qe.tracked && trackedQuest == null)
            {
               trackedQuest = qli;
            }
            for each(qe in qe.subquests)
            {
               sqli = new QuestListItem(true);
               sqli.questEntry = qe;
               sqli.addEventListener(MouseEvent.CLICK,this.itemClick);
               sqli.scaleY = 0;
               if(qe == this.selectedQuest)
               {
                  trackedQuest = sqli;
               }
               else if(qe.tracked && trackedQuest == null)
               {
                  trackedQuest = sqli;
                  trackedQuestHub = qli;
               }
               qli.subQuests.push(sqli);
               addChild(sqli);
            }
         }
         if(numChildren > 0)
         {
            if(Boolean(trackedQuestHub))
            {
               trackedQuestHub.expanded = true;
            }
            if(Boolean(trackedQuest))
            {
               this.selectItem(trackedQuest);
            }
         }
         else
         {
            ne = new QuestEvent(QuestEvent.QUESTS_SELECTED);
            dispatchEvent(ne);
         }
         updateNow();
      }
      
      public function itemClick(e:Event) : void
      {
         var qli:QuestListItem = e.currentTarget as QuestListItem;
         this.selectItem(qli);
      }
      
      private function selectItem(qli:QuestListItem) : void
      {
         var child:QuestListItem = null;
         var index:int = getChildIndex(qli);
         var ne:QuestEvent = new QuestEvent(QuestEvent.QUESTS_SELECTED);
         ne.id = qli.questEntry.questId;
         dispatchEvent(ne);
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i) as QuestListItem;
            child.selected = child == qli;
         }
      }
   }
}

