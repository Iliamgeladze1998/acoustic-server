package soul.view.ui
{
   import flash.events.MouseEvent;
   
   public class Button extends Box
   {
      
      protected var border:CachedImage = new CachedImage();
      
      protected var text:Label;
      
      protected var image:CachedImage;
      
      private var overState:Boolean;
      
      private var _downSkin:Object;
      
      private var _overSkin:Object;
      
      private var _disabledSkin:Object;
      
      private var _selectedSkin:Object;
      
      private var _selected:Boolean;
      
      private var _label:String;
      
      private var _fontSize:Number = 12;
      
      private var _textColor:uint = uint(Label.DEFAULT_FORMAT.color);
      
      public function Button()
      {
         super();
         horizontalAlign = HorizontalAlign.CENTER;
         verticalAlign = VerticalAlign.MIDDLE;
         padding = 5;
         gap = 2;
         mouseChildren = false;
         this.downSkin = this.downSkin || UIAssets.greenButtonDown;
         this.overSkin = this.overSkin || UIAssets.greenButtonOver;
         this.disabledSkin = this.disabledSkin || UIAssets.greenButtonOff;
         addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         background.addChild(this.border);
      }
      
      public function onMouseOver(e:MouseEvent) : void
      {
         this.overState = true;
         this.redraw();
      }
      
      public function onMouseOut(e:MouseEvent) : void
      {
         this.overState = false;
         this.redraw();
      }
      
      override public function set enabled(value:Boolean) : void
      {
         _enabled = value;
         mouseEnabled = value;
         this.redraw();
      }
      
      public function set downSkin(value:Object) : void
      {
         if(this._downSkin == value)
         {
            return;
         }
         this._downSkin = value;
         updateLater();
      }
      
      public function get downSkin() : Object
      {
         return this._downSkin;
      }
      
      public function set overSkin(value:Object) : void
      {
         if(this._overSkin == value)
         {
            return;
         }
         this._overSkin = value;
         updateLater();
      }
      
      public function get overSkin() : Object
      {
         return this._overSkin;
      }
      
      public function set disabledSkin(value:Object) : void
      {
         if(this._disabledSkin == value)
         {
            return;
         }
         this._disabledSkin = value;
         updateLater();
      }
      
      public function get disabledSkin() : Object
      {
         return this._disabledSkin;
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
            updateLater();
         }
      }
      
      public function get selectedSkin() : Object
      {
         return this._selectedSkin;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(this._selected == value)
         {
            return;
         }
         this._selected = value;
         updateLater();
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set label(value:String) : void
      {
         if(!value)
         {
            value = "";
         }
         if(!this._label == value)
         {
            return;
         }
         this._label = value;
         if(value.length > 0)
         {
            if(!this.text)
            {
               this.text = new Label();
               this.text.fontSize = this._fontSize;
               this.text.color = this._textColor;
               addChild(this.text);
            }
            this.text.text = value;
         }
         else if(Boolean(this.text))
         {
            removeChild(this.text);
            this.text = null;
         }
      }
      
      public function get label() : String
      {
         return this._label;
      }
      
      public function set icon(value:Object) : void
      {
         if(Boolean(value))
         {
            if(!this.image)
            {
               this.image = new CachedImage();
               addChildAt(this.image,0);
            }
            this.image.source = value;
         }
         else if(Boolean(this.image))
         {
            removeChild(this.image);
            this.image = null;
         }
      }
      
      public function set fontSize(value:Number) : void
      {
         this._fontSize = value;
         if(Boolean(this.text))
         {
            this.text.fontSize = value;
         }
      }
      
      public function set textColor(value:uint) : void
      {
         this._textColor = value;
         if(Boolean(this.text))
         {
            this.text.color = value;
         }
      }
      
      override protected function redraw() : void
      {
         super.redraw();
         this.border.width = _width;
         this.border.height = _height;
         if(!_enabled)
         {
            this.border.source = this._disabledSkin;
         }
         else if(this.overState)
         {
            this.border.source = this._overSkin;
         }
         else
         {
            this.border.source = this._downSkin;
         }
      }
   }
}

