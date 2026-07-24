package soul.model.interaction.settings
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.SharedObject;
   import mx.events.PropertyChangeEvent;
   import soul.event.ChatEvent;
   import soul.event.SettingsEvent;
   import soul.model.item.ItemShortcut;
   
   public class SettingsModel extends EventDispatcher
   {
      
      private const so:SharedObject = SharedObject.getLocal("sod_settings");
      
      private var _806066213fullScreen:Boolean;
      
      public var fullScreenAllowed:Boolean;
      
      private var _virtualPanelShortcuts:Vector.<ItemShortcut>;
      
      public function SettingsModel()
      {
         super();
      }
      
      public function set virtualPanelShortcuts(value:Vector.<ItemShortcut>) : void
      {
         this.so.data.virtualPanelShortcuts = value;
         this.so.flush();
      }
      
      public function get virtualPanelShortcuts() : Vector.<ItemShortcut>
      {
         return this.so.data.virtualPanelShortcuts;
      }
      
      public function set showLighting(value:Boolean) : void
      {
         if(this.so.data.showLighting == value)
         {
            return;
         }
         this.so.data.showLighting = value;
         this.so.flush();
         dispatchEvent(new SettingsEvent(SettingsEvent.LIGHTING));
      }
      
      public function get showLighting() : Boolean
      {
         return !this.so.data.hasOwnProperty("showLighting") || Boolean(this.so.data.showLighting);
      }
      
      public function set damageDisplay(value:uint) : void
      {
         if(this.so.data.damageDisplay == value)
         {
            return;
         }
         this.so.data.damageDisplay = value;
         this.so.flush();
         dispatchEvent(new SettingsEvent(SettingsEvent.DAMAGE));
      }
      
      public function get damageDisplay() : uint
      {
         return !this.so.data.hasOwnProperty("damageDisplay") ? DamageDisplay.PLAYER_DISPLAY : uint(this.so.data.damageDisplay);
      }
      
      public function set fowDisplay(value:uint) : void
      {
         if(this.so.data.fowDisplay == value)
         {
            return;
         }
         this.so.data.fowDisplay = value;
         this.so.flush();
         dispatchEvent(new SettingsEvent(SettingsEvent.FOW));
      }
      
      public function get fowDisplay() : uint
      {
         return !this.so.data.hasOwnProperty("fowDisplay") ? FowDisplay.NORMAL : uint(this.so.data.fowDisplay);
      }
      
      public function set chatVisible(value:Boolean) : void
      {
         this.so.data.chatVisible = value;
         this.so.flush();
      }
      
      public function get chatVisible() : Boolean
      {
         return this.so.data.chatVisible;
      }
      
      public function set chatUsersHidden(value:Boolean) : void
      {
         if(this.so.data.chatUsersHidden == value)
         {
            return;
         }
         this.so.data.chatUsersHidden = value;
         this.so.flush();
      }
      
      public function get chatUsersHidden() : Boolean
      {
         return this.so.data.chatUsersHidden;
      }
      
      public function set chatTansparentAlpha(value:Number) : void
      {
         this.so.data.chatTansparentAlpha = value;
         this.so.flush();
      }
      
      public function get chatTansparentAlpha() : Number
      {
         return this.so.data.hasOwnProperty("chatTansparentAlpha") ? Number(this.so.data.chatTansparentAlpha) : 0;
      }
      
      public function set chatOpaqueAlpha(value:Number) : void
      {
         this.so.data.chatOpaqueAlpha = value;
         this.so.flush();
      }
      
      public function get chatOpaqueAlpha() : Number
      {
         return this.so.data.hasOwnProperty("chatOpaqueAlpha") ? Number(this.so.data.chatOpaqueAlpha) : 1;
      }
      
      public function set chatTimeStamp(value:Boolean) : void
      {
         this.so.data.chatTimeStamp = value;
         this.so.flush();
         dispatchEvent(new ChatEvent(ChatEvent.TIMESTAMP_CHANGED));
      }
      
      public function get chatTimeStamp() : Boolean
      {
         return this.so.data.chatTimeStamp == true;
      }
      
      [Bindable("pvpEventsHiddenChanged")]
      public function set pvpEventsHidden(value:Boolean) : void
      {
         if(this.so.data.pvpEventsHidden == value)
         {
            return;
         }
         this.so.data.pvpEventsHidden = value;
         this.so.flush();
         dispatchEvent(new Event("pvpEventsHiddenChanged"));
      }
      
      public function get pvpEventsHidden() : Boolean
      {
         return this.so.data.pvpEventsHidden;
      }
      
      public function setAchievementTracked(achievementId:String, tracked:Boolean) : void
      {
         var data:Object = this.so.data.trackedAchievements || {};
         if(tracked)
         {
            data[achievementId] = true;
         }
         else
         {
            delete data[achievementId];
         }
         this.so.data.trackedAchievements = data;
         this.so.flush();
      }
      
      public function getAchievementTracked(achievementId:String) : Boolean
      {
         var data:Object = this.so.data.trackedAchievements;
         return Boolean(data) ? Boolean(data[achievementId]) : false;
      }
      
      public function set cameraFollowType(value:uint) : void
      {
         if(this.so.data.cameraFollowType == value)
         {
            return;
         }
         this.so.data.cameraFollowType = value;
         this.so.flush();
         dispatchEvent(new SettingsEvent(SettingsEvent.CAMERA));
      }
      
      public function get cameraFollowType() : uint
      {
         return !this.so.data.hasOwnProperty("cameraFollowType") ? CameraFollowType.AUTO : uint(this.so.data.cameraFollowType);
      }
      
      [Bindable(event="propertyChange")]
      public function get fullScreen() : Boolean
      {
         return this._806066213fullScreen;
      }
      
      public function set fullScreen(param1:Boolean) : void
      {
         var _loc2_:Object = this._806066213fullScreen;
         if(_loc2_ !== param1)
         {
            this._806066213fullScreen = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fullScreen",_loc2_,param1));
            }
         }
      }
   }
}

