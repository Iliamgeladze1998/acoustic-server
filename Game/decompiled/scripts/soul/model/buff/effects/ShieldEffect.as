package soul.model.buff.effects
{
   import mx.utils.StringUtil;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class ShieldEffect extends BuffEffect
   {
      
      private static var template:String;
      
      public var absorption:Number;
      
      public var elements:Array;
      
      public function ShieldEffect()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         var label:Label = null;
         var translatesElements:Array = null;
         var element:String = null;
         template = template || LocaleManager.getString(BundleName.BUFF,"SHIELD_TEMPLATE");
         label = new Label();
         label.percentWidth = 100;
         label.multiline = true;
         label.wordWrap = true;
         var txt:String = StringUtil.substitute(template,Math.round(this.absorption * 100) + "%");
         if(Boolean(this.elements) && this.elements.length > 0)
         {
            translatesElements = [];
            for each(element in this.elements)
            {
               translatesElements.push(LocaleManager.getString(BundleName.TOOLTIP,element));
            }
            txt += "(" + translatesElements.join(", ") + ")";
         }
         label.text = txt;
         return label;
      }
   }
}

