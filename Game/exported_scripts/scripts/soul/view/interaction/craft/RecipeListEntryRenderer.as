package soul.view.interaction.craft
{
   import mx.events.PropertyChangeEvent;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.GameModel;
   import soul.model.interaction.craft.Component;
   import soul.model.interaction.craft.Recipe;
   import soul.model.inventory.InventoryModel;
   import soul.view.ui.HBox;
   import soul.view.ui.IDataRenderer;
   import soul.view.ui.IListItemRenderer;
   import soul.view.ui.Label;
   
   public class RecipeListEntryRenderer extends HBox implements IListItemRenderer, IDataRenderer
   {
      
      private var model:InventoryModel = GameModel.getInstance().inventoryModel;
      
      private var components:Vector.<String> = new Vector.<String>();
      
      private var nameLabel:Label = new Label();
      
      private var countLabel:Label = new Label();
      
      private var _data:Recipe;
      
      public function RecipeListEntryRenderer()
      {
         super();
         width = 267;
         this.nameLabel.percentWidth = 100;
         this.nameLabel.fontSize = this.countLabel.fontSize = 12;
         addChild(this.nameLabel);
         addChild(this.countLabel);
         backgroundColor = 0;
         this.selected = false;
         this.model.totalItemCounts.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.itemsChanged);
      }
      
      private static function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.ITEMS,key);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.model.totalItemCounts.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.itemsChanged);
      }
      
      public function set selected(value:Boolean) : void
      {
         backgroundAlpha = value ? 0.3 : 0;
      }
      
      public function get selected() : Boolean
      {
         return false;
      }
      
      public function set data(value:Object) : void
      {
         var recipe:Recipe = null;
         var component:Component = null;
         recipe = value as Recipe;
         this._data = recipe;
         var locale:String = recipe.locale || (Boolean(recipe.item) ? recipe.item.templateId : null);
         this.nameLabel.text = LocaleManager.getItemName(locale);
         for each(component in recipe.components)
         {
            this.components.push(component.item.templateId);
         }
         this.recount();
      }
      
      public function get data() : Object
      {
         return this._data;
      }
      
      private function itemsChanged(e:PropertyChangeEvent) : void
      {
         var templateId:String = e.property as String;
         if(this.components.indexOf(templateId) == -1)
         {
            return;
         }
         this.recount();
      }
      
      private function recount() : void
      {
         var component:Component = null;
         var currentCount:uint = 0;
         var count:int = -1;
         var totalItems:Object = this.model.totalItemCounts;
         for each(component in this._data.components)
         {
            currentCount = uint(totalItems[component.item.templateId]) / component.count;
            if(count == -1)
            {
               count = int(currentCount);
            }
            else
            {
               count = Math.min(count,currentCount);
            }
         }
         this._data.availableCount = count;
         this.countLabel.text = "(" + count + ")";
      }
   }
}

