package soul.controller
{
   import flash.display.DisplayObjectContainer;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.event.BarterEvent;
   import soul.event.ChatEvent;
   import soul.event.CloseEvent;
   import soul.event.FieldEvent;
   import soul.event.GroupEvent;
   import soul.event.MenuEvent;
   import soul.event.RTMEvent;
   import soul.event.SocialEvent;
   import soul.model.GameModel;
   import soul.model.chat.ChatUser;
   import soul.model.common.MenuType;
   import soul.model.field.BaseUnit;
   import soul.model.group.GroupMember;
   import soul.model.group.LootMiningType;
   import soul.model.interaction.social.SocialListType;
   import soul.view.ui.controls.Alert;
   import soul.view.ui.controls.menu.Menu;
   
   public class MenuManager
   {
      
      private static var container:DisplayObjectContainer;
      
      private static var model:GameModel;
      
      public function MenuManager()
      {
         super();
      }
      
      public static function init(container:DisplayObjectContainer, model:GameModel) : void
      {
         MenuManager.container = container;
         MenuManager.model = model;
      }
      
      public static function create(type:String, ... args) : Menu
      {
         var menu:Menu = null;
         switch(type)
         {
            case MenuType.SELF_MENU:
               menu = createSelfMenu();
               break;
            case MenuType.CHARACTER_MENU:
               menu = createCharacterMenu(args);
         }
         if(Boolean(menu))
         {
            menu.show(container.mouseX,container.mouseY);
         }
         return menu;
      }
      
      private static function createSelfMenu() : Menu
      {
         var lootEnabled:Boolean = model.groupModel.leader || model.groupModel.members.length < 2;
         var menuData:Array = [{
            "label":getString("party.lootType"),
            "children":[{
               "label":getString(LootMiningType.LEADER),
               "type":"radio",
               "groupName":"lootType",
               "data":"changeLootType",
               "data2":LootMiningType.LEADER,
               "toggled":model.groupModel.lootMiningType == LootMiningType.LEADER,
               "enabled":lootEnabled
            },{
               "label":getString(LootMiningType.QUEUE),
               "type":"radio",
               "groupName":"lootType",
               "data":"changeLootType",
               "data2":LootMiningType.QUEUE,
               "toggled":model.groupModel.lootMiningType == LootMiningType.QUEUE,
               "enabled":lootEnabled
            },{
               "label":getString(LootMiningType.PARTY),
               "type":"radio",
               "groupName":"lootType",
               "data":"changeLootType",
               "data2":LootMiningType.PARTY,
               "toggled":model.groupModel.lootMiningType == LootMiningType.PARTY,
               "enabled":lootEnabled
            }]
         }];
         if(Boolean(model.groupModel.members) && model.groupModel.members.length > 1)
         {
            menuData.push({
               "label":getString("party.leave"),
               "data":"leave"
            });
         }
         var menu:Menu = Menu.createMenu(container,menuData);
         menu.addEventListener(MenuEvent.ITEM_CLICK,selectSelfMenu);
         return menu;
      }
      
      private static function selectSelfMenu(e:MenuEvent) : void
      {
         var ge:GroupEvent = null;
         switch(e.item.data)
         {
            case "changeLootType":
               ge = new GroupEvent(GroupEvent.LOOT_MINING,false);
               ge.data = e.item.data2;
               model.groupModel.dispatchEvent(ge);
               break;
            case "leave":
               Alert.show(getString("party.leave.confirm"),"",Alert.YES | Alert.NO,null,leaveConfirm);
         }
      }
      
      private static function leaveConfirm(e:CloseEvent) : void
      {
         if(e.detail != Alert.YES)
         {
            return;
         }
         var unit:BaseUnit = model.characterModel.myUnit;
         if(!unit)
         {
            return;
         }
         var ge:GroupEvent = new GroupEvent(GroupEvent.REMOVE,false);
         ge.data = unit.id;
         model.groupModel.dispatchEvent(ge);
      }
      
      private static function createCharacterMenu(args:Array) : Menu
      {
         var user:MenuUser = null;
         var isFriend:Boolean = false;
         var isEnemey:Boolean = false;
         var isIgnored:Boolean = false;
         var characterId:String = args[0];
         var calledFromTargetFrame:Boolean = Boolean(args[1]);
         var calledFromFieldOrTarget:Boolean = Boolean(args[2]);
         if(!characterId)
         {
            return null;
         }
         var itsMe:Boolean = characterId == model.characterModel.id;
         var canBeTraded:Boolean = true;
         var leader:Boolean = model.groupModel.leader;
         var members:uint = model.groupModel.members.length;
         var chatUser:ChatUser = model.chatModel.getChatUserById(characterId);
         var groupMember:GroupMember = model.groupModel.getMemberById(characterId);
         if(Boolean(chatUser))
         {
            user = new MenuUser().loadFromChat(chatUser);
         }
         else if(Boolean(groupMember))
         {
            user = new MenuUser().loadFromGroup(groupMember);
         }
         var menuData:Array = [{
            "label":getString("party.info"),
            "data":"info",
            "characterId":characterId
         }];
         if(Boolean(user))
         {
            menuData.push({
               "label":getString("chat.insert"),
               "data":"insert",
               "characterName":user.name
            });
            if(!itsMe)
            {
               if(calledFromFieldOrTarget)
               {
                  menuData.push({
                     "label":getString("target_stick"),
                     "data":"stick",
                     "characterId":characterId
                  });
               }
               if(leader)
               {
                  if(groupMember != null)
                  {
                     menuData.push({
                        "label":getString("party.kick"),
                        "characterId":characterId,
                        "data":"kick"
                     });
                     if(groupMember.online)
                     {
                        menuData.push({
                           "label":getString("party.promote"),
                           "characterId":characterId,
                           "data":"promote"
                        });
                     }
                  }
                  else if(members < model.groupModel.memberCountMax)
                  {
                     menuData.push({
                        "label":getString("party.invite"),
                        "characterName":user.name,
                        "data":"invite"
                     });
                  }
               }
               isFriend = model.socialModel.isFriend(characterId);
               isEnemey = model.socialModel.isEnemy(characterId);
               isIgnored = model.socialModel.isIgnored(characterId);
               if(canBeTraded)
               {
                  menuData = menuData.concat({
                     "label":getString("barter.invite"),
                     "data":"barter",
                     "characterId":characterId
                  });
               }
               menuData = menuData.concat([{
                  "label":getString("duel.call"),
                  "data":"duel",
                  "characterId":characterId
               },{
                  "label":getString("social.title"),
                  "children":[{
                     "label":getString("social.addFriend"),
                     "type":"radio",
                     "data":"friend",
                     "characterName":user.name,
                     "enabled":!isIgnored && !isFriend && !isEnemey,
                     "toggled":isFriend
                  },{
                     "label":getString("social.addEnemy"),
                     "type":"radio",
                     "data":"enemy",
                     "characterName":user.name,
                     "enabled":!isEnemey && !isFriend,
                     "toggled":isEnemey
                  },{
                     "label":getString("social.addIgnore"),
                     "type":"radio",
                     "data":"ignore",
                     "characterName":user.name,
                     "enabled":!isIgnored && !isFriend,
                     "toggled":isIgnored
                  }]
               }]);
            }
         }
         if(calledFromTargetFrame)
         {
            menuData.push({
               "label":getString("close"),
               "data":"close"
            });
         }
         var menu:Menu = Menu.createMenu(container,menuData);
         menu.addEventListener(MenuEvent.ITEM_CLICK,selectCharacterMenu);
         return menu;
      }
      
      private static function selectCharacterMenu(e:MenuEvent) : void
      {
         var characterId:String = null;
         var ge:GroupEvent = null;
         var se:SocialEvent = null;
         var ce:ChatEvent = null;
         var fe:FieldEvent = null;
         var be:BarterEvent = null;
         var kickConfirm:Function = null;
         var re:RTMEvent = null;
         var ne:FieldEvent = null;
         characterId = e.item.characterId;
         var characterName:String = e.item.characterName;
         switch(e.item.data)
         {
            case "info":
               Interaction.showCharacterInfo(characterId);
               break;
            case "insert":
               ce = new ChatEvent(ChatEvent.ADD_CHAT_RECIPIENT);
               ce.data = characterName;
               model.chatModel.dispatchEvent(ce);
               break;
            case "stick":
               fe = new FieldEvent(FieldEvent.STICK_TARGET);
               fe.data = characterId;
               model.rtmModel.dispatchEvent(fe);
               break;
            case "barter":
               be = new BarterEvent(BarterEvent.INVITE);
               be.characterId = characterId;
               model.barterModel.dispatchEvent(be);
               break;
            case "invite":
               ge = new GroupEvent(GroupEvent.INVITE,false);
               ge.data = characterName;
               model.groupModel.dispatchEvent(ge);
               break;
            case "kick":
               kickConfirm = function(e:CloseEvent):void
               {
                  if(e.detail != Alert.YES)
                  {
                     return;
                  }
                  ge = new GroupEvent(GroupEvent.REMOVE,false);
                  ge.data = characterId;
                  model.groupModel.dispatchEvent(ge);
               };
               Alert.show(getString("party.kick.confirm"),"",Alert.YES | Alert.NO,null,kickConfirm);
               break;
            case "promote":
               ge = new GroupEvent(GroupEvent.PROMOTE,false);
               ge.data = characterId;
               model.groupModel.dispatchEvent(ge);
               break;
            case "duel":
               re = new RTMEvent(RTMEvent.CALL_DUEL);
               re.id = characterId;
               model.rtmModel.dispatchEvent(re);
               break;
            case "ignore":
               se = new SocialEvent(SocialEvent.ADD);
               se.characterName = e.item.characterName;
               se.listType = SocialListType.IGNORE;
               model.socialModel.dispatchEvent(se);
               break;
            case "friend":
               se = new SocialEvent(SocialEvent.ADD);
               se.characterName = e.item.characterName;
               se.listType = SocialListType.FRIEND;
               model.socialModel.dispatchEvent(se);
               break;
            case "enemy":
               se = new SocialEvent(SocialEvent.ADD);
               se.characterName = e.item.characterName;
               se.listType = SocialListType.ENEMY;
               model.socialModel.dispatchEvent(se);
               break;
            case "close":
               ne = new FieldEvent(FieldEvent.UNSELECT_TARGET);
               model.rtmModel.dispatchEvent(ne);
         }
      }
      
      private static function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
   }
}

import soul.model.chat.ChatUser;
import soul.model.group.GroupMember;

class MenuUser
{
   
   public var id:String;
   
   public var name:String;
   
   public function MenuUser()
   {
      super();
   }
   
   public function loadFromGroup(member:GroupMember) : MenuUser
   {
      this.id = member.id;
      this.name = member.name;
      return this;
   }
   
   public function loadFromChat(user:ChatUser) : MenuUser
   {
      this.id = user.id;
      this.name = user.name;
      return this;
   }
}
