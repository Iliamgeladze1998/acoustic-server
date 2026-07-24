package soul.model.combat
{
   import mx.utils.StringUtil;
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   
   public class DamageRecord extends NamedCombatRecord
   {
      
      public var amount:int;
      
      public var crit:Boolean;
      
      public var element:String;
      
      public var absorb:int;
      
      public var resist:int;
      
      public var localeId:String;
      
      public function DamageRecord()
      {
         super();
      }
      
      override public function toString() : String
      {
         var template:String = null;
         var ability:String = null;
         var ret:String = "";
         if(this.crit)
         {
            ret += getTemplate("DamageRecord.critical") + " ";
         }
         template = getTemplate(Boolean(ability) ? "DamageRecord.ability" : "DamageRecord");
         ability = getAbilityOrBuffName(this.localeId);
         var element:String = LocaleManager.getString(BundleName.COMBAT,this.element);
         var damage:String = "<font color=\"#ff3131\">" + this.amount + "</font>";
         ret += StringUtil.substitute(template,ability,getCharacter(src),getCharacter(dst),damage,element);
         if(this.absorb > 0)
         {
            template = getTemplate("DamageRecord.absorb");
            ret += " " + StringUtil.substitute(template,this.absorb);
         }
         if(this.resist > 0)
         {
            template = getTemplate("DamageRecord.resist");
            ret += " " + StringUtil.substitute(template,this.resist);
         }
         return ret;
      }
   }
}

