package soul.view.interaction.achievement
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.achievement.AchievementSubgroup;
   import soul.model.system.Configuration;
   
   public class GroupRenderer extends AchievementCategoryRenderer
   {
      
      public var subcategories:Vector.<SubGroupRenderer> = new Vector.<SubGroupRenderer>();
      
      private var _group:AchievementSubgroup;
      
      public function GroupRenderer()
      {
         super();
      }
      
      public function set group(value:AchievementSubgroup) : void
      {
         this._group = value;
         label.text = LocaleManager.getString(BundleName.ACHIEVEMENT,value.id);
         icon.source = Configuration.getAchievementGroupSmallImage(value.imagePath);
      }
      
      public function get group() : AchievementSubgroup
      {
         return this._group;
      }
      
      override public function set selected(value:Boolean) : void
      {
         var child:SubGroupRenderer = null;
         for each(child in this.subcategories)
         {
            child.scaleY = value ? 1 : 0;
         }
         super.selected = value;
      }
   }
}

