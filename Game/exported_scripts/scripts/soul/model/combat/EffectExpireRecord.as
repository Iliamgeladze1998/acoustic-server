package soul.model.combat
{
   import mx.utils.StringUtil;
   
   public class EffectExpireRecord extends CombatRecord
   {
      
      public var name:String;
      
      public var localeId:String;
      
      public function EffectExpireRecord()
      {
         super();
      }
      
      override public function toString() : String
      {
         var template:String = getTemplate("EffectExpireRecord");
         var ability:String = getAbilityOrBuffName(this.localeId);
         return StringUtil.substitute(template,ability,getCharacter(this.name));
      }
   }
}

