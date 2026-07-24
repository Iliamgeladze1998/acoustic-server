package soul.view.interaction.ability
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import mx.binding.utils.BindingUtils;
   import mx.binding.utils.ChangeWatcher;
   import mx.events.PropertyChangeEvent;
   import soul.model.GameModel;
   import soul.model.ability.Ability;
   import soul.model.ability.AbilityModel;
   import soul.model.cooldown.CooldownModel;
   import soul.model.field.BaseUnit;
   import soul.model.field.StatType;
   import soul.model.inventory.InventoryModel;
   import soul.model.item.Item;
   import soul.model.item.ItemClass;
   import soul.model.system.Configuration;
   import soul.view.assets.Assets;
   import soul.view.common.IconRenderer;
   import soul.view.toolTip.AbilityTip;
   import soul.view.toolTip.ToolTipManager;
   
   public class AbilityRenderer extends IconRenderer
   {
      
      public var abilityModel:AbilityModel;
      
      public var cooldownModel:CooldownModel;
      
      public var inventoryModel:InventoryModel;
      
      private var cws:Array = [];
      
      public var checkStats:Boolean = true;
      
      private var enoughStats:Boolean;
      
      public var checkItems:Boolean = true;
      
      private var enoughItems:Boolean;
      
      private var fightOk:Boolean = true;
      
      private var _itemsToWatch:Vector.<Item>;
      
      private var _abilityId:String;
      
      private var _ability:Ability;
      
      private var _myUnit:BaseUnit;
      
      public function AbilityRenderer()
      {
         super();
         width = 51;
         height = 51;
         padding = 3;
         backgroundPadding = 1;
         borderSkin = Assets.simpleBorderRound;
         backgroundImage = ItemClass.IMG_CLASS1;
         image.showIcon = true;
         glow.source = Assets.iconGlow;
         addEventListener(Event.REMOVED,this.removed);
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         this.resetWatchers();
      }
      
      private function createWatchers() : void
      {
         this.resetWatchers();
         this.createAbilityWatcher();
         this.createStatWatcher();
         this.createInventoryWatcher();
      }
      
      private function createAbilityWatcher() : void
      {
         if(Boolean(this.abilityModel))
         {
            this.ability = this.abilityModel.getAbilityById(this._abilityId);
            this.ability.addEventListener(Event.CHANGE,this.abilityChanged,false,0,true);
         }
      }
      
      private function createStatWatcher() : void
      {
         if(Boolean(this._myUnit))
         {
            IEventDispatcher(this._myUnit.stats).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.statChanged);
            this.statChanged(null);
         }
      }
      
      private function createInventoryWatcher() : void
      {
         if(Boolean(this.inventoryModel))
         {
            IEventDispatcher(this.inventoryModel.totalItems).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.itemsChanged);
            this.itemsChanged(null);
         }
      }
      
      private function createFightWatcher() : void
      {
         IEventDispatcher(GameModel.getInstance().characterModel).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.characterModelChanged);
         this.characterModelChanged(null);
      }
      
      private function resetWatchers() : void
      {
         this.resetAbilityWatcher();
         this.resetStatWatcher();
         this.resetInventoryWatcher();
         this.itemsToWatch = null;
      }
      
      private function resetAbilityWatcher() : void
      {
         var cw:ChangeWatcher = null;
         for each(cw in this.cws)
         {
            cw.unwatch();
         }
      }
      
      private function resetStatWatcher() : void
      {
         if(Boolean(this._myUnit))
         {
            IEventDispatcher(this._myUnit.stats).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.statChanged);
         }
      }
      
      private function resetInventoryWatcher() : void
      {
         if(Boolean(this.inventoryModel))
         {
            IEventDispatcher(this.inventoryModel.totalItems).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.itemsChanged);
         }
      }
      
      private function resetFightWatcher() : void
      {
         IEventDispatcher(GameModel.getInstance().characterModel).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.characterModelChanged);
      }
      
      private function abilityChanged(e:Event) : void
      {
         this.ability = e.target as Ability;
      }
      
      private function statChanged(e:PropertyChangeEvent) : void
      {
         var stat:String = null;
         var have:int = 0;
         var enough:Boolean = true;
         if(!this._ability)
         {
            return;
         }
         for(stat in this._ability.costs)
         {
            have = int(this._myUnit.stats[stat]);
            if(this._ability.costs[stat] > have)
            {
               enough = false;
               break;
            }
         }
         if(this._myUnit.stats[StatType.LEVEL] < this._ability.level)
         {
            enough = false;
         }
         this.enoughStats = enough;
         this.checkConditions();
      }
      
      private function itemsChanged(e:PropertyChangeEvent) : void
      {
         var template:String = null;
         var item:Item = null;
         var allItemsExist:Boolean = true;
         var itemsToWatch:Array = [];
         if(Boolean(this._ability))
         {
            for(template in this._ability.itemCosts)
            {
               item = this.inventoryModel.totalItems[template];
               if(!item)
               {
                  allItemsExist = false;
                  break;
               }
               itemsToWatch.push(item);
            }
         }
         else
         {
            allItemsExist = false;
         }
         if(allItemsExist)
         {
            this.itemsToWatch = Vector.<Item>(itemsToWatch);
         }
         else
         {
            this.enoughItems = false;
            this.checkConditions();
         }
      }
      
      private function itemChanged(e:PropertyChangeEvent) : void
      {
         var item:Item = null;
         var enough:Boolean = true;
         for each(item in this._itemsToWatch)
         {
            if(item.count < this._ability.itemCosts[item.templateId])
            {
               enough = false;
               break;
            }
         }
         this.enoughItems = enough;
         this.checkConditions();
      }
      
      private function characterModelChanged(e:PropertyChangeEvent) : void
      {
         if(!this._ability)
         {
            return;
         }
         if(Boolean(e) && e.property != "fightMode")
         {
            return;
         }
         this.fightOk = this._ability.availableInFight || !GameModel.getInstance().characterModel.fightMode;
         this.checkConditions();
      }
      
      private function checkConditions() : void
      {
         this.enabled = this.fightOk && (!this.checkStats || this.enoughStats) && (!this.checkItems || this.enoughItems);
      }
      
      private function set itemsToWatch(value:Vector.<Item>) : void
      {
         var item:Item = null;
         for each(item in this._itemsToWatch)
         {
            IEventDispatcher(item).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.itemChanged);
         }
         this._itemsToWatch = value;
         for each(item in value)
         {
            IEventDispatcher(item).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.itemChanged);
         }
         this.itemChanged(null);
      }
      
      public function set abilityId(value:String) : void
      {
         this._abilityId = value;
         if(Boolean(value))
         {
            this.createWatchers();
         }
      }
      
      public function set ability(value:Ability) : void
      {
         if(Boolean(this._ability))
         {
            this.resetStatWatcher();
            this.resetInventoryWatcher();
            this.resetFightWatcher();
         }
         this._ability = value;
         if(Boolean(value))
         {
            if(value.loading)
            {
               toolTip = "loading... " + value.id;
               value.addEventListener(Event.CHANGE,this.abilityLoaded);
            }
            else
            {
               this.processAbility(value);
            }
         }
         else
         {
            ToolTipManager.unregister(this);
            source = null;
         }
      }
      
      public function get ability() : Ability
      {
         return this._ability;
      }
      
      private function abilityLoaded(e:Event) : void
      {
         this.processAbility(e.target as Ability);
      }
      
      private function processAbility(value:Ability) : void
      {
         ToolTipManager.register(this,value,AbilityTip);
         source = Configuration.getAbilityImageUrl(value.imagePath);
         if(Boolean(this.cooldownModel) && Boolean(value.groupCD))
         {
            this.cws.push(BindingUtils.bindProperty(this,"cooldown",this.cooldownModel.groups,value.groupCD,false,true));
            this.cws.push(BindingUtils.bindProperty(this,"cooldown",this.cooldownModel.abilities,value.id,false,true));
         }
         this.createStatWatcher();
         this.createInventoryWatcher();
         if(value.availableInFight)
         {
            this.fightOk = true;
         }
         else
         {
            this.createFightWatcher();
         }
      }
      
      public function set myUnit(value:BaseUnit) : void
      {
         this.resetStatWatcher();
         this._myUnit = value;
         this.createStatWatcher();
      }
      
      override public function set enabled(value:Boolean) : void
      {
         if(_enabled == value)
         {
            return;
         }
         _enabled = value;
         image.enabled = value;
      }
   }
}

