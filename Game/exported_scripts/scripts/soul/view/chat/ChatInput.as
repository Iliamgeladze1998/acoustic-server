package soul.view.chat
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import soul.event.ChatEvent;
   import soul.view.assets.Assets;
   import soul.view.ui.Input;
   
   public class ChatInput extends Input
   {
      
      private static const MAX_HISTORY:int = 10;
      
      public var chatUsers:Array;
      
      private var msgHistory:Array = [];
      
      private var historyPosition:int;
      
      public function ChatInput()
      {
         super();
         addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyDown,false,0,true);
         addEventListener(Event.RESIZE,this.onResize);
         var tf:TextFormat = new TextFormat();
         tf.leftMargin = 5;
         textField.defaultTextFormat = tf;
         height = 22;
         borderSkin = Assets.chatInput;
         color = 0;
         fontSize = 12;
      }
      
      public function addToHistory() : void
      {
         if(text.length < 1)
         {
            return;
         }
         var txt:String = text;
         if(this.msgHistory.indexOf(txt) == -1)
         {
            if(this.msgHistory.length >= MAX_HISTORY)
            {
               this.msgHistory.shift();
            }
            this.msgHistory.push(txt);
            this.historyPosition = this.msgHistory.length;
         }
      }
      
      private function prevMessage() : void
      {
         if(this.msgHistory.length < 1)
         {
            return;
         }
         --this.historyPosition;
         if(this.historyPosition < 0)
         {
            this.historyPosition = this.msgHistory.length - 1;
         }
         text = this.msgHistory[this.historyPosition];
      }
      
      private function nextMessage() : void
      {
         if(this.msgHistory.length < 1)
         {
            return;
         }
         ++this.historyPosition;
         if(this.historyPosition >= this.msgHistory.length)
         {
            this.historyPosition = 0;
         }
         text = this.msgHistory[this.historyPosition];
      }
      
      public function sendMessage() : void
      {
         this.historyPosition = this.msgHistory.length;
         dispatchEvent(new ChatEvent(ChatEvent.MESSAGE_SEND));
      }
      
      private function onResize(e:Event) : void
      {
         redraw();
      }
      
      private function onKeyDown(e:KeyboardEvent) : void
      {
         switch(e.keyCode)
         {
            case Keyboard.ENTER:
               this.sendMessage();
               break;
            case Keyboard.UP:
               this.prevMessage();
               break;
            case Keyboard.DOWN:
               this.nextMessage();
         }
      }
      
      public function clearCurrentUsers() : void
      {
         var txt:String = text;
         txt = txt.replace(/\[.*\]/g,"");
         text = txt;
      }
      
      public function userClicked(user:String) : void
      {
         var txt:String = text;
         var userEntry:String = "[" + user + "]";
         if(txt.indexOf(userEntry) != -1)
         {
            txt = txt.replace(userEntry,"");
         }
         else
         {
            txt = userEntry + txt;
         }
         text = txt;
         setFocus();
         textField.setSelection(text.length,text.length);
      }
   }
}

