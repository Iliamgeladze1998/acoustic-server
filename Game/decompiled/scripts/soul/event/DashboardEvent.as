package soul.event
{
   import flash.events.Event;
   import soul.model.interaction.dashboard.DashboardEntry;
   
   public class DashboardEvent extends Event
   {
      
      public static const GET_ENTRIES:String = "GET_ENTRIES";
      
      public static const JOIN:String = "JOIN";
      
      public static const LEAVE:String = "LEAVE";
      
      public var entry:DashboardEntry;
      
      public function DashboardEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

