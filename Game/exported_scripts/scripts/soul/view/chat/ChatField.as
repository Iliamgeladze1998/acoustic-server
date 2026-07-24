package soul.view.chat
{
   import flash.events.Event;
   import flash.events.TextEvent;
   import flash.filters.GlowFilter;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import soul.event.ChatEvent;
   import soul.view.ui.Component;
   import soul.view.ui.ScrollBar;
   
   public class ChatField extends Component
   {
      
      private static const opaqueFilters:Array = [new GlowFilter(0,1,2,2,2)];
      
      private var textField:TextField = new TextField();
      
      private var vs:ScrollBar = new ScrollBar();
      
      private var ss:StyleSheet = new StyleSheet();
      
      private var _htmlText:String;
      
      private var _transparent:Boolean;
      
      private var _fontSize:int;
      
      public function ChatField()
      {
         super();
         this.textField.multiline = true;
         this.textField.wordWrap = true;
         mouseEnabled = false;
         addChild(this.textField);
         addChild(this.vs);
         this.ss.setStyle("body",{
            "color":"#" + int(getStyle("color")).toString(16),
            "fontSize":getStyle("fontSize"),
            "fontFamily":getStyle("fontFamily")
         });
         this.ss.setStyle(".nick",{"color":"#" + int(getStyle("nickColor")).toString(16)});
         this.ss.setStyle(".myNick",{"color":"#" + int(getStyle("myNickColor")).toString(16)});
         this.textField.styleSheet = this.ss;
         this.textField.selectable = true;
         this.vs.addEventListener("scrollPositionChanged",this.scrollBarScroll);
         this.textField.addEventListener(Event.SCROLL,this.textScroll,false,0,true);
         this.textField.addEventListener(TextEvent.LINK,this.linkClicked,false,0,true);
         addEventListener(Event.RESIZE,this.onResize);
         this.onResize(null);
      }
      
      private function prepareScroll() : void
      {
         this.textField.getCharBoundaries(0);
         this.vs.minScrollPosition = 1;
         this.vs.maxScrollPosition = this.textField.maxScrollV;
         this.vs.scrollPosition = this.textField.scrollV;
      }
      
      private function onResize(e:Event) : void
      {
         this.vs.x = width - ScrollBar.THICKNESS;
         this.vs.height = height;
         this.textField.width = width - ScrollBar.THICKNESS;
         this.textField.height = height;
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
      
      private function linkClicked(event:TextEvent) : void
      {
         var e:ChatEvent = new ChatEvent(ChatEvent.CHAR_CLICKED);
         e.data = event.text;
         dispatchEvent(e);
      }
      
      public function set htmlText(value:String) : void
      {
         var scrollDown:Boolean = this.textField.scrollV >= this.textField.maxScrollV || this._htmlText == null;
         var scrollPos:int = this.textField.scrollV;
         if(value == this._htmlText)
         {
            return;
         }
         this._htmlText = value;
         this.textField.htmlText = "<body>" + value + "</body>";
         this.textField.getCharBoundaries(0);
         if(scrollDown)
         {
            this.textField.scrollV = this.textField.maxScrollV;
         }
         else
         {
            this.textField.scrollV = scrollPos;
         }
         callLater(this.prepareScroll);
      }
      
      public function get htmlText() : String
      {
         return this._htmlText;
      }
      
      public function set transparent(value:Boolean) : void
      {
         if(this._transparent == value)
         {
            return;
         }
         this._transparent = value;
         this.textField.selectable = !value;
         this.vs.visible = !value;
         mouseEnabled = mouseChildren = !value;
         this.textField.filters = value ? opaqueFilters : [];
      }
      
      public function set fontSize(value:int) : void
      {
         this._fontSize = value;
         var ss:StyleSheet = this.textField.styleSheet;
         var bodyStyle:Object = ss.getStyle("body");
         bodyStyle.fontSize = value;
         ss.setStyle("body",bodyStyle);
         this.textField.styleSheet = ss;
         callLater(this.prepareScroll);
      }
      
      public function get fontSize() : int
      {
         return this._fontSize;
      }
   }
}

