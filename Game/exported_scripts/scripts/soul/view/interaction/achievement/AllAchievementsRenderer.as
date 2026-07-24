package soul.view.interaction.achievement
{
   import soul.controller.locale.LocaleManager;
   import soul.model.system.Configuration;
   
   public class AllAchievementsRenderer extends AchievementCategoryRenderer
   {
      
      public static const IMAGE_URL:String = "all.jpg";
      
      public function AllAchievementsRenderer()
      {
         super();
         icon.source = Configuration.getAchievementGroupSmallImage(IMAGE_URL);
         label.text = LocaleManager.getAchievementName("allAchievements");
      }
   }
}

