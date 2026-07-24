package soul.model.chat
{
   public class ChatUserStatus
   {
      
      public static const ADM:String = "ADM";
      
      public static const MOD:String = "MOD";
      
      public static const HLP:String = "HLP";
      
      private static const colors:Array = [];
      
      colors[ADM] = "#FF0000";
      colors[MOD] = "#00FF00";
      colors[HLP] = "#0077FF";
      
      public function ChatUserStatus()
      {
         super();
      }
      
      public static function getColor(status:String) : String
      {
         return colors[status];
      }
   }
}

