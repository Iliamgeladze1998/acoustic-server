package soul.view.ui.controls
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import soul.event.CloseEvent;
   import soul.resources.ResourceManager;
   import soul.view.ui.Button;
   import soul.view.ui.HBox;
   import soul.view.ui.HorizontalAlign;
   import soul.view.ui.TextArea;
   import soul.view.ui.VBox;
   
   public class Alert extends Window
   {
      
      private static const PADDING:uint = 10;
      
      public static const YES:uint = 1;
      
      public static const NO:uint = 2;
      
      public static const OK:uint = 4;
      
      public static const CANCEL:uint = 8;
      
      private static const BUNDLE:String = "controls";
      
      public var defaultFlag:uint;
      
      private var mainBox:VBox = new VBox();
      
      private var textField:TextArea = new TextArea();
      
      private var buttonBox:HBox = new HBox();
      
      private var _flags:uint;
      
      public function Alert(text:String = "", title:String = "", flags:uint = 4)
      {
         super();
         this.mainBox.percentWidth = 100;
         this.mainBox.percentHeight = 100;
         this.mainBox.horizontalAlign = HorizontalAlign.CENTER;
         this.mainBox.padding = 5;
         this.mainBox.gap = 5;
         this.textField.editable = false;
         this.textField.multiline = true;
         this.textField.wordWrap = true;
         this.textField.percentWidth = 100;
         this.textField.percentHeight = 100;
         this.textField.align = "center";
         this.buttonBox.gap = 3;
         this.buttonBox.x = PADDING;
         addChild(this.mainBox);
         this.mainBox.addChild(this.textField);
         label = title;
         this.text = text;
         this.buttons = flags;
         width = 300;
         height = 200;
      }
      
      public static function show(text:String = "", title:String = "", flags:uint = 4, parent:Sprite = null, closeHandler:Function = null, defaultFlag:uint = 4) : void
      {
         var alert:Alert = new Alert(text,title,flags);
         if(closeHandler != null)
         {
            alert.addEventListener(CloseEvent.CLOSE,closeHandler);
         }
         PopupManager.addPopup(alert,parent,true);
         PopupManager.centerPopup(alert);
      }
      
      public function set text(value:String) : void
      {
         this.textField.text = value;
      }
      
      public function set htmlText(value:String) : void
      {
         this.textField.htmlText = value;
      }
      
      private function set buttons(flags:uint) : void
      {
         this._flags = flags;
         if(flags == 0)
         {
            return;
         }
         if(Boolean(flags & Alert.YES))
         {
            this.buttonBox.addChild(this.createButton(ResourceManager.getString(BUNDLE,"yesLabel"),"YES"));
         }
         if(Boolean(flags & Alert.NO))
         {
            this.buttonBox.addChild(this.createButton(ResourceManager.getString(BUNDLE,"noLabel"),"NO"));
         }
         if(Boolean(flags & Alert.OK))
         {
            this.buttonBox.addChild(this.createButton(ResourceManager.getString(BUNDLE,"okLabel"),"OK"));
         }
         if(Boolean(flags & Alert.CANCEL))
         {
            this.buttonBox.addChild(this.createButton(ResourceManager.getString(BUNDLE,"cancelLabel"),"CANCEL"));
         }
         this.mainBox.addChild(this.buttonBox);
      }
      
      private function createButton(label:String, name:String) : Button
      {
         var btn:Button = new Button();
         btn.label = label;
         btn.name = name;
         btn.addEventListener(MouseEvent.CLICK,this.buttonClicked);
         return btn;
      }
      
      private function buttonClicked(e:MouseEvent) : void
      {
         var name:String = Button(e.currentTarget).name;
         if(name == "YES")
         {
            this.fireFlag(YES);
         }
         else if(name == "NO")
         {
            this.fireFlag(NO);
         }
         else if(name == "CANCEL")
         {
            this.fireFlag(CANCEL);
         }
         else if(name == "OK")
         {
            this.fireFlag(OK);
         }
      }
      
      private function fireFlag(flag:uint) : void
      {
         var ne:CloseEvent = new CloseEvent(CloseEvent.CLOSE);
         ne.detail = flag;
         dispatchEvent(ne);
         exit(null);
      }
      
      override public function tryToConfirm(e:Event) : void
      {
         if(Boolean(this._flags) && Boolean(YES))
         {
            this.fireFlag(YES);
            e.stopPropagation();
            e.stopImmediatePropagation();
         }
         else if(Boolean(this._flags) && Boolean(OK))
         {
            this.fireFlag(OK);
            e.stopPropagation();
            e.stopImmediatePropagation();
         }
      }
   }
}

