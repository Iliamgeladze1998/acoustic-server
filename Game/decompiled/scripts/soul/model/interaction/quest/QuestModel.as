package soul.model.interaction.quest
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class QuestModel implements IEventDispatcher
   {
      
      private var _3552126tabs:Array;
      
      private var _220498682selectedTab:int = 0;
      
      private var _948698159quests:Array;
      
      private var _99283660hints:Array;
      
      private var _1443667719selectedQuest:QuestEntry;
      
      private var _1754824766selectedHint:HintEntry;
      
      private var _64742970hasNewHints:Boolean;
      
      private var _1235804158hasCompletedQuests:Boolean;
      
      private var _981094637trackedQuestId:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function QuestModel()
      {
         super();
      }
      
      public function getQuestById(questId:String) : QuestEntry
      {
         var qe:QuestEntry = null;
         for each(qe in this.quests)
         {
            if(qe.questId == questId)
            {
               return qe;
            }
         }
         return null;
      }
      
      public function getSubQuestByMaster(questId:String, masterId:String) : QuestEntry
      {
         var qe:QuestEntry = null;
         var master:QuestEntry = this.getQuestById(masterId);
         for each(qe in master.subquests)
         {
            if(qe.questId == questId)
            {
               return qe;
            }
         }
         return null;
      }
      
      public function findQuestById(questId:String) : QuestEntry
      {
         var qe:QuestEntry = null;
         for each(qe in this.quests)
         {
            if(qe.questId == questId)
            {
               return qe;
            }
            for each(qe in qe.subquests)
            {
               if(qe.questId == questId)
               {
                  return qe;
               }
            }
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get tabs() : Array
      {
         return this._3552126tabs;
      }
      
      public function set tabs(param1:Array) : void
      {
         var _loc2_:Object = this._3552126tabs;
         if(_loc2_ !== param1)
         {
            this._3552126tabs = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tabs",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedTab() : int
      {
         return this._220498682selectedTab;
      }
      
      public function set selectedTab(param1:int) : void
      {
         var _loc2_:Object = this._220498682selectedTab;
         if(_loc2_ !== param1)
         {
            this._220498682selectedTab = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedTab",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get quests() : Array
      {
         return this._948698159quests;
      }
      
      public function set quests(param1:Array) : void
      {
         var _loc2_:Object = this._948698159quests;
         if(_loc2_ !== param1)
         {
            this._948698159quests = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"quests",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hints() : Array
      {
         return this._99283660hints;
      }
      
      public function set hints(param1:Array) : void
      {
         var _loc2_:Object = this._99283660hints;
         if(_loc2_ !== param1)
         {
            this._99283660hints = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hints",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedQuest() : QuestEntry
      {
         return this._1443667719selectedQuest;
      }
      
      public function set selectedQuest(param1:QuestEntry) : void
      {
         var _loc2_:Object = this._1443667719selectedQuest;
         if(_loc2_ !== param1)
         {
            this._1443667719selectedQuest = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedQuest",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedHint() : HintEntry
      {
         return this._1754824766selectedHint;
      }
      
      public function set selectedHint(param1:HintEntry) : void
      {
         var _loc2_:Object = this._1754824766selectedHint;
         if(_loc2_ !== param1)
         {
            this._1754824766selectedHint = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedHint",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hasNewHints() : Boolean
      {
         return this._64742970hasNewHints;
      }
      
      public function set hasNewHints(param1:Boolean) : void
      {
         var _loc2_:Object = this._64742970hasNewHints;
         if(_loc2_ !== param1)
         {
            this._64742970hasNewHints = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hasNewHints",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hasCompletedQuests() : Boolean
      {
         return this._1235804158hasCompletedQuests;
      }
      
      public function set hasCompletedQuests(param1:Boolean) : void
      {
         var _loc2_:Object = this._1235804158hasCompletedQuests;
         if(_loc2_ !== param1)
         {
            this._1235804158hasCompletedQuests = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hasCompletedQuests",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get trackedQuestId() : String
      {
         return this._981094637trackedQuestId;
      }
      
      public function set trackedQuestId(param1:String) : void
      {
         var _loc2_:Object = this._981094637trackedQuestId;
         if(_loc2_ !== param1)
         {
            this._981094637trackedQuestId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"trackedQuestId",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

