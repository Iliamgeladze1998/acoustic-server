package soul.view.interaction.workshop
{
   import flash.filters.DropShadowFilter;
   import soul.model.location.workshop.WorkshopItem;
   import soul.view.common.PriceBox;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   public class WorkshopItemRenderer extends VBox
   {
      
      private var itemRenderer:ItemRenderer = new ItemRenderer();
      
      private var priceBox:PriceBox = new PriceBox();
      
      private var durabilityLabel:Label = new Label();
      
      public function WorkshopItemRenderer()
      {
         super();
         this.priceBox.width = 66;
         horizontalAlign = "center";
         addChild(this.itemRenderer);
         addChild(this.priceBox);
         doubleClickEnabled = true;
         this.durabilityLabel.right = 2;
         this.durabilityLabel.top = 2;
         this.durabilityLabel.filters = [new DropShadowFilter(1,45,0,1,2,2,4,1)];
         this.itemRenderer.addChild(this.durabilityLabel);
      }
      
      public function set workshopItem(value:WorkshopItem) : void
      {
         this.itemRenderer.item = WorkshopItem.toItem(value);
         if(!value)
         {
            return;
         }
         var price:Object = {};
         price[value.currency] = value.price;
         this.priceBox.dataProvider = price;
         this.durabilityLabel.text = value.durability + "/" + value.durabilityMax;
      }
   }
}

