package soul.view.interaction.shop
{
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   import mx.core.DragSource;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.controller.mouse.DragAction;
   import soul.controller.mouse.DragProxy;
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.DragEvent;
   import soul.event.ShopEvent;
   import soul.model.location.shop.ShopItem;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientBox;
   import soul.view.interaction.inventory.ItemRenderer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.HBox;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   public class ShopItemContainer extends HBox
   {
      
      private static const dialogTimeout:int = 200;
      
      private var itemRenderer:ItemRenderer;
      
      private var itemName:Label;
      
      private var itemLevel:Label;
      
      private var priceBox:SimpleShopDialogPriceBox;
      
      private var dragProxy:DragProxy;
      
      private var dialogInt:int = -1;
      
      public function ShopItemContainer()
      {
         var box:GradientBox = null;
         this.itemRenderer = new ItemRenderer();
         this.itemName = new Label();
         this.itemLevel = new Label();
         this.priceBox = new SimpleShopDialogPriceBox();
         super();
         verticalAlign = "middle";
         width = 200;
         height = 66;
         this.itemName.width = 130;
         this.itemName.height = 30;
         this.itemName.multiline = true;
         this.itemName.wordWrap = true;
         this.itemName.color = Colors.GOLD_LIGHT;
         this.itemLevel.width = 130;
         this.itemLevel.height = 20;
         box = new GradientBox();
         box.percentWidth = 100;
         box.percentHeight = 100;
         var vbox:VBox = new VBox();
         vbox.percentWidth = 100;
         vbox.percentHeight = 100;
         vbox.horizontalAlign = "right";
         var spacer:Component = new Component();
         spacer.percentHeight = 100;
         box.addChild(vbox);
         vbox.addChild(this.itemName);
         vbox.addChild(this.itemLevel);
         vbox.addChild(spacer);
         vbox.addChild(this.priceBox);
         addChild(this.itemRenderer);
         addChild(box);
         this.itemRenderer.doubleClickEnabled = box.doubleClickEnabled = true;
         box.mouseChildren = this.itemRenderer.mouseChildren = false;
         this.itemRenderer.addEventListener(MouseEvent.DOUBLE_CLICK,this.dblClick);
         box.addEventListener(MouseEvent.DOUBLE_CLICK,this.dblClick);
         addEventListener(MouseEvent.CLICK,this.click);
         this.dragProxy = new DragProxy(this,this.dragStart,null,null,this.dragComplete);
      }
      
      public function set item(value:ShopItem) : void
      {
         this.itemRenderer.item = value;
         if(!value)
         {
            return;
         }
         this.itemName.text = LocaleManager.getItemName(value.templateId,value.suffixId,value.locId);
         this.itemLevel.text = LocaleManager.getString(BundleName.INTERFACE,"level") + " " + value.level;
         this.itemLevel.visible = value.level > 0;
         this.priceBox.price = value.price;
      }
      
      private function click(e:MouseEvent) : void
      {
         if(this.dialogInt != -1)
         {
            return;
         }
         this.dialogInt = setTimeout(this.showBuyDialog,dialogTimeout);
      }
      
      private function dblClick(e:MouseEvent) : void
      {
         var ne:ShopEvent = null;
         if(this.dialogInt != -1)
         {
            clearInterval(this.dialogInt);
            this.dialogInt = -1;
         }
         if(int(this.itemRenderer.item.id) > 0)
         {
            ne = new ShopEvent(ShopEvent.SELL_ITEM);
            ne.item = this.itemRenderer.item;
            ne.count = this.itemRenderer.item.count;
         }
         else
         {
            ne = new ShopEvent(ShopEvent.BUY_ITEM);
            ne.templateId = this.itemRenderer.item.templateId;
            ne.count = 1;
         }
         dispatchEvent(ne);
      }
      
      private function dragStart(e:MouseEvent) : void
      {
         if(this.itemRenderer.item == null)
         {
            return;
         }
         var ds:DragSource = new DragSource();
         ds.addData(this.itemRenderer.item,"shopItem");
         var dsi:CachedImage = new CachedImage();
         dsi.source = this.itemRenderer.source;
         SimpleDragManager.doDrag(this,ds,e,dsi);
      }
      
      private function dragComplete(e:DragEvent) : void
      {
         if(e.action == DragAction.MOVE)
         {
            this.showBuyDialog();
         }
      }
      
      private function showBuyDialog() : void
      {
         if(this.dialogInt != -1)
         {
            clearInterval(this.dialogInt);
            this.dialogInt = -1;
         }
         var ne:ShopEvent = new ShopEvent(ShopEvent.OPEN_BUY_DIALOG);
         ne.templateId = this.itemRenderer.item.templateId;
         dispatchEvent(ne);
      }
   }
}

