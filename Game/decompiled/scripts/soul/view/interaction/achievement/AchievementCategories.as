package soul.view.interaction.achievement
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.model.achievement.AchievementGroup;
   import soul.model.achievement.AchievementModel;
   import soul.model.achievement.AchievementSubgroup;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.VBox;
   
   [Event(name="change",type="flash.events.Event")]
   public class AchievementCategories extends ScrollBase
   {
      
      private static const EVENT:Event = new Event(Event.CHANGE);
      
      public var lastSelectedCategorie:AchievementCategoryRenderer;
      
      private var selectedCategorie:AchievementCategoryRenderer;
      
      private var selectedSubcategorie:AchievementCategoryRenderer;
      
      private var box:VBox = new VBox();
      
      private var lastRenderer:LastAchievementsRenderer = new LastAchievementsRenderer();
      
      private var childs:Vector.<AchievementCategoryRenderer> = new Vector.<AchievementCategoryRenderer>();
      
      public function AchievementCategories()
      {
         super();
         this.lastRenderer.addEventListener(MouseEvent.CLICK,this.categoryClicked);
         this.box.addChild(this.lastRenderer);
         addChild(this.box);
         this.selectedCategorie = this.lastSelectedCategorie = this.lastRenderer;
         this.selectedCategorie.selected = true;
      }
      
      public function set model(value:AchievementModel) : void
      {
         var child:GroupRenderer = null;
         var categorieToFocus:GroupRenderer = null;
         var subCategorieToFocus:SubGroupRenderer = null;
         var group:AchievementGroup = null;
         var subGroup:AchievementSubgroup = null;
         var subGroupRenderer:SubGroupRenderer = null;
         var scrollTo:uint = 0;
         for each(child in this.childs)
         {
            this.box.removeChild(child);
         }
         this.childs.length = 0;
         if(!value || !value.groups)
         {
            return;
         }
         for each(group in value.groups)
         {
            child = new GroupRenderer();
            child.addEventListener(MouseEvent.CLICK,this.categoryClicked);
            child.group = group;
            this.childs.push(child);
            this.box.addChild(child);
            if(group.hasAchievement(value.toFocus))
            {
               categorieToFocus = child;
            }
            for each(subGroup in group.subgroups)
            {
               subGroupRenderer = new SubGroupRenderer();
               if(subGroup.hasAchievement(value.toFocus))
               {
                  categorieToFocus = child;
                  subCategorieToFocus = subGroupRenderer;
               }
               subGroupRenderer.addEventListener(MouseEvent.CLICK,this.subcategoryClicked);
               subGroupRenderer.scaleY = subCategorieToFocus == subGroupRenderer ? 1 : 0;
               subGroupRenderer.group = subGroup;
               child.subcategories.push(subGroupRenderer);
               this.childs.push(subGroupRenderer);
               this.box.addChild(subGroupRenderer);
            }
         }
         if(Boolean(categorieToFocus))
         {
            if(Boolean(this.lastSelectedCategorie))
            {
               this.lastSelectedCategorie.selected = false;
            }
            this.box.updateNow();
            updateNow();
            this.selectedCategorie = categorieToFocus;
            this.selectedCategorie.selected = true;
            scrollTo = 0;
            if(Boolean(subCategorieToFocus))
            {
               this.selectedSubcategorie = subCategorieToFocus;
               this.lastSelectedCategorie = subCategorieToFocus;
               this.selectedSubcategorie.selected = true;
               scrollTo = subCategorieToFocus.y;
            }
            else
            {
               this.lastSelectedCategorie = categorieToFocus;
               scrollTo = categorieToFocus.y;
            }
            vScrollPosition = scrollTo;
         }
      }
      
      private function categoryClicked(e:MouseEvent) : void
      {
         var child:AchievementCategoryRenderer = e.currentTarget as AchievementCategoryRenderer;
         if(child == this.selectedCategorie && !this.selectedSubcategorie)
         {
            return;
         }
         if(Boolean(this.selectedCategorie))
         {
            this.selectedCategorie.selected = false;
         }
         child.selected = true;
         if(Boolean(this.selectedSubcategorie))
         {
            this.selectedSubcategorie.selected = false;
            this.selectedSubcategorie = null;
         }
         this.selectedCategorie = child;
         this.lastSelectedCategorie = child;
         this.dispatchChangeEvent();
      }
      
      private function subcategoryClicked(e:MouseEvent) : void
      {
         var child:AchievementCategoryRenderer = e.currentTarget as AchievementCategoryRenderer;
         if(child == this.selectedSubcategorie)
         {
            return;
         }
         child.selected = true;
         if(Boolean(this.selectedSubcategorie))
         {
            this.selectedSubcategorie.selected = false;
         }
         this.selectedSubcategorie = child;
         this.lastSelectedCategorie = child;
         this.dispatchChangeEvent();
      }
      
      private function dispatchChangeEvent() : void
      {
         dispatchEvent(EVENT);
      }
   }
}

