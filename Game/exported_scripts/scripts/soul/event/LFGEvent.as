package soul.event
{
   import flash.events.Event;
   
   public class LFGEvent extends Event
   {
      
      public static const GET_RECORDS:String = "GET_RECORDS";
      
      public static const GET_APPLICATIONS:String = "GET_APPLICATIONS";
      
      public static const SUBSCRIBE:String = "SUBSCRIBE";
      
      public static const UNSUBSCRIBE:String = "UNSUBSCRIBE";
      
      public static const JOIN:String = "JOIN";
      
      public var applicationId:Number;
      
      public var applicationType:String;
      
      public var criteriaId:String;
      
      public var questIds:Array;
      
      public var instanceIds:Array;
      
      public var locationIds:Array;
      
      public function LFGEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

