package soul.view.ui
{
   import flash.events.Event;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class TextArea extends Component
   {
      
      private var textField:TextField = new TextField();
      
      private var vs:ScrollBar = new ScrollBar();
      
      private var border:BorderedContainer = new BorderedContainer();
      
      private var _align:String = "left";
      
      public function TextArea()
      {
         super();
         this.textField.defaultTextFormat = Label.DEFAULT_FORMAT;
         addChild(this.border);
         addChild(this.textField);
         addChild(this.vs);
         addEventListener(Event.RESIZE,this.onResize);
         this.textField.addEventListener(Event.SCROLL,this.textScroll,false,0,true);
         this.textField.addEventListener(Event.CHANGE,this.onTextChange,false,0,true);
         this.vs.addEventListener("scrollPositionChanged",this.scrollBarScroll);
         this.editable = false;
         setActualSize(100,100);
      }
      
      private function onResize(e:Event) : void
      {
         this.vs.x = _width - ScrollBar.THICKNESS;
         this.vs.height = _height;
         this.textField.width = _width - ScrollBar.THICKNESS;
         this.textField.height = _height;
         this.border.width = _width - ScrollBar.THICKNESS;
         this.border.height = _height;
         var visibleLines:uint = this.textField.height / this.textField.getLineMetrics(0).height;
         this.vs.pageSize = visibleLines;
         callLater(this.prepareScroll);
      }
      
      private function scrollBarScroll(e:Event) : void
      {
         this.textField.scrollV = this.vs.scrollPosition;
      }
      
      private function textScroll(e:Event) : void
      {
         callLater(this.prepareScroll);
         this.vs.scrollPosition = this.textField.scrollV;
      }
      
      private function onTextChange(e:Event) : void
      {
         dispatchEvent(new Event("textChanged"));
      }
      
      private function prepareScroll() : void
      {
         this.textField.getCharBoundaries(0);
         this.vs.minScrollPosition = 1;
         this.vs.maxScrollPosition = this.textField.maxScrollV;
         this.vs.scrollPosition = this.textField.scrollV;
         this.vs.visible = this.textField.maxScrollV > 1;
      }
      
      public function set editable(value:Boolean) : void
      {
         this.textField.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
      }
      
      public function set selectable(value:Boolean) : void
      {
         this.textField.selectable = value;
      }
      
      public function set color(value:uint) : void
      {
         this.textField.textColor = value;
      }
      
      public function set borderSkin(value:Object) : void
      {
         this.border.borderSkin = value;
      }
      
      [Bindable("textChanged")]
      public function set text(value:String) : void
      {
         if(!value)
         {
            value = "";
         }
         if(this.textField.text == value)
         {
            return;
         }
         this.textField.text = value;
         redraw();
      }
      
      public function get text() : String
      {
         return this.textField.text;
      }
      
      [Bindable("htmlTextChanged")]
      public function set htmlText(value:String) : void
      {
         if(!value)
         {
            value = "";
         }
         if(this.textField.htmlText == value)
         {
            return;
         }
         this.textField.htmlText = value;
         dispatchEvent(new Event("htmlTextChanged"));
         redraw();
      }
      
      public function get htmlText() : String
      {
         return this.textField.htmlText;
      }
      
      public function set wordWrap(value:Boolean) : void
      {
         this.textField.wordWrap = value;
      }
      
      public function set multiline(value:Boolean) : void
      {
         this.textField.multiline = value;
      }
      
      [Inspectable(category="General",enumeration="left,center,right",defaultValue="left")]
      public function set align(value:String) : void
      {
         if(this._align == value)
         {
            return;
         }
         this._align = value;
         var tf:TextFormat = this.textField.defaultTextFormat;
         tf.align = value;
         this.textField.defaultTextFormat = tf;
         this.textField.setTextFormat(tf);
      }
      
      public function set fontSize(value:Number) : void
      {
         var tf:TextFormat = this.textField.defaultTextFormat;
         tf.size = value;
         this.textField.defaultTextFormat = tf;
         this.textField.setTextFormat(tf);
      }
      
      override public function set tabIndex(index:int) : void
      {
         this.textField.tabIndex = index;
      }
      
      override public function get tabIndex() : int
      {
         return this.textField.tabIndex;
      }
   }
}

