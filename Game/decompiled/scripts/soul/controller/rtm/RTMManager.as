package soul.controller.rtm
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import mx.binding.utils.BindingUtils;
   import mx.binding.utils.ChangeWatcher;
   import soul.controller.IManager;
   import soul.controller.Interaction;
   import soul.controller.MenuManager;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.controller.shortcut.InteractShortcut;
   import soul.controller.shortcut.Shortcut;
   import soul.controller.shortcut.ShortcutManager;
   import soul.event.AbilityEvent;
   import soul.event.FieldEvent;
   import soul.event.InventoryEvent;
   import soul.event.PanelEvent;
   import soul.event.RTMEvent;
   import soul.model.GameModel;
   import soul.model.ability.Ability;
   import soul.model.common.InteractionType;
   import soul.model.common.MenuType;
   import soul.model.field.FieldUnit;
   import soul.model.field.LibraryManager;
   import soul.model.field.mapconfig.PvpState;
   import soul.model.field.spriteconfig.ObjectLayout;
   import soul.model.item.ItemShortcut;
   import soul.model.rtm.TargetType;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   import soul.utils.CursorUtil;
   import soul.view.common.BigMessage;
   import soul.view.rtm.RTMScreen;
   import soul.view.rtm.ShortcutPanel;
   
   public class RTMManager implements IManager
   {
      
      private var model:GameModel;
      
      private var view:RTMScreen;
      
      private var fieldManager:FieldManager;
      
      private var cws:Array = [];
      
      public function RTMManager(model:GameModel, view:RTMScreen)
      {
         super();
         ComponentLocator.setComponent(ComponentLocator.RTM,this);
         this.view = view;
         this.model = model;
         model.rtmModel.addEventListener(FieldEvent.MAP_LOADING,this.mapLoading);
         model.rtmModel.addEventListener(FieldEvent.ACCEPT_ABILITY,this.acceptAbility);
         model.rtmModel.addEventListener(FieldEvent.CREATE_SPELL_CURSOR,this.createSpellCursor);
         model.rtmModel.addEventListener(FieldEvent.REMOVE_SPELL_CURSOR,this.removeSpellCursor);
         model.rtmModel.addEventListener(FieldEvent.FIELD_READY,this.fieldReady);
         model.rtmModel.addEventListener(FieldEvent.SHOW_MENU,this.showMenu);
         model.rtmModel.addEventListener(RTMEvent.CALL_DUEL,this.callDuel);
         model.rtmModel.addEventListener(RTMEvent.SWITCH_RUN,this.runClick);
         model.abilityModel.addEventListener(AbilityEvent.ABILITY_CLICK,this.abilityClick);
         model.inventoryModel.addEventListener(InventoryEvent.USE,this.useItem);
         model.rtmModel.addEventListener(PanelEvent.CREATE_SHORTCUT,this.createPanelShortcut);
         model.rtmModel.addEventListener(PanelEvent.REMOVE_SHORTCUT,this.removePanelShortcut);
         model.rtmModel.addEventListener(RTMEvent.SELECT_AMMO,this.quiverClick);
         model.rtmModel.addEventListener(RTMEvent.SELECT_WEAPON,this.switchAltMode);
         model.rtmModel.addEventListener(InventoryEvent.CREATE_AMMO_SHORTCUT,this.createAmmoShortcut);
         model.rtmModel.addEventListener(InventoryEvent.REMOVE_AMMO_SHORTCUT,this.removeAmmoShortcut);
         view.targetFrame.addEventListener(Event.CLOSE,this.selectNull);
         view.targetFrame.addEventListener(FieldEvent.CS_INTERACT,this.interact);
         ShortcutManager.addShortcutListener(Shortcut.SWITCH_WEAPON,this.switchAltModeByKey);
         ShortcutManager.addShortcutListener(Shortcut.SWITCH_AUTOATTACK,this.switchAutoAttack);
         ShortcutManager.addShortcutListener(Shortcut.SWITCH_CRAFT,this.switchCraft);
         ShortcutManager.addShortcutListener(Shortcut.CANCEL,this.cancel);
         ShortcutManager.addShortcutListener(Shortcut.TAB,this.selectNextEnemy);
         ShortcutManager.addShortcutListener(Shortcut.SELECT_NEXT_ENEMY2,this.selectNextEnemy);
         ShortcutManager.addShortcutListener(InteractShortcut.instance,this.interact,InteractShortcut.TARGET_FRAME,false);
         this.cws.push(BindingUtils.bindSetter(this.myHpChanged,model.rtmModel,["myUnit","stats","HP"]));
      }
      
      public function reset() : void
      {
         var cw:ChangeWatcher = null;
         this.model.rtmModel.removeEventListener(FieldEvent.MAP_LOADING,this.mapLoading);
         this.model.rtmModel.removeEventListener(FieldEvent.ACCEPT_ABILITY,this.acceptAbility);
         this.model.rtmModel.removeEventListener(FieldEvent.CREATE_SPELL_CURSOR,this.createSpellCursor);
         this.model.rtmModel.removeEventListener(FieldEvent.REMOVE_SPELL_CURSOR,this.removeSpellCursor);
         this.model.rtmModel.removeEventListener(FieldEvent.FIELD_READY,this.fieldReady);
         this.model.rtmModel.removeEventListener(FieldEvent.SHOW_MENU,this.showMenu);
         this.model.rtmModel.removeEventListener(RTMEvent.CALL_DUEL,this.callDuel);
         this.model.rtmModel.removeEventListener(RTMEvent.SWITCH_RUN,this.runClick);
         this.model.abilityModel.removeEventListener(AbilityEvent.ABILITY_CLICK,this.abilityClick);
         this.model.inventoryModel.removeEventListener(InventoryEvent.USE,this.useItem);
         this.model.rtmModel.removeEventListener(PanelEvent.CREATE_SHORTCUT,this.createPanelShortcut);
         this.model.rtmModel.removeEventListener(PanelEvent.REMOVE_SHORTCUT,this.removePanelShortcut);
         this.model.rtmModel.removeEventListener(RTMEvent.SELECT_AMMO,this.quiverClick);
         this.model.rtmModel.removeEventListener(RTMEvent.SELECT_WEAPON,this.switchAltMode);
         this.model.rtmModel.removeEventListener(InventoryEvent.CREATE_AMMO_SHORTCUT,this.createAmmoShortcut);
         this.model.rtmModel.removeEventListener(InventoryEvent.REMOVE_AMMO_SHORTCUT,this.removeAmmoShortcut);
         this.view.targetFrame.removeEventListener(Event.CLOSE,this.selectNull);
         this.view.targetFrame.removeEventListener(FieldEvent.CS_INTERACT,this.interact);
         ShortcutManager.removeShortcutListener(Shortcut.SWITCH_WEAPON,this.switchAltModeByKey);
         ShortcutManager.removeShortcutListener(Shortcut.SWITCH_AUTOATTACK,this.switchAutoAttack);
         ShortcutManager.removeShortcutListener(Shortcut.SWITCH_CRAFT,this.switchCraft);
         ShortcutManager.removeShortcutListener(Shortcut.CANCEL,this.cancel);
         ShortcutManager.removeShortcutListener(Shortcut.TAB,this.selectNextEnemy);
         ShortcutManager.removeShortcutListener(Shortcut.SELECT_NEXT_ENEMY2,this.selectNextEnemy);
         ShortcutManager.removeShortcutListener(InteractShortcut.instance,this.interact,false);
         ComponentLocator.setComponent(ComponentLocator.RTM,null);
         for each(cw in this.cws)
         {
            cw.unwatch();
         }
      }
      
      public function show() : void
      {
         this.ready();
         this.getCommonSprites();
         if(!this.fieldManager)
         {
            this.fieldManager = new FieldManager(this.view.field,this.model);
            this.fieldManager.getMapData();
         }
         this.view.visible = true;
      }
      
      public function hide() : void
      {
         this.view.visible = false;
         if(Boolean(this.fieldManager))
         {
            this.fieldManager.cleanMap();
         }
      }
      
      private function cancel(e:Event) : void
      {
         if(Boolean(this.model.rtmModel.activeAbility))
         {
            this.cancelAbility();
         }
         else if(Boolean(this.model.rtmModel.targetUnit))
         {
            this.selectNull(null);
         }
      }
      
      private function fieldReady(e:Event) : void
      {
         BigMessage.showMessage(this.model.rtmModel.mapName,16776960);
         BigMessage.showMessage(LocaleManager.getString(BundleName.INTERFACE,this.model.rtmModel.pvpState),PvpState.getTextColor(this.model.rtmModel.pvpState));
      }
      
      private function callDuel(e:RTMEvent) : void
      {
         ServerLayer.call("battlegroundService","duel",null,null,e.id);
      }
      
      private function showMenu(e:FieldEvent) : void
      {
         var fu:FieldUnit = FieldUnit(e.data);
         MenuManager.create(MenuType.CHARACTER_MENU,fu.id,false,true);
      }
      
      private function createSpellCursor(e:Event) : void
      {
         this.setCustomCursor(LibraryManager.getObjectClass("spellCursor"));
      }
      
      private function removeSpellCursor(e:Event) : void
      {
         this.clearCustomCursor();
         this.model.rtmModel.dispatchEvent(new FieldEvent(FieldEvent.REMOVE_AOE));
      }
      
      private function setCustomCursor(cursorClass:Class) : void
      {
         CursorUtil.setCursor(cursorClass);
      }
      
      private function clearCustomCursor() : void
      {
         CursorUtil.removeAllCursors();
      }
      
      private function mapLoading(e:FieldEvent) : void
      {
         var loading:Boolean = e.data;
         this.view.visible = !loading;
      }
      
      private function runClick(e:Event) : void
      {
         trace("RTMManager.runClick()");
         this.requestRun(!this.model.characterModel.runMode);
      }
      
      private function switchAutoAttack(e:Event) : void
      {
         trace("RTMManager.switchAutoAttack()");
         this.requestAttack(!this.model.characterModel.attackMode);
      }
      
      private function switchCraft(e:Event) : void
      {
         trace("RTMManager.switchCraft()");
         Interaction.toggle(InteractionType.CRAFT);
      }
      
      private function abilityClick(e:AbilityEvent) : void
      {
         trace("RTMManager.abilityClick()",e.abilityId);
         var ability:Ability = this.model.abilityModel.getAbilityById(e.abilityId);
         this.initAbility(ability,null,e.self);
      }
      
      private function useItem(e:InventoryEvent) : void
      {
         if(!e.item)
         {
            return;
         }
         var item:ItemShortcut = new ItemShortcut();
         item.abilityId = e.item.abilityId;
         item.templateId = e.item.templateId;
         this.initItem(item);
      }
      
      private function initItem(item:ItemShortcut) : void
      {
         var ability:Ability = this.model.abilityModel.getAbilityById(item.abilityId);
         this.initAbility(ability,item);
      }
      
      private function initAbility(a:Ability, i:ItemShortcut = null, self:Boolean = false) : void
      {
         var targetId:String = null;
         var useNow:Boolean = false;
         if(!a)
         {
            return;
         }
         if(a.target == TargetType.UNIT && a.distance == 0)
         {
            useNow = true;
         }
         else
         {
            if(a.target == TargetType.POINT && a.distance <= 0)
            {
               this.useAbilityHere(a,i);
               return;
            }
            if(a.target == TargetType.UNIT)
            {
               if(self)
               {
                  targetId = this.model.rtmModel.myUnit.id;
                  useNow = true;
               }
               else if(Boolean(this.model.rtmModel.targetUnit) && this.model.rtmModel.targetUnit.accepts(a))
               {
                  targetId = this.model.rtmModel.targetUnit.id;
                  useNow = true;
               }
            }
         }
         if(useNow)
         {
            this.useAbility(targetId,a,i);
         }
         else
         {
            this.model.rtmModel.activeAbility = a;
            this.model.rtmModel.activeItem = i;
            this.model.rtmModel.dispatchEvent(new FieldEvent(FieldEvent.CREATE_SPELL_CURSOR));
            this.model.rtmModel.dispatchEvent(new FieldEvent(FieldEvent.CREATE_AOE));
         }
      }
      
      private function useAbility(targetId:String, ability:Ability, item:ItemShortcut = null) : void
      {
         var e:FieldEvent = null;
         if(Boolean(item))
         {
            e = new FieldEvent(FieldEvent.CS_USE_ITEM_ON_UNIT);
            e.data = {
               "targetId":targetId,
               "templateId":item.templateId
            };
            this.model.rtmModel.dispatchEvent(e);
         }
         else if(Boolean(ability))
         {
            e = new FieldEvent(FieldEvent.CS_USE_ABILITY_ON_UNIT);
            e.data = {
               "targetId":targetId,
               "abilityId":ability.id
            };
            this.model.rtmModel.dispatchEvent(e);
         }
      }
      
      private function useAbilityHere(ability:Ability, item:ItemShortcut = null) : void
      {
         var e:FieldEvent = null;
         if(Boolean(item))
         {
            e = new FieldEvent(FieldEvent.CS_USE_ITEM_HERE);
            e.data = item.templateId;
            this.model.rtmModel.dispatchEvent(e);
         }
         else
         {
            e = new FieldEvent(FieldEvent.CS_USE_ABILITY_HERE);
            e.data = ability.id;
            this.model.rtmModel.dispatchEvent(e);
         }
      }
      
      private function acceptAbility(e:Event) : void
      {
         var unit:FieldUnit = this.model.rtmModel.activeUnit;
         if(!unit)
         {
            return;
         }
         var ability:Ability = this.model.rtmModel.activeAbility;
         if(!unit.accepts(ability))
         {
            return;
         }
         this.model.rtmModel.dispatchEvent(new FieldEvent(FieldEvent.REMOVE_SPELL_CURSOR));
         this.useAbility(unit.id,ability,this.model.rtmModel.activeItem);
         this.model.rtmModel.activeAbility = null;
         this.model.rtmModel.activeItem = null;
         this.model.rtmModel.activeUnit = null;
      }
      
      private function cancelAbility() : void
      {
         this.removeSpellCursor(null);
         this.model.rtmModel.activeAbility = null;
         this.model.rtmModel.activeItem = null;
         this.model.rtmModel.activeUnit = null;
      }
      
      private function switchAltMode(e:RTMEvent) : void
      {
         this.requestSelectAlternative(e.index);
      }
      
      private function switchAltModeByKey(e:Event) : void
      {
         var altMode:int = 1 - this.model.characterModel.alternativeIndex;
         this.requestSelectAlternative(altMode);
      }
      
      private function quiverClick(e:RTMEvent) : void
      {
         e.stopPropagation();
         ServerLayer.call("characterService","selectAmmoIndex",null,null,e.index);
      }
      
      private function selectNull(e:Event) : void
      {
         var ne:FieldEvent = new FieldEvent(FieldEvent.UNSELECT_TARGET);
         this.model.rtmModel.dispatchEvent(ne);
      }
      
      private function interact(e:Event) : Boolean
      {
         var ne:FieldEvent = null;
         var ability:Ability = this.model.rtmModel.activeAbility;
         var unit:FieldUnit = this.model.rtmModel.targetUnit;
         if(Boolean(ability) && ability.target == TargetType.POINT)
         {
            ne = new FieldEvent(FieldEvent.USE_POINT_ABILITY_ON_UNIT);
            ne.data = Boolean(unit) ? unit : this.model.rtmModel.myUnit;
            this.model.rtmModel.dispatchEvent(ne);
            return true;
         }
         if(Boolean(unit))
         {
            ne = new FieldEvent(FieldEvent.CS_INTERACT);
            this.model.rtmModel.dispatchEvent(ne);
            return true;
         }
         return false;
      }
      
      private function createPanelShortcut(e:PanelEvent) : void
      {
         var method:String = e.panel == ShortcutPanel.LEFT ? "addQuickSlotAbility" : "addQuickSlotRune";
         ServerLayer.call("characterService",method,null,null,e.id,e.index);
      }
      
      private function removePanelShortcut(e:PanelEvent) : void
      {
         var method:String = e.panel == ShortcutPanel.LEFT ? "addQuickSlotAbility" : "addQuickSlotRune";
         ServerLayer.call("characterService",method,null,null,null,e.index);
      }
      
      private function createAmmoShortcut(e:InventoryEvent) : void
      {
         e.stopPropagation();
         ServerLayer.call("characterService","addQuickSlotAmmo",null,null,e.itemId,e.slotIndex);
      }
      
      private function removeAmmoShortcut(e:InventoryEvent) : void
      {
         e.stopPropagation();
         ServerLayer.call("characterService","addQuickSlotAmmo",null,null,null,e.slotIndex);
      }
      
      private function myHpChanged(value:Object) : void
      {
         var dead:Boolean = value !== null && value <= 0;
         this.model.characterModel.dead = dead;
         if(dead)
         {
            Interaction.hide(InteractionType.INVENTORY);
         }
      }
      
      private function ready() : void
      {
         ServerLayer.call("rtmService","rtmReady");
      }
      
      private function getCommonSprites() : void
      {
         ServerLayer.call("rtmService","getCommonSprites",this.setCommonSprites);
      }
      
      public function requestRun(flag:Boolean) : void
      {
         ServerLayer.call("rtmService","selectRun",null,null,flag);
      }
      
      public function requestAttack(flag:Boolean) : void
      {
         ServerLayer.call("rtmService","selectAttack",null,null,flag);
      }
      
      public function requestSelectAlternative(index:int) : void
      {
         ServerLayer.call("rtmService","setAlternativeIndex",null,null,index);
      }
      
      public function selectNextEnemy(e:KeyboardEvent) : void
      {
         ServerLayer.call("rtmService","selectNextEnemy");
      }
      
      public function init() : void
      {
      }
      
      private function setCommonSprites(value:Object) : void
      {
         var cfg:ObjectLayout = null;
         for each(cfg in value)
         {
            cfg.applyAspectRatio();
         }
         this.model.rtmModel.commonObjectLayouts = value;
      }
      
      public function selectRun(value:Boolean) : void
      {
         this.model.characterModel.runMode = value;
      }
      
      public function selectAttack(value:Boolean) : void
      {
         this.model.characterModel.attackMode = value;
      }
      
      public function selectFightMode(value:Boolean) : void
      {
         if(this.model.characterModel.fightMode == value)
         {
            return;
         }
         this.model.characterModel.fightMode = value;
      }
      
      public function selectAlternative(index:int) : void
      {
         this.model.characterModel.alternativeIndex = index;
      }
      
      public function initBeltActions(belt:Array) : void
      {
         this.model.characterModel.belt = belt;
      }
      
      public function initQuiver(quiver:Array) : void
      {
         this.model.characterModel.quiver = quiver;
      }
      
      public function selectAmmoIndex(index:int) : void
      {
         this.model.characterModel.selectedAmmoIndex = index;
      }
      
      public function initAbilityActions(slots:Array) : void
      {
         this.model.characterModel.abilitySlots = slots;
      }
      
      public function changeEdge(value:int) : void
      {
         this.model.rtmModel.mapEdge = value;
      }
   }
}

