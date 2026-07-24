package soul.view.interaction.achievement
{
   import soul.model.system.Configuration;
   import soul.view.assets.Assets;
   import soul.view.assets.RoundImage;
   import soul.view.rtm.BarDrawer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Component;
   
   public class PointsProgress extends Canvas
   {
      
      private var blackBox:Component = new Component();
      
      private var icon:RoundImage = new RoundImage();
      
      private var bar:BarDrawer = new BarDrawer();
      
      private var frame:CachedImage = new CachedImage();
      
      public function PointsProgress()
      {
         super();
         width = 299;
         height = 46;
         this.blackBox.backgroundColor = 0;
         this.blackBox.x = 42;
         this.blackBox.y = 9;
         this.blackBox.width = 220;
         this.blackBox.height = 17;
         this.icon.backgroundColor = 0;
         this.icon.width = 40;
         this.icon.height = 40;
         this.icon.x = this.icon.y = 2;
         this.bar.labelSize = 12;
         this.bar.x = 42;
         this.bar.y = 9;
         this.bar.width = 220;
         this.bar.height = 17;
         this.bar.barColor = 426758;
         this.frame.source = Assets.achievementProgressbar;
         addChild(this.blackBox);
         addChild(this.icon);
         addChild(this.bar);
         addChild(this.frame);
      }
      
      public function set current(value:int) : void
      {
         this.bar.value = value;
      }
      
      public function set maximum(value:int) : void
      {
         this.bar.maxValue = value;
      }
      
      public function set iconSource(value:String) : void
      {
         this.icon.source = Configuration.getAchievementGroupBigImage(value);
      }
   }
}

