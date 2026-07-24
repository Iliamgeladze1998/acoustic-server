package soul.model.interaction.dashboard
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class DashboardModel extends EventDispatcher
   {
      
      private var _1591573360entries:Array = [];
      
      private var _1842960245bgEntries:Array = [];
      
      private var _692890728citadelEntries:Array = [];
      
      private var _67358868hasNewEntry:Boolean;
      
      private var _1006382865nearestBgEntry:BattlegroundEntry;
      
      private var _1444732537currentEntry:BattlegroundEntry;
      
      public function DashboardModel()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get entries() : Array
      {
         return this._1591573360entries;
      }
      
      public function set entries(param1:Array) : void
      {
         var _loc2_:Object = this._1591573360entries;
         if(_loc2_ !== param1)
         {
            this._1591573360entries = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"entries",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bgEntries() : Array
      {
         return this._1842960245bgEntries;
      }
      
      public function set bgEntries(param1:Array) : void
      {
         var _loc2_:Object = this._1842960245bgEntries;
         if(_loc2_ !== param1)
         {
            this._1842960245bgEntries = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bgEntries",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get citadelEntries() : Array
      {
         return this._692890728citadelEntries;
      }
      
      public function set citadelEntries(param1:Array) : void
      {
         var _loc2_:Object = this._692890728citadelEntries;
         if(_loc2_ !== param1)
         {
            this._692890728citadelEntries = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"citadelEntries",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hasNewEntry() : Boolean
      {
         return this._67358868hasNewEntry;
      }
      
      public function set hasNewEntry(param1:Boolean) : void
      {
         var _loc2_:Object = this._67358868hasNewEntry;
         if(_loc2_ !== param1)
         {
            this._67358868hasNewEntry = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hasNewEntry",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get nearestBgEntry() : BattlegroundEntry
      {
         return this._1006382865nearestBgEntry;
      }
      
      public function set nearestBgEntry(param1:BattlegroundEntry) : void
      {
         var _loc2_:Object = this._1006382865nearestBgEntry;
         if(_loc2_ !== param1)
         {
            this._1006382865nearestBgEntry = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nearestBgEntry",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentEntry() : BattlegroundEntry
      {
         return this._1444732537currentEntry;
      }
      
      public function set currentEntry(param1:BattlegroundEntry) : void
      {
         var _loc2_:Object = this._1444732537currentEntry;
         if(_loc2_ !== param1)
         {
            this._1444732537currentEntry = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentEntry",_loc2_,param1));
            }
         }
      }
   }
}

