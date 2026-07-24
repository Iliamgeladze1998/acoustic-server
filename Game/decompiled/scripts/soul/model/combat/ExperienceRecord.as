package soul.model.combat
{
   import mx.utils.StringUtil;
   
   public class ExperienceRecord extends CombatRecord
   {
      
      public var xp:int;
      
      public var groupBonus:int;
      
      public function ExperienceRecord()
      {
         super();
      }
      
      override public function toString() : String
      {
         var bonus:String = this.groupBonus > 0 ? StringUtil.substitute(getTemplate("ExperienceRecord.bonus"),this.groupBonus) : "";
         return "<font color=\"#44ff44\">" + StringUtil.substitute(getTemplate("ExperienceRecord"),this.xp) + bonus + "</font>";
      }
   }
}

