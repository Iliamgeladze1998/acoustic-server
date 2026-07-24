package soul.model.combat
{
   import flash.utils.describeType;
   import flash.utils.getQualifiedClassName;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   
   public class CombatRecord
   {
      
      private static const templates:Object = {};
      
      public var date:Number;
      
      public function CombatRecord()
      {
         super();
      }
      
      protected static function getCharacter(key:String) : String
      {
         return "<font color=\"#ffffff\"><b>" + LocaleManager.getString(BundleName.NPC,key) + "</b></font>";
      }
      
      protected static function getAbilityOrBuffName(key:String) : String
      {
         return "<font color=\"#2ac427\">" + LocaleManager.getAbilityOrBuffName(key) + "</font>";
      }
      
      protected static function getTemplate(templateId:String) : String
      {
         var template:String = templates[templateId];
         if(!template)
         {
            template = templates[templateId] = LocaleManager.getString(BundleName.COMBAT,templateId);
         }
         return templates[templateId];
      }
      
      public function toString() : String
      {
         var key:String = null;
         var params:Vector.<String> = new Vector.<String>();
         var props:XMLList = describeType(this).variable.@name;
         for each(key in props)
         {
            params.push(key + "=\"" + this[key] + "\"");
         }
         return "[" + getQualifiedClassName(this) + " " + params.join(", ") + "]";
      }
   }
}

