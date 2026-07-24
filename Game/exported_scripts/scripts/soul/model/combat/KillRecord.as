package soul.model.combat
{
   import mx.utils.StringUtil;
   
   public class KillRecord extends NamedCombatRecord
   {
      
      public function KillRecord()
      {
         super();
      }
      
      override public function toString() : String
      {
         var template:String = getTemplate(Boolean(src) ? "KillRecord.src.dst" : "KillRecord.dst");
         if(!template)
         {
            return super.toString();
         }
         return StringUtil.substitute(template,getCharacter(src),getCharacter(dst));
      }
   }
}

