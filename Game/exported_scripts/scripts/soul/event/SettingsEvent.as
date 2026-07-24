package soul.event
{
   import flash.events.Event;
   
   public class SettingsEvent extends Event
   {
      
      public static const LIGHTING:String = "LIGHTING";
      
      public static const DAMAGE:String = "DAMAGE";
      
      public static const FOW:String = "FOW";
      
      public static const CAMERA:String = "CAMERA";
      
      public function SettingsEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

