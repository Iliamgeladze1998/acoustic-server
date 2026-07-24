package soul.controller
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.FullScreenEvent;
   import soul.controller.astral.AstralManager;
   import soul.controller.character.CharacterManager;
   import soul.controller.chat.ChatManager;
   import soul.controller.cooldown.CooldownManager;
   import soul.controller.group.GroupManager;
   import soul.controller.interaction.AchievementManager;
   import soul.controller.interaction.ArenaManager;
   import soul.controller.interaction.AuctionManager;
   import soul.controller.interaction.BarterManager;
   import soul.controller.interaction.ClanManager;
   import soul.controller.interaction.DashboardManager;
   import soul.controller.interaction.InventoryManager;
   import soul.controller.interaction.LFGManager;
   import soul.controller.interaction.MailManager;
   import soul.controller.interaction.QuestManager;
   import soul.controller.interaction.SocialManager;
   import soul.controller.loading.LoadingManager;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.controller.rtm.RTMManager;
   import soul.controller.shortcut.Shortcut;
   import soul.controller.shortcut.ShortcutManager;
   import soul.event.FieldEvent;
   import soul.event.GameEvent;
   import soul.model.GameMode;
   import soul.model.GameModel;
   import soul.model.character.CharacterData;
   import soul.model.common.InteractionType;
   import soul.model.common.ShortMessage;
   import soul.model.interaction.dashboard.BattlegroundStatistics;
   import soul.model.interaction.resurrection.ResurrectionData;
   import soul.model.system.Configuration;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   import soul.view.GameScreen;
   import soul.view.popups.MessageManager;
   
   public class GameManager extends EventDispatcher implements IManager
   {
      
      private var container:DisplayObjectContainer;
      
      private var model:GameModel;
      
      private var view:GameScreen;
      
      private var characterManager:CharacterManager;
      
      private var chatManager:ChatManager;
      
      private var inventoryManager:InventoryManager;
      
      private var auctionManager:AuctionManager;
      
      private var mailManager:MailManager;
      
      private var groupManager:GroupManager;
      
      private var arenaManager:ArenaManager;
      
      private var rtmManager:RTMManager;
      
      private var astralManager:AstralManager;
      
      private var cooldownManager:CooldownManager;
      
      private var questManager:QuestManager;
      
      private var socialManager:SocialManager;
      
      private var clanManager:ClanManager;
      
      private var dashboardManager:DashboardManager;
      
      private var barterManager:BarterManager;
      
      private var achievementManager:AchievementManager;
      
      private var combatManager:CombatManager;
      
      private var lfgManager:LFGManager;
      
      public function GameManager(container:DisplayObjectContainer)
      {
         super();
         this.container = container;
         ComponentLocator.setComponent(ComponentLocator.GAME,this);
         this.model = new GameModel();
         this.view = new GameScreen();
         container.addChild(this.view);
         this.view.model = this.model;
         MessageManager.init(this.view.stage,this.model);
         Interaction.init(this.view.stage,this.model);
         MenuManager.init(this.view.stage,this.model);
         LogManager.init(this.view.rtmScreen.errorContainer);
         this.model.addEventListener(GameEvent.USER_LOGOUT,this.userLogout);
         this.model.addEventListener(GameEvent.CHARACTER_LOGOUT,this.characterLogout);
         LoadingManager.action = LocaleManager.getString(BundleName.SYSTEM,"loadingCharacter");
         LoadingManager.tip = LocaleManager.getRandomTip();
         ServerLayer.call("gameService",ComponentLocator.READY);
         this.characterManager = new CharacterManager(this.model.characterModel);
         this.inventoryManager = new InventoryManager(this.model.inventoryModel);
         this.auctionManager = new AuctionManager(this.model.auctionModel);
         this.mailManager = new MailManager(this.model.mailModel);
         this.questManager = new QuestManager(this.model.questModel);
         this.groupManager = new GroupManager(this.model.groupModel);
         this.arenaManager = new ArenaManager(this.model.arenaModel);
         this.cooldownManager = new CooldownManager(this.model.cooldownModel);
         this.socialManager = new SocialManager(this.model.socialModel);
         this.clanManager = new ClanManager(this.model.clanModel,this.model.characterModel,this.model.inventoryModel);
         this.chatManager = new ChatManager(this.view.chatScreen,this.model);
         this.dashboardManager = new DashboardManager(this.model.dashboardModel);
         this.barterManager = new BarterManager(this.model.barterModel,this.model.inventoryModel);
         this.achievementManager = new AchievementManager(this.model.achievementModel);
         this.combatManager = new CombatManager(this.model);
         this.lfgManager = new LFGManager(this.model.lfgModel);
         ShortcutManager.addShortcutListener(Shortcut.ALT_ENTER,this.switchFullScreen);
         this.model.settingsModel.addEventListener(GameEvent.SWITCH_FULLSCREEN,this.switchFullScreen);
         container.stage.addEventListener(FullScreenEvent.FULL_SCREEN,this.fullScreenChanged);
         this.applyFulLScreenToModel();
      }
      
      public function reset() : void
      {
         ComponentLocator.reset();
         MessageManager.reset();
         Interaction.reset();
         LogManager.reset();
         this.model.removeEventListener(GameEvent.USER_LOGOUT,this.userLogout);
         this.model.removeEventListener(GameEvent.CHARACTER_LOGOUT,this.characterLogout);
         this.container.removeChild(this.view);
         this.view = null;
         this.characterManager.reset();
         this.inventoryManager.reset();
         this.auctionManager.reset();
         this.groupManager.reset();
         this.chatManager.reset();
         this.dashboardManager.reset();
         ShortcutManager.removeShortcutListener(Shortcut.ALT_ENTER,this.switchFullScreen);
         this.model.settingsModel.removeEventListener(GameEvent.SWITCH_FULLSCREEN,this.switchFullScreen);
         this.container.stage.removeEventListener(FullScreenEvent.FULL_SCREEN,this.fullScreenChanged);
      }
      
      private function switchFullScreen(e:Event) : void
      {
         var stage:Stage = this.container.stage;
         if(stage.allowsFullScreen)
         {
            stage.displayState = stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE ? StageDisplayState.NORMAL : StageDisplayState.FULL_SCREEN_INTERACTIVE;
         }
         this.applyFulLScreenToModel();
      }
      
      private function fullScreenChanged(e:FullScreenEvent) : void
      {
         this.applyFulLScreenToModel();
      }
      
      private function applyFulLScreenToModel() : void
      {
         this.model.settingsModel.fullScreen = this.container.stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE;
         this.model.settingsModel.fullScreenAllowed = this.container.stage.allowsFullScreen;
      }
      
      private function characterLogout(e:Event) : void
      {
         trace("GameManager.characterLogout()");
         ServerLayer.unregisterCharacter(this.logoutConfirm);
      }
      
      private function logoutConfirm(r:* = null) : void
      {
         dispatchEvent(new Event(GameEvent.CHARACTER_LOGOUT));
      }
      
      private function userLogout(e:Event) : void
      {
         trace("GameManager.userLogout()");
         ServerLayer.unregisterCharacter(this.exitConfirm);
      }
      
      private function exitConfirm(r:* = null) : void
      {
         dispatchEvent(new Event(GameEvent.USER_LOGOUT));
      }
      
      public function init(gameData:CharacterData) : void
      {
         var msg:ShortMessage = null;
         LoadingManager.hide();
         this.loadGameData(gameData);
         this.rtmManager = new RTMManager(this.model,this.view.rtmScreen);
         this.model.astralModel.myId = this.model.characterModel.id;
         this.model.astralModel.myName = this.model.characterModel.name;
         this.astralManager = new AstralManager(this.view.astralScreen,this.model.astralModel);
         this.changeMode(gameData.mode);
         for each(msg in gameData.messages)
         {
            this.showMessage(msg);
         }
         if(Boolean(gameData.interaction))
         {
            Interaction.serverShow(gameData.interaction,true);
         }
         if(Boolean(gameData.resurrection))
         {
            Interaction.showResurrection(gameData.resurrection);
         }
      }
      
      public function loadGameData(gameData:CharacterData) : void
      {
         this.model.load(gameData);
         Configuration.portalId = gameData.portalId;
      }
      
      public function showInteraction(interactionType:String, modal:Boolean = false) : void
      {
         Interaction.serverShow(interactionType,modal);
      }
      
      public function closeInteraction() : void
      {
         Interaction.serverHide();
      }
      
      public function showMessage(msg:ShortMessage) : void
      {
         MessageManager.addMessage(msg);
      }
      
      public function closeMessage(messageId:String) : void
      {
         MessageManager.closeMessage(messageId);
      }
      
      public function showStatistics(stats:BattlegroundStatistics) : void
      {
         Interaction.show(InteractionType.STATS,false,stats);
      }
      
      public function resurrectionDialog(data:ResurrectionData) : void
      {
         Interaction.showResurrection(data);
      }
      
      public function updateAbilityBook(abilities:Array) : void
      {
         this.model.abilityModel.updateAbilityBook(abilities);
      }
      
      public function updateAbilityCache(cache:Array) : void
      {
         this.model.abilityModel.updateCache(cache);
      }
      
      public function changeMode(mode:String) : void
      {
         this.model.mode = mode;
         if(mode == GameMode.ASTRAL)
         {
            this.astralManager.show();
            this.rtmManager.hide();
            this.model.rtmModel.dispatchEvent(new FieldEvent(FieldEvent.CLEAN_STICKS));
         }
         else
         {
            this.astralManager.hide();
            this.rtmManager.show();
         }
      }
   }
}

