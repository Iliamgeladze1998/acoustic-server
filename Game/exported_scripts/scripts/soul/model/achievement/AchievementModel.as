package soul.model.achievement
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.model.interaction.settings.SettingsModel;
   
   public class AchievementModel extends EventDispatcher
   {
      
      public static const LAST_ACHIEVEMT_COUNT:uint = 7;
      
      public var groups:Array;
      
      private var _1721765082lastAchievements:Vector.<Achievement> = new Vector.<Achievement>();
      
      private var _360101191lastAchievement:Achievement;
      
      public var toFocus:String;
      
      public var pointsTotal:uint;
      
      private var _2106613158pointsCollected:uint;
      
      private var settingsModel:SettingsModel;
      
      public function AchievementModel(settingsModel:SettingsModel)
      {
         super();
         this.settingsModel = settingsModel;
      }
      
      private static function sorter(a:Achievement, b:Achievement) : int
      {
         return a.completeDate > b.completeDate ? -1 : (a.completeDate < b.completeDate ? 1 : 0);
      }
      
      public function getAchievementById(id:String) : Achievement
      {
         var achievement:Achievement = null;
         var group:AchievementGroup = null;
         var subGroup:AchievementSubgroup = null;
         for each(group in this.groups)
         {
            for each(achievement in group.achievements)
            {
               if(achievement.id == id)
               {
                  return achievement;
               }
            }
            for each(subGroup in group.subgroups)
            {
               for each(achievement in subGroup.achievements)
               {
                  if(achievement.id == id)
                  {
                     return achievement;
                  }
               }
            }
         }
         return null;
      }
      
      public function load(groups:Array) : void
      {
         var achievement:Achievement = null;
         var group:AchievementGroup = null;
         var subgroup:AchievementSubgroup = null;
         this.pointsTotal = 0;
         this.pointsCollected = 0;
         this.groups = groups;
         var completeAchievements:Vector.<Achievement> = new Vector.<Achievement>();
         for each(group in groups)
         {
            group.pointsTotal = 0;
            group.pointsCollected = 0;
            for each(subgroup in group.subgroups)
            {
               subgroup.pointsTotal = 0;
               subgroup.pointsCollected = 0;
               for each(achievement in subgroup.achievements)
               {
                  subgroup.pointsTotal += achievement.points;
                  if(!isNaN(achievement.completeDate) && achievement.completeDate > 0)
                  {
                     completeAchievements.push(achievement);
                     subgroup.pointsCollected += achievement.points;
                     if(Boolean(this.settingsModel))
                     {
                        this.settingsModel.setAchievementTracked(achievement.id,false);
                     }
                  }
                  else
                  {
                     achievement.tracked = Boolean(this.settingsModel) ? this.settingsModel.getAchievementTracked(achievement.id) : false;
                  }
               }
               group.pointsTotal += subgroup.pointsTotal;
               group.pointsCollected += subgroup.pointsCollected;
            }
            for each(achievement in group.achievements)
            {
               group.pointsTotal += achievement.points;
               if(!isNaN(achievement.completeDate) && achievement.completeDate > 0)
               {
                  completeAchievements.push(achievement);
                  group.pointsCollected += achievement.points;
                  if(Boolean(this.settingsModel))
                  {
                     this.settingsModel.setAchievementTracked(achievement.id,false);
                  }
               }
               else
               {
                  achievement.tracked = Boolean(this.settingsModel) ? this.settingsModel.getAchievementTracked(achievement.id) : false;
               }
            }
            this.pointsCollected += group.pointsCollected;
            this.pointsTotal += group.pointsTotal;
         }
         completeAchievements.sort(sorter);
         if(completeAchievements.length > 0)
         {
            this.lastAchievement = completeAchievements[0];
         }
         this.lastAchievements.length = 0;
         var i:uint = 0;
         while(i < AchievementModel.LAST_ACHIEVEMT_COUNT && i < completeAchievements.length)
         {
            this.lastAchievements.push(completeAchievements[i]);
            i++;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lastAchievements() : Vector.<Achievement>
      {
         return this._1721765082lastAchievements;
      }
      
      public function set lastAchievements(param1:Vector.<Achievement>) : void
      {
         var _loc2_:Object = this._1721765082lastAchievements;
         if(_loc2_ !== param1)
         {
            this._1721765082lastAchievements = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lastAchievements",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lastAchievement() : Achievement
      {
         return this._360101191lastAchievement;
      }
      
      public function set lastAchievement(param1:Achievement) : void
      {
         var _loc2_:Object = this._360101191lastAchievement;
         if(_loc2_ !== param1)
         {
            this._360101191lastAchievement = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lastAchievement",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get pointsCollected() : uint
      {
         return this._2106613158pointsCollected;
      }
      
      public function set pointsCollected(param1:uint) : void
      {
         var _loc2_:Object = this._2106613158pointsCollected;
         if(_loc2_ !== param1)
         {
            this._2106613158pointsCollected = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pointsCollected",_loc2_,param1));
            }
         }
      }
   }
}

