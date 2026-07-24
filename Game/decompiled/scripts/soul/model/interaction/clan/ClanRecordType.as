package soul.model.interaction.clan
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   
   public class ClanRecordType
   {
      
      private static var filters:Array;
      
      public static const CREATED:String = "CREATED";
      
      public static const JOINED:String = "JOINED";
      
      public static const LEFT:String = "LEFT";
      
      public static const DEPOSIT:String = "DEPOSIT";
      
      public static const FEE:String = "FEE";
      
      public static const EXTENDED:String = "EXTENDED";
      
      public static const ALL_TYPES:Array = [CREATED,JOINED,LEFT,DEPOSIT,FEE,EXTENDED];
      
      public function ClanRecordType()
      {
         super();
      }
      
      public static function getFilters() : Array
      {
         var type:String = null;
         if(!filters)
         {
            filters = [{
               "label":getString("all"),
               "data":"*"
            }];
            for each(type in ALL_TYPES)
            {
               filters.push({
                  "label":getString(type),
                  "data":type
               });
            }
         }
         return filters;
      }
      
      private static function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,"clan.records." + key);
      }
   }
}

