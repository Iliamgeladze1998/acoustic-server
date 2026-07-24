package soul.view.popups
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearInterval;
   import flash.utils.clearTimeout;
   import flash.utils.getTimer;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import mx.events.ItemClickEvent;
   import mx.utils.StringUtil;
   import soul.controller.Interaction;
   import soul.controller.MenuManager;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.common.MenuType;
   import soul.model.common.ShortMessage;
   import soul.view.assets.Button1;
   import soul.view.assets.Colors;
   import soul.view.chat.ClanIcon;
   import soul.view.ui.HBox;
   import soul.view.ui.HorizontalAlign;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   import soul.view.ui.controls.Window;
   
   [Event(name="itemClick",type="mx.events.ItemClickEvent")]
   public class DialogWindow extends Window
   {
      
      private static const WIDTH:uint = 292;
      
      private var box:VBox = new VBox();
      
      private var hbox:HBox = new HBox();
      
      private var clanIcon:ClanIcon = new ClanIcon();
      
      private var charName:Label = new Label();
      
      private var text:Label = new Label();
      
      private var buttons:HBox = new HBox();
      
      private var closeTimer:int;
      
      private var tickTimer:int;
      
      private var timerStartedAt:int;
      
      private var timeTotal:int;
      
      private var defaultButtonIndex:int = -1;
      
      private var confirmButtonIndex:int = -1;
      
      private var messageId:String;
      
      private var msg:ShortMessage;
      
      public function DialogWindow()
      {
         super();
         this.box.width = WIDTH;
         addChild(this.box);
         this.text.width = WIDTH;
         this.text.multiline = true;
         this.text.wordWrap = true;
         this.text.align = "center";
         this.text.fontSize = 12;
         this.text.color = Colors.LABEL;
         this.charName.bold = true;
         this.clanIcon.addEventListener(MouseEvent.CLICK,this.clanClick);
         this.charName.addEventListener(MouseEvent.CLICK,this.charClick);
         this.hbox.gap = 5;
         this.buttons.gap = 10;
         this.box.padding = 10;
         this.box.gap = 10;
         this.box.horizontalAlign = HorizontalAlign.CENTER;
         this.box.addChild(this.hbox);
         this.box.addChild(this.text);
         this.box.addChild(this.buttons);
      }
      
      public function init(msg:ShortMessage) : void
      {
         var button:Button1 = null;
         var btn:String = null;
         this.msg = msg;
         label = this.getString(msg.type + ".title");
         if(msg.clanId > 0)
         {
            this.clanIcon.clanId = msg.clanId;
            this.clanIcon.toolTip = msg.clanName;
            this.hbox.addChild(this.clanIcon);
         }
         if(msg.characterId > 0)
         {
            this.charName.text = msg.characterName;
            this.hbox.addChild(this.charName);
         }
         var text:String = this.getString(msg.type + ".text");
         this.text.htmlText = StringUtil.substitute(text,msg.params);
         this.messageId = msg.id;
         for each(btn in msg.buttons)
         {
            button = new Button1();
            button.padding = 7;
            button.label = this.getString(msg.type + "." + btn);
            this.buttons.addChild(button);
            button.addEventListener(MouseEvent.CLICK,this.buttonClicked,false,0,true);
         }
         this.hbox.updateNow(null);
         this.buttons.updateNow(null);
         this.box.updateNow(null);
         this.defaultButtonIndex = msg.defaultButton;
         this.confirmButtonIndex = msg.confirmButton;
         if(msg.timeOut > 0)
         {
            this.timeTotal = msg.timeOut;
            this.timerStartedAt = getTimer();
            this.closeTimer = setTimeout(this.defaultAction,msg.timeOut);
            this.tickTimer = setInterval(this.tick,1000);
         }
      }
      
      public function reset() : void
      {
         clearTimeout(this.closeTimer);
         clearInterval(this.tickTimer);
      }
      
      override public function tryToConfirm(e:Event) : void
      {
         if(this.confirmButtonIndex > -1)
         {
            this.fireButtonClick(this.confirmButtonIndex);
            e.stopPropagation();
            e.stopImmediatePropagation();
         }
      }
      
      override protected function exit(e:Event) : void
      {
         e.stopImmediatePropagation();
         this.defaultAction();
      }
      
      private function tick() : void
      {
         trace("tick: ",this.timeTotal + this.timerStartedAt - getTimer());
      }
      
      private function defaultAction() : void
      {
         this.fireButtonClick(this.defaultButtonIndex);
      }
      
      override protected function removed(e:Event) : void
      {
         clearInterval(this.tickTimer);
         super.removed(e);
      }
      
      private function clanClick(e:MouseEvent) : void
      {
         Interaction.showCharacterClan(String(this.msg.clanId));
      }
      
      private function charClick(e:MouseEvent) : void
      {
         MenuManager.create(MenuType.CHARACTER_MENU,this.msg.characterId);
      }
      
      private function buttonClicked(e:Event) : void
      {
         var btn:Button1 = e.target as Button1;
         var index:int = this.buttons.getChildIndex(btn);
         this.fireButtonClick(index);
      }
      
      private function fireButtonClick(index:int) : void
      {
         clearInterval(this.tickTimer);
         clearTimeout(this.closeTimer);
         var e:ItemClickEvent = new ItemClickEvent(ItemClickEvent.ITEM_CLICK);
         e.index = index;
         e.item = this.messageId;
         dispatchEvent(e);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.SHORT_MESSAGE,key);
      }
   }
}

