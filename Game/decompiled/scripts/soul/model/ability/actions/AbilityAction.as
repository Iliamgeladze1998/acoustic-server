package soul.model.ability.actions
{
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.character.UnitPropertyType;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   import soul.view.ui.VBox;
   
   public class AbilityAction
   {
      
      private static const bundles:Array = [BundleName.TOOLTIP,BundleName.INTERFACE];
      
      public var condition:String;
      
      public function AbilityAction()
      {
         super();
      }
      
      public function getDescriptionWithCondition() : Component
      {
         var vbox:VBox = null;
         var label:Label = null;
         var description:Component = this.getDescription();
         if(Boolean(this.condition))
         {
            vbox = new VBox();
            vbox.percentWidth = 100;
            label = new Label();
            label.htmlText = this.getString("condition") + ": " + this.getCondition(this.condition);
            vbox.addChild(label);
            vbox.addChild(description);
            return vbox;
         }
         return description;
      }
      
      public function getDescription() : Component
      {
         var key:String = null;
         var label:Label = new Label();
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
      
      protected function getPropertyLocale(property:String) : String
      {
         return Boolean(property) && property != UnitPropertyType.HP ? " (" + this.getString(property) + ")" : "";
      }
      
      protected function getParam(param:String) : String
      {
         return "<font color=\'#FFFFFF\'>" + this.getString(param) + ": " + "</font>";
      }
      
      protected function getCondition(buffId:String) : String
      {
         return "<font color=\'#2ac427\'>" + LocaleManager.getString(BundleName.BUFF,buffId) + "</font>";
      }
      
      protected function getNpc(npc:String) : String
      {
         return "<font color=\'#2ac427\'>" + LocaleManager.getString(BundleName.NPC,npc) + "</font>";
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

