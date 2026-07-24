package soul.view.interaction.shop
{
   import soul.view.common.MoneyRenderer;
   import soul.view.ui.Box;
   import soul.view.ui.BoxDirection;
   import spark.layouts.HorizontalAlign;
   import spark.layouts.VerticalAlign;
   
   public class SimpleShopDialogPriceBox extends Box
   {
      
      private var _price:Object;
      
      private var _count:int = 1;
      
      public function SimpleShopDialogPriceBox()
      {
         super();
         direction = BoxDirection.VERTICAL;
         horizontalAlign = HorizontalAlign.RIGHT;
         verticalAlign = VerticalAlign.BOTTOM;
         width = 140;
         height = 30;
         gap = -6;
      }
      
      protected function draw() : void
      {
         var currency:String = null;
         var value:int = 0;
         var mr:MoneyRenderer = null;
         removeAllChildren();
         for(currency in this._price)
         {
            value = int(this._price[currency]);
            if(value > 0)
            {
               mr = new MoneyRenderer();
               mr.type = currency;
               mr.value = value * this._count;
               addChild(mr);
            }
         }
      }
      
      public function set price(value:Object) : void
      {
         this._price = value;
         this.draw();
      }
      
      public function set count(value:int) : void
      {
         this._count = value;
         this.draw();
      }
   }
}

