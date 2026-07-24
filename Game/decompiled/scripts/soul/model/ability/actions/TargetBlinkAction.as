package soul.model.ability.actions
{
   import mx.utils.StringUtil;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class TargetBlinkAction extends UnitAbilityAction
   {
      
      protected static var template:String;
      
      protected static var minDistanceTemplate:String;
      
      public var minDistance:uint;
      
      public var distance:uint;
      
      public function TargetBlinkAction()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         var txt:String = null;
         var label:Label = null;
         this.generateTemplate();
         txt = StringUtil.substitute(template,this.distance);
         if(this.minDistance > 0)
         {
            minDistanceTemplate = minDistanceTemplate || getString("minDistanceTemplate");
            txt += "\n" + StringUtil.substitute(minDistanceTemplate,this.minDistance);
         }
         label = new Label();
         label.percentWidth = 100;
         label.wordWrap = label.multiline = true;
         label.htmlText = txt;
         return label;
      }
      
      protected function generateTemplate() : void
      {
         template = template || getString("targetBlinkAction");
      }
   }
}

