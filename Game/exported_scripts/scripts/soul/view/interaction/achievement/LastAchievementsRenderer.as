package soul.view.interaction.achievement
{
   import soul.controller.locale.LocaleManager;
   import soul.model.system.Configuration;
   
   public class LastAchievementsRenderer extends AchievementCategoryRenderer
   {
      
      public static const IMAGE_URL:String = "last.jpg";
      
      public function LastAchievementsRenderer()
      {
         super();
         icon.source = Configuration.getAchievementGroupSmallImage(IMAGE_URL);
         label.text = LocaleManager.getAchievementName("lastAchievements");
      }
   }
}

