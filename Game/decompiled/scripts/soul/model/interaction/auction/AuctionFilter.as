package soul.model.interaction.auction
{
   public class AuctionFilter
   {
      
      public var minLevel:int = -1;
      
      public var maxLevel:int = -1;
      
      public var itemType:String;
      
      public var itemClass:String;
      
      public var indexFrom:int;
      
      public var count:int;
      
      public function AuctionFilter()
      {
         super();
      }
   }
}

