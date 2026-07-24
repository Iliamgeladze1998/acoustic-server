package soul.view.interaction.craft
{
   import mx.events.PropertyChangeEvent;
   import soul.controller.locale.LocaleManager;
   import soul.model.GameModel;
   import soul.model.interaction.craft.Component;
   import soul.model.inventory.InventoryModel;
   import soul.model.item.Item;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   
   public class ComponentRenderer extends HBox
   {
      
      private var itemRenderer:ItemRenderer = new ItemRenderer();
      
      private var label:Label = new Label();
      
      private var model:InventoryModel = GameModel.getInstance().inventoryModel;
      
      private var _component:Component;
      
      public function ComponentRenderer()
      {
         super();
         this.itemRenderer.width = this.itemRenderer.height = 51;
         addChild(this.itemRenderer);
         addChild(this.label);
         this.model.totalItemCounts.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.itemCountChanged);
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this.model.totalItemCounts.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.itemCountChanged);
      }
      
      private function itemCountChanged(e:PropertyChangeEvent) : void
      {
         if(Boolean(this._component) && this._component.item.templateId == e.property)
         {
            this.showCount();
         }
      }
      
      public function set component(value:Component) : void
      {
         var item:Item = null;
         item = value.item.toItem();
         this.itemRenderer.item = item;
         this._component = value;
         this.label.text = LocaleManager.getItemName(item.templateId);
         this.showCount();
      }
      
      private function showCount() : void
      {
         var total:int = int(this.model.totalItemCounts[this._component.item.templateId]);
         var count:int = this._component.count;
         this.itemRenderer.shortcut = total + "/" + count;
      }
   }
}

