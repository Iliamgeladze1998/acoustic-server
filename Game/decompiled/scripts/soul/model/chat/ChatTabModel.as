package soul.model.chat
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.LabelTab;
   
   public class ChatTabModel extends LabelTab implements IEventDispatcher
   {
      
      public static const PLACE:String = "PLACE";
      
      public static const TRADE:String = "MARKET";
      
      public static const GROUP:String = "GROUP";
      
      public static const CLAN:String = "CLAN";
      
      public static const SYSTEM:String = "SYSTEM";
      
      public static const COMBAT:String = "COMBAT";
      
      public static const PRIVATE:String = "PRIVATE";
      
      public static const SPAM_TABS:Array = [PLACE,TRADE];
      
      private static const tabTypeMap:Object = {};
      
      private static const LAST_AUTHOR_COUNT:uint = 5;
      
      tabTypeMap[PLACE] = [MessageType.CITADEL_OWNED,MessageType.CITADEL_NOT_OWNED,MessageType.CITADEL_OPENED];
      tabTypeMap[TRADE] = [MessageType.NOT_ENOUGH_MONEY,MessageType.USELESS_REPAIR];
      tabTypeMap[GROUP] = [MessageType.GROUP_ALREADY_HERE,MessageType.GROUP_ENTER,MessageType.GROUP_INVITE_RECV,MessageType.GROUP_INVITE_REFUSED,MessageType.GROUP_INVITE_SENT,MessageType.GROUP_ITEM_RECV,MessageType.ITEM_RECV,MessageType.GROUP_LEADER_CHANGED,MessageType.GROUP_LEAVE,MessageType.GROUP_LEVEL_MISSMATCH,MessageType.GROUP_LMT_CHANGED,MessageType.GROUP_NOT_LEADER,MessageType.GROUP_OVERFLOW,MessageType.GROUP_USER_OVERFLOW,MessageType.CHAR_NOT_FOUND];
      tabTypeMap[CLAN] = [MessageType.CLAN_AD,MessageType.CLAN_AIC,MessageType.CLAN_FULL,MessageType.CLAN_INV_NS,MessageType.CLAN_INV_REJ,MessageType.CLAN_INV_SENT,MessageType.CLAN_KICK,MessageType.CLAN_LEFT,MessageType.CLAN_NEM,MessageType.CLAN_JOIN,MessageType.CLAN_MEMBER_LEFT,MessageType.CITADEL_OPEN,MessageType.CITADEL_OWNED,MessageType.CITADEL_NOT_OWNED,MessageType.CITADEL_OPENED,MessageType.CITADEL_ASSAULT,MessageType.CITADEL_TAKEN];
      tabTypeMap[SYSTEM] = [MessageType.CHAT_PENALTY,MessageType.CHAT_FLOOD,MessageType.RESTART,MessageType.SHUTDOWN,MessageType.NEXT_DAY_REWARD];
      tabTypeMap[COMBAT] = [MessageType.REP_RECV,MessageType.EXP_RECV,MessageType.FIGHT_START,MessageType.FIGHT_STOP,MessageType.LEVEL_UP];
      
      private var _111578632users:Array;
      
      private var _462094004messages:Array;
      
      private var _794652428newMessages:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ChatTabModel(data:ChatTabData)
      {
         super(data.tab,Boolean(data.name) ? data.name : LocaleManager.getString(BundleName.INTERFACE,"tabs." + data.tab),data.enabled);
         this.messages = data.messages;
         this.users = data.users;
      }
      
      public function showsType(type:String) : Boolean
      {
         var arr:Array = tabTypeMap[key];
         if(!arr)
         {
            return false;
         }
         return arr.indexOf(type) != -1;
      }
      
      public function getLastUniqueAuthors() : Vector.<String>
      {
         var msg:ChatMessage = null;
         var ret:Vector.<String> = new Vector.<String>();
         for(var i:int = this.messages.length - 1; i >= 0; i--)
         {
            msg = this.messages[i] as ChatMessage;
            if(msg)
            {
               if(ret.indexOf(msg.sender) == -1)
               {
                  ret.push(msg.sender);
                  if(ret.length >= LAST_AUTHOR_COUNT)
                  {
                     break;
                  }
               }
            }
         }
         return ret;
      }
      
      [Bindable(event="propertyChange")]
      public function get users() : Array
      {
         return this._111578632users;
      }
      
      public function set users(param1:Array) : void
      {
         var _loc2_:Object = this._111578632users;
         if(_loc2_ !== param1)
         {
            this._111578632users = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"users",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get messages() : Array
      {
         return this._462094004messages;
      }
      
      public function set messages(param1:Array) : void
      {
         var _loc2_:Object = this._462094004messages;
         if(_loc2_ !== param1)
         {
            this._462094004messages = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messages",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get newMessages() : Boolean
      {
         return this._794652428newMessages;
      }
      
      public function set newMessages(param1:Boolean) : void
      {
         var _loc2_:Object = this._794652428newMessages;
         if(_loc2_ !== param1)
         {
            this._794652428newMessages = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"newMessages",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

