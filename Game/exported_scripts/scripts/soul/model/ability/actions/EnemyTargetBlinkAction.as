package soul.model.ability.actions
{
   public class EnemyTargetBlinkAction extends TargetBlinkAction
   {
      
      public function EnemyTargetBlinkAction()
      {
         super();
      }
      
      override protected function generateTemplate() : void
      {
         template = template || getString("enemyTargetBlinkAction");
      }
   }
}

