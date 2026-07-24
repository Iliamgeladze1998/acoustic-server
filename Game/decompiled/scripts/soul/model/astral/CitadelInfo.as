package soul.model.astral
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.system.Configuration;
   import soul.utils.DateUtils;
   import soul.utils.NumberUtils;
   
   public class CitadelInfo
   {
      
      private static const bundles:Array = [BundleName.TOOLTIP,BundleName.INTERFACE];
      
      public var clanId:Number;
      
      public var clanName:String;
      
      public var assault:Boolean;
      
      public var siegeDate:Number;
      
      public var siegeDuration:Number;
      
      public function CitadelInfo()
      {
         super();
      }
      
      public function getDescription() : String
      {
         var clientSiegeDate:Date = null;
         var formattedDate:String = null;
         var txt:String = "";
         txt += this.getString("ownerClan") + ": <font color=\'#00FF00\'>" + (Boolean(this.clanName) ? this.clanName : "---") + "</font>";
         txt += "<br>" + this.getString("assaultStatus") + ": " + this.getString(this.assault ? "assaultActive" : "assaultNotActive");
         if(this.siegeDate > 0)
         {
            clientSiegeDate = new Date(Configuration.serverTimeToLocal(this.siegeDate));
            formattedDate = NumberUtils.addZero(clientSiegeDate.hours) + ":" + NumberUtils.addZero(clientSiegeDate.minutes) + " " + NumberUtils.addZero(clientSiegeDate.date) + "." + NumberUtils.addZero(clientSiegeDate.month + 1) + "." + clientSiegeDate.fullYear;
            txt += "<br>" + this.getString("siegeDate") + ": <font color=\'#00FF00\'>" + formattedDate + "</font>";
            txt += "<br>" + this.getString("siegeDuration") + ": <font color=\'#00FF00\'>" + DateUtils.getTimeLeft(this.siegeDuration) + "</font>";
         }
         return txt;
      }
      
      protected function getString(key:String) : String
      {
         var bundle:String = null;
         var str:String = null;
         for each(bundle in bundles)
         {
            str = LocaleManager.getString(bundle,key);
            if(str != key)
            {
               return str;
            }
         }
         return key;
      }
   }
}

