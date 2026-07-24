package soul.view.interaction.quest
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.events.ItemClickEvent;
   import soul.model.interaction.quest.HintEntry;
   import soul.view.ui.VBox;
   
   [Event(name="itemClick",type="mx.events.ItemClickEvent")]
   public class HintListRenderer extends VBox
   {
      
      private var _hintList:Array;
      
      public function HintListRenderer()
      {
         super();
      }
      
      public function set hintList(value:Array) : void
      {
         var item:HintListItem = null;
         var qe:HintEntry = null;
         var ne:ItemClickEvent = null;
         removeAllChildren();
         this._hintList = value;
         for each(qe in value)
         {
            item = new HintListItem();
            item.entry = qe;
            item.addEventListener(MouseEvent.CLICK,this.itemClick);
            addChild(item);
         }
         if(numChildren > 0)
         {
            this.selectItem(getChildAt(0) as HintListItem);
         }
         else
         {
            ne = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
            ne.item = null;
            dispatchEvent(ne);
         }
      }
      
      public function itemClick(e:Event) : void
      {
         var item:HintListItem = e.currentTarget as HintListItem;
         this.selectItem(item);
      }
      
      private function selectItem(item:HintListItem) : void
      {
         var child:HintListItem = null;
         var index:int = getChildIndex(item);
         var ne:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
         ne.item = this._hintList[index];
         dispatchEvent(ne);
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i) as HintListItem;
            child.selected = child == item;
         }
      }
   }
}

