package soul.model.combat
{
   import mx.utils.StringUtil;
   
   public class EffectApplyRecord extends NamedCombatRecord
   {
      
      public var localeId:String;
      
      public function EffectApplyRecord()
      {
         super();
      }
      
      override public function toString() : String
      {
         var template:String = getTemplate(Boolean(src) ? "EffectApplyRecord.src" : "EffectApplyRecord");
         var ability:String = getAbilityOrBuffName(this.localeId);
         return StringUtil.substitute(template,getCharacter(src),getCharacter(dst),ability);
      }
   }
}

