package soul.model.achievement
{
   import flash.events.EventDispatcher;
   import soul.model.condition.Condition;
   
   [Event(name="change",type="flash.events.Event")]
   public class Achievement extends EventDispatcher
   {
      
      public var id:String;
      
      public var imagePath:String;
      
      public var conditions:Array;
      
      public var rewards:Array;
      
      public var metaRewards:Array;
      
      public var completeDate:Number;
      
      public var points:uint;
      
      public var tracked:Boolean;
      
      public function Achievement()
      {
         super();
      }
      
      public function getConditionById(conditionId:String) : Condition
      {
         var condition:Condition = null;
         for each(condition in this.conditions)
         {
            if(condition.id == conditionId)
            {
               return condition;
            }
         }
         return null;
      }
   }
}

