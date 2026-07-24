package soul.model.interaction.clan
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.utils.DateUtils;
   
   public class ClanRecord
   {
      
      private static const DATE_TEMPLATE:String = "Y/m/d HH:i";
      
      public var params:Object;
      
      public function ClanRecord()
      {
         super();
      }
      
      public function get type() : String
      {
         return this.params["type"];
      }
      
      public function get date() : Number
      {
         return this.params["stamp"];
      }
      
      public function toString() : String
      {
         var key:String = null;
         var ret:String = LocaleManager.getString(BundleName.CLAN_LOG,this.type);
         var time:String = DateUtils.formatDate(DATE_TEMPLATE,new Date(this.date));
         for(key in this.params)
         {
            ret = ret.replace("{" + key + "}",this.params[key]);
         }
         return time + " " + ret;
      }
   }
}

