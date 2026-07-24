package soul.model.group
{
   import mx.events.PropertyChangeEvent;
   import soul.model.field.BaseUnit;
   
   public class GroupMember extends BaseUnit
   {
      
      private var _113766sex:String;
      
      private var _583380919disposition:String;
      
      private var _1012222381online:Boolean;
      
      private var _103663511mapId:String;
      
      private var _948117281sectorId:String;
      
      private var _1106754295leader:Boolean;
      
      public function GroupMember()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get sex() : String
      {
         return this._113766sex;
      }
      
      public function set sex(param1:String) : void
      {
         var _loc2_:Object = this._113766sex;
         if(_loc2_ !== param1)
         {
            this._113766sex = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sex",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get disposition() : String
      {
         return this._583380919disposition;
      }
      
      public function set disposition(param1:String) : void
      {
         var _loc2_:Object = this._583380919disposition;
         if(_loc2_ !== param1)
         {
            this._583380919disposition = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"disposition",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get online() : Boolean
      {
         return this._1012222381online;
      }
      
      public function set online(param1:Boolean) : void
      {
         var _loc2_:Object = this._1012222381online;
         if(_loc2_ !== param1)
         {
            this._1012222381online = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"online",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mapId() : String
      {
         return this._103663511mapId;
      }
      
      public function set mapId(param1:String) : void
      {
         var _loc2_:Object = this._103663511mapId;
         if(_loc2_ !== param1)
         {
            this._103663511mapId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mapId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get sectorId() : String
      {
         return this._948117281sectorId;
      }
      
      public function set sectorId(param1:String) : void
      {
         var _loc2_:Object = this._948117281sectorId;
         if(_loc2_ !== param1)
         {
            this._948117281sectorId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sectorId",_loc2_,param1));
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

