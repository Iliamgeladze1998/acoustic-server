package soul.view.assets
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   
   [Event(name="change",type="flash.events.Event")]
   public class SelectButton extends Component
   {
      
      private var image:CachedImage = new CachedImage();
      
      private var _selected:Boolean;
      
      private var _skin:Object;
      
      private var _selectedSkin:Object;
      
      public function SelectButton()
      {
         super();
         addChild(this.image);
         addEventListener(MouseEvent.CLICK,this.onClick);
         this.apply();
      }
      
      protected function apply() : void
      {
         this.image.source = this._selected ? this._selectedSkin : this._skin;
         actualWidth = this.image.width;
         actualHeight = this.image.height;
      }
      
      private function onClick(e:MouseEvent) : void
      {
         this.selected = !this.selected;
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
         dispatchEvent(new Event("selectedChanged"));
         if(hasEventListener(Event.CHANGE))
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
         this.apply();
      }
      
      public function set skin(value:Object) : void
      {
         if(this._skin == value)
         {
            return;
         }
         this._skin = value;
         this.apply();
      }
      
      public function set selectedSkin(value:Object) : void
      {
         if(this._selectedSkin == value)
         {
            return;
         }
         this._selectedSkin = value;
         this.apply();
      }
   }
}

