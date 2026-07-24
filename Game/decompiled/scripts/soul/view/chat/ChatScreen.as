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
   import soul.controller.Interaction;
   import soul.controller.MenuManager;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.controller.shortcut.Shortcut;
   import soul.controller.shortcut.ShortcutManager;
   import soul.event.ChatEvent;
   import soul.event.MenuEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.character.CharacterModel;
   import soul.model.chat.ChatModel;
   import soul.model.chat.ChatUser;
   import soul.model.chat.ClientMessage;
   import soul.model.common.MenuType;
   import soul.model.group.GroupModel;
   import soul.model.interaction.settings.SettingsModel;
   import soul.model.interaction.social.SocialModel;
   import soul.model.rtm.RTMModel;
   import soul.net.ServerLayer;
   import soul.view.assets.Assets;
   import soul.view.common.Icons;
   import soul.view.ui.Box;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Component;
   import soul.view.ui.Container;
   import soul.view.ui.Label;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.controls.menu.Menu;
   
   use namespace mx_internal;
   
   public class ChatScreen extends Container implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const barSize:uint = 18;
      
      private static const FONT_SIZES:Vector.<int> = Vector.<int>([10,11,12,14]);
      
      private static const ALPHAS:Vector.<Number> = Vector.<Number>([1,0.8,0.6,0.4,0.2,0]);
      
      public var _ChatScreen_Box1:Box;
      
      public var _ChatScreen_CachedImage1:CachedImage;
      
      public var _ChatScreen_CachedImage2:CachedImage;
      
      public var _ChatScreen_Label1:Label;
      
      private var _97739box:ChatBorder;
      
      private var _1437388534chatTabs:ChatTabs;
      
      private var _2071192609clearButton:CachedImage;
      
      private var _1354665387corner:CachedImage;
      
      private var _100358090input:ChatInput;
      
      private var _470688161inputBox:Box;
      
      private var _284964057inputHoverBox:Component;
      
      private var _241734567localeSelector:ChatLanguageSelector;
      
      private var _913939087menuButton:CachedImage;
      
      private var _462094004messages:ChatField;
      
      private var _2144320631resizeBox:Component;
      
      private var _1097202238resizer:Component;
      
      private var _713510sendButton:CachedImage;
      
      private var _1726194350transparent:HideButton;
      
      private var _1106426589userButton:CachedImage;
      
      private var _266718455userList:ChatUsers;
      
      private var _111578632users:ChatBorder;
      
      private var _104069929model:ChatModel;
      
      public var characterModel:CharacterModel;
      
      public var groupModel:GroupModel;
      
      public var socialModel:SocialModel;
      
      public var rtmModel:RTMModel;
      
      public var settingsModel:SettingsModel;
      
      private var _141450934usersVisible:Boolean = true;
      
      private var _1453111624inputVisible:Boolean;
      
      private var _1365299090inputHover:Boolean;
      
      private var _1425484221opaqueAlpha:Number = 0.8;
      
      private var _87431380transparentAlpha:Number = 0.2;
      
      private var cursorId:int;
      
      private var currentSort:String;
      
      private var currentList:Vector.<String>;
      
      private var currentUserIndex:int = 0;
      
      mx_internal var _bindings:Array;
      
      mx_internal var _watchers:Array;
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public function ChatScreen()
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
         bindings = this._ChatScreen_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_soul_view_chat_ChatScreenWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ChatScreen[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mouseEnabled = false;
         this.children = [this._ChatScreen_ChatBorder1_i(),this._ChatScreen_ChatTabs1_i(),this._ChatScreen_ChatBorder2_i(),this._ChatScreen_HideButton1_i(),this._ChatScreen_CachedImage7_i(),this._ChatScreen_Component1_i(),this._ChatScreen_Component2_i(),this._ChatScreen_Component3_i()];
         this.addEventListener("creationComplete",this.___ChatScreen_Container1_creationComplete);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      private static function userListChanged(oldList:Vector.<String>, newList:Vector.<String>) : Boolean
      {
         var u1:String = null;
         var u2:String = null;
         if(!oldList)
         {
            return true;
         }
         var l:uint = oldList.length;
         if(l != newList.length)
         {
            return true;
         }
         for(var i:uint = 0; i < l; i++)
         {
            u1 = oldList[i];
            u2 = newList[i];
            if(u1 != u2)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ChatScreen._watcherSetupUtil = param1;
      }
      
      private function creationComplete() : void
      {
         this.box.addEventListener(Event.RESIZE,this.onBoxResize);
         this.resizer.graphics.beginFill(16711680,0);
         this.resizer.graphics.drawRect(0,0,15,15);
         this.resizer.width = 15;
         this.resizer.height = 15;
         this.box.updateNow();
         this.onBoxResize(null);
         addEventListener(Event.REMOVED_FROM_STAGE,this.onRemoved);
         this.userList.addEventListener(ChatEvent.OPEN_CHAR_MENU,this.openCharMenu,false,0,true);
         this.userList.addEventListener(ChatEvent.OPEN_CHAR_CLAN,this.openCharClan,false,0,true);
         this.messages.addEventListener(ChatEvent.CHAR_CLICKED,this.textUserClicked,false,0,true);
         this.input.addEventListener(ChatEvent.MESSAGE_SEND,this.send,false,0,true);
         this.sendButton.addEventListener(MouseEvent.CLICK,this.send,false,0,true);
         this.clearButton.addEventListener(MouseEvent.CLICK,this.clear,false,0,true);
         this.menuButton.addEventListener(MouseEvent.CLICK,this.showMenu,false,0,true);
         this.userButton.addEventListener(MouseEvent.CLICK,this.toggleUsers,false,0,true);
         this.resizer.addEventListener(MouseEvent.MOUSE_DOWN,this.resizeStart);
         ShortcutManager.addShortcutListener(Shortcut.TAB,this.onTab,1,false);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
         this.model.addEventListener(ChatEvent.ADD_CHAT_RECIPIENT,this.addChatRecipient);
         this.transparent.selected = !this.settingsModel.chatVisible;
         this.usersVisible = !this.settingsModel.chatUsersHidden;
         this.opaqueAlpha = this.settingsModel.chatOpaqueAlpha;
         this.transparentAlpha = this.settingsModel.chatTansparentAlpha;
      }
      
      private function onRemoved(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         ShortcutManager.removeShortcutListener(Shortcut.TAB,this.onTab,false);
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyUp);
      }
      
      private function sortBy(field:String) : void
      {
         if(this.currentSort == field)
         {
            field = "-" + field;
         }
         this.currentSort = field;
         this.userList.sortBy(field);
      }
      
      private function transparentChange() : void
      {
         this.settingsModel.chatVisible = this.transparent.selected;
         if(!this.transparent.selected)
         {
            this.input.setFocus();
         }
      }
      
      private function addChatRecipient(e:ChatEvent) : void
      {
         this.input.userClicked(e.data);
      }
      
      private function onKeyUp(e:KeyboardEvent) : void
      {
         if(this.input.getFocus())
         {
            if(e.keyCode == Keyboard.TAB)
            {
               this.onTab();
            }
            else if(e.keyCode == Keyboard.ESCAPE)
            {
               this.onCancel();
            }
         }
         else if(!(stage.focus is TextField) || TextField(stage.focus).type != TextFieldType.INPUT)
         {
            if(e.keyCode == Keyboard.ENTER)
            {
               this.onEnter();
            }
         }
      }
      
      private function onEnter() : void
      {
         if(this.input.getFocus())
         {
            this.inputVisible = false;
         }
         else
         {
            this.inputVisible = true;
            this.input.setFocus();
         }
         this.transparentChange();
      }
      
      private function onCancel() : void
      {
         if(!this.input.getFocus())
         {
            return;
         }
         if(this.input.text.length > 0)
         {
            this.input.text = "";
         }
         else
         {
            this.inputVisible = false;
         }
         this.transparentChange();
      }
      
      private function onTab() : void
      {
         var newList:Vector.<String> = this.model.currentTab.getLastUniqueAuthors();
         if(!newList || userListChanged(this.currentList,newList))
         {
            this.currentList = newList;
            this.currentUserIndex = 0;
         }
         if(!this.currentList || this.currentList.length < 1)
         {
            return;
         }
         var user:String = this.currentList[this.currentUserIndex];
         this.input.clearCurrentUsers();
         this.input.userClicked(user);
         ++this.currentUserIndex;
         if(this.currentUserIndex >= this.currentList.length)
         {
            this.currentUserIndex = 0;
         }
      }
      
      private function resizeStart(e:MouseEvent) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.resizeMove);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.resizeStop);
      }
      
      private function resizeMove(e:MouseEvent) : void
      {
         this.drawResizeRect();
      }
      
      private function resizeStop(e:MouseEvent) : void
      {
         this.resizeBox.graphics.clear();
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.resizeMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.resizeStop);
         var width:Number = Math.max(this.resizeBox.mouseX,this.box.minWidth);
         this.box.width = width;
         var height:Number = Math.max(-this.resizeBox.mouseY,this.box.minHeight);
         this.box.height = height;
      }
      
      private function drawResizeRect() : void
      {
         this.resizeBox.graphics.clear();
         this.resizeBox.graphics.lineStyle(3,13421772,0.5);
         this.resizeBox.graphics.drawRect(0,0,this.resizeBox.mouseX,this.resizeBox.mouseY);
      }
      
      private function openCharClan(e:ChatEvent) : void
      {
         Interaction.showCharacterClan(e.data);
      }
      
      private function openCharMenu(e:ChatEvent) : void
      {
         var user:ChatUser = e.data;
         MenuManager.create(MenuType.CHARACTER_MENU,user.id);
      }
      
      private function textUserClicked(e:ChatEvent) : void
      {
         var u:ChatUser = null;
         if(ShortcutManager.ctrlPressed)
         {
            u = this.model.getChatUserByName(e.data);
            if(!u)
            {
               u = new ChatUser();
               u.name = e.data;
            }
            e.data = u;
            this.openCharMenu(e);
         }
         else
         {
            this.input.userClicked(e.data);
         }
      }
      
      private function send(e:Event) : void
      {
         if(this.input.text.length < 1)
         {
            return;
         }
         if(this.input.text == "test")
         {
            ServerLayer.call("testPvPStatisticService","getStatistics");
            return;
         }
         this.input.addToHistory();
         var message:ClientMessage = new ClientMessage(this.input.text,this.model.currentTab.key);
         callLater(this.clear,null);
         var ne:ChatEvent = new ChatEvent(ChatEvent.MESSAGE_SEND);
         ne.data = message;
         this.model.dispatchEvent(ne);
      }
      
      private function clear(e:Event = null) : void
      {
         this.input.text = " ";
         this.input.text = "";
      }
      
      private function toggleUsers(e:MouseEvent) : void
      {
         this.usersVisible = !this.usersVisible;
         this.settingsModel.chatUsersHidden = !this.usersVisible;
      }
      
      private function showMenu(e:MouseEvent) : void
      {
         var size:int = 0;
         var transparentAlpha:Number = NaN;
         var transparentAlphas:Array = null;
         var alpha:Number = NaN;
         var opaqueAlpha:Number = NaN;
         var opaqueAlphas:Array = null;
         var menuData:Array = null;
         var menu:Menu = null;
         var fontSize:int = this.messages.fontSize;
         var sizeItems:Array = [];
         for each(size in FONT_SIZES)
         {
            sizeItems.push({
               "type":"radio",
               "groupName":"fontSize",
               "label":size,
               "data":size,
               "toggled":fontSize == size
            });
         }
         transparentAlpha = this.settingsModel.chatTansparentAlpha;
         transparentAlphas = [];
         for each(alpha in ALPHAS)
         {
            transparentAlphas.push({
               "type":"radio",
               "groupName":"transparentAlpha",
               "label":alpha * 100 + "%",
               "data":alpha,
               "toggled":transparentAlpha == alpha
            });
         }
         opaqueAlpha = this.settingsModel.chatOpaqueAlpha;
         opaqueAlphas = [];
         for each(alpha in ALPHAS)
         {
            opaqueAlphas.push({
               "type":"radio",
               "groupName":"opaqueAlpha",
               "label":alpha * 100 + "%",
               "data":alpha,
               "toggled":opaqueAlpha == alpha
            });
         }
         menuData = [{
            "label":this.getString("chat.fontSize"),
            "children":sizeItems
         },{
            "label":this.getString("chat.enabledAlpha"),
            "children":opaqueAlphas
         },{
            "label":this.getString("chat.disabledAlpha"),
            "children":transparentAlphas
         },{
            "label":this.getString("chat.combatLog"),
            "type":"radio",
            "toggled":this.model.combatLogEnabled,
            "groupName":"combatLog"
         },{
            "label":this.getString("chat.timeStamp"),
            "type":"radio",
            "toggled":this.settingsModel.chatTimeStamp,
            "groupName":"timeStamp"
         }];
         menu = Menu.createMenu(stage,menuData);
         menu.addEventListener(MenuEvent.ITEM_CLICK,this.systemMenuClick,false,0,true);
         menu.show(stage.mouseX,stage.mouseY);
      }
      
      private function systemMenuClick(e:MenuEvent) : void
      {
         var group:String = e.item.groupName;
         if(group == "fontSize")
         {
            this.messages.fontSize = e.item.data;
         }
         else if(group == "combatLog")
         {
            this.model.dispatchEvent(new ChatEvent(ChatEvent.TOGGLE_COMBAT_LOG));
         }
         else if(group == "opaqueAlpha")
         {
            this.settingsModel.chatOpaqueAlpha = this.opaqueAlpha = e.item.data;
         }
         else if(group == "transparentAlpha")
         {
            this.settingsModel.chatTansparentAlpha = this.transparentAlpha = e.item.data;
         }
         else if(group == "timeStamp")
         {
            this.settingsModel.chatTimeStamp = !this.settingsModel.chatTimeStamp;
         }
      }
      
      private function onBoxResize(e:Event) : void
      {
         width = this.box.width;
         height = this.box.height + barSize;
         this.chatTabs.x = 34;
         this.chatTabs.y = height - barSize - 3;
         this.transparent.y = height - barSize + 4;
         this.resizer.x = width - this.resizer.width;
         this.resizeBox.y = height - barSize;
         this.corner.x = width - this.corner.width + 1;
         this.updateHoverBox();
      }
      
      private function updateHoverBox() : void
      {
         this.box.updateNow();
         this.inputHoverBox.graphics.clear();
         var ZERO:Point = new Point();
         var topLeft:Point = this.inputHoverBox.globalToLocal(this.inputBox.localToGlobal(ZERO));
         this.inputHoverBox.graphics.beginFill(16711680,0);
         this.inputHoverBox.graphics.drawRect(topLeft.x,topLeft.y,Math.min(250,this.inputBox.width),this.inputBox.height);
         this.inputHoverBox.graphics.endFill();
      }
      
      private function localeSelected() : void
      {
         var locale:String = this.localeSelector.locale;
         var ne:ChatEvent = new ChatEvent(ChatEvent.LOCALE_CHANGED);
         ne.data = locale;
         this.model.dispatchEvent(ne);
      }
      
      private function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
      
      private function _ChatScreen_ChatBorder1_i() : ChatBorder
      {
         var _loc1_:ChatBorder = new ChatBorder();
         _loc1_.width = 170;
         _loc1_.padding = 4;
         _loc1_.children = [this._ChatScreen_Box1_i(),this._ChatScreen_ScrollBase1_c()];
         this.users = _loc1_;
         BindingManager.executeBindings(this,"users",this.users);
         return _loc1_;
      }
      
      private function _ChatScreen_Box1_i() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.percentWidth = 100;
         _loc1_.height = 18;
         _loc1_.backgroundColor = 1;
         _loc1_.backgroundAlpha = 0.3;
         _loc1_.children = [this._ChatScreen_Box2_c(),this._ChatScreen_Box3_c()];
         this._ChatScreen_Box1 = _loc1_;
         BindingManager.executeBindings(this,"_ChatScreen_Box1",this._ChatScreen_Box1);
         return _loc1_;
      }
      
      private function _ChatScreen_Box2_c() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.width = 50;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._ChatScreen_Label1_i(),this._ChatScreen_CachedImage1_i()];
         _loc1_.addEventListener("click",this.___ChatScreen_Box2_click);
         return _loc1_;
      }
      
      private function _ChatScreen_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         this._ChatScreen_Label1 = _loc1_;
         BindingManager.executeBindings(this,"_ChatScreen_Label1",this._ChatScreen_Label1);
         return _loc1_;
      }
      
      private function _ChatScreen_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._ChatScreen_CachedImage1 = _loc1_;
         BindingManager.executeBindings(this,"_ChatScreen_CachedImage1",this._ChatScreen_CachedImage1);
         return _loc1_;
      }
      
      public function ___ChatScreen_Box2_click(event:MouseEvent) : void
      {
         this.sortBy("level");
      }
      
      private function _ChatScreen_Box3_c() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.horizontalAlign = "center";
         _loc1_.verticalAlign = "middle";
         _loc1_.children = [this._ChatScreen_CachedImage2_i()];
         _loc1_.addEventListener("click",this.___ChatScreen_Box3_click);
         return _loc1_;
      }
      
      private function _ChatScreen_CachedImage2_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this._ChatScreen_CachedImage2 = _loc1_;
         BindingManager.executeBindings(this,"_ChatScreen_CachedImage2",this._ChatScreen_CachedImage2);
         return _loc1_;
      }
      
      public function ___ChatScreen_Box3_click(event:MouseEvent) : void
      {
         this.sortBy("name");
      }
      
      private function _ChatScreen_ScrollBase1_c() : ScrollBase
      {
         var _loc1_:ScrollBase = new ScrollBase();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.children = [this._ChatScreen_ChatUsers1_i()];
         return _loc1_;
      }
      
      private function _ChatScreen_ChatUsers1_i() : ChatUsers
      {
         var _loc1_:ChatUsers = new ChatUsers();
         this.userList = _loc1_;
         BindingManager.executeBindings(this,"userList",this.userList);
         return _loc1_;
      }
      
      private function _ChatScreen_ChatTabs1_i() : ChatTabs
      {
         var _loc1_:ChatTabs = new ChatTabs();
         this.chatTabs = _loc1_;
         BindingManager.executeBindings(this,"chatTabs",this.chatTabs);
         return _loc1_;
      }
      
      private function _ChatScreen_ChatBorder2_i() : ChatBorder
      {
         var _loc1_:ChatBorder = new ChatBorder();
         _loc1_.padding = 7;
         _loc1_.backgroundPadding = 1;
         _loc1_.gap = 4;
         _loc1_.minWidth = 290;
         _loc1_.minHeight = 100;
         _loc1_.width = 450;
         _loc1_.height = 200;
         _loc1_.mouseEnabled = false;
         _loc1_.children = [this._ChatScreen_ChatField1_i(),this._ChatScreen_Box4_i()];
         this.box = _loc1_;
         BindingManager.executeBindings(this,"box",this.box);
         return _loc1_;
      }
      
      private function _ChatScreen_ChatField1_i() : ChatField
      {
         var _loc1_:ChatField = new ChatField();
         _loc1_.minWidth = 10;
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         this.messages = _loc1_;
         BindingManager.executeBindings(this,"messages",this.messages);
         return _loc1_;
      }
      
      private function _ChatScreen_Box4_i() : Box
      {
         var _loc1_:Box = new Box();
         _loc1_.percentWidth = 100;
         _loc1_.height = 24;
         _loc1_.verticalAlign = "middle";
         _loc1_.gap = 5;
         _loc1_.children = [this._ChatScreen_ChatInput1_i(),this._ChatScreen_CachedImage3_i(),this._ChatScreen_CachedImage4_i(),this._ChatScreen_CachedImage5_i(),this._ChatScreen_ChatLanguageSelector1_i(),this._ChatScreen_CachedImage6_i()];
         this.inputBox = _loc1_;
         BindingManager.executeBindings(this,"inputBox",this.inputBox);
         return _loc1_;
      }
      
      private function _ChatScreen_ChatInput1_i() : ChatInput
      {
         var _loc1_:ChatInput = new ChatInput();
         _loc1_.percentWidth = 100;
         _loc1_.height = 22;
         _loc1_.verticalAlign = "middle";
         _loc1_.maxChars = 200;
         this.input = _loc1_;
         BindingManager.executeBindings(this,"input",this.input);
         return _loc1_;
      }
      
      private function _ChatScreen_CachedImage3_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.sendButton = _loc1_;
         BindingManager.executeBindings(this,"sendButton",this.sendButton);
         return _loc1_;
      }
      
      private function _ChatScreen_CachedImage4_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.clearButton = _loc1_;
         BindingManager.executeBindings(this,"clearButton",this.clearButton);
         return _loc1_;
      }
      
      private function _ChatScreen_CachedImage5_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.menuButton = _loc1_;
         BindingManager.executeBindings(this,"menuButton",this.menuButton);
         return _loc1_;
      }
      
      private function _ChatScreen_ChatLanguageSelector1_i() : ChatLanguageSelector
      {
         var _loc1_:ChatLanguageSelector = new ChatLanguageSelector();
         _loc1_.addEventListener("change",this.__localeSelector_change);
         this.localeSelector = _loc1_;
         BindingManager.executeBindings(this,"localeSelector",this.localeSelector);
         return _loc1_;
      }
      
      public function __localeSelector_change(event:Event) : void
      {
         this.localeSelected();
      }
      
      private function _ChatScreen_CachedImage6_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.userButton = _loc1_;
         BindingManager.executeBindings(this,"userButton",this.userButton);
         return _loc1_;
      }
      
      private function _ChatScreen_HideButton1_i() : HideButton
      {
         var _loc1_:HideButton = new HideButton();
         _loc1_.selected = true;
         _loc1_.addEventListener("change",this.__transparent_change);
         this.transparent = _loc1_;
         BindingManager.executeBindings(this,"transparent",this.transparent);
         return _loc1_;
      }
      
      public function __transparent_change(event:Event) : void
      {
         this.transparentChange();
      }
      
      private function _ChatScreen_CachedImage7_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         this.corner = _loc1_;
         BindingManager.executeBindings(this,"corner",this.corner);
         return _loc1_;
      }
      
      private function _ChatScreen_Component1_i() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.addEventListener("rollOver",this.__resizer_rollOver);
         _loc1_.addEventListener("rollOut",this.__resizer_rollOut);
         this.resizer = _loc1_;
         BindingManager.executeBindings(this,"resizer",this.resizer);
         return _loc1_;
      }
      
      public function __resizer_rollOver(event:MouseEvent) : void
      {
         Mouse.cursor = MouseCursor.HAND;
      }
      
      public function __resizer_rollOut(event:MouseEvent) : void
      {
         Mouse.cursor = MouseCursor.AUTO;
      }
      
      private function _ChatScreen_Component2_i() : Component
      {
         var _loc1_:Component = new Component();
         this.resizeBox = _loc1_;
         BindingManager.executeBindings(this,"resizeBox",this.resizeBox);
         return _loc1_;
      }
      
      private function _ChatScreen_Component3_i() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.addEventListener("rollOver",this.__inputHoverBox_rollOver);
         _loc1_.addEventListener("rollOut",this.__inputHoverBox_rollOut);
         _loc1_.addEventListener("click",this.__inputHoverBox_click);
         this.inputHoverBox = _loc1_;
         BindingManager.executeBindings(this,"inputHoverBox",this.inputHoverBox);
         return _loc1_;
      }
      
      public function __inputHoverBox_rollOver(event:MouseEvent) : void
      {
         this.inputHover = true;
      }
      
      public function __inputHoverBox_rollOut(event:MouseEvent) : void
      {
         this.inputHover = false;
      }
      
      public function __inputHoverBox_click(event:MouseEvent) : void
      {
         this.onEnter();
      }
      
      public function ___ChatScreen_Container1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      private function _ChatScreen_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Number
         {
            return box.width - 2;
         },null,"users.x");
         result[1] = new Binding(this,function():Number
         {
            return box.height;
         },null,"users.height");
         result[2] = new Binding(this,function():Boolean
         {
            return !transparent.selected && usersVisible;
         },null,"users.visible");
         result[3] = new Binding(this,function():Number
         {
            return transparent.selected ? transparentAlpha : opaqueAlpha;
         },null,"users.borderAlpha");
         result[4] = new Binding(this,function():Number
         {
            return box.width - 2;
         },null,"_ChatScreen_Box1.x");
         result[5] = new Binding(this,function():String
         {
            var _loc1_:* = int(model.currentTab.users.length);
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_ChatScreen_Label1.text");
         result[6] = new Binding(this,function():Object
         {
            return Icons.chatSort;
         },null,"_ChatScreen_CachedImage1.source");
         result[7] = new Binding(this,function():Object
         {
            return Icons.chatSort;
         },null,"_ChatScreen_CachedImage2.source");
         result[8] = new Binding(this,function():Array
         {
            var _loc1_:* = model.currentTab.users;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"userList.dataProvider");
         result[9] = new Binding(this,null,null,"chatTabs.model","model");
         result[10] = new Binding(this,function():Boolean
         {
            return transparent.selected;
         },null,"chatTabs.transparent");
         result[11] = new Binding(this,function():Boolean
         {
            return transparent.selected;
         },null,"box.transparent");
         result[12] = new Binding(this,function():Number
         {
            return transparent.selected ? transparentAlpha : opaqueAlpha;
         },null,"box.borderAlpha");
         result[13] = new Binding(this,function():String
         {
            var _loc1_:* = model.currentMessages;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"messages.htmlText");
         result[14] = new Binding(this,function():Boolean
         {
            return transparent.selected;
         },null,"messages.transparent");
         result[15] = new Binding(this,function():Boolean
         {
            return inputVisible || inputHover || !transparent.selected;
         },null,"inputBox.visible");
         result[16] = new Binding(this,function():Array
         {
            var _loc1_:* = model.currentTab.users;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"input.chatUsers");
         result[17] = new Binding(this,function():Object
         {
            return Icons.chatSend;
         },null,"sendButton.source");
         result[18] = new Binding(this,function():Object
         {
            return Icons.chatClear;
         },null,"clearButton.source");
         result[19] = new Binding(this,function():Object
         {
            return Icons.chatMenu;
         },null,"menuButton.source");
         result[20] = new Binding(this,function():Array
         {
            var _loc1_:* = model.languages;
            return _loc1_ == null || _loc1_ is Array || _loc1_ is Proxy ? _loc1_ : [_loc1_];
         },null,"localeSelector.locales");
         result[21] = new Binding(this,function():String
         {
            var _loc1_:* = model.currentLanguage;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"localeSelector.locale");
         result[22] = new Binding(this,function():String
         {
            var _loc1_:* = getString("select.language");
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"localeSelector.toolTip");
         result[23] = new Binding(this,function():Object
         {
            return Icons.chatUsers;
         },null,"userButton.source");
         result[24] = new Binding(this,function():Object
         {
            return Assets.chatCorner;
         },null,"corner.source");
         result[25] = new Binding(this,function():Boolean
         {
            return !transparent.selected;
         },null,"corner.visible");
         result[26] = new Binding(this,function():Boolean
         {
            return !transparent.selected;
         },null,"resizer.visible");
         result[27] = new Binding(this,function():Boolean
         {
            return !inputVisible && transparent.selected;
         },null,"inputHoverBox.visible");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get box() : ChatBorder
      {
         return this._97739box;
      }
      
      public function set box(param1:ChatBorder) : void
      {
         var _loc2_:Object = this._97739box;
         if(_loc2_ !== param1)
         {
            this._97739box = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"box",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get chatTabs() : ChatTabs
      {
         return this._1437388534chatTabs;
      }
      
      public function set chatTabs(param1:ChatTabs) : void
      {
         var _loc2_:Object = this._1437388534chatTabs;
         if(_loc2_ !== param1)
         {
            this._1437388534chatTabs = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatTabs",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clearButton() : CachedImage
      {
         return this._2071192609clearButton;
      }
      
      public function set clearButton(param1:CachedImage) : void
      {
         var _loc2_:Object = this._2071192609clearButton;
         if(_loc2_ !== param1)
         {
            this._2071192609clearButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clearButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get corner() : CachedImage
      {
         return this._1354665387corner;
      }
      
      public function set corner(param1:CachedImage) : void
      {
         var _loc2_:Object = this._1354665387corner;
         if(_loc2_ !== param1)
         {
            this._1354665387corner = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"corner",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get input() : ChatInput
      {
         return this._100358090input;
      }
      
      public function set input(param1:ChatInput) : void
      {
         var _loc2_:Object = this._100358090input;
         if(_loc2_ !== param1)
         {
            this._100358090input = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"input",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get inputBox() : Box
      {
         return this._470688161inputBox;
      }
      
      public function set inputBox(param1:Box) : void
      {
         var _loc2_:Object = this._470688161inputBox;
         if(_loc2_ !== param1)
         {
            this._470688161inputBox = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inputBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get inputHoverBox() : Component
      {
         return this._284964057inputHoverBox;
      }
      
      public function set inputHoverBox(param1:Component) : void
      {
         var _loc2_:Object = this._284964057inputHoverBox;
         if(_loc2_ !== param1)
         {
            this._284964057inputHoverBox = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inputHoverBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get localeSelector() : ChatLanguageSelector
      {
         return this._241734567localeSelector;
      }
      
      public function set localeSelector(param1:ChatLanguageSelector) : void
      {
         var _loc2_:Object = this._241734567localeSelector;
         if(_loc2_ !== param1)
         {
            this._241734567localeSelector = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"localeSelector",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get menuButton() : CachedImage
      {
         return this._913939087menuButton;
      }
      
      public function set menuButton(param1:CachedImage) : void
      {
         var _loc2_:Object = this._913939087menuButton;
         if(_loc2_ !== param1)
         {
            this._913939087menuButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"menuButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get messages() : ChatField
      {
         return this._462094004messages;
      }
      
      public function set messages(param1:ChatField) : void
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
      public function get resizeBox() : Component
      {
         return this._2144320631resizeBox;
      }
      
      public function set resizeBox(param1:Component) : void
      {
         var _loc2_:Object = this._2144320631resizeBox;
         if(_loc2_ !== param1)
         {
            this._2144320631resizeBox = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"resizeBox",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get resizer() : Component
      {
         return this._1097202238resizer;
      }
      
      public function set resizer(param1:Component) : void
      {
         var _loc2_:Object = this._1097202238resizer;
         if(_loc2_ !== param1)
         {
            this._1097202238resizer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"resizer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get sendButton() : CachedImage
      {
         return this._713510sendButton;
      }
      
      public function set sendButton(param1:CachedImage) : void
      {
         var _loc2_:Object = this._713510sendButton;
         if(_loc2_ !== param1)
         {
            this._713510sendButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sendButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get transparent() : HideButton
      {
         return this._1726194350transparent;
      }
      
      public function set transparent(param1:HideButton) : void
      {
         var _loc2_:Object = this._1726194350transparent;
         if(_loc2_ !== param1)
         {
            this._1726194350transparent = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"transparent",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get userButton() : CachedImage
      {
         return this._1106426589userButton;
      }
      
      public function set userButton(param1:CachedImage) : void
      {
         var _loc2_:Object = this._1106426589userButton;
         if(_loc2_ !== param1)
         {
            this._1106426589userButton = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userButton",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get userList() : ChatUsers
      {
         return this._266718455userList;
      }
      
      public function set userList(param1:ChatUsers) : void
      {
         var _loc2_:Object = this._266718455userList;
         if(_loc2_ !== param1)
         {
            this._266718455userList = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userList",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get users() : ChatBorder
      {
         return this._111578632users;
      }
      
      public function set users(param1:ChatBorder) : void
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
      
      [Bindable(event="propertyChange")]
      private function get usersVisible() : Boolean
      {
         return this._141450934usersVisible;
      }
      
      private function set usersVisible(param1:Boolean) : void
      {
         var _loc2_:Object = this._141450934usersVisible;
         if(_loc2_ !== param1)
         {
            this._141450934usersVisible = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"usersVisible",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get inputVisible() : Boolean
      {
         return this._1453111624inputVisible;
      }
      
      private function set inputVisible(param1:Boolean) : void
      {
         var _loc2_:Object = this._1453111624inputVisible;
         if(_loc2_ !== param1)
         {
            this._1453111624inputVisible = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inputVisible",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get inputHover() : Boolean
      {
         return this._1365299090inputHover;
      }
      
      private function set inputHover(param1:Boolean) : void
      {
         var _loc2_:Object = this._1365299090inputHover;
         if(_loc2_ !== param1)
         {
            this._1365299090inputHover = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inputHover",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get opaqueAlpha() : Number
      {
         return this._1425484221opaqueAlpha;
      }
      
      private function set opaqueAlpha(param1:Number) : void
      {
         var _loc2_:Object = this._1425484221opaqueAlpha;
         if(_loc2_ !== param1)
         {
            this._1425484221opaqueAlpha = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"opaqueAlpha",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get transparentAlpha() : Number
      {
         return this._87431380transparentAlpha;
      }
      
      private function set transparentAlpha(param1:Number) : void
      {
         var _loc2_:Object = this._87431380transparentAlpha;
         if(_loc2_ !== param1)
         {
            this._87431380transparentAlpha = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"transparentAlpha",_loc2_,param1));
            }
         }
      }
   }
}

