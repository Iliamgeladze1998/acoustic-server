package soul.model.group
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.model.character.CharacterModel;
   import soul.model.field.BaseUnit;
   
   public class GroupModel extends EventDispatcher
   {
      
      private var characterModel:CharacterModel;
      
      private var _488029070lootMiningType:String;
      
      private var _529481073memberCountMax:uint;
      
      private var _948881689members:Array;
      
      private var _1106754295leader:Boolean;
      
      public function GroupModel(characterModel:CharacterModel)
      {
         super();
         this.characterModel = characterModel;
      }
      
      public function load(data:GroupData) : void
      {
         var unit:BaseUnit = null;
         this.lootMiningType = data.lootMiningType;
         this.memberCountMax = data.memberCountMax;
         this.members = data.members;
         this.leaderId = data.leaderId;
         for each(unit in this.members)
         {
            if(unit.id == this.characterModel.id)
            {
               this.characterModel.myUnit = unit;
               break;
            }
         }
      }
      
      public function set leaderId(value:String) : void
      {
         var member:GroupMember = null;
         if(this.characterModel.id == value)
         {
            this.leader = true;
         }
         else
         {
            this.leader = false;
         }
         for each(member in this.members)
         {
            member.leader = member.id == value;
         }
      }
      
      public function getMemberById(id:String) : GroupMember
      {
         var member:GroupMember = null;
         for each(member in this.members)
         {
            if(member.id == id)
            {
               return member;
            }
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get lootMiningType() : String
      {
         return this._488029070lootMiningType;
      }
      
      public function set lootMiningType(param1:String) : void
      {
         var _loc2_:Object = this._488029070lootMiningType;
         if(_loc2_ !== param1)
         {
            this._488029070lootMiningType = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lootMiningType",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get memberCountMax() : uint
      {
         return this._529481073memberCountMax;
      }
      
      public function set memberCountMax(param1:uint) : void
      {
         var _loc2_:Object = this._529481073memberCountMax;
         if(_loc2_ !== param1)
         {
            this._529481073memberCountMax = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"memberCountMax",_loc2_,param1));
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
      public function get leader() : Boolean
      {
         return this._1106754295leader;
      }
      
      public function set leader(param1:Boolean) : void
      {
         var _loc2_:Object = this._1106754295leader;
         if(_loc2_ !== param1)
         {
            this._1106754295leader = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leader",_loc2_,param1));
            }
         }
      }
   }
}

