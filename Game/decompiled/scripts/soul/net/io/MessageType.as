package soul.net.io
{
   public class MessageType
   {
      
      public static const PING:uint = 0;
      
      public static const PONG:uint = 1;
      
      public static const AUTH_REQUEST:uint = 2;
      
      public static const AUTH_RESPONSE:uint = 3;
      
      public static const COMMAND:uint = 4;
      
      public static const RPC_REQUEST:uint = 5;
      
      public static const RPC_RESPONSE:uint = 6;
      
      public function MessageType()
      {
         super();
      }
   }
}

