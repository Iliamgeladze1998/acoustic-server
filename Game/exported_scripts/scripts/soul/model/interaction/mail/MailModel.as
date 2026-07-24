package soul.model.interaction.mail
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class MailModel extends EventDispatcher
   {
      
      private var _10783196mailCost:int;
      
      private var _100344454inbox:Array;
      
      private var _417589379hasNewMail:Boolean;
      
      public function MailModel()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get mailCost() : int
      {
         return this._10783196mailCost;
      }
      
      public function set mailCost(param1:int) : void
      {
         var _loc2_:Object = this._10783196mailCost;
         if(_loc2_ !== param1)
         {
            this._10783196mailCost = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mailCost",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get inbox() : Array
      {
         return this._100344454inbox;
      }
      
      public function set inbox(param1:Array) : void
      {
         var _loc2_:Object = this._100344454inbox;
         if(_loc2_ !== param1)
         {
            this._100344454inbox = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inbox",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hasNewMail() : Boolean
      {
         return this._417589379hasNewMail;
      }
      
      public function set hasNewMail(param1:Boolean) : void
      {
         var _loc2_:Object = this._417589379hasNewMail;
         if(_loc2_ !== param1)
         {
            this._417589379hasNewMail = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hasNewMail",_loc2_,param1));
            }
         }
      }
   }
}

