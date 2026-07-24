package soul.model.combat
{
   import mx.utils.StringUtil;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   
   public class BuffGroupImmunityRecord extends NamedCombatRecord
   {
      
      public var group:String;
      
      public function BuffGroupImmunityRecord()
      {
         super();
      }
      
      private static function getBuff(key:String) : String
      {
         return LocaleManager.getString(BundleName.BUFF,key);
      }
      
      override public function toString() : String
      {
         return StringUtil.substitute(getTemplate("ImmunityRecord"),getCharacter(dst),getBuff(this.group));
      }
   }
}

