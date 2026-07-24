package soul.view.rtm.targetFrame
{
   import flash.events.Event;
   import soul.controller.MenuManager;
   import soul.event.FieldEvent;
   import soul.model.common.MenuType;
   
   public class TargetFrame extends GenericFrame
   {
      
      public function TargetFrame()
      {
         super();
      }
      
      override protected function avatarClick() : void
      {
         if(Boolean(model.activeAbility))
         {
            if(Boolean(unit) && unit.accepts(model.activeAbility))
            {
               model.activeUnit = unit;
               model.dispatchEvent(new FieldEvent(FieldEvent.ACCEPT_ABILITY));
            }
         }
         else
         {
            dispatchEvent(new FieldEvent(FieldEvent.CS_INTERACT));
         }
      }
      
      override protected function menuClick() : void
      {
         if(!unit.character)
         {
            this.close();
            return;
         }
         MenuManager.create(MenuType.CHARACTER_MENU,unit.id,true,true);
      }
      
      protected function close() : void
      {
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}

