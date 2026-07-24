package soul.model.chat
{
   public class ClientMessage
   {
      
      public var text:String;
      
      public var tab:String;
      
      public function ClientMessage(text:String, tab:String)
      {
         super();
         this.text = text;
         this.tab = tab;
      }
      
      public function toString() : String
      {
         return "Tab: " + this.tab + ", text: " + this.text;
      }
   }
}

