package soul.view.chat
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.styles.*;
   import soul.model.chat.ChatModel;
   import soul.model.chat.ChatTabModel;
   import soul.view.ui.Box;
   
   use namespace mx_internal;
   
   public class ChatTabs extends Box implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _104069929model:ChatModel;
      
      private var _transparent:Boolean;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ChatTabs()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         bindings = this._ChatTabs_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_chat_ChatTabsWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ChatTabs[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.gap = 2;
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ChatTabs._watcherSetupUtil = param1;
      }
      
      private function set tabs(value:Array) : void
      {
         var tabModel:ChatTabModel = null;
         var tab:ChatTab = null;
         removeAllChildren();
         for each(tabModel in value)
         {
            if(tabModel.enabled)
            {
               tab = new ChatTab();
               tab.model = tabModel;
               tab.transparent = this._transparent;
               if(tabModel == this.model.currentTab)
               {
                  tab.selected = true;
               }
               tab.addEventListener(MouseEvent.CLICK,this.tabClick,false,0,true);
               addChild(tab);
            }
         }
      }
      
      public function set transparent(value:Boolean) : void
      {
         var tab:ChatTab = null;
         this._transparent = value;
         for(var i:int = 0; i < numChildren; i++)
         {
            tab = ChatTab(getChildAt(i));
            tab.transparent = value;
         }
      }
      
      private function set selectedTab(value:ChatTabModel) : void
      {
         var tab:ChatTab = null;
         for(var i:int = 0; i < numChildren; i++)
         {
            tab = ChatTab(getChildAt(i));
            tab.selected = tab.model == value;
         }
      }
      
      private function tabClick(e:MouseEvent) : void
      {
         var currentTab:ChatTab = ChatTab(e.currentTarget);
         this.model.currentTab = currentTab.model;
         currentTab.model.newMessages = false;
      }
      
      private function _ChatTabs_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():*
         {
            return model.tabs;
         },function(param1:*):void
         {
            tabs = param1;
         },"tabs");
         result[1] = new Binding(this,function():*
         {
            return model.currentTab;
         },function(param1:*):void
         {
            selectedTab = param1;
         },"selectedTab");
         return result;
      }
      
      private function _ChatTabs_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         this.tabs = this.model.tabs;
         this.selectedTab = this.model.currentTab;
      }
      
      [Bindable(event="propertyChange")]
      public function get model() : ChatModel
      {
         return this._104069929model;
      }
      
      public function set model(param1:ChatModel) : void
      {
         var _loc2_:Object = this._104069929model;
         if(_loc2_ !== param1)
         {
            this._104069929model = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"model",_loc2_,param1));
            }
         }
      }
   }
}

