package soul.controller
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import soul.controller.dialog.DialogManager;
   import soul.controller.interaction.AcademyManager;
   import soul.controller.interaction.CraftManager;
   import soul.controller.interaction.LootManager;
   import soul.controller.interaction.ShopManager;
   import soul.model.GameModel;
   import soul.model.common.InteractionType;
   import soul.model.interaction.resurrection.ResurrectionData;
   import soul.view.AlignPosition;
   import soul.view.avatar.AvatarScreen;
   import soul.view.interaction.ability.AbilityScreen;
   import soul.view.interaction.academy.AcademyScreen;
   import soul.view.interaction.achievement.AchievementScreen;
   import soul.view.interaction.achievement.AchievementScreenExternal;
   import soul.view.interaction.arena.Arena;
   import soul.view.interaction.auction.AuctionScreen;
   import soul.view.interaction.bank.BankScreen;
   import soul.view.interaction.barter.BarterScreen;
   import soul.view.interaction.character.ExternalInfo;
   import soul.view.interaction.character.InternalInfo;
   import soul.view.interaction.clan.ClanScreen;
   import soul.view.interaction.clan.CreateClanScreen;
   import soul.view.interaction.clan.ExternalClanScreen;
   import soul.view.interaction.craft.CraftScreen;
   import soul.view.interaction.dashboard.BattlegroundStatScreen;
   import soul.view.interaction.dashboard.DashboardScreen;
   import soul.view.interaction.instance.InstanceScreen;
   import soul.view.interaction.inventory.InventoryScreen;
   import soul.view.interaction.inventory.encrust.EncrustScreen;
   import soul.view.interaction.lfg.LFGScreen;
   import soul.view.interaction.loot.LootScreen;
   import soul.view.interaction.mail.MailScreen;
   import soul.view.interaction.map.GlobalMap;
   import soul.view.interaction.map.Map;
   import soul.view.interaction.quest.QuestDialog;
   import soul.view.interaction.quest.QuestLog;
   import soul.view.interaction.resurrection.ResurrectionScreen;
   import soul.view.interaction.ruby.RubyScreen;
   import soul.view.interaction.settings.SettingsScreen;
   import soul.view.interaction.shop.ShopScreen;
   import soul.view.interaction.social.SocialScreen;
   import soul.view.interaction.talents.TalentScreen;
   import soul.view.interaction.workshop.Workshop;
   import soul.view.login.LogoutScreen;
   import soul.view.popups.InteractionWindow;
   import soul.view.ui.controls.PopupManager;
   
   public class Interaction
   {
      
      private static var container:DisplayObjectContainer;
      
      private static var model:GameModel;
      
      private static var serverInteractionType:String;
      
      private static var managers:Object = {};
      
      private static var views:Object = {};
      
      public function Interaction()
      {
         super();
      }
      
      public static function init(container:DisplayObjectContainer, model:GameModel) : void
      {
         Interaction.container = container;
         Interaction.model = model;
      }
      
      public static function reset() : void
      {
         var type:String = null;
         for(type in views)
         {
            hide(type);
         }
         managers = {};
         views = {};
         container = null;
         model = null;
      }
      
      public static function serverHide() : void
      {
         hide(serverInteractionType);
      }
      
      public static function hide(type:String) : void
      {
         var view:InteractionWindow = null;
         var manager:IManager = null;
         if(isActive(type))
         {
            view = getByType(type);
            view.destroy();
            PopupManager.removePopup(view);
            delete views[type];
            manager = managers[type];
            if(Boolean(manager))
            {
               manager.reset();
               delete managers[type];
            }
         }
      }
      
      public static function isActive(type:String) : Boolean
      {
         return views[type] != null;
      }
      
      public static function getByType(type:String) : InteractionWindow
      {
         return views[type];
      }
      
      public static function serverShow(type:String, modal:Boolean = false) : void
      {
         if(Boolean(views[type]))
         {
            hide(type);
         }
         serverInteractionType = type;
         toggle(type,modal);
      }
      
      public static function show(type:String, modal:Boolean = false, ... args) : void
      {
         if(Boolean(views[type]))
         {
            return;
         }
         var arg:Array = [type,modal].concat(args);
         toggle.apply(null,arg);
      }
      
      public static function toggle(type:String, modal:Boolean = false, ... args) : void
      {
         var view:Sprite = null;
         var manager:IManager = null;
         var interactionWindow:InteractionWindow = null;
         var inventory:InteractionWindow = null;
         if(Boolean(views[type]))
         {
            hide(type);
         }
         else
         {
            switch(type)
            {
               case InteractionType.AUCTION:
                  view = new AuctionScreen();
                  AuctionScreen(view).model = model.auctionModel;
                  AuctionScreen(view).inventoryModel = model.inventoryModel;
                  AuctionScreen(view).characterModel = model.characterModel;
                  break;
               case InteractionType.ACHIEVEMENT:
                  view = new AchievementScreen();
                  model.achievementModel.toFocus = args[0];
                  AchievementScreen(view).model = model.achievementModel;
                  break;
               case InteractionType.ACHIEVEMENT_EXTERNAL:
                  view = new AchievementScreenExternal();
                  AchievementScreenExternal(view).characterId = args[0];
                  break;
               case InteractionType.AVATARS:
                  view = new AvatarScreen();
                  break;
               case InteractionType.CHARACTER:
                  view = new InternalInfo();
                  InternalInfo(view).model = model.inventoryModel;
                  InternalInfo(view).characterModel = model.characterModel;
                  InternalInfo(view).rtmModel = model.rtmModel;
                  InternalInfo(view).clanModel = model.clanModel;
                  InternalInfo(view).achievementModel = model.achievementModel;
                  break;
               case InteractionType.BANK:
                  view = new BankScreen();
                  BankScreen(view).model = model.characterModel;
                  break;
               case InteractionType.INVENTORY:
                  view = new InventoryScreen();
                  InventoryScreen(view).model = model.inventoryModel;
                  InventoryScreen(view).shopModel = model.shopModel;
                  InventoryScreen(view).characterModel = model.characterModel;
                  break;
               case InteractionType.TALENTS:
                  view = new TalentScreen();
                  TalentScreen(view).model = model.talentsModel;
                  TalentScreen(view).characterModel = model.characterModel;
                  TalentScreen(view).abilityModel = model.abilityModel;
                  break;
               case InteractionType.ABILITIES:
                  view = new AbilityScreen();
                  AbilityScreen(view).characterModel = model.characterModel;
                  AbilityScreen(view).abilityModel = model.abilityModel;
                  break;
               case InteractionType.ARENA:
                  view = new Arena();
                  Arena(view).model = model.arenaModel;
                  break;
               case InteractionType.LOGOUT:
                  view = new LogoutScreen();
                  LogoutScreen(view).model = model;
                  modal = true;
                  break;
               case InteractionType.MAIL:
                  view = new MailScreen();
                  MailScreen(view).model = model.mailModel;
                  MailScreen(view).characterModel = model.characterModel;
                  break;
               case InteractionType.SOCIAL:
                  view = new SocialScreen();
                  SocialScreen(view).model = model.socialModel;
                  SocialScreen(view).characterModel = model.characterModel;
                  break;
               case InteractionType.CLAN:
                  if(model.clanModel.id > 0)
                  {
                     view = new ClanScreen();
                     ClanScreen(view).model = model.clanModel;
                     ClanScreen(view).characterModel = model.characterModel;
                  }
                  else
                  {
                     view = new CreateClanScreen();
                     CreateClanScreen(view).model = model.clanModel;
                     CreateClanScreen(view).characterModel = model.characterModel;
                  }
                  break;
               case InteractionType.CLAN_EXTERNAL:
                  view = new ExternalClanScreen();
                  ExternalClanScreen(view).clanId = args[0];
                  break;
               case InteractionType.RUBY:
                  view = new RubyScreen();
                  RubyScreen(view).model = model.characterModel;
                  RubyScreen(view).abilityModel = model.abilityModel;
                  RubyScreen(view).selectedTab = int(args[0]);
                  break;
               case InteractionType.LOOT:
                  view = new LootScreen();
                  manager = new LootManager(LootScreen(view),model.lootModel,model.characterModel,model.groupModel);
                  break;
               case InteractionType.SHOP:
                  view = new ShopScreen();
                  manager = new ShopManager(ShopScreen(view),model.shopModel,model.characterModel,model.inventoryModel);
                  break;
               case InteractionType.WORKSHOP:
                  view = new Workshop();
                  break;
               case InteractionType.ACADEMY:
                  view = new AcademyScreen();
                  manager = new AcademyManager(AcademyScreen(view),model.characterModel);
                  break;
               case InteractionType.CHARACTER_INFO:
                  view = new ExternalInfo();
                  ExternalInfo(view).userId = args[0];
                  break;
               case InteractionType.MAP:
                  view = new Map();
                  Map(view).model = model.rtmModel;
                  Map(view).groupModel = model.groupModel;
                  Map(view).characterModel = model.characterModel;
                  break;
               case InteractionType.WORLD_MAP:
                  view = new GlobalMap();
                  break;
               case InteractionType.DIALOG:
                  view = new QuestDialog();
                  manager = new DialogManager(QuestDialog(view));
                  break;
               case InteractionType.QUESTS:
                  view = new QuestLog();
                  QuestLog(view).model = model.questModel;
                  model.questModel.selectedTab = Boolean(args[0]) ? 2 : 0;
                  break;
               case InteractionType.INSTANCE:
                  view = new InstanceScreen();
                  InstanceScreen(view).model = model.characterModel;
                  break;
               case InteractionType.LFG:
                  view = new LFGScreen();
                  LFGScreen(view).model = model.lfgModel;
                  LFGScreen(view).characterName = model.characterModel.name;
                  break;
               case InteractionType.RESURRECTION:
                  view = new ResurrectionScreen();
                  ResurrectionScreen(view).resData = args[0];
                  break;
               case InteractionType.ENCRUST:
                  view = new EncrustScreen();
                  EncrustScreen(view).model = model.inventoryModel;
                  EncrustScreen(view).item = args[0];
                  break;
               case InteractionType.DASHBOARD:
                  view = new DashboardScreen();
                  DashboardScreen(view).model = model.dashboardModel;
                  DashboardScreen(view).settingsModel = model.settingsModel;
                  break;
               case InteractionType.BARTER:
                  view = new BarterScreen();
                  BarterScreen(view).model = model.barterModel;
                  BarterScreen(view).characterModel = model.characterModel;
                  break;
               case InteractionType.SETTINGS:
                  view = new SettingsScreen();
                  SettingsScreen(view).model = model.settingsModel;
                  break;
               case InteractionType.STATS:
                  view = new BattlegroundStatScreen();
                  BattlegroundStatScreen(view).stats = args[0];
                  break;
               case InteractionType.CRAFT:
                  view = new CraftScreen();
                  CraftScreen(view).inventoryModel = model.inventoryModel;
                  manager = new CraftManager(CraftScreen(view),model.craftModel);
                  break;
               default:
                  trace("Interaction",type,"not found");
                  return;
            }
            interactionWindow = new InteractionWindow();
            interactionWindow.type = type;
            interactionWindow.modal = modal;
            interactionWindow.addChild(view);
            interactionWindow.closeButton.visible = !modal;
            views[type] = interactionWindow;
            managers[type] = manager;
            PopupManager.addPopup(interactionWindow,container,modal);
            switch(type)
            {
               case InteractionType.SHOP:
               case InteractionType.MAIL:
               case InteractionType.BARTER:
               case InteractionType.CHARACTER_INFO:
               case InteractionType.CHARACTER:
                  interactionWindow.x = 50;
                  interactionWindow.y = 50;
                  break;
               case InteractionType.INVENTORY:
                  PopupManager.align(interactionWindow,new AlignPosition(NaN,120,50));
                  break;
               default:
                  PopupManager.centerPopup(interactionWindow);
            }
            if(type == InteractionType.SHOP || type == InteractionType.BARTER)
            {
               inventory = getByType(InteractionType.INVENTORY);
               if(!inventory)
               {
                  toggle(InteractionType.INVENTORY);
               }
            }
         }
      }
      
      public static function showCharacterInfo(characterId:String) : void
      {
         hide(InteractionType.CHARACTER_INFO);
         show(InteractionType.CHARACTER_INFO,false,characterId);
      }
      
      public static function showCharacterClan(clanId:String) : void
      {
         toggle(InteractionType.CLAN_EXTERNAL,false,clanId);
      }
      
      public static function showResurrection(data:ResurrectionData) : void
      {
         toggle(InteractionType.RESURRECTION,true,data);
      }
   }
}

