package soul.model.interaction.quest
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import soul.model.condition.Condition;
   import soul.model.interaction.dialog.DialogBranch;
   
   public class QuestEntry extends EventDispatcher
   {
      
      public var questId:String;
      
      public var state:String;
      
      public var description:DialogBranch;
      
      public var subquests:Array;
      
      private var _1067395286tracked:Boolean;
      
      public function QuestEntry()
      {
         super();
      }
      
      public function getConditionById(id:String) : Condition
      {
         var qc:Condition = null;
         if(!this.description)
         {
            return null;
         }
         for each(qc in this.description.requirements)
         {
            if(qc.id == id)
            {
               return qc;
            }
         }
         return null;
      }
      
      [Bindable(event="propertyChange")]
      public function get tracked() : Boolean
      {
         return this._1067395286tracked;
      }
      
      public function set tracked(param1:Boolean) : void
      {
         var _loc2_:Object = this._1067395286tracked;
         if(_loc2_ !== param1)
         {
            this._1067395286tracked = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tracked",_loc2_,param1));
            }
         }
      }
   }
}

