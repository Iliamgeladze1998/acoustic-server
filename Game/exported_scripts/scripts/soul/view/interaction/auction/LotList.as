package soul.view.interaction.auction
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.model.interaction.auction.Lot;
   import soul.view.ui.VBox;
   
   public class LotList extends VBox
   {
      
      private var _selectedLot:Lot;
      
      public function LotList()
      {
         super();
         gap = 5;
         padding = 5;
      }
      
      public function set lots(value:Array) : void
      {
         var lot:Lot = null;
         var renderer:LotRenderer = null;
         removeAllChildren();
         this.selectedLot = null;
         for each(lot in value)
         {
            renderer = new LotRenderer();
            renderer.lot = lot;
            addChild(renderer);
            renderer.addEventListener(MouseEvent.CLICK,this.lotClick,false,0,true);
         }
      }
      
      private function lotClick(e:Event) : void
      {
         var lr:LotRenderer = null;
         var selectedRenderer:LotRenderer = LotRenderer(e.currentTarget);
         for(var i:int = 0; i < numChildren; i++)
         {
            lr = LotRenderer(getChildAt(i));
            if(Boolean(lr) && lr != selectedRenderer)
            {
               lr.selected = false;
            }
         }
         selectedRenderer.selected = true;
         this.selectedLot = selectedRenderer.lot;
      }
      
      [Bindable("lotSelected")]
      public function set selectedLot(value:Lot) : void
      {
         if(this._selectedLot == value)
         {
            return;
         }
         this._selectedLot = value;
         dispatchEvent(new Event("lotSelected"));
      }
      
      public function get selectedLot() : Lot
      {
         return this._selectedLot;
      }
   }
}

