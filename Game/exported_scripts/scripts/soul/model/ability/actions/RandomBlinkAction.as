package soul.model.ability.actions
{
   import soul.view.ui.Component;
   
   public class RandomBlinkAction extends UnitAbilityAction
   {
      
      public var minRadius:uint;
      
      public var maxRadius:uint;
      
      public function RandomBlinkAction()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         return null;
      }
   }
}

