package soul.model.ability.actions
{
   public class UnitExplodeAction extends ExplodeAction
   {
      
      public var excludeTarget:Boolean;
      
      public function UnitExplodeAction()
      {
         super();
      }
      
      override protected function getAreaDescription() : String
      {
         var opts:Vector.<String> = new Vector.<String>(0);
         if(this.excludeTarget)
         {
            opts.push(getString("excludeTarget"));
         }
         if(limit > 0)
         {
            opts.push(getString("maxTargets") + " " + limit);
         }
         return opts.length > 0 ? "(" + opts.join(", ") + ")" : "";
      }
   }
}

