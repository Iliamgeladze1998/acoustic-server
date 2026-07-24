package soul.model.ability.actions
{
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class HealAction extends UnitAbilityAction
   {
      
      public var property:String;
      
      public var points:uint;
      
      public function HealAction()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         var label:Label = new Label();
         label.htmlText = getParam("restore") + getPropertyLocale(this.property) + " " + this.points;
         return label;
      }
   }
}

