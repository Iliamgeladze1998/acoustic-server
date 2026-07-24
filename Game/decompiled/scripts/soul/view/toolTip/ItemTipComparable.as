package soul.view.toolTip
{
   import flash.events.Event;
   import soul.model.GameModel;
   import soul.model.item.Item;
   
   public class ItemTipComparable extends ItemTip
   {
      
      private var comparison:ItemTipComparison;
      
      public function ItemTipComparable()
      {
         super();
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
      }
      
      override protected function onAdded(e:Event) : void
      {
         if(!this.comparison)
         {
            return;
         }
         parent.addChild(this.comparison);
         var sw:Number = stage.stageWidth;
         var sh:Number = stage.stageHeight;
         if(x + width + this.comparison.width > sw)
         {
            this.comparison.x = x - this.comparison.width;
         }
         else
         {
            this.comparison.x = x + width;
         }
         this.comparison.y = y;
         var dy:int = sh - this.comparison.y - this.comparison.height;
         if(dy < 0)
         {
            this.comparison.y += dy;
         }
      }
      
      private function onRemoved(e:Event) : void
      {
         if(!this.comparison)
         {
            return;
         }
         parent.removeChild(this.comparison);
      }
      
      override public function prepare() : void
      {
         var itemToCompare:Item = null;
         super.prepare();
         var item:Item = data as Item;
         if(Boolean(item))
         {
            itemToCompare = GameModel.getInstance().inventoryModel.getWornItemBySlot(item.slot);
            if(itemToCompare != item)
            {
               this.comparison = new ItemTipComparison();
               this.comparison.data = itemToCompare;
               this.comparison.prepare();
               this.comparison.visible = true;
            }
         }
      }
   }
}

