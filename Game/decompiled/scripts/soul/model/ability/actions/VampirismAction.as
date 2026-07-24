package soul.model.ability.actions
{
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   public class VampirismAction extends DamageAction
   {
      
      public var healProperty:String;
      
      public var healPoints:int;
      
      public var healPercents:Number;
      
      public function VampirismAction()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         var box:VBox = null;
         var label:Label = null;
         box = new VBox();
         box.percentWidth = 100;
         box.addChild(super.getDescription());
         label = new Label();
         label.wordWrap = label.multiline = true;
         label.htmlText = getParam("vampirism." + this.healProperty) + " " + (this.healPoints > 0 ? this.healPoints + " " : "") + Math.round(this.healPercents * 100) + "%";
         box.addChild(label);
         return box;
      }
   }
}

