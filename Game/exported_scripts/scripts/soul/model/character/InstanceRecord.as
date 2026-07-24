package soul.model.character
{
   import soul.model.system.Configuration;
   
   public class InstanceRecord
   {
      
      public var sectorId:String;
      
      public var time:Number;
      
      public function InstanceRecord()
      {
         super();
      }
      
      public function get timeLeft() : Number
      {
         var realTime:Number = Configuration.serverTimeToLocal(this.time);
         return realTime - new Date().time;
      }
   }
}

