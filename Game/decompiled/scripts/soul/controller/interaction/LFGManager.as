package soul.controller.interaction
{
   import soul.controller.IManager;
   import soul.event.LFGEvent;
   import soul.model.interaction.lfg.GroupApplication;
   import soul.model.interaction.lfg.LFGData;
   import soul.model.interaction.lfg.LFGModel;
   import soul.net.ComponentLocator;
   import soul.net.ServerLayer;
   
   public class LFGManager implements IManager
   {
      
      private static const SERVICE:String = "lfgService";
      
      private var model:LFGModel;
      
      public function LFGManager(model:LFGModel)
      {
         super();
         ComponentLocator.setComponent(ComponentLocator.LFG,this);
         this.model = model;
         model.addEventListener(LFGEvent.GET_RECORDS,this.getRecords);
         model.addEventListener(LFGEvent.GET_APPLICATIONS,this.getApplications);
         model.addEventListener(LFGEvent.SUBSCRIBE,this.subscribe);
         model.addEventListener(LFGEvent.UNSUBSCRIBE,this.unsubscribe);
         model.addEventListener(LFGEvent.JOIN,this.join);
         ServerLayer.call(SERVICE,ComponentLocator.READY);
      }
      
      public function reset() : void
      {
         ComponentLocator.setComponent(ComponentLocator.LFG,null);
      }
      
      private function getRecords(e:LFGEvent) : void
      {
         ServerLayer.call(SERVICE,"getLFGData",this.setData);
      }
      
      private function setData(r:LFGData) : void
      {
         this.model.quests = r.quests;
         this.model.instances = r.instances;
         this.model.locations = r.locations;
      }
      
      private function getApplications(e:LFGEvent) : void
      {
         ServerLayer.call(SERVICE,"getApplications",this.setApplications,null,e.applicationType,e.criteriaId);
      }
      
      private function setApplications(r:Array) : void
      {
         this.model.applications = r;
      }
      
      private function subscribe(e:LFGEvent) : void
      {
         ServerLayer.call(SERVICE,"subscribe",null,null,e.questIds,e.instanceIds,e.locationIds);
      }
      
      private function unsubscribe(e:LFGEvent) : void
      {
         ServerLayer.call(SERVICE,"unsubscribe");
      }
      
      private function join(e:LFGEvent) : void
      {
         ServerLayer.call(SERVICE,"join",null,null,e.applicationId);
      }
      
      public function setCurrentApplication(application:GroupApplication) : void
      {
         this.model.currentApplication = application;
      }
   }
}

