package soul.view.interaction.inventory
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.MouseEvent;
   import mx.binding.utils.BindingUtils;
   import mx.binding.utils.ChangeWatcher;
   import mx.core.DragSource;
   import mx.events.PropertyChangeEvent;
   import soul.controller.mouse.SimpleDragManager;
   import soul.event.DragEvent;
   import soul.event.InventoryEvent;
   import soul.model.GameModel;
   import soul.model.ability.Ability;
   import soul.model.ability.AbilityModel;
   import soul.model.character.CharacterModel;
   import soul.model.cooldown.CooldownModel;
   import soul.model.field.BaseUnit;
   import soul.model.field.StatType;
   import soul.model.item.Item;
   import soul.model.item.ItemSlot;
   import soul.view.assets.Assets;
   import soul.view.ui.CachedImage;
   
   public class RuneContainer extends ItemContainer
   {
      
      private var abilityModel:AbilityModel;
      
      private var cooldownModel:CooldownModel;
      
      private var characterModel:CharacterModel;
      
      private var cws:Array = [];
      
      private var fightOk:Boolean = true;
      
      private var countOk:Boolean;
      
      protected var statsOk:Boolean;
      
      private var _count:int;
      
      private var _ability:Ability;
      
      private var _myUnit:BaseUnit;
      
      public function RuneContainer()
      {
         super();
         itemSlot = ItemSlot.RUNE;
         doubleClickEnabled = false;
         width = 51;
         height = 51;
         padding = 3;
         glowSource = Assets.iconGlow;
         addEventListener(Event.ADDED_TO_STAGE,this.added);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
      }
      
      private function added(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         this.abilityModel = GameModel.getInstance().abilityModel;
         this.cooldownModel = GameModel.getInstance().cooldownModel;
         this.characterModel = GameModel.getInstance().characterModel;
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         this.resetWatchers();
         this.abilityModel = null;
         this.cooldownModel = null;
         this.characterModel = null;
      }
      
      override protected function mouseDown(e:MouseEvent) : void
      {
         trace("ItemContainer.mouseDown()");
         var locked:Boolean = this.locked;
         if(e.ctrlKey)
         {
            this.locked = false;
         }
         super.mouseDown(e);
         this.locked = locked;
      }
      
      override protected function dragStart(e:MouseEvent) : void
      {
         var ds:DragSource = null;
         var dsi:CachedImage = null;
         super.mouseUp(null);
         var target:RuneContainer = e.target as RuneContainer;
         if(item != null)
         {
            ds = new DragSource();
            ds.addData(item,"runeItem");
            if(this is RuneContainer)
            {
               ds.addData(slotIndex,"sourceSlot");
            }
            dsi = new CachedImage();
            dsi.source = image.source;
            SimpleDragManager.doDrag(target,ds,e,dsi);
         }
      }
      
      override protected function dragEnter(e:DragEvent) : void
      {
         var item:Item = Item(e.dragSource.dataForFormat("item")) || Item(e.dragSource.dataForFormat("runeItem"));
         if(Boolean(item) && item.usable)
         {
            SimpleDragManager.acceptDragDrop(this);
            return;
         }
         var ability:Ability = e.dragSource.hasFormat("ability") ? Ability(e.dragSource.dataForFormat("ability")) : null;
         if(Boolean(ability))
         {
            SimpleDragManager.acceptDragDrop(this);
         }
      }
      
      override protected function dragDrop(e:DragEvent) : void
      {
         var ne:InventoryEvent = null;
         var item:Item = Item(e.dragSource.dataForFormat("item")) || Item(e.dragSource.dataForFormat("runeItem"));
         var ability:Ability = Ability(e.dragSource.dataForFormat("ability"));
         var sourceSlot:int = e.dragSource.hasFormat("sourceSlot") ? int(e.dragSource.dataForFormat("sourceSlot")) : -1;
         ne = new InventoryEvent(InventoryEvent.CREATE_RUNE_SHORTCUT);
         ne.itemId = item == null ? ability.id : item.templateId;
         ne.slotIndex = slotIndex;
         dispatchEvent(ne);
      }
      
      override protected function dragComplete(e:DragEvent) : void
      {
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.REMOVE_RUNE_SHORTCUT);
         ne.slotIndex = slotIndex;
         dispatchEvent(ne);
      }
      
      private function resetWatchers() : void
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
            IEventDispatcher(this._myUnit.stats).removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.statChanged,false);
         }
      }
      
      private function createStatWatcher() : void
      {
         if(Boolean(this._myUnit))
         {
            IEventDispatcher(this._myUnit.stats).addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.statChanged,false,0,true);
            this.statChanged(null);
         }
      }
      
      private function checkConditions() : void
      {
         this.enabled = item == null || this.fightOk && this.countOk && this.statsOk;
      }
      
      private function countChanged() : void
      {
         this.countOk = Boolean(item) && this._count > 0;
         super.count = this._count;
         this.checkConditions();
      }
      
      private function fightModeChanged(value:Boolean) : void
      {
         this.fightOk = this._ability == null || this._ability.availableInFight || !value;
         this.checkConditions();
      }
      
      private function statChanged(e:PropertyChangeEvent) : void
      {
         var enough:Boolean = true;
         if(!item)
         {
            return;
         }
         if(this._myUnit.stats[StatType.LEVEL] < item.level)
         {
            enough = false;
         }
         this.statsOk = enough;
         this.checkConditions();
      }
      
      override public function set count(value:int) : void
      {
         this._count = value;
         this.countChanged();
      }
      
      override public function set item(value:Item) : void
      {
         if(Boolean(item))
         {
            this.resetWatchers();
         }
         super.item = value;
         if(Boolean(value))
         {
            this.ability = this.abilityModel.getAbilityById(value.abilityId);
            this.createStatWatcher();
         }
         this.count = Boolean(item) ? item.count : 0;
      }
      
      public function set ability(value:Ability) : void
      {
         if(this._ability == value)
         {
            return;
         }
         this._ability = value;
         if(!value || value.loading)
         {
            value.addEventListener(Event.CHANGE,this.abilityChanged,false,0,true);
         }
         else
         {
            this.abilityChanged(null);
         }
      }
      
      private function abilityChanged(e:Event) : void
      {
         if(Boolean(this.cooldownModel))
         {
            this.cws.push(BindingUtils.bindProperty(this,"cooldown",this.cooldownModel.groups,this._ability.groupCD,false,true));
            this.cws.push(BindingUtils.bindProperty(this,"cooldown",this.cooldownModel.abilities,this._ability.id,false,true));
         }
         if(!this._ability.availableInFight)
         {
            this.cws.push(BindingUtils.bindSetter(this.fightModeChanged,this.characterModel,"fightMode",false,true));
         }
      }
      
      public function set myUnit(value:BaseUnit) : void
      {
         if(this._myUnit == value)
         {
            return;
         }
         this.resetStatWatcher();
         this._myUnit = value;
         this.createStatWatcher();
      }
      
      override public function set enabled(value:Boolean) : void
      {
         image.enabled = value;
      }
   }
}

