package soul.view.interaction.clan
{
   import soul.model.interaction.clan.ClanRecord;
   import soul.view.ui.Label;
   
   public class ClanRecordRenderer extends Label
   {
      
      public function ClanRecordRenderer()
      {
         super();
         percentWidth = 100;
      }
      
      public function set record(value:ClanRecord) : void
      {
         htmlText = value.toString();
      }
   }
}

