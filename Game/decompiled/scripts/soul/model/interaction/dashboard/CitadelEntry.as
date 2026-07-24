package soul.model.interaction.dashboard
{
   import soul.model.system.Configuration;
   import soul.utils.DateUtils;
   import soul.utils.NumberUtils;
   import soul.view.assets.Colors;
   import soul.view.assets.GradientLabel;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class CitadelEntry extends DashboardEntry
   {
      
      public static const citadel:Class = CitadelEntry_citadel;
      
      public var clanId:Number;
      
      public var clanName:String;
      
      public var siegeDuration:Number;
      
      public function CitadelEntry()
      {
         super();
      }
      
      override public function get icon() : Object
      {
         return citadel;
      }
      
      override public function getDescriptors() : Vector.<Component>
      {
         var ret:Vector.<Component> = null;
         var label:GradientLabel = null;
         ret = new Vector.<Component>();
         var txt:String = getString("ownerClan") + ": " + (Boolean(this.clanName) ? this.clanName : "---");
         var clientSiegeDate:Date = new Date(Configuration.serverTimeToLocal(date.time));
         var formattedDate:String = NumberUtils.addZero(clientSiegeDate.hours) + ":" + NumberUtils.addZero(clientSiegeDate.minutes) + " " + NumberUtils.addZero(clientSiegeDate.date) + "." + NumberUtils.addZero(clientSiegeDate.month + 1) + "." + clientSiegeDate.fullYear;
         txt += "<br>" + getString("siegeDate") + ": " + formattedDate;
         txt += "<br>" + getString("siegeDuration") + ": " + DateUtils.getTimeLeft(this.siegeDuration);
         var description:Label = new Label();
         description.color = Colors.LABEL;
         description.multiline = true;
         description.wordWrap = true;
         description.percentWidth = 100;
         description.htmlText = txt;
         ret.push(description);
         label = new GradientLabel();
         label.color = Colors.PLUSES;
         label.bgPaddingLeft = -5;
         label.bold = true;
         label.percentWidth = 100;
         label.height = 20;
         label.text = getString("citadel.bonuses") + ":";
         ret.push(label);
         var bonuses:Label = new Label();
         bonuses.color = Colors.LABEL;
         bonuses.multiline = true;
         bonuses.wordWrap = true;
         bonuses.percentWidth = 100;
         bonuses.htmlText = getEvent(localeId + ".bonuses");
         ret.push(bonuses);
         return ret.concat(super.getDescriptors());
      }
   }
}

