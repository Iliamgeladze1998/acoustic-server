package soul.controller.interaction
{
   import flash.events.Event;
   import soul.controller.IManager;
   import soul.model.achievement.Achievement;
   import soul.model.achievement.AchievementGroup;
   import soul.model.achievement.AchievementModel;
   import soul.model.achievement.AchievementSubgroup;
   import soul.model.condition.Condition;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   import soul.view.common.BigMessage;
   
   public class AchievementManager implements IManager
   {
      
      public static const SERVICE:String = "achievementService";
      
      private static const EVENT:Event = new Event(Event.CHANGE);
      
      private var model:AchievementModel;
      
      public function AchievementManager(model:AchievementModel)
      {
         super();
         ComponentLocator.setComponent(ComponentLocator.ACHIEVEMENT,this);
         this.model = model;
         ServerLayer.call(SERVICE,ComponentLocator.READY);
      }
      
      public function reset() : void
      {
      }
      
      public function init(groups:Array) : void
      {
         this.model.load(groups);
      }
      
      public function completeAchievement(id:String, date:Number) : void
      {
         var subgroupFound:Boolean = false;
         var achievement:Achievement = null;
         var group:AchievementGroup = null;
         var subGroup:AchievementSubgroup = null;
         var found:Boolean = false;
         for each(group in this.model.groups)
         {
            for each(achievement in group.achievements)
            {
               if(achievement.id == id)
               {
                  found = true;
                  break;
               }
            }
            if(found)
            {
               break;
            }
            for each(subGroup in group.subgroups)
            {
               subgroupFound = false;
               for each(achievement in subGroup.achievements)
               {
                  if(achievement.id == id)
                  {
                     subgroupFound = true;
                     found = true;
                     break;
                  }
               }
               if(subgroupFound)
               {
                  break;
               }
            }
            if(subgroupFound)
            {
               break;
            }
         }
         if(!found)
         {
            return;
         }
         if(subgroupFound)
         {
            subGroup.pointsCollected += achievement.points;
         }
         group.pointsCollected += achievement.points;
         achievement.completeDate = date;
         while(this.model.lastAchievements.length >= AchievementModel.LAST_ACHIEVEMT_COUNT)
         {
            this.model.lastAchievements.pop();
         }
         this.model.lastAchievements.unshift(achievement);
         this.model.lastAchievement = achievement;
         this.model.pointsCollected += achievement.points;
         achievement.dispatchEvent(EVENT);
         this.model.dispatchEvent(EVENT);
      }
      
      public function updateAchievementProgress(id:String, conditionId:String, current:int) : void
      {
         var achievement:Achievement = this.model.getAchievementById(id);
         if(!achievement)
         {
            return;
         }
         var condition:Condition = achievement.getConditionById(conditionId);
         if(!condition)
         {
            return;
         }
         condition.current = current;
         achievement.dispatchEvent(EVENT);
         if(achievement.tracked)
         {
            BigMessage.showAchievementConditionChange(condition);
         }
      }
   }
}

