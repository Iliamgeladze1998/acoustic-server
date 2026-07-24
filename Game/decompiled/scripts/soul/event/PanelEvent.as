package soul.event
{
   import flash.events.Event;
   
   public class PanelEvent extends Event
   {
      
      public static const CREATE_SHORTCUT:String = "CREATE_SHORTCUT";
      
      public static const REMOVE_SHORTCUT:String = "REMOVE_SHORTCUT";
      
      public var id:String;
      
      public var index:int;
      
      public var panel:int;
      
      public function PanelEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

