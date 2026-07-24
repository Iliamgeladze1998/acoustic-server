package soul.model.ability.actions
{
   import soul.view.ui.Component;
   
   public class BlinkAction extends UnitAbilityAction
   {
      
      public var distance:uint;
      
      public function BlinkAction()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         return null;
      }
   }
}

