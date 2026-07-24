package soul.view.interaction.inventory
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import mx.core.DragSource;
   import soul.controller.Interaction;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.DragEvent;
   import soul.event.InventoryEvent;
   import soul.event.MenuEvent;
   import soul.event.ShopEvent;
   import soul.model.common.InteractionType;
   import soul.model.item.Item;
   import soul.model.location.shop.ShopModel;
   import soul.view.common.BodyIcons;
   import soul.view.ui.CachedImage;
   import soul.view.ui.controls.menu.Menu;
   
   public class ItemContainer extends ItemRenderer
   {
      
      private static const dialogTimeout:int = 200;
      
      private static const DRAG_TRESHOLD:uint = 4;
      
      public var locked:Boolean;
      
      public var menuAllowed:Boolean = true;
      
      public var acceptsDrag:Boolean = true;
      
      private var dialogInt:int = -1;
      
      private var downPoint:Point;
      
      public var slotIndex:int = -1;
      
      protected var _itemSlot:String;
      
      public function ItemContainer()
      {
         super();
         mouseChildren = false;
         doubleClickEnabled = true;
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         addEventListener(DragEvent.DRAG_ENTER,this.dragEnter);
         addEventListener(DragEvent.DRAG_DROP,this.dragDrop);
         addEventListener(DragEvent.DRAG_COMPLETE,this.dragComplete);
         addEventListener(MouseEvent.CLICK,this.click);
         addEventListener(MouseEvent.DOUBLE_CLICK,this.dblClick);
         addEventListener("rightClick",this.dblClick);
      }
      
      protected function mouseDown(e:MouseEvent) : void
      {
         if(!item || this.locked)
         {
            return;
         }
         if(SimpleDragManager.isDragging)
         {
            return;
         }
         this.downPoint = new Point(e.localX,e.localY);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
      }
      
      private function mouseMove(e:MouseEvent) : void
      {
         if(!this.downPoint)
         {
            return;
         }
         var dx:uint = Math.abs(e.localX - this.downPoint.x);
         var dy:uint = Math.abs(e.localY - this.downPoint.y);
         if(dx > DRAG_TRESHOLD || dy > DRAG_TRESHOLD)
         {
            this.dragStart(e);
         }
      }
      
      protected function mouseUp(e:Event) : void
      {
         this.downPoint = null;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
      }
      
      protected function dragStart(e:MouseEvent) : void
      {
         var ds:DragSource = null;
         var dsi:CachedImage = null;
         this.mouseUp(null);
         var target:ItemContainer = e.target as ItemContainer;
         if(item != null)
         {
            ds = new DragSource();
            ds.addData(item,"item");
            dsi = new CachedImage();
            dsi.source = image.source;
            SimpleDragManager.doDrag(target,ds,e,dsi);
         }
      }
      
      protected function dragEnter(e:DragEvent) : void
      {
         if(!this.acceptsDrag || !enabled)
         {
            return;
         }
         var item:Item = Item(e.dragSource.dataForFormat("item"));
         if(Boolean(this._itemSlot) && !item)
         {
            return;
         }
         if(Boolean(item) && Boolean(item.equipped) && Boolean(this.item))
         {
            return;
         }
         item ||= Item(e.dragSource.dataForFormat("splitItem"));
         if(!item)
         {
            return;
         }
         if((!this._itemSlot || item.slot == this._itemSlot) && (!this.item || item.id != this.item.id))
         {
            SimpleDragManager.acceptDragDrop(this);
         }
      }
      
      protected function dragDrop(e:DragEvent) : void
      {
         var item:Item = Item(e.dragSource.dataForFormat("item"));
         var splitItem:Item = Item(e.dragSource.dataForFormat("splitItem"));
         if(Boolean(item))
         {
            if(e.shiftKey)
            {
               this.splitHere(item);
            }
            else
            {
               this.wearOrTakeOff(item);
            }
         }
         else if(Boolean(splitItem))
         {
            this.split(splitItem);
         }
      }
      
      protected function dragComplete(e:DragEvent) : void
      {
      }
      
      protected function dblClick(e:Event) : void
      {
         clearTimeout(this.dialogInt);
         this.dialogInt = -1;
         if(!item)
         {
            return;
         }
         var shopPrice:Object = Boolean(ShopModel.sellDatas) ? ShopModel.sellDatas[item.id] : null;
         if(Boolean(shopPrice))
         {
            this.sellItem();
         }
         else
         {
            this.equip();
         }
      }
      
      private function equip() : void
      {
         if(!item.slot)
         {
            return;
         }
         if(item.equipped)
         {
            this.takeOff(item);
         }
         else
         {
            this.wear(item);
         }
      }
      
      protected function click(e:MouseEvent) : void
      {
         if(!this.menuAllowed)
         {
            return;
         }
         if(this.dialogInt != -1)
         {
            return;
         }
         this.dialogInt = setTimeout(this.dialogOpen,dialogTimeout,e);
      }
      
      protected function dialogOpen(e:MouseEvent) : void
      {
         clearTimeout(this.dialogInt);
         this.dialogInt = -1;
         if(!item || !stage || this.locked)
         {
            return;
         }
         if(e.shiftKey)
         {
            this.splitItem();
            return;
         }
         var menuData:Array = [];
         if(Interaction.isActive(InteractionType.SHOP))
         {
            if(ShopModel.sellDatas[item.id] != null && !item.equipped)
            {
               menuData.push({
                  "label":this.getString("sell.menu"),
                  "data":"sell"
               });
            }
         }
         if(item.canBeEquipped())
         {
            menuData.push({
               "label":this.getString(Boolean(item.key) ? "equip.menu" : "unequip.menu"),
               "data":"equip"
            });
         }
         if(item.usable)
         {
            menuData.push({
               "label":this.getString("use.menu"),
               "data":"use"
            });
         }
         if(item.sockets > 0 && item.key != null)
         {
            menuData.push({
               "label":this.getString("encrust.menu"),
               "data":"encrust"
            });
         }
         if(item.count > 1)
         {
            menuData.push({
               "label":this.getString("split.menu"),
               "data":"split"
            });
         }
         if(!item.undroppable && item.key != null)
         {
            menuData.push({
               "label":this.getString("drop.menu"),
               "data":"drop"
            });
         }
         var menu:Menu = Menu.createMenu(stage,menuData);
         menu.addEventListener(MenuEvent.ITEM_CLICK,this.selectSystemMenu);
         menu.show(stage.mouseX,stage.mouseY);
      }
      
      private function selectSystemMenu(e:MenuEvent) : void
      {
         var data:String = e.item.data;
         switch(data)
         {
            case "sell":
               this.sellItem();
               break;
            case "equip":
               this.equip();
               break;
            case "use":
               this.useItem();
               break;
            case "encrust":
               this.encrustItem();
               break;
            case "split":
               this.splitItem();
               break;
            case "drop":
               this.dropItem();
         }
      }
      
      private function sellItem() : void
      {
         var ne:ShopEvent = new ShopEvent(ShopEvent.OPEN_SELL_DIALOG);
         ne.item = item;
         dispatchEvent(ne);
      }
      
      private function useItem() : void
      {
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.USE);
         ne.item = item;
         dispatchEvent(ne);
      }
      
      private function encrustItem() : void
      {
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.GET_SOCKETS);
         ne.item = item;
         dispatchEvent(ne);
      }
      
      private function splitItem() : void
      {
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.SPLIT_START);
         ne.item = item;
         ne.slotIndex = -1;
         dispatchEvent(ne);
      }
      
      private function splitHere(item:Item) : void
      {
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.SPLIT_START);
         ne.item = item;
         ne.slotIndex = this.slotIndex;
         dispatchEvent(ne);
      }
      
      private function dropItem() : void
      {
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.DROP);
         ne.item = item;
         dispatchEvent(ne);
      }
      
      private function wearOrTakeOff(item:Item) : void
      {
         if(!item.equipped)
         {
            if(Boolean(this._itemSlot))
            {
               this.wearToSlot(item);
            }
            else
            {
               this.changeSlot(item);
            }
         }
         else if(Boolean(this._itemSlot))
         {
            this.changeBodySlot(item);
         }
         else
         {
            this.takeOffToSlot(item);
         }
      }
      
      private function takeOff(item:Item) : void
      {
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.TAKEOFF);
         ne.item = item;
         dispatchEvent(ne);
      }
      
      private function takeOffToSlot(item:Item) : void
      {
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.TAKEOFF_TO_SLOT);
         ne.item = item;
         ne.slotIndex = this.slotIndex;
         dispatchEvent(ne);
      }
      
      private function changeBodySlot(item:Item) : void
      {
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.CHANGE_BODY_SLOT);
         ne.item = item;
         ne.slotIndex = this.slotIndex;
         dispatchEvent(ne);
      }
      
      private function wear(item:Item) : void
      {
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.EQUIP);
         ne.item = item;
         dispatchEvent(ne);
      }
      
      private function wearToSlot(item:Item) : void
      {
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.EQUIP_TO_SLOT);
         ne.item = item;
         ne.slotIndex = this.slotIndex;
         dispatchEvent(ne);
      }
      
      private function changeSlot(item:Item) : void
      {
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.CHANGE_SLOT);
         ne.item = item;
         ne.slotIndex = this.slotIndex;
         dispatchEvent(ne);
      }
      
      private function split(item:Item) : void
      {
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.SPLIT);
         ne.item = item;
         ne.slotIndex = this.slotIndex;
         dispatchEvent(ne);
      }
      
      public function set itemSlot(value:String) : void
      {
         this._itemSlot = value;
         if(item != null)
         {
            return;
         }
         this.drawSlotImage();
      }
      
      override public function set item(value:Item) : void
      {
         super.item = value;
         if(item == null)
         {
            this.drawSlotImage();
         }
      }
      
      private function drawSlotImage() : void
      {
         image.source = BodyIcons.getIcon(this._itemSlot);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
   }
}

