package soul.model.combat
{
   import mx.utils.StringUtil;
   
   public class EffectDispelRecord extends NamedCombatRecord
   {
      
      public var localeId:String;
      
      public function EffectDispelRecord()
      {
         super();
      }
      
      override public function toString() : String
      {
         var template:String = getTemplate("EffectDispelRecord");
         var ability:String = getAbilityOrBuffName(this.localeId);
         return StringUtil.substitute(template,getCharacter(src),ability,getCharacter(dst));
      }
   }
}

