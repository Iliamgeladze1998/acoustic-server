package soul.view.ui
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Event(name="change",type="flash.events.Event")]
   public class Checkbox extends Component
   {
      
      private var box:HBox = new HBox();
      
      private var icon:CachedImage = new CachedImage();
      
      private var text:Label = new Label();
      
      private var _selected:Boolean;
      
      private var _downSkin:Object;
      
      private var _selectedSkin:Object;
      
      public function Checkbox()
      {
         super();
         addEventListener(MouseEvent.CLICK,this.onClick);
         this.box.addEventListener(Event.RESIZE,this.onChildResize);
         addChild(this.box);
         mouseChildren = false;
         this.box.addChild(this.icon);
         this.box.addChild(this.text);
      }
      
      override protected function applyDefaultStyle() : void
      {
         this.downSkin = this.downSkin || UIAssets.checkBox;
         this.selectedSkin = this.selectedSkin || UIAssets.checkBoxSelected;
      }
      
      private function showImage() : void
      {
         this.icon.source = this._selected ? this._selectedSkin : this._downSkin;
      }
      
      protected function onChildResize(event:Event) : void
      {
         setActualSize(this.box.width,this.box.height);
      }
      
      protected function onClick(event:MouseEvent) : void
      {
         if(!_enabled)
         {
            return;
         }
         this.selected = !this._selected;
      }
      
      [Bindable("selectedChanged")]
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(this._selected == value)
         {
            return;
         }
         this._selected = value;
         if(hasEventListener("selectedChanged"))
         {
            dispatchEvent(new Event("selectedChanged"));
         }
         if(hasEventListener(Event.CHANGE))
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
         callLater(this.showImage);
      }
      
      public function set label(value:String) : void
      {
         this.text.text = value;
      }
      
      public function set downSkin(value:Object) : void
      {
         if(this._downSkin == value)
         {
            return;
         }
         this._downSkin = value;
         if(!this._selected)
         {
            callLater(this.showImage);
         }
      }
      
      public function get downSkin() : Object
      {
         return this._downSkin;
      }
      
      public function set selectedSkin(value:Object) : void
      {
         if(this._selectedSkin == value)
         {
            return;
         }
         this._selectedSkin = value;
         if(this._selected)
         {
            callLater(this.showImage);
         }
      }
      
      public function get selectedSkin() : Object
      {
         return this._selectedSkin;
      }
   }
}

