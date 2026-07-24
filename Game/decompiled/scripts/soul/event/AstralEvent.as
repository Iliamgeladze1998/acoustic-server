package soul.event
{
   import flash.events.Event;
   
   public class AstralEvent extends Event
   {
      
      public static const INIT:String = "INIT";
      
      public static const FOCUS:String = "FOCUS";
      
      public static const ESTIMATE:String = "ESTIMATE";
      
      public static const MOVE_TO:String = "MOVE_TO";
      
      public static const ENTER:String = "ENTER";
      
      public static const STOP:String = "STOP";
      
      public static const IMAGE_LOADED:String = "IMAGE_LOADED";
      
      public static const FOCUS_COMLETED:String = "FOCUS_COMLETED";
      
      public static const DRAG:String = "DRAG";
      
      public static const RESIZE:String = "RESIZE";
      
      public static const INSTANT_FOCUS:String = "INSTANT_FOCUS";
      
      public var id:String;
      
      public var x:int;
      
      public var y:int;
      
      public var mode:String;
      
      public function AstralEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

