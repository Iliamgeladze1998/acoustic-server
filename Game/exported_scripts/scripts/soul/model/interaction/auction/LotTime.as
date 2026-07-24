package soul.model.interaction.auction
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   
   public class LotTime
   {
      
      public var id:String;
      
      public var timeFee:int;
      
      public var timeFeePercent:Number;
      
      public function LotTime()
      {
         super();
      }
      
      public function get label() : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,this.id);
      }
   }
}

