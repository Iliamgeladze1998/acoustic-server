package soul.view.ui
{
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class Label extends Component implements IDataRenderer
   {
      
      public static const DEFAULT_FORMAT:TextFormat = new TextFormat("Verdana, Tahoma, _sans",11,12618080);
      
      public static const WINDOW_TITLE:TextFormat = new TextFormat("Verdana",12,16635800);
      
      public static const MY_VERDANA:TextFormat = new TextFormat("Verdana, Tahoma, _sans",12,10253648);
      
      public static const TEXT_TOOLTIP:TextFormat = new TextFormat("Verdana, Tahoma, _sans",11,16777215);
      
      public static const FIELD_LABEL:TextFormat = new TextFormat("Verdana, Tahoma, _sans",11,16777215,null,null,null,null,null,"center");
      
      public static const MONEY_LABEL:TextFormat = new TextFormat("Verdana, Tahoma, _sans",11,10253648);
      
      public static const BALOON_LABEL:TextFormat = new TextFormat("Verdana, Tahoma, _sans",11,0,true);
      
      public static const ITEM_COUNT:TextFormat = new TextFormat("Verdana, Tahoma, _sans",11,15966022);
      
      public static const ITEM_SHORTCUT:TextFormat = new TextFormat("Verdana, Tahoma, _sans",11,10253648);
      
      public static const QUEST_TEXT:TextFormat = new TextFormat("Verdana, Tahoma, _sans",12,0);
      
      public static const QUEST_ANSWER:TextFormat = new TextFormat("Verdana, Tahoma, _sans",12,2824706,true);
      
      private static const WIDTH_FIX:int = 4;
      
      private static const ADD_HEIGHT:int = 4;
      
      private static const DOTS:String = "...";
      
      protected var textField:TextField = new TextField();
      
      public var truncateToFit:Boolean;
      
      private var isHtml:Boolean;
      
      private var _align:String = "left";
      
      protected var _verticalAlign:String;
      
      protected var _text:String = "";
      
      private var _padding:int = 0;
      
      private var setToolTip:String;
      
      public function Label(format:TextFormat = null, embedFonts:Boolean = false)
      {
         super();
         format ||= DEFAULT_FORMAT;
         this.textField.defaultTextFormat = format;
         this.textField.width = 200;
         this.textField.height = 20;
         this.textField.autoSize = "left";
         this.textField.embedFonts = embedFonts;
         this.linkEnabled = false;
         addChild(this.textField);
         this.textField.addEventListener(TextEvent.TEXT_INPUT,this.onChange);
         this.textField.addEventListener(Event.CHANGE,this.onChange);
      }
      
      private function onChange(e:Event) : void
      {
         updateLater();
      }
      
      public function set editable(value:Boolean) : void
      {
         this.textField.type = value ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
      }
      
      public function set linkEnabled(value:Boolean) : void
      {
         this.textField.mouseEnabled = value;
         this.textField.selectable = value;
      }
      
      [Inspectable(category="General",enumeration="left,center,right",defaultValue="left")]
      public function set align(value:String) : void
      {
         if(this._align == value)
         {
            return;
         }
         this._align = value;
         this.applyAlign();
         updateLater();
      }
      
      [Inspectable(category="General",enumeration="top,middle,bottom",defaultValue="top")]
      public function set verticalAlign(value:String) : void
      {
         this._verticalAlign = value;
         updateLater();
      }
      
      public function set data(value:Object) : void
      {
         this.text = String(value);
      }
      
      public function get data() : Object
      {
         return this.text;
      }
      
      [Bindable("textChanged")]
      public function set text(value:String) : void
      {
         if(!value)
         {
            value = "";
         }
         if(this._text == value)
         {
            return;
         }
         this._text = this.textField.text = value;
         dispatchEvent(new Event("textChanged"));
         this.isHtml = false;
         this.redraw();
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
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
         this._text = this.textField.text;
         this.isHtml = true;
         this.redraw();
      }
      
      public function set color(value:uint) : void
      {
         this.textField.textColor = value;
      }
      
      public function set fontName(value:String) : void
      {
         var tf:TextFormat = this.textField.defaultTextFormat;
         tf.font = value;
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
      
      public function set wordWrap(value:Boolean) : void
      {
         this.textField.wordWrap = value;
         this.applyAlign();
      }
      
      public function get wordWrap() : Boolean
      {
         return this.textField.wordWrap;
      }
      
      public function set multiline(value:Boolean) : void
      {
         this.textField.multiline = value;
      }
      
      public function get multiline() : Boolean
      {
         return this.textField.multiline;
      }
      
      public function set padding(value:int) : void
      {
         if(this._padding == value)
         {
            return;
         }
         this._padding = value;
         this.redraw();
      }
      
      public function get padding() : int
      {
         return this._padding;
      }
      
      public function set bold(value:Boolean) : void
      {
         var tf:TextFormat = this.textField.defaultTextFormat;
         tf.bold = value;
         this.textField.defaultTextFormat = tf;
         this.textField.setTextFormat(tf);
      }
      
      public function set leftMargin(value:Number) : void
      {
         var tf:TextFormat = this.textField.defaultTextFormat;
         tf.leftMargin = value;
         this.textField.defaultTextFormat = tf;
         this.textField.setTextFormat(tf);
      }
      
      public function set rightMargin(value:Number) : void
      {
         var tf:TextFormat = this.textField.defaultTextFormat;
         tf.rightMargin = value;
         this.textField.defaultTextFormat = tf;
         this.textField.setTextFormat(tf);
      }
      
      override public function set toolTip(value:String) : void
      {
         this.setToolTip = value;
         updateLater();
      }
      
      private function applyAlign() : void
      {
         var tf:TextFormat = this.textField.defaultTextFormat;
         tf.align = this.wordWrap ? this._align : TextFormatAlign.LEFT;
         this.textField.defaultTextFormat = tf;
         this.textField.setTextFormat(tf);
      }
      
      override protected function redraw() : void
      {
         var realWidth:int = 0;
         var w:int = 0;
         var h:int = 0;
         var p2:int = this._padding * 2;
         var autoWidth:Boolean = true;
         if(!isNaN(setWidth) || !isNaN(percentWidth))
         {
            autoWidth = false;
            realWidth = _width - p2;
            if(realWidth > 0)
            {
               this.textField.width = realWidth;
            }
            this.textField.getCharBoundaries(0);
            w = _width - p2;
            if(this._align == "center")
            {
               if(this.textField.wordWrap)
               {
                  this.textField.x = this._padding + int(w - this.textField.width) / 2;
               }
               else
               {
                  this.textField.x = this._padding + Math.max(0,int(w - this.textField.textWidth - WIDTH_FIX) / 2);
               }
            }
            else if(this._align == "right")
            {
               if(this.textField.wordWrap)
               {
                  this.textField.x = w - this.textField.width;
               }
               else
               {
                  this.textField.x = w - this._padding - this.textField.textWidth - WIDTH_FIX;
               }
            }
            else
            {
               this.textField.x = this._padding;
            }
         }
         else
         {
            this.textField.x = this._padding;
            this.textField.getCharBoundaries(0);
            actualWidth = this.textField.textWidth + p2 + WIDTH_FIX;
         }
         if(!isNaN(setHeight) || !isNaN(percentHeight))
         {
            h = _height - p2;
            if(this._verticalAlign == "middle")
            {
               this.textField.y = this._padding + int(_height / 2 - (this.textField.textHeight + ADD_HEIGHT) / 2);
            }
            else if(this._verticalAlign == "bottom")
            {
               this.textField.y = this._padding + _height - this.textField.textHeight - ADD_HEIGHT;
            }
            else
            {
               this.textField.y = this._padding;
            }
         }
         else
         {
            this.textField.y = this._padding;
            actualHeight = this.textField.textHeight + p2 + ADD_HEIGHT;
         }
         this.textField.scrollRect = new Rectangle(Math.min(this.textField.x,0),0,_width,_height);
         if(this.truncateToFit && this.setToolTip == null && !autoWidth && !this.multiline && !this.isHtml && this.textField.textWidth + p2 > _width)
         {
            super.toolTip = this._text;
            this.truncate();
         }
         else if(this.setToolTip != null)
         {
            super.toolTip = this.setToolTip;
         }
         super.redraw();
      }
      
      private function truncate() : void
      {
         var dots:TextField = new TextField();
         dots.autoSize = TextFieldAutoSize.LEFT;
         dots.defaultTextFormat = this.textField.defaultTextFormat;
         dots.text = DOTS;
         dots.getCharBoundaries(0);
         var dotsWidth:int = dots.textWidth;
         var txt:String = this.textField.text;
         var w:int = _width - this._padding * 2 - dotsWidth;
         while(txt.length > 1 && this.textField.textWidth > w)
         {
            txt = txt.slice(0,-1);
            this.textField.text = txt;
         }
         if(txt.length > 0)
         {
            this.textField.appendText(DOTS);
         }
      }
   }
}

