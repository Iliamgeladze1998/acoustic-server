package soul.model.chat
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class ChatModel extends EventDispatcher
   {
      
      private var _3552126tabs:Array;
      
      private var _1088984228currentTab:ChatTabModel;
      
      private var _1790120620characterName:String;
      
      private var _1518327835languages:Array;
      
      private var _639904753currentLanguage:String;
      
      private var _1791400421currentMessages:String;
      
      private var _1418803855combatLogEnabled:Boolean;
      
      public function ChatModel()
      {
         super();
      }
      
      public function getChatUserByName(name:String) : ChatUser
      {
         var user:ChatUser = null;
         if(Boolean(this.currentTab))
         {
            for each(user in this.currentTab.users)
            {
               if(user.name == name)
               {
                  return user;
               }
            }
         }
         return null;
      }
      
      public function getChatUserById(id:String) : ChatUser
      {
         var tab:ChatTabModel = null;
         var user:ChatUser = null;
         for each(tab in this.tabs)
         {
            for each(user in tab.users)
            {
               if(user.id == id)
               {
                  return user;
               }
            }
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get tabs() : Array
      {
         return this._3552126tabs;
      }
      
      public function set tabs(param1:Array) : void
      {
         var _loc2_:Object = this._3552126tabs;
         if(_loc2_ !== param1)
         {
            this._3552126tabs = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tabs",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentTab() : ChatTabModel
      {
         return this._1088984228currentTab;
      }
      
      public function set currentTab(param1:ChatTabModel) : void
      {
         var _loc2_:Object = this._1088984228currentTab;
         if(_loc2_ !== param1)
         {
            this._1088984228currentTab = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentTab",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get characterName() : String
      {
         return this._1790120620characterName;
      }
      
      public function set characterName(param1:String) : void
      {
         var _loc2_:Object = this._1790120620characterName;
         if(_loc2_ !== param1)
         {
            this._1790120620characterName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"characterName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get languages() : Array
      {
         return this._1518327835languages;
      }
      
      public function set languages(param1:Array) : void
      {
         var _loc2_:Object = this._1518327835languages;
         if(_loc2_ !== param1)
         {
            this._1518327835languages = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"languages",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentLanguage() : String
      {
         return this._639904753currentLanguage;
      }
      
      public function set currentLanguage(param1:String) : void
      {
         var _loc2_:Object = this._639904753currentLanguage;
         if(_loc2_ !== param1)
         {
            this._639904753currentLanguage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentLanguage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentMessages() : String
      {
         return this._1791400421currentMessages;
      }
      
      public function set currentMessages(param1:String) : void
      {
         var _loc2_:Object = this._1791400421currentMessages;
         if(_loc2_ !== param1)
         {
            this._1791400421currentMessages = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentMessages",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get combatLogEnabled() : Boolean
      {
         return this._1418803855combatLogEnabled;
      }
      
      public function set combatLogEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1418803855combatLogEnabled;
         if(_loc2_ !== param1)
         {
            this._1418803855combatLogEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"combatLogEnabled",_loc2_,param1));
            }
         }
      }
   }
}

