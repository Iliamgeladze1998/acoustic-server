package soul.model.interaction.clan
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class ClanModel extends EventDispatcher
   {
      
      private var _3355id:Number;
      
      private var _3373707name:String;
      
      private var _948881689members:Array;
      
      private var _2122818325maxMembers:uint;
      
      private var _1585515340creationCost:uint;
      
      private var _2132418659changeCost:uint;
      
      private var _1197581942inviteCost:uint;
      
      private var _920168456rubies:uint;
      
      private var _1376866566roleMap:Object;
      
      private var _1967634944sortedRoles:Array;
      
      private var _618239529clanBonuses:Array;
      
      private var _1465029357memberBonuses:Array;
      
      private var _982754077points:uint;
      
      private var _107332log:Array;
      
      private var _1884274053storage:Array;
      
      private var _992373914myMember:ClanMember;
      
      private var _myPlayerId:String;
      
      public function ClanModel()
      {
         super();
      }
      
      public function load(data:ClanData) : void
      {
         var roleName:String = null;
         var found:ClanMember = null;
         var member:ClanMember = null;
         var role:ClanRole = null;
         var clanRole:ClanRole = null;
         this.id = data.id;
         this.name = data.name;
         this.members = data.members;
         this.maxMembers = data.maxMembers;
         this.creationCost = data.creationCost;
         this.changeCost = data.changeCost;
         this.inviteCost = data.inviteCost;
         this.rubies = data.rubies;
         this.roleMap = data.roles;
         var sorted:Array = [];
         for(roleName in this.roleMap)
         {
            role = this.roleMap[roleName];
            sorted.push(role);
         }
         sorted.sortOn("priority");
         this.sortedRoles = sorted;
         this.clanBonuses = data.clanBonuses;
         this.memberBonuses = data.memberBonuses;
         this.points = data.points;
         this.log = data.log;
         this.storage = data.storage;
         for each(member in this.members)
         {
            clanRole = this.roleMap[member.role];
            if(Boolean(clanRole))
            {
               member.clanRole = clanRole;
            }
            if(member.id == this._myPlayerId)
            {
               found = member;
            }
         }
         this.myMember = found;
      }
      
      public function set myPlayerId(value:String) : void
      {
         var found:ClanMember = null;
         var member:ClanMember = null;
         this._myPlayerId = value;
         for each(member in this.members)
         {
            if(member.id == this._myPlayerId)
            {
               found = member;
               break;
            }
         }
         this.myMember = found;
      }
      
      public function addMember(member:ClanMember) : void
      {
         member.clanRole = this.roleMap[member.role];
         var arr:Array = this.members;
         arr.push(member);
         this.members = null;
         this.members = arr;
      }
      
      public function getSackByRole(role:String) : ClanSack
      {
         var sack:ClanSack = null;
         for each(sack in this.storage)
         {
            if(sack.role == role)
            {
               return sack;
            }
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get id() : Number
      {
         return this._3355id;
      }
      
      public function set id(param1:Number) : void
      {
         var _loc2_:Object = this._3355id;
         if(_loc2_ !== param1)
         {
            this._3355id = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"id",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get name() : String
      {
         return this._3373707name;
      }
      
      public function set name(param1:String) : void
      {
         var _loc2_:Object = this._3373707name;
         if(_loc2_ !== param1)
         {
            this._3373707name = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"name",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get members() : Array
      {
         return this._948881689members;
      }
      
      public function set members(param1:Array) : void
      {
         var _loc2_:Object = this._948881689members;
         if(_loc2_ !== param1)
         {
            this._948881689members = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"members",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get maxMembers() : uint
      {
         return this._2122818325maxMembers;
      }
      
      public function set maxMembers(param1:uint) : void
      {
         var _loc2_:Object = this._2122818325maxMembers;
         if(_loc2_ !== param1)
         {
            this._2122818325maxMembers = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxMembers",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get creationCost() : uint
      {
         return this._1585515340creationCost;
      }
      
      public function set creationCost(param1:uint) : void
      {
         var _loc2_:Object = this._1585515340creationCost;
         if(_loc2_ !== param1)
         {
            this._1585515340creationCost = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"creationCost",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get changeCost() : uint
      {
         return this._2132418659changeCost;
      }
      
      public function set changeCost(param1:uint) : void
      {
         var _loc2_:Object = this._2132418659changeCost;
         if(_loc2_ !== param1)
         {
            this._2132418659changeCost = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"changeCost",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get inviteCost() : uint
      {
         return this._1197581942inviteCost;
      }
      
      public function set inviteCost(param1:uint) : void
      {
         var _loc2_:Object = this._1197581942inviteCost;
         if(_loc2_ !== param1)
         {
            this._1197581942inviteCost = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inviteCost",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rubies() : uint
      {
         return this._920168456rubies;
      }
      
      public function set rubies(param1:uint) : void
      {
         var _loc2_:Object = this._920168456rubies;
         if(_loc2_ !== param1)
         {
            this._920168456rubies = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rubies",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get roleMap() : Object
      {
         return this._1376866566roleMap;
      }
      
      public function set roleMap(param1:Object) : void
      {
         var _loc2_:Object = this._1376866566roleMap;
         if(_loc2_ !== param1)
         {
            this._1376866566roleMap = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"roleMap",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get sortedRoles() : Array
      {
         return this._1967634944sortedRoles;
      }
      
      public function set sortedRoles(param1:Array) : void
      {
         var _loc2_:Object = this._1967634944sortedRoles;
         if(_loc2_ !== param1)
         {
            this._1967634944sortedRoles = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sortedRoles",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clanBonuses() : Array
      {
         return this._618239529clanBonuses;
      }
      
      public function set clanBonuses(param1:Array) : void
      {
         var _loc2_:Object = this._618239529clanBonuses;
         if(_loc2_ !== param1)
         {
            this._618239529clanBonuses = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clanBonuses",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get memberBonuses() : Array
      {
         return this._1465029357memberBonuses;
      }
      
      public function set memberBonuses(param1:Array) : void
      {
         var _loc2_:Object = this._1465029357memberBonuses;
         if(_loc2_ !== param1)
         {
            this._1465029357memberBonuses = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"memberBonuses",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get points() : uint
      {
         return this._982754077points;
      }
      
      public function set points(param1:uint) : void
      {
         var _loc2_:Object = this._982754077points;
         if(_loc2_ !== param1)
         {
            this._982754077points = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"points",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get log() : Array
      {
         return this._107332log;
      }
      
      public function set log(param1:Array) : void
      {
         var _loc2_:Object = this._107332log;
         if(_loc2_ !== param1)
         {
            this._107332log = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"log",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get storage() : Array
      {
         return this._1884274053storage;
      }
      
      public function set storage(param1:Array) : void
      {
         var _loc2_:Object = this._1884274053storage;
         if(_loc2_ !== param1)
         {
            this._1884274053storage = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"storage",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get myMember() : ClanMember
      {
         return this._992373914myMember;
      }
      
      public function set myMember(param1:ClanMember) : void
      {
         var _loc2_:Object = this._992373914myMember;
         if(_loc2_ !== param1)
         {
            this._992373914myMember = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"myMember",_loc2_,param1));
            }
         }
      }
   }
}

