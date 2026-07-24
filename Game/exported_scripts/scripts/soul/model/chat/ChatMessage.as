package soul.model.chat
{
   public class ChatMessage extends Message
   {
      
      public var tab:String;
      
      public var sender:String;
      
      public var recipients:Array;
      
      public function ChatMessage()
      {
         super();
      }
   }
}

