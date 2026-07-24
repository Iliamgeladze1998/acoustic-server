package soul.model.buff.effects
{
   import mx.utils.StringUtil;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class PropertyEffect extends BuffEffect
   {
      
      private static var damageTemplate:String;
      
      private static var restoreTemplate:String;
      
      public var property:String;
      
      public var value:int;
      
      public var period:Number;
      
      public var element:String;
      
      public function PropertyEffect()
      {
         super();
      }
      
      override public function getDescription() : Component
      {
         var txt:String = null;
         var label:Label = null;
         damageTemplate = damageTemplate || LocaleManager.getString(BundleName.BUFF,"DAMAGE_TEMPLATE");
         restoreTemplate = restoreTemplate || LocaleManager.getString(BundleName.BUFF,"RESTORE_TEMPLATE");
         txt = StringUtil.substitute(this.value > 0 ? restoreTemplate : damageTemplate,getString(this.property),String(Math.abs(this.value)),String(Math.round(this.period / 100) / 10));
         label = new Label();
         label.percentWidth = 100;
         label.multiline = true;
         label.wordWrap = true;
         label.text = txt;
         return label;
      }
   }
}

