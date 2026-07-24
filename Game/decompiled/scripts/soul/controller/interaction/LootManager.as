package soul.controller.interaction
{
   import flash.events.Event;
   import soul.controller.IManager;
   import soul.event.ItemClickEvent;
   import soul.event.LootEvent;
   import soul.event.MenuEvent;
   import soul.model.character.CharacterModel;
   import soul.model.group.GroupMember;
   import soul.model.group.GroupModel;
   import soul.model.group.LootMiningType;
   import soul.model.interaction.loot.LootItem;
   import soul.model.interaction.loot.LootModel;
   import soul.model.item.Item;
   import soul.model.item.ItemBindingType;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   import soul.view.interaction.loot.BindingDialog;
   import soul.view.interaction.loot.LootScreen;
   import soul.view.ui.controls.PopupManager;
   import soul.view.ui.controls.Window;
   import soul.view.ui.controls.menu.Menu;
   
   public class LootManager implements IManager
   {
      
      private var character:CharacterModel;
      
      private var view:LootScreen;
      
      private var model:LootModel;
      
      private var groupModel:GroupModel;
      
      private var popup:BindingDialog;
      
      public function LootManager(view:LootScreen, model:LootModel, character:CharacterModel, groupModel:GroupModel)
      {
         super();
         this.view = view;
         this.model = model;
         this.character = character;
         this.groupModel = groupModel;
         view.model = model;
         model.addEventListener(LootEvent.TAKE_ALL,this.takeAllLoot);
         model.addEventListener(ItemClickEvent.ITEM_CLICK,this.takeLoot);
         ComponentLocator.setComponent(ComponentLocator.LOOT,this);
         ServerLayer.call("lootService",ComponentLocator.READY);
      }
      
      public function reset() : void
      {
         this.model.items = null;
         this.model.removeEventListener(LootEvent.TAKE_ALL,this.takeAllLoot);
         this.model.removeEventListener(ItemClickEvent.ITEM_CLICK,this.takeLoot);
         ComponentLocator.setComponent(ComponentLocator.LOOT,null);
      }
      
      private function takeLoot(e:ItemClickEvent) : void
      {
         var menuData:Array = null;
         var member:GroupMember = null;
         var menu:Menu = null;
         var item:Item = null;
         if(this.groupModel.lootMiningType == LootMiningType.LEADER)
         {
            menuData = [];
            for each(member in this.groupModel.members)
            {
               menuData.push({
                  "label":member.name,
                  "userId":member.id,
                  "index":e.index
               });
            }
            menu = Menu.createMenu(this.view,menuData);
            menu.addEventListener(MenuEvent.ITEM_CLICK,this.giveLoot);
            menu.show(this.view.stage.mouseX,this.view.stage.mouseY);
         }
         else
         {
            item = e.item as Item;
            this.model.currentTakingLoot = item;
            this.model.currentTakingLootIndex = e.index;
            if(Boolean(item) && Boolean(item.binding == ItemBindingType.ON_ACQUIRE) && item.confirmBinding)
            {
               this.closePopup();
               this.popup = new BindingDialog();
               this.popup.item = item;
               this.popup.action = ItemBindingType.ON_ACQUIRE;
               this.popup.addEventListener(Window.DIALOG_CLOSE,this.closePopup);
               this.popup.addEventListener(LootEvent.CONFIRM,this.popupConfirm);
               PopupManager.addPopup(this.popup,null,true);
               PopupManager.centerPopup(this.popup);
            }
            else
            {
               this.takeLootRequest();
            }
         }
      }
      
      private function popupConfirm(e:Event) : void
      {
         this.closePopup();
         this.takeLootRequest();
      }
      
      private function closePopup(e:Event = null) : void
      {
         if(!this.popup)
         {
            return;
         }
         PopupManager.removePopup(this.popup);
         this.popup = null;
      }
      
      public function init(value:Array) : void
      {
         var boaCount:uint = 0;
         var item:LootItem = null;
         this.model.items = value;
         for each(item in value)
         {
            if(Boolean(item) && Boolean(item.binding == ItemBindingType.ON_ACQUIRE) && item.confirmBinding)
            {
               boaCount++;
            }
         }
         this.model.lootAllEnabled = boaCount < 2;
      }
      
      public function removeLoot(index:int) : void
      {
         var tmp:Array = this.model.items.slice();
         tmp[index] = null;
         this.model.items = tmp;
      }
      
      private function takeLootRequest() : void
      {
         var lootIndex:int = this.model.currentTakingLootIndex;
         ServerLayer.call("lootService","takeLoot",null,null,lootIndex);
      }
      
      private function giveLoot(e:MenuEvent) : void
      {
         ServerLayer.call("lootService","giveLoot",null,null,e.item.index,e.item.userId);
      }
      
      private function takeAllLoot(e:Event) : void
      {
         ServerLayer.call("lootService","takeAllLoot");
      }
   }
}

