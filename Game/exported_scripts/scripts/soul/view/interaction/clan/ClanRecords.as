package soul.view.interaction.clan
{
   import soul.model.interaction.clan.ClanRecord;
   import soul.view.ui.ScrollBase;
   import soul.view.ui.ScrollPolicy;
   import soul.view.ui.VBox;
   
   public class ClanRecords extends ScrollBase
   {
      
      private var box:VBox = new VBox();
      
      private var _filter:String;
      
      private var _dataProvider:Array;
      
      public function ClanRecords()
      {
         super();
         verticalScrollPolicy = ScrollPolicy.AUTO;
         this.box.percentWidth = 100;
         addChild(this.box);
      }
      
      public function set filter(value:String) : void
      {
         if(value == "*")
         {
            value = null;
         }
         if(value == this._filter)
         {
            return;
         }
         this._filter = value;
         this.redrawRecords();
      }
      
      public function set dataProvider(value:Array) : void
      {
         if(this._dataProvider == value)
         {
            return;
         }
         this._dataProvider = value;
         this.redrawRecords();
      }
      
      private function redrawRecords() : void
      {
         var record:ClanRecord = null;
         var child:ClanRecordRenderer = null;
         this.box.removeAllChildren();
         for each(record in this._dataProvider)
         {
            if(!this._filter || this._filter == record.type)
            {
               child = new ClanRecordRenderer();
               child.record = record;
               this.box.addChild(child);
            }
         }
      }
   }
}

