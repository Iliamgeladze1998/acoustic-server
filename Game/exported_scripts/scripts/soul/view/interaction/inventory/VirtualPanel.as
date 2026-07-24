package soul.view.interaction.inventory
{
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import soul.event.InventoryEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.field.BaseUnit;
   import soul.model.inventory.InventoryModel;
   import soul.model.item.Item;
   import soul.model.item.ItemShortcut;
   import soul.net.ServerLayer;
   import soul.view.ui.VBox;
   
   public class VirtualPanel extends VBox
   {
      
      public var model:InventoryModel;
      
      private const hotKeys:Array;
      
      private var _backpackVisible:Boolean;
      
      private var _myUnit:BaseUnit;
      
      public function VirtualPanel()
      {
         var i:uint = 0;
         var child:VirtualPanelItemContainer = null;
         var keyIndex:uint = 0;
         this.hotKeys = ["1","2","3","4","5","6","7","8","9","0"];
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.added);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         addEventListener(SimpleUIEvent.CREATION_COMPLETE,this.creationComplete);
         var len:uint = this.hotKeys.length;
         for(i = 0; i < len; i++)
         {
            child = new VirtualPanelItemContainer();
            keyIndex = len - i - 1;
            child.shortcut = "C+" + this.hotKeys[keyIndex];
            child.visible = false;
            child.slotIndex = i;
            child.addEventListener(MouseEvent.CLICK,this.itemClicked);
            addChild(child);
         }
      }
      
      private function creationComplete(e:Event) : void
      {
         var shortcut:ItemShortcut = null;
         var item:Item = null;
         var child:VirtualPanelItemContainer = null;
         this.model.addEventListener(InventoryEvent.INVENTORY_VISIBLE,this.backpackVisible);
         this.model.addEventListener(InventoryEvent.INVENTORY_HIDDEN,this.backpackHidden);
         var shortcuts:Vector.<ItemShortcut> = this.model.virtualPanelShortcuts;
         if(!shortcuts)
         {
            return;
         }
         for(var i:uint = 0; i < shortcuts.length; i++)
         {
            shortcut = shortcuts[i];
            item = this.model.getItemByShortcut(shortcut);
            child = getChildAt(i) as VirtualPanelItemContainer;
            child.item = item;
            child.visible = item != null;
         }
      }
      
      private function added(e:Event) : void
      {
         stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyPress);
         addEventListener(InventoryEvent.CREATE_RUNE_SHORTCUT,this.onCreateShortcut);
         addEventListener(InventoryEvent.REMOVE_RUNE_SHORTCUT,this.onRemoveShortcut);
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         stage.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyPress);
         this.model.removeEventListener(InventoryEvent.INVENTORY_VISIBLE,this.backpackVisible);
         this.model.removeEventListener(InventoryEvent.INVENTORY_HIDDEN,this.backpackHidden);
         removeEventListener(InventoryEvent.CREATE_RUNE_SHORTCUT,this.onCreateShortcut);
         removeEventListener(InventoryEvent.REMOVE_RUNE_SHORTCUT,this.onRemoveShortcut);
      }
      
      private function itemClicked(e:MouseEvent) : void
      {
         this.activateItem(e.target as VirtualPanelItemContainer);
      }
      
      private function onCreateShortcut(e:InventoryEvent) : void
      {
         e.stopPropagation();
         var child:VirtualPanelItemContainer = e.target as VirtualPanelItemContainer;
         var item:Item = e.item;
         if(!item)
         {
            return;
         }
         var shortcut:ItemShortcut = new ItemShortcut();
         shortcut.templateId = item.templateId;
         shortcut.abilityId = item.abilityId;
         shortcut.imagePath = item.imagePath;
         shortcut.itemClass = item.itemClass;
         shortcut.level = item.level;
         child.item = this.model.getItemByShortcut(shortcut);
         child.visible = true;
         var shortcuts:Vector.<ItemShortcut> = this.model.virtualPanelShortcuts || new Vector.<ItemShortcut>(this.hotKeys.length);
         shortcuts[e.slotIndex] = shortcut;
         this.model.virtualPanelShortcuts = shortcuts;
      }
      
      private function onRemoveShortcut(e:InventoryEvent) : void
      {
         e.stopPropagation();
         var child:VirtualPanelItemContainer = e.target as VirtualPanelItemContainer;
         child.item = null;
         child.visible = this._backpackVisible;
         var shortcuts:Vector.<ItemShortcut> = this.model.virtualPanelShortcuts || new Vector.<ItemShortcut>(this.hotKeys.length);
         shortcuts[e.slotIndex] = null;
         this.model.virtualPanelShortcuts = shortcuts;
      }
      
      private function backpackVisible(e:InventoryEvent) : void
      {
         var child:VirtualPanelItemContainer = null;
         this._backpackVisible = true;
         var len:uint = this.hotKeys.length;
         for(var i:uint = 0; i < len; i++)
         {
            child = getChildAt(i) as VirtualPanelItemContainer;
            child.visible = true;
         }
      }
      
      private function backpackHidden(e:InventoryEvent) : void
      {
         var child:VirtualPanelItemContainer = null;
         this._backpackVisible = false;
         var len:uint = this.hotKeys.length;
         for(var i:uint = 0; i < len; i++)
         {
            child = getChildAt(i) as VirtualPanelItemContainer;
            child.visible = child.item != null;
         }
      }
      
      private function onKeyPress(e:KeyboardEvent) : void
      {
         if(stage.focus is TextField)
         {
            return;
         }
         var code:uint = e.keyCode;
         if(!e.ctrlKey || code < 48 || code > 57)
         {
            return;
         }
         var id:int = code - 49;
         if(id == -1)
         {
            id = 9;
         }
         if(id + 1 > numChildren)
         {
            return;
         }
         var len:uint = this.hotKeys.length;
         id = len - 1 - id;
         this.activateItem(getChildAt(id) as VirtualPanelItemContainer);
      }
      
      private function activateItem(container:VirtualPanelItemContainer) : void
      {
         if(!container || !container.item || container.item.count < 1)
         {
            return;
         }
         var cooldownLeft:int = container.cooldownLeft - ServerLayer.latency * 0.75;
         if(cooldownLeft > 0)
         {
            return;
         }
         var ne:InventoryEvent = new InventoryEvent(InventoryEvent.USE);
         ne.item = container.item;
         this.model.dispatchEvent(ne);
      }
      
      public function set myUnit(value:BaseUnit) : void
      {
         var slot:VirtualPanelItemContainer = null;
         this._myUnit = value;
         for(var i:int = 0; i < numChildren; i++)
         {
            slot = VirtualPanelItemContainer(getChildAt(i));
            if(Boolean(slot))
            {
               slot.myUnit = value;
            }
         }
      }
   }
}

