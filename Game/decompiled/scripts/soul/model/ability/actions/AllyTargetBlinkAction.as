package soul.model.ability.actions
{
   public class AllyTargetBlinkAction extends TargetBlinkAction
   {
      
      public function AllyTargetBlinkAction()
      {
         super();
      }
      
      override protected function generateTemplate() : void
      {
         template = template || getString("allyTargetBlinkAction");
      }
   }
}

