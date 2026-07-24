package soul.model.buff.effects
{
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class BuffEffect
   {
      
      private static const bundles:Array = [BundleName.TOOLTIP,BundleName.INTERFACE];
      
      public function BuffEffect()
      {
         super();
      }
      
      public function getDescription() : Component
      {
         var label:Label = null;
         var key:String = null;
         label = new Label();
         label.percentWidth = 100;
         label.multiline = true;
         label.wordWrap = true;
         var txt:String = "[" + getQualifiedClassName(this) + "] {";
         var props:XMLList = describeType(this).variable.@name;
         var values:Vector.<String> = new Vector.<String>();
         for each(key in props)
         {
            values.push(key + "=" + this[key]);
         }
         txt += values.join(", ") + "}";
         label.text = txt;
         return label;
      }
      
      protected function getString(key:String) : String
      {
         var bundle:String = null;
         var str:String = null;
         for each(bundle in bundles)
         {
            str = LocaleManager.getString(bundle,key);
            if(str != key)
            {
               return str;
            }
         }
         return key;
      }
   }
}

