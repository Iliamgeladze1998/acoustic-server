package soul.view.rtm
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import soul.event.AbilityEvent;
   import soul.event.InventoryEvent;
   import soul.event.PanelEvent;
   import soul.model.GameModel;
   import soul.model.field.BaseUnit;
   import soul.model.item.Item;
   import soul.model.item.ItemShortcut;
   import soul.net.ServerLayer;
   import soul.view.interaction.ability.BeltAbilityContainer;
   import soul.view.interaction.inventory.RuneContainer;
   import soul.view.ui.HBox;
   
   public class ShortcutPanel extends HBox
   {
      
      public static const LEFT:uint = 0;
      
      public static const RIGHT:uint = 1;
      
      public var panelType:uint;
      
      public var model:GameModel;
      
      public var hotKeys:Array;
      
      private var _locked:Boolean;
      
      private var _myUnit:BaseUnit;
      
      public function ShortcutPanel()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.added);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
      }
      
      private function added(e:Event) : void
      {
         addEventListener(InventoryEvent.CREATE_RUNE_SHORTCUT,this.delegateItem);
         addEventListener(InventoryEvent.REMOVE_RUNE_SHORTCUT,this.delegateItem);
         addEventListener(AbilityEvent.CREATE_ABILITY_SHORTCUT,this.delegateAbility);
         addEventListener(AbilityEvent.REMOVE_ABILITY_SHORTCUT,this.delegateAbility);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyPress);
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         removeEventListener(InventoryEvent.CREATE_RUNE_SHORTCUT,this.delegateItem);
         removeEventListener(InventoryEvent.REMOVE_RUNE_SHORTCUT,this.delegateItem);
         removeEventListener(AbilityEvent.CREATE_ABILITY_SHORTCUT,this.delegateAbility);
         removeEventListener(AbilityEvent.REMOVE_ABILITY_SHORTCUT,this.delegateAbility);
      }
      
      private function delegateItem(e:InventoryEvent) : void
      {
         e.stopPropagation();
         var ne:PanelEvent = new PanelEvent(e.type == InventoryEvent.CREATE_RUNE_SHORTCUT ? PanelEvent.CREATE_SHORTCUT : PanelEvent.REMOVE_SHORTCUT);
         ne.id = e.itemId;
         ne.index = e.slotIndex;
         ne.panel = this.panelType;
         this.model.rtmModel.dispatchEvent(ne);
      }
      
      private function delegateAbility(e:AbilityEvent) : void
      {
         e.stopPropagation();
         var ne:PanelEvent = new PanelEvent(e.type == AbilityEvent.CREATE_ABILITY_SHORTCUT ? PanelEvent.CREATE_SHORTCUT : PanelEvent.REMOVE_SHORTCUT);
         ne.id = e.abilityId;
         ne.index = e.slotIndex;
         ne.panel = this.panelType;
         this.model.rtmModel.dispatchEvent(ne);
      }
      
      private function onKeyPress(e:KeyboardEvent) : void
      {
         if(!this.hotKeys)
         {
            return;
         }
         if(stage.focus is TextField)
         {
            return;
         }
         var key:String = String.fromCharCode(e.charCode);
         var id:int = this.hotKeys.indexOf(key);
         if(id == -1 || id + 1 > numChildren)
         {
            return;
         }
         var child:DisplayObject = getChildAt(id);
         this.pressAbility(child as BeltAbilityContainer,e);
         this.pressItem(child as RuneContainer,e);
      }
      
      private function pressAbility(child:BeltAbilityContainer, e:Event) : void
      {
         if(!child || !child.ability)
         {
            return;
         }
         var cooldownLeft:int = child.cooldownLeft - ServerLayer.latency * 0.75;
         if(cooldownLeft > 0)
         {
            return;
         }
         var ne:AbilityEvent = new AbilityEvent(AbilityEvent.ABILITY_CLICK);
         ne.abilityId = child.ability.id;
         ne.self = e is MouseEvent && MouseEvent(e).shiftKey || e is KeyboardEvent && KeyboardEvent(e).shiftKey;
         this.model.abilityModel.dispatchEvent(ne);
      }
      
      private function pressItem(child:RuneContainer, e:Event) : void
      {
         if(!child || !child.item || child.item.count < 1)
         {
            return;
         }
         var cooldownLeft:int = child.cooldownLeft - ServerLayer.latency * 0.75;
         if(cooldownLeft > 0)
         {
            return;
         }
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.USE);
         ne.item = child.item;
         this.model.inventoryModel.dispatchEvent(ne);
      }
      
      private function itemClick(e:Event) : void
      {
         this.pressItem(e.target as RuneContainer,e);
      }
      
      public function set shortcuts(value:Array) : void
      {
         var abilityChild:BeltAbilityContainer = null;
         var itemChild:RuneContainer = null;
         var i:String = null;
         var shortcut:PanelShortcut = null;
         var item:Item = null;
         removeAllChildren();
         for(i in value)
         {
            shortcut = value[i];
            if(Boolean(shortcut) && Boolean(shortcut.abilityId))
            {
               abilityChild = new BeltAbilityContainer();
               abilityChild.abilityModel = this.model.abilityModel;
               abilityChild.cooldownModel = this.model.cooldownModel;
               abilityChild.myUnit = this._myUnit;
               abilityChild.inventoryModel = this.model.inventoryModel;
               abilityChild.abilityId = shortcut.abilityId;
               abilityChild.locked = this._locked;
               abilityChild.shortcut = this.hotKeys[i];
               abilityChild.slotIndex = numChildren;
               addChild(abilityChild);
            }
            else
            {
               item = this.model.inventoryModel.getItemByShortcut(Boolean(shortcut) ? shortcut.item : null);
               itemChild = new RuneContainer();
               itemChild.myUnit = this._myUnit;
               itemChild.slotIndex = numChildren;
               itemChild.shortcut = this.hotKeys[i];
               addChild(itemChild);
               itemChild.item = item;
               if(item)
               {
                  itemChild.locked = this._locked;
                  itemChild.addEventListener(MouseEvent.CLICK,this.itemClick);
               }
            }
         }
      }
      
      public function set locked(value:Boolean) : void
      {
         var child:DisplayObject = null;
         this._locked = value;
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i);
            if(child is RuneContainer)
            {
               RuneContainer(child).locked = value;
            }
            else if(child is BeltAbilityContainer)
            {
               BeltAbilityContainer(child).locked = value;
            }
         }
      }
      
      public function set myUnit(value:BaseUnit) : void
      {
         var child:DisplayObject = null;
         this._myUnit = value;
         for(var i:int = 0; i < numChildren; i++)
         {
            child = getChildAt(i);
            if(child is RuneContainer)
            {
               RuneContainer(child).myUnit = value;
            }
            else if(child is BeltAbilityContainer)
            {
               BeltAbilityContainer(child).myUnit = value;
            }
         }
      }
   }
}

