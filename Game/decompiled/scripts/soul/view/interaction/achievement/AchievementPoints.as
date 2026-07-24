package soul.view.interaction.achievement
{
   import flash.filters.GlowFilter;
   import soul.view.assets.Assets;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Label;
   
   public class AchievementPoints extends Canvas
   {
      
      private static const FILTERS:Array = [new GlowFilter(14141843,1,2,2,20,2)];
      
      protected var scroll:CachedImage = new CachedImage();
      
      private var label:Label = new Label();
      
      public function AchievementPoints()
      {
         super();
         this.scroll.source = Assets.achievementScroll;
         this.label.verticalCenter = 0;
         this.label.horizontalCenter = 0;
         this.label.fontSize = 11;
         this.label.color = 3219484;
         this.label.bold = true;
         this.label.filters = FILTERS;
         width = 49;
         height = 41;
         addChild(this.scroll);
         addChild(this.label);
      }
      
      public function set points(value:uint) : void
      {
         this.label.text = String(value);
      }
   }
}

