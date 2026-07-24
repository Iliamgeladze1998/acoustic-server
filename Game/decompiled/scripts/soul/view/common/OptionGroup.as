package soul.view.common
{
   import flash.events.MouseEvent;
   import mx.events.PropertyChangeEvent;
   import soul.view.ui.Box;
   import soul.view.ui.BoxDirection;
   
   public class OptionGroup extends Box
   {
      
      private var _1436069623selectedIndex:int;
      
      private var selectedChild:OptionRenderer;
      
      private var _dataProvider:Array;
      
      public function OptionGroup()
      {
         super();
         direction = BoxDirection.HORIZONTAL;
      }
      
      public function set dataProvider(value:Array) : void
      {
         var firstSelected:Boolean = false;
         var o:Object = null;
         var child:OptionRenderer = null;
         if(this._dataProvider == value)
         {
            return;
         }
         this._dataProvider = value;
         removeAllChildren();
         for each(o in value)
         {
            child = new OptionRenderer();
            child.value = o.value;
            child.label = o.label;
            child.enabled = o.enabled;
            if(!firstSelected && Boolean(o.enabled))
            {
               firstSelected = true;
               this.selectedChild = child;
               this.selectedChild.selected = true;
               this.selectedIndex = numChildren;
            }
            child.source = o.source;
            child.addEventListener(MouseEvent.CLICK,this.childClick);
            addChild(child);
         }
      }
      
      private function childClick(e:MouseEvent) : void
      {
         if(Boolean(this.selectedChild))
         {
            this.selectedChild.selected = false;
         }
         this.selectedChild = e.currentTarget as OptionRenderer;
         this.selectedChild.selected = true;
         this.selectedIndex = getChildIndex(this.selectedChild);
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedIndex() : int
      {
         return this._1436069623selectedIndex;
      }
      
      public function set selectedIndex(param1:int) : void
      {
         var _loc2_:Object = this._1436069623selectedIndex;
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

