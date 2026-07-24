package soul.model.ability.actions
{
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class DamageAction extends UnitAbilityAction
   {
      
      public var property:String;
      
      public var min:int;
      
      public var max:int;
      
      public var top:int;
      
      public var elementType:String;
      
      public function DamageAction()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         var label:Label = new Label();
         var damage:String = "";
         damage += this.min > 0 ? this.min : "";
         damage += this.min != this.max ? "-" : "";
         damage += this.max > 0 && this.max != this.min ? this.max : "";
         damage += this.top > 0 ? " (" + this.top + ") " : " ";
         label.htmlText = getParam("damage") + getPropertyLocale(this.property) + " " + damage + getString(this.elementType);
         return label;
      }
   }
}

