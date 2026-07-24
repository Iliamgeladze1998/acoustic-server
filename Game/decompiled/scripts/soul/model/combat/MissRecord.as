package soul.model.combat
{
   import mx.utils.StringUtil;
   
   public class MissRecord extends NamedCombatRecord
   {
      
      public function MissRecord()
      {
         super();
      }
      
      override public function toString() : String
      {
         return StringUtil.substitute(getTemplate("MissRecord"),getCharacter(src));
      }
   }
}

