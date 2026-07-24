package air.update.states
{
   import flash.events.Event;
   
   [ExcludeClass]
   public class HSMEvent extends Event
   {
      
      public static const ENTER:String = "enter";
      
      public static const EXIT:String = "exit";
      
      public function HSMEvent(type:String)
      {
         super(type);
      }
   }
}

