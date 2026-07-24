package soul.controller.group
{
   import flash.utils.describeType;
   import soul.controller.IManager;
   import soul.event.GroupEvent;
   import soul.model.field.StatType;
   import soul.model.group.GroupData;
   import soul.model.group.GroupMember;
   import soul.model.group.GroupModel;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   
   public class GroupManager implements IManager
   {
      
      private var model:GroupModel;
      
      public function GroupManager(value:GroupModel)
      {
         super();
         this.model = value;
         ComponentLocator.setComponent(ComponentLocator.GROUP,this);
         this.model.addEventListener(GroupEvent.INVITE,this.inviteMember);
         this.model.addEventListener(GroupEvent.PROMOTE,this.promoteMember);
         this.model.addEventListener(GroupEvent.REMOVE,this.requestRemoveMember);
         this.model.addEventListener(GroupEvent.LOOT_MINING,this.changeLootMining);
         ServerLayer.call("groupService",ComponentLocator.READY);
      }
      
      private static function sortFunction(a:GroupMember, b:GroupMember) : int
      {
         if(a.leader && !b.leader)
         {
            return -1;
         }
         if(!a.leader && b.leader)
         {
            return 1;
         }
         if(a.online && !b.online)
         {
            return -1;
         }
         if(!a.online && b.online)
         {
            return 1;
         }
         if(a.stats[StatType.LEVEL] > b.stats[StatType.LEVEL])
         {
            return -1;
         }
         if(a.stats[StatType.LEVEL] < b.stats[StatType.LEVEL])
         {
            return 1;
         }
         return 0;
      }
      
      public function reset() : void
      {
         this.model.removeEventListener(GroupEvent.INVITE,this.inviteMember);
         this.model.removeEventListener(GroupEvent.PROMOTE,this.promoteMember);
         this.model.removeEventListener(GroupEvent.REMOVE,this.requestRemoveMember);
         this.model.removeEventListener(GroupEvent.LOOT_MINING,this.changeLootMining);
      }
      
      private function changeLootMining(e:GroupEvent) : void
      {
         ServerLayer.call("groupService","changeLootMining",null,this.fault,e.data as String);
      }
      
      private function inviteMember(e:GroupEvent) : void
      {
         ServerLayer.call("groupService","inviteMember",null,this.fault,e.data as String);
      }
      
      private function promoteMember(e:GroupEvent) : void
      {
         ServerLayer.call("groupService","promote",null,this.fault,e.data);
      }
      
      private function requestRemoveMember(e:GroupEvent) : void
      {
         ServerLayer.call("groupService","removeMember",null,this.fault,e.data as String);
      }
      
      private function fault(fault:Object = null) : void
      {
      }
      
      public function init(value:GroupData) : void
      {
         this.model.load(value);
         this.sortMembers();
      }
      
      public function changeGroupProperty(prop:String, value:Object) : void
      {
         this.model[prop] = value;
         if(prop == "leaderId")
         {
            this.sortMembers();
         }
      }
      
      public function addMember(member:GroupMember) : void
      {
         var members:Array = this.model.members;
         members.push(member);
         this.sortMembers();
      }
      
      public function removeMember(memberId:String) : void
      {
         var i:String = null;
         var members:Array = this.model.members;
         for(i in members)
         {
            if(GroupMember(members[i]).id == memberId)
            {
               members.splice(int(i),1);
            }
         }
         this.model.members = null;
         this.model.members = members;
      }
      
      public function changeMemberStat(id:String, statType:String, value:int) : void
      {
         var member:GroupMember = null;
         var members:Array = this.model.members;
         for each(member in members)
         {
            if(member.id == id)
            {
               member.stats[statType] = value;
               break;
            }
         }
         if(statType == StatType.LEVEL)
         {
            this.sortMembers();
         }
      }
      
      public function changeMemberProperty(id:String, property:String, value:Object) : void
      {
         var member:GroupMember = null;
         for each(member in this.model.members)
         {
            if(member.id == id)
            {
               member[property] = value;
               break;
            }
         }
         if(property == "online")
         {
            this.sortMembers();
         }
      }
      
      public function changeMember(newMember:GroupMember) : void
      {
         var member:GroupMember = null;
         var props:XMLList = null;
         var key:String = null;
         for each(member in this.model.members)
         {
            if(member.id == newMember.id)
            {
               props = describeType(member).accessor.@name;
               for each(key in props)
               {
                  member[key] = newMember[key];
               }
               return;
            }
         }
      }
      
      private function sortMembers() : void
      {
         var members:Array = this.model.members;
         members.sort(sortFunction);
         this.model.members = null;
         this.model.members = members;
      }
   }
}

