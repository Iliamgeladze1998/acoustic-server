package soul.controller.interaction
{
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import soul.controller.IManager;
   import soul.event.DashboardEvent;
   import soul.model.interaction.dashboard.BattlegroundEntry;
   import soul.model.interaction.dashboard.CitadelEntry;
   import soul.model.interaction.dashboard.DashboardEntry;
   import soul.model.interaction.dashboard.DashboardModel;
   import soul.model.system.Configuration;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   
   public class DashboardManager implements IManager
   {
      
      public static const SERVICE:String = "dashboardService";
      
      private var model:DashboardModel;
      
      private var updateTimeout:uint;
      
      public function DashboardManager(model:DashboardModel)
      {
         super();
         this.model = model;
         ComponentLocator.setComponent(ComponentLocator.DASHBOARD,this);
         ServerLayer.call(SERVICE,ComponentLocator.READY);
         model.addEventListener(DashboardEvent.GET_ENTRIES,this.getEntries);
         model.addEventListener(DashboardEvent.JOIN,this.join);
         model.addEventListener(DashboardEvent.LEAVE,this.leave);
      }
      
      public function init() : void
      {
         this.getEntries(null);
      }
      
      private function getEntries(e:DashboardEvent) : void
      {
         ServerLayer.call(SERVICE,"getEntries",this.setEntries);
      }
      
      public function setEntries(r:Array) : void
      {
         var e:DashboardEntry = null;
         var nearestEntry:DashboardEntry = null;
         var bge:BattlegroundEntry = null;
         var delay:Number = NaN;
         this.model.entries = r;
         var bg:Array = [];
         var citadels:Array = [];
         var hasNewEntry:Boolean = false;
         for each(e in r)
         {
            if(e.active)
            {
               hasNewEntry = true;
            }
            if(e is BattlegroundEntry)
            {
               bge = e as BattlegroundEntry;
               bg.push(e);
            }
            else if(e is CitadelEntry)
            {
               citadels.push(e);
            }
         }
         this.model.bgEntries = bg;
         this.model.citadelEntries = citadels;
         this.model.hasNewEntry = hasNewEntry;
         clearTimeout(this.updateTimeout);
         nearestEntry = bg[0];
         if(Boolean(nearestEntry))
         {
            delay = Configuration.serverDateToLocal(nearestEntry.date).time - new Date().time + 10000;
            if(delay > 0)
            {
               this.updateTimeout = setTimeout(this.getEntries,delay,null);
            }
         }
         this.findNearestJoined();
      }
      
      private function findNearestJoined() : void
      {
         var bge:BattlegroundEntry = null;
         this.model.nearestBgEntry = null;
         for each(bge in this.model.bgEntries)
         {
            if(bge.joined)
            {
               this.model.nearestBgEntry = bge;
               return;
            }
         }
      }
      
      private function join(e:DashboardEvent) : void
      {
         if(e.entry is BattlegroundEntry)
         {
            this.model.currentEntry = BattlegroundEntry(e.entry);
            ServerLayer.call("battlegroundService","join",this.joinResponse,this.joinLeaveFailed,e.entry.id);
         }
      }
      
      private function joinResponse() : void
      {
         this.model.currentEntry.setJoined(true);
         this.findNearestJoined();
      }
      
      private function joinLeaveFailed(r:* = null) : void
      {
         this.getEntries(null);
      }
      
      private function leave(e:DashboardEvent) : void
      {
         if(e.entry is BattlegroundEntry)
         {
            this.model.currentEntry = BattlegroundEntry(e.entry);
            ServerLayer.call("battlegroundService","leave",this.leaveResponse,this.joinLeaveFailed,e.entry.id);
         }
      }
      
      private function leaveResponse() : void
      {
         this.model.currentEntry.setJoined(false);
         this.findNearestJoined();
      }
      
      public function reset() : void
      {
         clearTimeout(this.updateTimeout);
      }
      
      public function activateEntry(entryId:uint) : void
      {
         this.model.hasNewEntry = true;
      }
      
      public function deactivateEntry(entryId:uint) : void
      {
         this.getEntries(null);
      }
   }
}

