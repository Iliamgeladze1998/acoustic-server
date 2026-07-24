package soul.model.combat
{
   import mx.utils.StringUtil;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   
   public class HealRecord extends NamedCombatRecord
   {
      
      public var amount:int;
      
      public var localeId:String;
      
      public var property:String;
      
      public function HealRecord()
      {
         super();
      }
      
      override public function toString() : String
      {
         var template:String = getTemplate(Boolean(this.localeId) ? (Boolean(src) ? "HealRecord.src" : "HealRecord") : "HealRecord.null");
         var ability:String = getAbilityOrBuffName(this.localeId);
         var property:String = LocaleManager.getString(BundleName.INTERFACE,this.property);
         return StringUtil.substitute(template,ability,getCharacter(src),getCharacter(dst),this.amount,property);
      }
   }
}

