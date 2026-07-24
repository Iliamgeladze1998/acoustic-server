package soul.view.common
{
   import soul.view.assets.Assets;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.BoxDirection;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   
   public class PriceBox extends BorderedContainer
   {
      
      public function PriceBox()
      {
         super();
         direction = BoxDirection.VERTICAL;
         minHeight = 16;
         borderSkin = Assets.priceFrame;
      }
      
      public function set dataProvider(data:Object) : void
      {
         var currency:String = null;
         var value:int = 0;
         var priceEntry:HBox = null;
         var spacer:Component = null;
         var icon:CachedImage = null;
         var cost:Label = null;
         removeAllChildren();
         for(currency in data)
         {
            value = int(data[currency]);
            priceEntry = new HBox();
            priceEntry.verticalAlign = "middle";
            spacer = new Component();
            spacer.width = 10;
            icon = new CachedImage();
            icon.source = Currency.getCurrencyIcon(currency);
            cost = new Label();
            cost.text = String(value);
            priceEntry.addChild(spacer);
            priceEntry.addChild(icon);
            priceEntry.addChild(cost);
            addChild(priceEntry);
         }
      }
   }
}

