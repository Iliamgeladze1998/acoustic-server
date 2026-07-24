package soul.view.interaction.achievement
{
   import soul.view.assets.Assets;
   
   public class AchievementPointsInfo extends AchievementPoints
   {
      
      public function AchievementPointsInfo()
      {
         super();
         scroll.source = Assets.achievementButton;
         width = 55;
         height = 55;
      }
   }
}

