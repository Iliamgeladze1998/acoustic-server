package soul.controller.chat
{
   import flash.display.DisplayObjectContainer;
   import mx.binding.utils.BindingUtils;
   import mx.binding.utils.ChangeWatcher;
   import mx.utils.StringUtil;
   import soul.controller.LogManager;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.ChatEvent;
   import soul.model.GameModel;
   import soul.model.chat.ChatMessage;
   import soul.model.chat.ChatModel;
   import soul.model.chat.ChatTabData;
   import soul.model.chat.ChatTabModel;
   import soul.model.chat.ChatUser;
   import soul.model.chat.Message;
   import soul.model.chat.SystemMessage;
   import soul.model.interaction.settings.SettingsModel;
   import soul.model.system.Configuration;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   import soul.view.chat.ChatScreen;
   import soul.view.common.BigMessage;
   
   public class ChatManager
   {
      
      private static const MAX_LINES_IN_TAB:int = 100;
      
      private static const SERVICE:String = "chatService";
      
      private static const bundles:Array = [BundleName.INTERFACE,BundleName.CHAT];
      
      private var container:DisplayObjectContainer;
      
      private var view:ChatScreen;
      
      private var model:ChatModel;
      
      private var settingsModel:SettingsModel;
      
      private var cw:ChangeWatcher;
      
      private var timeStamp:Boolean;
      
      public function ChatManager(view:ChatScreen, gameModel:GameModel)
      {
         super();
         ComponentLocator.setComponent(ComponentLocator.CHAT,this);
         this.view = view;
         this.model = gameModel.chatModel;
         this.settingsModel = gameModel.settingsModel;
         this.model.addEventListener(ChatEvent.MESSAGE_SEND,this.messageSend);
         this.model.addEventListener(ChatEvent.ADD_COMBAT_MESSAGE,this.addCombatMessage);
         this.model.addEventListener(ChatEvent.LOCALE_CHANGED,this.requestLocaleChange);
         this.settingsModel.addEventListener(ChatEvent.TIMESTAMP_CHANGED,this.timeStampChange);
         this.timeStampChange(null);
         this.cw = BindingUtils.bindSetter(this.tabChanged,this.model,"currentTab");
         ServerLayer.call(SERVICE,ComponentLocator.READY,null,null,Configuration.locale);
      }
      
      public function reset() : void
      {
         this.model.removeEventListener(ChatEvent.MESSAGE_SEND,this.messageSend);
         this.model.removeEventListener(ChatEvent.ADD_COMBAT_MESSAGE,this.addCombatMessage);
         this.model.removeEventListener(ChatEvent.LOCALE_CHANGED,this.requestLocaleChange);
         this.settingsModel.removeEventListener(ChatEvent.TIMESTAMP_CHANGED,this.timeStampChange);
         if(Boolean(this.cw))
         {
            this.cw.unwatch();
            this.cw = null;
         }
         this.view = null;
         this.model = null;
         this.settingsModel = null;
      }
      
      private function timeStampChange(e:ChatEvent) : void
      {
         this.timeStamp = this.settingsModel.chatTimeStamp;
         this.showCurrentMessages();
      }
      
      private function messageSend(e:ChatEvent) : void
      {
         ServerLayer.call(SERVICE,"sendMessage",null,null,e.data);
      }
      
      private function addCombatMessage(e:ChatEvent) : void
      {
         var update:Boolean = false;
         var msg:Message = e.data as Message;
         var tab:ChatTabModel = this.getTabByKey(ChatTabModel.COMBAT);
         if(!tab)
         {
            return;
         }
         if(tab.messages.length > MAX_LINES_IN_TAB)
         {
            tab.messages.shift();
         }
         tab.messages.push(msg);
         if(Boolean(this.model.currentTab) && tab.key == this.model.currentTab.key)
         {
            update = true;
         }
         else
         {
            tab.newMessages = true;
         }
         if(update)
         {
            this.showCurrentMessages();
         }
      }
      
      private function requestLocaleChange(e:ChatEvent) : void
      {
         ServerLayer.call(SERVICE,"selectLanguage",null,null,e.data);
      }
      
      private function parseInitialData(tabDatas:Array) : void
      {
         var chatTabData:ChatTabData = null;
         var tab:ChatTabModel = null;
         var tabs:Array = [];
         for each(chatTabData in tabDatas)
         {
            tab = new ChatTabModel(chatTabData);
            tabs.push(tab);
         }
         this.model.tabs = tabs;
         ServerLayer.call(SERVICE,"getDefaultTab",this.setDefaultTab);
      }
      
      private function setDefaultTab(value:String) : void
      {
         var tab:ChatTabModel = this.getTabByKey(value);
         this.model.currentTab = tab;
      }
      
      private function tabChanged(tab:ChatTabModel) : void
      {
         if(!tab)
         {
            return;
         }
         this.showCurrentMessages();
      }
      
      public function showCurrentMessages() : void
      {
         var msg:Message = null;
         if(!this.model.currentTab)
         {
            return;
         }
         var msgs:Vector.<String> = new Vector.<String>();
         var txt:String = "";
         for each(msg in this.model.currentTab.messages)
         {
            msgs.push(this.createMessage(msg));
         }
         this.model.currentMessages = msgs.join("\n");
      }
      
      private function createMessage(msg:Message) : String
      {
         var txt:String = null;
         var res:Array = null;
         var rec:String = null;
         var str:String = this.timeStamp ? this.drawTime(msg.date) + " " : "";
         var chatMsg:ChatMessage = msg as ChatMessage;
         if(Boolean(chatMsg))
         {
            if(Boolean(chatMsg.sender))
            {
               str += this.drawUser(chatMsg.sender);
            }
            if(Boolean(chatMsg.recipients) && chatMsg.recipients.length > 0)
            {
               str += " > [";
               res = [];
               for each(rec in chatMsg.recipients)
               {
                  res.push(this.drawUser(rec));
               }
               str += res.join(",") + "]";
            }
            txt = chatMsg.text.replace(/</g,"&lt;");
            txt = txt.replace(/>/g,"&gt;");
            str += " " + txt;
         }
         else
         {
            str += msg.text;
         }
         return str;
      }
      
      private function drawTime(date:Date) : String
      {
         var h:String = (date.hours > 9 ? "" : "0") + date.hours;
         var m:String = (date.minutes > 9 ? "" : "0") + date.minutes;
         var s:String = (date.seconds > 9 ? "" : "0") + date.seconds;
         return h + ":" + m + ":" + s;
      }
      
      private function drawUser(nick:String) : String
      {
         var spanClass:String = nick == this.model.characterName ? "myNick" : "nick";
         return "<b><span class=\"" + spanClass + "\"><a href=\"event:" + nick + "\">" + nick + "</a></span></b>";
      }
      
      public function init(tabDatas:Array, languages:Array, currentLanguage:String) : void
      {
         this.parseInitialData(tabDatas);
         this.model.languages = languages;
         this.model.currentLanguage = currentLanguage;
      }
      
      public function addTab(newTab:ChatTabData) : void
      {
         if(!newTab.enabled)
         {
            return;
         }
         var tabs:Array = this.model.tabs;
         tabs.push(new ChatTabModel(newTab));
         this.model.tabs = null;
         this.model.tabs = tabs;
      }
      
      public function removeTab(tabKey:String) : void
      {
         var tab:ChatTabModel = null;
         var tabs:Array = this.model.tabs;
         for(var i:uint = 0; i < tabs.length; i++)
         {
            tab = tabs[i];
            if(tab.key == tabKey)
            {
               tabs.splice(i,1);
               this.model.tabs = null;
               this.model.tabs = tabs;
               if(tab == this.model.currentTab)
               {
                  this.model.currentTab = this.model.tabs[0];
               }
            }
         }
      }
      
      public function changeTab(newTab:ChatTabData) : void
      {
         var key:String = null;
         var tab:ChatTabModel = null;
         if(!newTab)
         {
            return;
         }
         var tabs:Array = this.model.tabs;
         for(key in tabs)
         {
            tab = tabs[key];
            if(tab.key == newTab.tab)
            {
               tab = new ChatTabModel(newTab);
               tabs[key] = tab;
               this.model.currentTab = newTab.enabled ? tab : tabs[0];
               break;
            }
         }
         this.model.tabs = null;
         this.model.tabs = tabs;
      }
      
      public function addMessage(msg:ChatMessage) : void
      {
         var tab:ChatTabModel = this.getTabByKey(msg.tab) || this.model.currentTab;
         if(!tab)
         {
            return;
         }
         tab.messages.push(msg);
         if(tab.messages.length > MAX_LINES_IN_TAB)
         {
            tab.messages.shift();
         }
         if(tab == this.model.currentTab)
         {
            this.showCurrentMessages();
         }
         else if(ChatTabModel.SPAM_TABS.indexOf(msg.tab) != -1)
         {
            tab.newMessages = msg.recipients.indexOf(this.model.characterName) != -1;
         }
         else
         {
            tab.newMessages = true;
         }
      }
      
      public function selectLanguage(locale:String) : void
      {
         this.model.currentLanguage = locale;
      }
      
      public function addSystemMessage(msg:SystemMessage) : void
      {
         var update:Boolean = false;
         var tab:ChatTabModel = null;
         var tabs:Vector.<ChatTabModel> = this.getTabsByType(msg.type);
         var string:String = this.getString(msg.type);
         var color:String = this.getMessageColor(msg.type);
         msg.text = msg.localizedText;
         if(Boolean(color))
         {
            msg.text = "<font color=\"" + color + "\">" + msg.text + "</font>";
         }
         for each(tab in tabs)
         {
            if(tab.messages.length > MAX_LINES_IN_TAB)
            {
               tab.messages.shift();
            }
            tab.messages.push(msg);
            if(tab.key == this.model.currentTab.key)
            {
               update = true;
            }
            else
            {
               tab.newMessages = true;
            }
         }
         if(update)
         {
            this.showCurrentMessages();
         }
         LogManager.addMessage(msg.text);
         if(BigMessage.messageTypeSupported(msg.type))
         {
            BigMessage.showMessage(msg.text);
         }
      }
      
      public function addBigMessage(key:String, arguments:Array) : void
      {
         var str:String = this.getString(key);
         str = StringUtil.substitute(str,arguments);
         BigMessage.showMessage(str);
      }
      
      public function addUser(tabName:String, user:ChatUser) : void
      {
         if(user == null || tabName == null)
         {
            return;
         }
         var tab:ChatTabModel = this.getTabByKey(tabName);
         if(!tab)
         {
            return;
         }
         var users:Array = tab.users;
         if(!users)
         {
            return;
         }
         users.push(user);
         tab.users = users.slice();
      }
      
      public function removeUser(tabName:String, id:String) : void
      {
         var i:String = null;
         var user:ChatUser = null;
         if(id == null || tabName == null)
         {
            return;
         }
         var tab:ChatTabModel = this.getTabByKey(tabName);
         if(!tab)
         {
            return;
         }
         var users:Array = tab.users;
         for(i in users)
         {
            user = users[i];
            if(user.id == id)
            {
               users.splice(int(i),1);
            }
         }
         tab.users = users.slice();
      }
      
      public function updateUser(value:ChatUser) : void
      {
         var t:ChatTabModel = null;
         var i:String = null;
         var users:Array = null;
         if(value == null)
         {
            return;
         }
         for each(t in this.model.tabs)
         {
            for(i in t.users)
            {
               if(ChatUser(t.users[i]).id == value.id)
               {
                  users = t.users;
                  users[i] = value;
                  t.users = null;
                  t.users = users;
                  break;
               }
            }
         }
      }
      
      private function getTabByKey(key:String) : ChatTabModel
      {
         var t:ChatTabModel = null;
         for each(t in this.model.tabs)
         {
            if(t.key == key)
            {
               return t;
            }
         }
         return null;
      }
      
      private function getTabsByType(type:String) : Vector.<ChatTabModel>
      {
         var t:ChatTabModel = null;
         var v:Vector.<ChatTabModel> = new Vector.<ChatTabModel>();
         for each(t in this.model.tabs)
         {
            if(t.showsType(type))
            {
               v.push(t);
            }
         }
         return v;
      }
      
      private function getMessageColor(type:String) : String
      {
         var color:String = this.getString(type + ".color");
         return color == type ? null : color;
      }
      
      private function getString(key:String) : String
      {
         var bundle:String = null;
         var str:String = null;
         for each(bundle in bundles)
         {
            str = LocaleManager.getString(bundle,key);
            if(str != key)
            {
               return str;
            }
         }
         return key;
      }
   }
}

