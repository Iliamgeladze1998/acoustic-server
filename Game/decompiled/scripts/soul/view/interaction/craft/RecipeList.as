package soul.view.interaction.craft
{
   import soul.view.ui.List;
   
   public class RecipeList extends List
   {
      
      public function RecipeList()
      {
         super();
         itemRenderer = RecipeListEntryRenderer;
      }
   }
}

