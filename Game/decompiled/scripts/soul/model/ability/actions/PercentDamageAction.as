package soul.model.ability.actions
{
   import mx.utils.StringUtil;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class PercentDamageAction extends PercentHealAction
   {
      
      private static var template:String;
      
      public var elementType:String;
      
      public function PercentDamageAction()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         template = template || getString("percentDamageAction");
         maxTemplate = maxTemplate || getString("maxTemplate");
         var label:Label = new Label();
         label.percentWidth = 100;
         label.multiline = label.wordWrap = true;
         var damage:String = "";
         damage += Math.round(percents * 100);
         var maxDamage:String = "";
         if(top < Number.POSITIVE_INFINITY)
         {
            maxDamage = StringUtil.substitute(maxTemplate,Math.round(top * 100));
         }
         label.htmlText = StringUtil.substitute(template,damage,getString(this.elementType),getString(property),getString(Boolean(dependsOnParam) ? dependsOnParam : dependsOnProperty),getString(dependsOnUnit),maxDamage);
         return label;
      }
   }
}

