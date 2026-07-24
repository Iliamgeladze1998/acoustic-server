package soul.view.ui
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   [Event(name="change",type="flash.events.Event")]
   public class ComboBox extends Canvas
   {
      
      private var bg:Sprite = new UIAssets.simpleBorderShaded();
      
      public const label:ComboBoxDropItem = new ComboBoxDropItem();
      
      private const button:CachedImage = new CachedImage();
      
      public var dropDown:ComboBoxDropPane;
      
      private var _dataProvider:Array;
      
      private var _prompt:String = "";
      
      private var _selectedIndex:int = -1;
      
      private var _selectedItem:Object;
      
      private var _labelField:String = "label";
      
      public function ComboBox()
      {
         super();
         background.addChild(this.bg);
         this.button.source = UIAssets.dropDownButton;
         this.button.verticalCenter = 0;
         this.label.percentWidth = 100;
         this.label.percentHeight = 100;
         this.label.verticalAlign = "middle";
         this.label.left = 3;
         this.button.verticalCenter = 0;
         this.button.right = 2;
         addChild(this.label);
         addChild(this.button);
         width = 100;
         height = 21;
         this.button.addEventListener(MouseEvent.CLICK,this.onClick);
         this.label.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function onClick(e:MouseEvent) : void
      {
         if(Boolean(this.dropDown))
         {
            this.unlock();
            return;
         }
         this.dropDown = new ComboBoxDropPane();
         this.dropDown.y = height;
         var p:Point = localToGlobal(new Point(0,height));
         this.dropDown.x = p.x;
         this.dropDown.y = p.y;
         this.dropDown.width = width;
         this.dropDown.labelField = this._labelField;
         this.dropDown.dataProvider = this._dataProvider;
         this.dropDown.selectedIndex = this._selectedIndex;
         this.dropDown.addEventListener(Event.SELECT,this.itemSelected);
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         if(this._selectedIndex > -1)
         {
            this.dropDown.focusOnChild(this._selectedIndex);
         }
         stage.addChild(this.dropDown);
      }
      
      private function onMouseDown(e:MouseEvent) : void
      {
         if(this.dropDown.hitTestPoint(e.stageX,e.stageY) || hitTestPoint(e.stageX,e.stageY))
         {
            return;
         }
         callLater(this.unlock);
      }
      
      public function itemSelected(e:Event) : void
      {
         this.selectedIndex = this.dropDown.selectedIndex;
         this.drawLabel();
         callLater(this.unlock);
      }
      
      private function unlock() : void
      {
         if(!this.dropDown)
         {
            return;
         }
         stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         stage.removeChild(this.dropDown);
         this.dropDown = null;
      }
      
      private function drawLabel() : void
      {
         var txt:String = null;
         if(Boolean(this._selectedItem))
         {
            if(this._selectedItem.hasOwnProperty(this._labelField))
            {
               txt = String(this._selectedItem[this._labelField]);
            }
            else
            {
               txt = this._selectedItem.toString();
            }
         }
         else
         {
            txt = this._prompt;
         }
         this.label.text = txt;
      }
      
      public function set dataProvider(value:Array) : void
      {
         if(this._dataProvider == value)
         {
            return;
         }
         this._dataProvider = value;
         if(Boolean(this._dataProvider) && this._selectedIndex > -1)
         {
            this.selectedItem = this._dataProvider[this._selectedIndex];
         }
         this.drawLabel();
      }
      
      public function get dataProvider() : Array
      {
         return this._dataProvider;
      }
      
      public function set prompt(value:String) : void
      {
         this._prompt = value;
      }
      
      public function get prompt() : String
      {
         return this._prompt;
      }
      
      [Bindable("selectedIndexChanged")]
      public function set selectedIndex(value:int) : void
      {
         if(this._selectedIndex == value)
         {
            return;
         }
         this._selectedIndex = value;
         dispatchEvent(new Event("selectedIndexChanged"));
         if(Boolean(this._dataProvider))
         {
            this.selectedItem = this._dataProvider[value];
         }
         this.drawLabel();
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedItem(value:Object) : void
      {
         if(this._selectedIndex == value)
         {
            return;
         }
         var index:int = this._dataProvider.indexOf(value);
         if(index == -1)
         {
            this._selectedItem = null;
            this.drawLabel();
            return;
         }
         this._selectedItem = value;
         dispatchEvent(new Event("selectedItemChanged"));
         dispatchEvent(new Event(Event.CHANGE));
         this.selectedIndex = index;
         this.drawLabel();
      }
      
      [Bindable("selectedItemChanged")]
      public function get selectedItem() : Object
      {
         return this._selectedItem;
      }
      
      override public function set enabled(value:Boolean) : void
      {
         if(value == _enabled)
         {
            return;
         }
         super.enabled = mouseChildren = value;
      }
      
      public function set labelField(value:String) : void
      {
         this._labelField = value;
         this.drawLabel();
      }
      
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      override protected function applySize() : void
      {
         super.applySize();
         this.bg.width = width;
         this.bg.height = height;
      }
   }
}

