package soul.controller.interaction
{
   import flash.events.Event;
   import mx.binding.utils.BindingUtils;
   import mx.binding.utils.ChangeWatcher;
   import mx.events.PropertyChangeEvent;
   import soul.controller.IManager;
   import soul.controller.Interaction;
   import soul.event.ClanEvent;
   import soul.model.character.CharacterModel;
   import soul.model.common.InteractionType;
   import soul.model.interaction.clan.ClanBonus;
   import soul.model.interaction.clan.ClanCreationData;
   import soul.model.interaction.clan.ClanData;
   import soul.model.interaction.clan.ClanMember;
   import soul.model.interaction.clan.ClanModel;
   import soul.model.interaction.clan.ClanRecord;
   import soul.model.interaction.clan.ClanSack;
   import soul.model.inventory.InventoryModel;
   import soul.model.item.InvKey;
   import soul.model.item.Item;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   
   public class ClanManager implements IManager
   {
      
      private static const service:String = "clanService";
      
      private var model:ClanModel;
      
      private var characterModel:CharacterModel;
      
      private var inventoryModel:InventoryModel;
      
      private var cw:ChangeWatcher;
      
      public function ClanManager(model:ClanModel, characterModel:CharacterModel, inventoryModel:InventoryModel)
      {
         super();
         this.model = model;
         this.characterModel = characterModel;
         this.inventoryModel = inventoryModel;
         ComponentLocator.setComponent(ComponentLocator.CLAN,this);
         model.addEventListener(ClanEvent.CREATE_CLAN,this.onCreateClan);
         model.addEventListener(ClanEvent.CHANGE_CLAN,this.onChangeClan);
         model.addEventListener(ClanEvent.INVITE_CONFIRM,this.onInvite);
         model.addEventListener(ClanEvent.KICK_CONFIRM,this.onKick);
         model.addEventListener(ClanEvent.STATUS_CONFIRM,this.onStatus);
         model.addEventListener(ClanEvent.DEPOSIT_CONFIRM,this.onDeposit);
         model.addEventListener(ClanEvent.BUY_BONUS,this.onBuyBonus);
         model.addEventListener(ClanEvent.STORE_ITEM,this.onStoreItem);
         model.addEventListener(ClanEvent.TAKE_ITEM,this.onTakeItem);
         inventoryModel.addEventListener(ClanEvent.TAKE_ITEM,this.onTakeItem);
         this.cw = BindingUtils.bindSetter(this.myIdChanged,characterModel,"id",false,true);
         ServerLayer.call(service,ComponentLocator.READY);
      }
      
      public function reset() : void
      {
         ComponentLocator.setComponent(ComponentLocator.CLAN,null);
         this.model.removeEventListener(ClanEvent.CREATE_CLAN,this.onCreateClan);
         this.model.removeEventListener(ClanEvent.CHANGE_CLAN,this.onChangeClan);
         this.model.removeEventListener(ClanEvent.INVITE_CONFIRM,this.onInvite);
         this.model.removeEventListener(ClanEvent.KICK_CONFIRM,this.onKick);
         this.model.removeEventListener(ClanEvent.STATUS_CONFIRM,this.onStatus);
         this.model.removeEventListener(ClanEvent.DEPOSIT_CONFIRM,this.onDeposit);
         this.model.removeEventListener(ClanEvent.BUY_BONUS,this.onBuyBonus);
         this.model.removeEventListener(ClanEvent.STORE_ITEM,this.onStoreItem);
         this.model.removeEventListener(ClanEvent.TAKE_ITEM,this.onTakeItem);
         if(Boolean(this.cw))
         {
            this.cw.unwatch();
         }
      }
      
      private function myIdChanged(value:String) : void
      {
         this.model.myPlayerId = value;
      }
      
      public function init(data:ClanData) : void
      {
         this.model.load(data);
         Interaction.hide(InteractionType.CLAN);
      }
      
      public function addMember(member:ClanMember) : void
      {
         this.model.addMember(member);
      }
      
      public function removeMember(memberId:String) : void
      {
         var arr:Array = this.model.members;
         arr.splice(arr.indexOf(this.getMemberById(memberId)),1);
         this.model.members = null;
         this.model.members = arr;
      }
      
      public function changeMember(memberId:String, property:String, value:Object) : void
      {
         var member:ClanMember = this.getMemberById(memberId);
         member[property] = value;
         if(property == "role")
         {
            member.clanRole = this.model.roleMap[value];
            member.dispatchEvent(new Event("clanRoleChanged"));
         }
         member.dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE));
      }
      
      public function changeClan(property:String, value:Object) : void
      {
         this.model[property] = value;
      }
      
      public function changeBonus(id:String, rank:int, cost:uint) : void
      {
         var bonus:ClanBonus = this.getBonusById(id);
         if(!bonus)
         {
            return;
         }
         bonus.rank = rank;
         bonus.cost = cost;
      }
      
      public function addClanRecord(record:ClanRecord) : void
      {
         var log:Array = this.model.log || [];
         log.push(record);
         this.model.log = null;
         this.model.log = log;
      }
      
      public function changeStorageItem(role:String, index:int, item:Item) : void
      {
         var sack:ClanSack = this.model.getSackByRole(role);
         if(!sack)
         {
            return;
         }
         sack.changeItem(index,item);
      }
      
      private function onCreateClan(e:ClanEvent) : void
      {
         var data:ClanCreationData = e.data;
         ServerLayer.call(service,"createClan",null,null,data);
      }
      
      private function onChangeClan(e:ClanEvent) : void
      {
         var data:ClanCreationData = e.data;
         ServerLayer.call(service,"changeClan",null,null,data);
      }
      
      private function onInvite(e:ClanEvent) : void
      {
         var nick:String = e.data[0];
         var rubies:uint = uint(e.data[1]);
         ServerLayer.call(service,"inviteMember",null,null,nick,rubies);
      }
      
      private function onKick(e:ClanEvent) : void
      {
         var id:String = e.data;
         ServerLayer.call(service,"removeMember",null,null,id);
      }
      
      private function onStatus(e:ClanEvent) : void
      {
         var id:String = e.data[0];
         var status:String = e.data[1];
         ServerLayer.call(service,"changeMember",null,null,id,status);
      }
      
      private function onDeposit(e:ClanEvent) : void
      {
         ServerLayer.call(service,"deposit",null,null,e.data);
      }
      
      private function onBuyBonus(e:ClanEvent) : void
      {
         ServerLayer.call(service,"buy",null,null,e.data);
      }
      
      private function onStoreItem(e:ClanEvent) : void
      {
         var sack:String = e.data[0];
         var index:int = int(e.data[1]);
         var key:InvKey = e.data[2];
         ServerLayer.call(service,"store",null,null,sack,index,key);
      }
      
      private function onTakeItem(e:ClanEvent) : void
      {
         var sack:String = e.data[0];
         var index:int = int(e.data[1]);
         var key:InvKey = e.data[2];
         ServerLayer.call(service,"take",null,null,sack,index,key);
      }
      
      private function getMemberById(id:String) : ClanMember
      {
         var member:ClanMember = null;
         for each(member in this.model.members)
         {
            if(member.id == id)
            {
               return member;
            }
         }
         return null;
      }
      
      private function getBonusById(id:String) : ClanBonus
      {
         var bonus:ClanBonus = null;
         for each(bonus in this.model.clanBonuses)
         {
            if(bonus.id == id)
            {
               return bonus;
            }
         }
         for each(bonus in this.model.memberBonuses)
         {
            if(bonus.id == id)
            {
               return bonus;
            }
         }
         return null;
      }
   }
}

