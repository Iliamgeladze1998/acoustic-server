package soul.model.interaction.auction
{
   import soul.model.item.InvKey;
   
   public class CreateLotData
   {
      
      public var itemKey:InvKey;
      
      public var quantity:int;
      
      public var currency:String;
      
      public var startPrice:int;
      
      public var buyNowPrice:int;
      
      public var lotTimeId:String;
      
      public function CreateLotData()
      {
         super();
      }
   }
}

