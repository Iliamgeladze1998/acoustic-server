package soul.event
{
   import flash.events.Event;
   import soul.model.interaction.mail.NewMailData;
   
   public class MailEvent extends Event
   {
      
      public static const READ:String = "READ";
      
      public static const TAKE:String = "TAKE";
      
      public static const DELETE:String = "DELETE";
      
      public static const SEND:String = "SEND";
      
      public static const SEND_FAIL:String = "SEND_FAIL";
      
      public static const SEND_SUCCESS:String = "SEND_SUCCESS";
      
      public var newMailData:NewMailData;
      
      public var mailId:String;
      
      public var itemIndex:int;
      
      public function MailEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

