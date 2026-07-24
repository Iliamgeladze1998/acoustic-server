package soul.model.common
{
   public class ShortMessage
   {
      
      public var id:String;
      
      public var type:String;
      
      public var params:Array;
      
      public var buttons:Array;
      
      public var defaultButton:int = -1;
      
      public var confirmButton:int = -1;
      
      public var timeOut:uint;
      
      public var characterId:uint;
      
      public var characterName:String;
      
      public var clanId:uint;
      
      public var clanName:String;
      
      public var timer:uint;
      
      public var started:uint;
      
      public function ShortMessage()
      {
         super();
      }
   }
}

