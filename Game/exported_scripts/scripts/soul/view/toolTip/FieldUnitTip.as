package soul.view.toolTip
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.field.FieldUnit;
   import soul.model.field.NpcDifficulty;
   import soul.model.field.StatType;
   import soul.view.assets.Assets;
   import soul.view.ui.BoxDirection;
   import soul.view.ui.Label;
   
   public class FieldUnitTip extends SoulToolTipBase
   {
      
      public function FieldUnitTip()
      {
         super();
         borderSkin = Assets.simpleBorderRound;
         backgroundColor = 0;
         backgroundAlpha = 0.75;
         direction = BoxDirection.VERTICAL;
         padding = 5;
         gap = 1;
      }
      
      override public function prepare() : void
      {
         var label:Label = null;
         var unitType:String = null;
         if(prepared)
         {
            return;
         }
         var unit:FieldUnit = data as FieldUnit;
         label = new Label();
         label.color = NpcDifficulty.getColor(unit.difficulty);
         label.bold = true;
         label.text = unit.name;
         addChild(label);
         var level:int = Boolean(unit.stats) ? int(unit.stats[StatType.LEVEL]) : 0;
         if(level > 0)
         {
            label = new Label();
            label.text = getString("level") + " " + level;
            addChild(label);
         }
         if(Boolean(unit.clan))
         {
            label = new Label();
            label.text = "<" + unit.clan + ">";
            addChild(label);
         }
         if(Boolean(unit.types) && unit.types.length > 0)
         {
            for each(unitType in unit.types)
            {
               label = new Label();
               label.color = 16777215;
               label.text = LocaleManager.getString(BundleName.NPC,unitType);
               addChild(label);
            }
         }
         if(unit.difficulty != null)
         {
            label = new Label();
            label.text = LocaleManager.getString(BundleName.NPC,unit.difficulty);
            addChild(label);
         }
         prepared = true;
      }
   }
}

