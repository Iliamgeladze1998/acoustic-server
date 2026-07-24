package soul.model
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.model.ability.AbilityModel;
   import soul.model.achievement.AchievementModel;
   import soul.model.astral.AstralModel;
   import soul.model.character.CharacterData;
   import soul.model.character.CharacterModel;
   import soul.model.chat.ChatModel;
   import soul.model.cooldown.CooldownModel;
   import soul.model.group.GroupModel;
   import soul.model.interaction.arena.ArenaModel;
   import soul.model.interaction.auction.AuctionModel;
   import soul.model.interaction.barter.BarterModel;
   import soul.model.interaction.clan.ClanModel;
   import soul.model.interaction.craft.CraftModel;
   import soul.model.interaction.dashboard.BattlegroundStatistics;
   import soul.model.interaction.dashboard.DashboardModel;
   import soul.model.interaction.lfg.LFGModel;
   import soul.model.interaction.loot.LootModel;
   import soul.model.interaction.mail.MailModel;
   import soul.model.interaction.quest.QuestModel;
   import soul.model.interaction.settings.SettingsModel;
   import soul.model.interaction.social.SocialModel;
   import soul.model.inventory.InventoryModel;
   import soul.model.location.shop.ShopModel;
   import soul.model.rtm.RTMModel;
   import soul.model.talents.TalentsModel;
   
   public class GameModel extends EventDispatcher
   {
      
      private static var instance:GameModel;
      
      private var _3357091mode:String;
      
      private var _620925754settingsModel:SettingsModel = new SettingsModel();
      
      private var _1603325617chatModel:ChatModel = new ChatModel();
      
      private var _340320640characterModel:CharacterModel = new CharacterModel();
      
      private var _1265716202groupModel:GroupModel;
      
      private var _150432670arenaModel:ArenaModel = new ArenaModel();
      
      private var _49910995inventoryModel:InventoryModel;
      
      private var _376201562auctionModel:AuctionModel = new AuctionModel();
      
      private var _325058638mailModel:MailModel = new MailModel();
      
      private var _2007003204socialModel:SocialModel = new SocialModel();
      
      private var _259260447abilityModel:AbilityModel = new AbilityModel();
      
      private var _656102814talentsModel:TalentsModel = new TalentsModel();
      
      private var _2103504510cooldownModel:CooldownModel = new CooldownModel();
      
      private var _1371024737lootModel:LootModel = new LootModel();
      
      private var _2120508973shopModel:ShopModel = new ShopModel();
      
      private var _1185874711craftModel:CraftModel = new CraftModel();
      
      private var _206201611dashboardModel:DashboardModel = new DashboardModel();
      
      private var _559427431questModel:QuestModel = new QuestModel();
      
      private var _187142541clanModel:ClanModel = new ClanModel();
      
      private var _116778114rtmModel:RTMModel = new RTMModel();
      
      private var _1625732494astralModel:AstralModel = new AstralModel();
      
      private var _1303441563barterModel:BarterModel = new BarterModel();
      
      private var _2075894074achievementModel:AchievementModel;
      
      private var _1695630084lfgModel:LFGModel = new LFGModel();
      
      private var _109757599stats:BattlegroundStatistics;
      
      public function GameModel()
      {
         this._1265716202groupModel = new GroupModel(this.characterModel);
         this._49910995inventoryModel = new InventoryModel(this.settingsModel);
         this._2075894074achievementModel = new AchievementModel(this.settingsModel);
         super();
         instance = this;
      }
      
      public static function getInstance() : GameModel
      {
         return instance;
      }
      
      public function load(data:CharacterData) : void
      {
         this.abilityModel.load(data);
         this.characterModel.load(data);
         this.chatModel.characterName = data.name;
      }
      
      [Bindable(event="propertyChange")]
      public function get mode() : String
      {
         return this._3357091mode;
      }
      
      public function set mode(param1:String) : void
      {
         var _loc2_:Object = this._3357091mode;
         if(_loc2_ !== param1)
         {
            this._3357091mode = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mode",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get settingsModel() : SettingsModel
      {
         return this._620925754settingsModel;
      }
      
      public function set settingsModel(param1:SettingsModel) : void
      {
         var _loc2_:Object = this._620925754settingsModel;
         if(_loc2_ !== param1)
         {
            this._620925754settingsModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"settingsModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get chatModel() : ChatModel
      {
         return this._1603325617chatModel;
      }
      
      public function set chatModel(param1:ChatModel) : void
      {
         var _loc2_:Object = this._1603325617chatModel;
         if(_loc2_ !== param1)
         {
            this._1603325617chatModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get characterModel() : CharacterModel
      {
         return this._340320640characterModel;
      }
      
      public function set characterModel(param1:CharacterModel) : void
      {
         var _loc2_:Object = this._340320640characterModel;
         if(_loc2_ !== param1)
         {
            this._340320640characterModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"characterModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get groupModel() : GroupModel
      {
         return this._1265716202groupModel;
      }
      
      public function set groupModel(param1:GroupModel) : void
      {
         var _loc2_:Object = this._1265716202groupModel;
         if(_loc2_ !== param1)
         {
            this._1265716202groupModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"groupModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get arenaModel() : ArenaModel
      {
         return this._150432670arenaModel;
      }
      
      public function set arenaModel(param1:ArenaModel) : void
      {
         var _loc2_:Object = this._150432670arenaModel;
         if(_loc2_ !== param1)
         {
            this._150432670arenaModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"arenaModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get inventoryModel() : InventoryModel
      {
         return this._49910995inventoryModel;
      }
      
      public function set inventoryModel(param1:InventoryModel) : void
      {
         var _loc2_:Object = this._49910995inventoryModel;
         if(_loc2_ !== param1)
         {
            this._49910995inventoryModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inventoryModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get auctionModel() : AuctionModel
      {
         return this._376201562auctionModel;
      }
      
      public function set auctionModel(param1:AuctionModel) : void
      {
         var _loc2_:Object = this._376201562auctionModel;
         if(_loc2_ !== param1)
         {
            this._376201562auctionModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"auctionModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mailModel() : MailModel
      {
         return this._325058638mailModel;
      }
      
      public function set mailModel(param1:MailModel) : void
      {
         var _loc2_:Object = this._325058638mailModel;
         if(_loc2_ !== param1)
         {
            this._325058638mailModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mailModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get socialModel() : SocialModel
      {
         return this._2007003204socialModel;
      }
      
      public function set socialModel(param1:SocialModel) : void
      {
         var _loc2_:Object = this._2007003204socialModel;
         if(_loc2_ !== param1)
         {
            this._2007003204socialModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"socialModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get abilityModel() : AbilityModel
      {
         return this._259260447abilityModel;
      }
      
      public function set abilityModel(param1:AbilityModel) : void
      {
         var _loc2_:Object = this._259260447abilityModel;
         if(_loc2_ !== param1)
         {
            this._259260447abilityModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"abilityModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get talentsModel() : TalentsModel
      {
         return this._656102814talentsModel;
      }
      
      public function set talentsModel(param1:TalentsModel) : void
      {
         var _loc2_:Object = this._656102814talentsModel;
         if(_loc2_ !== param1)
         {
            this._656102814talentsModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"talentsModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cooldownModel() : CooldownModel
      {
         return this._2103504510cooldownModel;
      }
      
      public function set cooldownModel(param1:CooldownModel) : void
      {
         var _loc2_:Object = this._2103504510cooldownModel;
         if(_loc2_ !== param1)
         {
            this._2103504510cooldownModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cooldownModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lootModel() : LootModel
      {
         return this._1371024737lootModel;
      }
      
      public function set lootModel(param1:LootModel) : void
      {
         var _loc2_:Object = this._1371024737lootModel;
         if(_loc2_ !== param1)
         {
            this._1371024737lootModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lootModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get shopModel() : ShopModel
      {
         return this._2120508973shopModel;
      }
      
      public function set shopModel(param1:ShopModel) : void
      {
         var _loc2_:Object = this._2120508973shopModel;
         if(_loc2_ !== param1)
         {
            this._2120508973shopModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"shopModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get craftModel() : CraftModel
      {
         return this._1185874711craftModel;
      }
      
      public function set craftModel(param1:CraftModel) : void
      {
         var _loc2_:Object = this._1185874711craftModel;
         if(_loc2_ !== param1)
         {
            this._1185874711craftModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"craftModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get dashboardModel() : DashboardModel
      {
         return this._206201611dashboardModel;
      }
      
      public function set dashboardModel(param1:DashboardModel) : void
      {
         var _loc2_:Object = this._206201611dashboardModel;
         if(_loc2_ !== param1)
         {
            this._206201611dashboardModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dashboardModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get questModel() : QuestModel
      {
         return this._559427431questModel;
      }
      
      public function set questModel(param1:QuestModel) : void
      {
         var _loc2_:Object = this._559427431questModel;
         if(_loc2_ !== param1)
         {
            this._559427431questModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"questModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clanModel() : ClanModel
      {
         return this._187142541clanModel;
      }
      
      public function set clanModel(param1:ClanModel) : void
      {
         var _loc2_:Object = this._187142541clanModel;
         if(_loc2_ !== param1)
         {
            this._187142541clanModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clanModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rtmModel() : RTMModel
      {
         return this._116778114rtmModel;
      }
      
      public function set rtmModel(param1:RTMModel) : void
      {
         var _loc2_:Object = this._116778114rtmModel;
         if(_loc2_ !== param1)
         {
            this._116778114rtmModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rtmModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get astralModel() : AstralModel
      {
         return this._1625732494astralModel;
      }
      
      public function set astralModel(param1:AstralModel) : void
      {
         var _loc2_:Object = this._1625732494astralModel;
         if(_loc2_ !== param1)
         {
            this._1625732494astralModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"astralModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get barterModel() : BarterModel
      {
         return this._1303441563barterModel;
      }
      
      public function set barterModel(param1:BarterModel) : void
      {
         var _loc2_:Object = this._1303441563barterModel;
         if(_loc2_ !== param1)
         {
            this._1303441563barterModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"barterModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get achievementModel() : AchievementModel
      {
         return this._2075894074achievementModel;
      }
      
      public function set achievementModel(param1:AchievementModel) : void
      {
         var _loc2_:Object = this._2075894074achievementModel;
         if(_loc2_ !== param1)
         {
            this._2075894074achievementModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"achievementModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lfgModel() : LFGModel
      {
         return this._1695630084lfgModel;
      }
      
      public function set lfgModel(param1:LFGModel) : void
      {
         var _loc2_:Object = this._1695630084lfgModel;
         if(_loc2_ !== param1)
         {
            this._1695630084lfgModel = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lfgModel",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get stats() : BattlegroundStatistics
      {
         return this._109757599stats;
      }
      
      public function set stats(param1:BattlegroundStatistics) : void
      {
         var _loc2_:Object = this._109757599stats;
         if(_loc2_ !== param1)
         {
            this._109757599stats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stats",_loc2_,param1));
            }
         }
      }
   }
}

