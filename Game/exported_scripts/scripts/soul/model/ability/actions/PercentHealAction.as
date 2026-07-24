package soul.model.ability.actions
{
   import mx.utils.StringUtil;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class PercentHealAction extends UnitAbilityAction
   {
      
      private static var template:String;
      
      protected static var maxTemplate:String;
      
      public var property:String;
      
      public var dependsOnProperty:String;
      
      public var dependsOnParam:String;
      
      public var percents:Number;
      
      public var top:Number;
      
      public var dependsOnUnit:String;
      
      public function PercentHealAction()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         template = template || getString("percentHealAction");
         maxTemplate = maxTemplate || getString("maxTemplate");
         var label:Label = new Label();
         label.percentWidth = 100;
         label.multiline = label.wordWrap = true;
         var damage:String = "";
         damage += Math.round(this.percents * 100);
         var maxDamage:String = "";
         if(this.top < Number.POSITIVE_INFINITY)
         {
            maxDamage = StringUtil.substitute(maxTemplate,Math.round(this.top * 100));
         }
         label.htmlText = StringUtil.substitute(template,damage,getParam(this.property),getString(Boolean(this.dependsOnParam) ? this.dependsOnParam : this.dependsOnProperty),getString(this.dependsOnUnit),maxDamage);
         return label;
      }
   }
}

