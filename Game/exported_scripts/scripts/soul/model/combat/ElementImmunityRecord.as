package soul.model.combat
{
   import mx.utils.StringUtil;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   
   public class ElementImmunityRecord extends NamedCombatRecord
   {
      
      public var element:String;
      
      public function ElementImmunityRecord()
      {
         super();
      }
      
      private static function getElement(key:String) : String
      {
         return LocaleManager.getString(BundleName.COMBAT,key);
      }
      
      override public function toString() : String
      {
         return StringUtil.substitute(getTemplate("ImmunityRecord"),getCharacter(dst),getElement(this.element));
      }
   }
}

