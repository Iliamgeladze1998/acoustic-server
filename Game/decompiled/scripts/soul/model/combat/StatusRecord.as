package soul.model.combat
{
   public class StatusRecord extends CombatRecord
   {
      
      public var status:Boolean;
      
      public function StatusRecord()
      {
         super();
      }
      
      override public function toString() : String
      {
         return "<font color=\"#da1515\">" + getTemplate("StatusRecord." + this.status) + "</font>";
      }
   }
}

