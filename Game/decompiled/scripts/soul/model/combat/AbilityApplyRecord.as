package soul.model.combat
{
   import mx.utils.StringUtil;
   import soul.controller.locale.LocaleManager;
   
   public class AbilityApplyRecord extends NamedCombatRecord
   {
      
      public var localeId:String;
      
      public function AbilityApplyRecord()
      {
         super();
      }
      
      override public function toString() : String
      {
         var template:String = getTemplate(Boolean(dst) ? "AbilityApplyRecord.dst" : "AbilityApplyRecord");
         var ability:String = "<font color=\"#2ac427\">" + LocaleManager.getAbilityName(this.localeId) + "</font>";
         return StringUtil.substitute(template,getCharacter(src),ability,getCharacter(dst));
      }
   }
}

