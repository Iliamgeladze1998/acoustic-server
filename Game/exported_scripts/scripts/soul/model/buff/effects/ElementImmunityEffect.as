package soul.model.buff.effects
{
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class ElementImmunityEffect extends ImmunityEffect
   {
      
      public var elements:Array;
      
      public function ElementImmunityEffect()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         var label:Label = null;
         var element:String = null;
         label = new Label();
         label.percentWidth = 100;
         label.multiline = label.wordWrap = true;
         var txt:String = "<font color=\"#ffffff\">" + getString("immunity") + ":</font> ";
         var localized:Vector.<String> = new Vector.<String>();
         if(Boolean(this.elements) && this.elements.length > 0)
         {
            for each(element in this.elements)
            {
               localized.push(getString(element));
            }
            txt += localized.join(", ");
         }
         else
         {
            txt += getString("ALL_ELEMENTS");
         }
         if(chance > 0)
         {
            txt += "(" + Math.round(chance * 100) + ")%";
         }
         label.htmlText = txt;
         return label;
      }
   }
}

