package soul.view.interaction.inventory
{
   import flash.events.MouseEvent;
   import mx.events.PropertyChangeEvent;
   import soul.model.inventory.Sack;
   import soul.view.ui.HBox;
   
   public class SackBar extends HBox
   {
      
      private var _dataProvider:Vector.<Sack>;
      
      private var selectedChild:SackRenderer;
      
      private var _selectedIndex:int = -1;
      
      public function SackBar()
      {
         super();
         gap = 5;
      }
      
      public function set dataProvider(value:Vector.<Sack>) : void
      {
         var sack:Sack = null;
         var child:SackRenderer = null;
         if(this._dataProvider == value)
         {
            return;
         }
         this._dataProvider = value;
         removeAllChildren();
         if(!value)
         {
            return;
         }
         for(var i:int = 0; i < value.length; i++)
         {
            sack = value[i];
            child = new SackRenderer();
            child.slotIndex = i;
            child.sack = sack;
            child.enabled = false;
            child.addEventListener(MouseEvent.CLICK,this.sackClick);
            addChild(child);
         }
         var restoredIndex:int = this._selectedIndex;
         this._selectedIndex = -1;
         this.selectedIndex = restoredIndex > -1 ? restoredIndex : 0;
      }
      
      private function sackClick(e:MouseEvent) : void
      {
         var child:SackRenderer = e.currentTarget as SackRenderer;
         if(!child.sack)
         {
            return;
         }
         this.selectedIndex = getChildIndex(child);
      }
      
      private function set _1436069623selectedIndex(value:int) : void
      {
         if(this._selectedIndex == value)
         {
            return;
         }
         this._selectedIndex = value;
         if(Boolean(this.selectedChild))
         {
            this.selectedChild.enabled = false;
         }
         this.selectedChild = getChildAt(value) as SackRenderer;
         this.selectedChild.enabled = true;
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      [Bindable(event="propertyChange")]
      public function set selectedIndex(param1:int) : void
      {
         var _loc2_:Object = this.selectedIndex;
         if(_loc2_ !== param1)
         {
            this._1436069623selectedIndex = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedIndex",_loc2_,param1));
            }
         }
      }
   }
}

