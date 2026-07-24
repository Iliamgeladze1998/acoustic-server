package soul.model.character
{
   public class CharacterPublicData
   {
      
      public var id:String;
      
      public var name:String;
      
      public var avatarImagePath:String;
      
      public var sex:String;
      
      public var properties:Object;
      
      public var params:Object;
      
      public var side:String;
      
      public var race:String;
      
      public var dispositionGroup:String;
      
      public var disposition:String;
      
      public var reputations:Array;
      
      public var mode:String;
      
      public var subscriptionType:String;
      
      public var subscriptionExpire:Date;
      
      public var subscriptionRenew:Boolean;
      
      public var subscriptionHidden:Boolean;
      
      public var autoSlots:Array;
      
      public function CharacterPublicData()
      {
         super();
      }
   }
}

