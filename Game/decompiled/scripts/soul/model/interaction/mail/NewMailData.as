package soul.model.interaction.mail
{
   import soul.model.item.InvKey;
   
   public class NewMailData
   {
      
      public var to:String;
      
      public var subject:String;
      
      public var body:String;
      
      public var item:InvKey;
      
      public var copper:uint;
      
      public function NewMailData()
      {
         super();
      }
   }
}

