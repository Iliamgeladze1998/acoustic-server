package soul.view.interaction.achievement
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.achievement.AchievementGroup;
   import soul.view.ui.Container;
   import soul.view.ui.IDataRenderer;
   import soul.view.ui.Label;
   
   public class CategorySummaryRenderer extends Container implements IDataRenderer
   {
      
      private var progress:PointsProgress = new PointsProgress();
      
      private var label:Label = new Label();
      
      private var _data:AchievementGroup;
      
      public function CategorySummaryRenderer()
      {
         super();
         height = 46;
         addChild(this.progress);
         this.label.color = 0;
         this.label.x = 46;
         this.label.y = 30;
         addChild(this.label);
      }
      
      public function set data(value:Object) : void
      {
         this._data = value as AchievementGroup;
         if(!this._data)
         {
            return;
         }
         this.progress.maximum = this._data.pointsTotal;
         this.progress.current = this._data.pointsCollected;
         this.progress.iconSource = this._data.imagePath;
         this.label.text = LocaleManager.getString(BundleName.ACHIEVEMENT,this._data.id);
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

