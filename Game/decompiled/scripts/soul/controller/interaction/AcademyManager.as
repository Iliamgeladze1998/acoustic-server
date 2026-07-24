package soul.controller.interaction
{
   import soul.controller.IManager;
   import soul.controller.Interaction;
   import soul.controller.locale.LocaleManager;
   import soul.event.AcademyEvent;
   import soul.model.character.CharacterModel;
   import soul.model.common.InteractionType;
   import soul.model.location.academy.AcademyData;
   import soul.model.location.academy.AcademyModel;
   import soul.model.location.academy.AcademyResetType;
   import soul.net.ServerLayer;
   import soul.view.interaction.academy.AcademyScreen;
   
   public class AcademyManager implements IManager
   {
      
      private var character:CharacterModel;
      
      private var model:AcademyModel;
      
      private var view:AcademyScreen;
      
      public function AcademyManager(v:AcademyScreen, c:CharacterModel)
      {
         super();
         this.model = new AcademyModel();
         this.character = c;
         this.view = v;
         this.view.model = this.model;
         this.view.character = this.character;
         this.model.addEventListener(AcademyEvent.CHANGE_DISPOSITION,this.changeDisposition);
         this.model.addEventListener(AcademyEvent.RESET_STATS,this.resetStats);
         this.getAcademyData();
      }
      
      public function reset() : void
      {
         this.model.removeEventListener(AcademyEvent.CHANGE_DISPOSITION,this.changeDisposition);
      }
      
      private function changeDisposition(e:AcademyEvent) : void
      {
         ServerLayer.call("academyService","changePresets",this.dispositionChanged,null,e.data);
      }
      
      private function resetStats(e:AcademyEvent) : void
      {
         var method:String = null;
         switch(e.data)
         {
            case AcademyResetType.STATS:
               method = "changeStats";
               break;
            case AcademyResetType.SCHOOLS:
               method = "changeSkills";
               break;
            case AcademyResetType.TALENTS:
               method = "changeTalents";
               break;
            case AcademyResetType.PROFESSIONS:
               method = "changeProfessions";
               break;
            default:
               return;
         }
         ServerLayer.call("academyService",method,this.dispositionChanged);
      }
      
      private function dispositionChanged(result:Object = null) : void
      {
         Interaction.hide(InteractionType.ACADEMY);
      }
      
      private function getAcademyData(result:Object = null) : void
      {
         ServerLayer.call("academyService","getAcademy",this.setAcademy);
      }
      
      private function setAcademy(value:AcademyData) : void
      {
         this.model.load(value);
         this.model.currentPresetDescription = this.getPresetDescription(value.currentPreset);
      }
      
      private function getPresetDescription(preset:String) : String
      {
         return LocaleManager.getString("disposition_info",preset);
      }
   }
}

