package soul.view.interaction.achievement
{
   import soul.model.achievement.Achievement;
   import soul.view.ui.List;
   
   public class AchievementList extends List
   {
      
      public function AchievementList()
      {
         super();
         itemRenderer = AchievementRenderer;
      }
      
      public function focusAchievement(toFocus:String) : void
      {
         var childToFocus:AchievementRenderer = null;
         var child:AchievementRenderer = null;
         if(!toFocus)
         {
            return;
         }
         for(var i:uint = 0; Boolean(vbox.numChildren); i++)
         {
            child = vbox.getChildAt(i) as AchievementRenderer;
            if(child)
            {
               if(Achievement(child.data).id == toFocus)
               {
                  childToFocus = child;
                  break;
               }
            }
         }
         if(Boolean(childToFocus))
         {
            vbox.updateNow();
            updateNow();
            vScrollPosition = childToFocus.y;
         }
      }
   }
}

