package soul.model.interaction.lfg
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   
   public class GroupApplication
   {
      
      public var id:Number;
      
      public var leader:LFGUser;
      
      public var members:Array;
      
      public var quests:Array;
      
      public var instances:Array;
      
      public var locations:Array;
      
      public function GroupApplication()
      {
         super();
      }
      
      public function getTooltip() : String
      {
         var id:String = null;
         var tt:String = "";
         if(Boolean(this.quests) && this.quests.length > 0)
         {
            tt += "<font color=\"#00FF00\">" + LocaleManager.getString(BundleName.INTERFACE,"lfg.quests") + "</font>:\n";
            for each(id in this.quests)
            {
               tt += "- " + LocaleManager.getString(BundleName.QUESTS,id) + "<br>";
            }
         }
         if(Boolean(this.instances) && this.instances.length > 0)
         {
            tt += "<font color=\"#00FF00\">" + LocaleManager.getString(BundleName.INTERFACE,"lfg.instances") + "</font>:\n";
            for each(id in this.instances)
            {
               tt += "- " + LocaleManager.getString(BundleName.SECTOR,id) + "<br>";
            }
         }
         if(Boolean(this.locations) && this.locations.length > 0)
         {
            tt += "<font color=\"#00FF00\">" + LocaleManager.getString(BundleName.INTERFACE,"lfg.locations") + "</font>:\n";
            for each(id in this.locations)
            {
               tt += "- " + LocaleManager.getString(BundleName.SECTOR,id) + "<br>";
            }
         }
         return tt;
      }
   }
}

