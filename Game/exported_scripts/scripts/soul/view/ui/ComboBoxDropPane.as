package soul.view.ui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ComboBoxDropPane extends Canvas
   {
      
      private static const HEIGHT:uint = 91;
      
      private const bg:Sprite = new UIAssets.simpleBorderShaded();
      
      private var scrollPane:ScrollBase = new ScrollBase();
      
      private var _box:VBox = new VBox();
      
      public var labelField:String = "label";
      
      private var _selectedIndex:int = -1;
      
      public function ComboBoxDropPane()
      {
         super();
         padding = 3;
         this.scrollPane.left = 0;
         this.scrollPane.top = 0;
         this.scrollPane.percentWidth = 100;
         this.scrollPane.percentHeight = 100;
         this.scrollPane.verticalScrollPolicy = ScrollPolicy.ON;
         background.addChild(this.bg);
         this.scrollPane.addChild(this._box);
         addChild(this.scrollPane);
         width = 125;
         height = HEIGHT;
      }
      
      private function childSelected(e:MouseEvent) : void
      {
         this._selectedIndex = this._box.getChildIndex(e.currentTarget as ComboBoxDropItem);
         dispatchEvent(new Event(Event.SELECT));
      }
      
      public function selectFoundedElement(value:int) : void
      {
         this._selectedIndex = int(this._box.getChildAt(value));
         dispatchEvent(new Event(Event.SELECT));
      }
      
      public function get box() : VBox
      {
         return this._box;
      }
      
      public function set dataProvider(value:Array) : void
      {
         var obj:Object = null;
         var child:ComboBoxDropItem = null;
         updateNow();
         for each(obj in value)
         {
            child = new ComboBoxDropItem();
            child.width = this.scrollPane.width;
            child.labelField = this.labelField;
            child.value = obj;
            child.addEventListener(MouseEvent.CLICK,this.childSelected);
            this._box.addChild(child);
         }
      }
      
      public function set selectedIndex(value:int) : void
      {
         if(value < 0 || value >= this._box.numChildren)
         {
            return;
         }
         var child:ComboBoxDropItem = this._box.getChildAt(value) as ComboBoxDropItem;
         child.selected = true;
      }
      
      public function deselectIndex(value:int) : void
      {
         if(value < 0 || value >= this._box.numChildren)
         {
            return;
         }
         var child:ComboBoxDropItem = this._box.getChildAt(value) as ComboBoxDropItem;
         child.selected = false;
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      override protected function redraw() : void
      {
         super.redraw();
         this.bg.width = width;
         this.bg.height = height;
      }
      
      public function focusOnChild(index:int) : void
      {
         var scrollLength:Number = NaN;
         var selectedElementPosition:Number = this._box.getChildAt(index).height * (index + 1);
         if(selectedElementPosition > this._box.parent.height)
         {
            scrollLength = selectedElementPosition - this._box.parent.height;
            this.scrollPane.vScrollPosition = scrollLength;
            this.scrollPane.updateNow();
         }
         else if(selectedElementPosition < this._box.parent.height)
         {
            this.scrollPane.vScrollPosition = 0;
         }
      }
   }
}

