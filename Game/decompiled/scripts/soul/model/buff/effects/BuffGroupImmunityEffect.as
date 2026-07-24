package soul.model.buff.effects
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class BuffGroupImmunityEffect extends ImmunityEffect
   {
      
      public var groupSet:BuffGroupSet;
      
      public function BuffGroupImmunityEffect()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         var label:Label = null;
         var buffGroup:String = null;
         label = new Label();
         label.percentWidth = 100;
         label.multiline = label.wordWrap = true;
         var txt:String = "<font color=\"#ffffff\">" + getString("immunity") + ":</font> ";
         var localized:Vector.<String> = new Vector.<String>();
         if(Boolean(this.groupSet))
         {
            if(Boolean(this.groupSet.setType))
            {
               txt += LocaleManager.getString(BundleName.BUFF,this.groupSet.setType);
            }
            else
            {
               for each(buffGroup in this.groupSet.customSet)
               {
                  localized.push(LocaleManager.getString(BundleName.BUFF,buffGroup));
               }
               txt += localized.join(", ");
            }
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

