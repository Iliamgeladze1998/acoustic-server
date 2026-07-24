package soul.view.chat
{
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import mx.events.PropertyChangeEvent;
   import soul.event.ChatEvent;
   import soul.model.chat.ChatUser;
   import soul.model.chat.ChatUserStatus;
   import soul.view.ui.Box;
   import soul.view.ui.Label;
   import spark.layouts.VerticalAlign;
   
   public class ChatUserRenderer extends Box
   {
      
      private var icon:ClanIcon = new ClanIcon();
      
      private var level:Label = new Label();
      
      private var nick:Label = new Label();
      
      private var color:uint = 14402489;
      
      private var disabledColor:uint = 3355443;
      
      private var _user:ChatUser;
      
      public function ChatUserRenderer()
      {
         super();
         gap = 0;
         verticalAlign = VerticalAlign.BOTTOM;
         this.level.color = this.color;
         addChild(this.icon);
         addChild(this.level);
         addChild(this.nick);
         addEventListener(MouseEvent.CLICK,this.showInfo,false,0,true);
         this.icon.addEventListener(MouseEvent.CLICK,this.showClan,false,0,true);
      }
      
      private function showInfo(e:MouseEvent) : void
      {
         e.stopPropagation();
         var ne:ChatEvent = new ChatEvent(ChatEvent.OPEN_CHAR_MENU);
         ne.data = this._user;
         dispatchEvent(ne);
      }
      
      private function showClan(e:MouseEvent) : void
      {
         e.stopPropagation();
         var ne:ChatEvent = new ChatEvent(ChatEvent.OPEN_CHAR_CLAN);
         ne.data = this._user.clanId;
         dispatchEvent(ne);
      }
      
      public function set user(value:ChatUser) : void
      {
         this._user = value;
         this.level.text = "[" + value.level + "]";
         if(value.clanId > 0)
         {
            this.icon.clanId = value.clanId;
            this.icon.toolTip = value.clanName;
         }
         this.redrawNick();
         IEventDispatcher(this._user).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.userChanged,false,0,true);
         updateNow();
      }
      
      public function get user() : ChatUser
      {
         return this._user;
      }
      
      private function userChanged(e:PropertyChangeEvent) : void
      {
         if(e.property == "punished")
         {
            this.redrawNick();
         }
      }
      
      private function redrawNick() : void
      {
         var prefix:String = "";
         if(Boolean(this.user.role))
         {
            prefix = "<font color=\"" + ChatUserStatus.getColor(this._user.role) + "\"><b>" + this._user.role + "</b></font> ";
         }
         var color:int = this._user.punished ? int(this.disabledColor) : int(this.color);
         var name:String = "<font color=\"#" + color.toString(16) + "\">" + this._user.name + "</font>";
         this.nick.htmlText = prefix + name;
      }
   }
}

