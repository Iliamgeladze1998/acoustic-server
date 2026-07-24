package soul.view.ui
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   [DefaultProperty("children")]
   public class ViewStack extends Container
   {
      
      private var _children:Vector.<DisplayObject> = new Vector.<DisplayObject>();
      
      private var _selectedIndex:int = -1;
      
      private var selectedChild:DisplayObject;
      
      public function ViewStack()
      {
         super();
      }
      
      public function set selectedIndex(value:int) : void
      {
         if(this._selectedIndex == value)
         {
            return;
         }
         this._selectedIndex = value;
         if(Boolean(this.selectedChild))
         {
            super.removeChild(this.selectedChild);
         }
         this.selectedChild = value < this._children.length ? this._children[value] : null;
         if(Boolean(this.selectedChild))
         {
            super.addChild(this.selectedChild);
         }
      }
      
      override public function addChild(child:DisplayObject) : DisplayObject
      {
         if(this._children.indexOf(child) > -1)
         {
            return child;
         }
         var childIndex:int = this._children.push(child) - 1;
         if(this._selectedIndex == childIndex)
         {
            this.selectedChild = child;
            super.addChild(child);
         }
         return child;
      }
      
      override public function removeChild(child:DisplayObject) : DisplayObject
      {
         var index:int = this._children.indexOf(child);
         if(index < 0)
         {
            return null;
         }
         this._children.splice(index,1);
         if(index <= this._selectedIndex)
         {
            if(Boolean(this.selectedChild))
            {
               super.removeChild(this.selectedChild);
            }
            this.selectedChild = this._children[index];
            if(Boolean(this.selectedChild))
            {
               super.addChild(this.selectedChild);
            }
         }
         return child;
      }
      
      override protected function childAdded(child:DisplayObject) : void
      {
         this.measure();
      }
      
      override protected function childRemoved(child:DisplayObject) : void
      {
         this.measure();
      }
      
      override protected function childResized(e:Event) : void
      {
         this.measure();
      }
      
      private function measure() : void
      {
         if(Boolean(this.selectedChild))
         {
            actualWidth = this.selectedChild.width;
            actualHeight = this.selectedChild.height;
         }
         else
         {
            actualHeight = actualWidth = 0;
         }
      }
   }
}

