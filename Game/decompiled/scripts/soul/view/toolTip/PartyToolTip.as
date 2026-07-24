package soul.view.toolTip
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.field.StatType;
   import soul.model.group.GroupMember;
   import soul.view.ui.BoxDirection;
   import soul.view.ui.Component;
   import soul.view.ui.Label;
   
   public class PartyToolTip extends SoulToolTipBase
   {
      
      public function PartyToolTip()
      {
         super();
         direction = BoxDirection.VERTICAL;
         padding = 5;
         gap = 1;
      }
      
      override public function prepare() : void
      {
         var value:GroupMember = null;
         var label:Label = null;
         var ui:Component = null;
         value = data as GroupMember;
         if(!value)
         {
            return;
         }
         removeAllChildren();
         label = new Label();
         label.color = 16777215;
         label.htmlText = "<b><font size=\"+1\">" + value.name + "</font></b>";
         addChild(label);
         label = new Label();
         label.text = getString(value.disposition) + ", " + value.stats[StatType.LEVEL] + " " + getString("level");
         addChild(label);
         ui = new Component();
         ui.height = 10;
         addChild(ui);
         label = new Label();
         label.text = LocaleManager.getString(BundleName.MAPS,value.sectorId + "." + value.mapId);
         addChild(label);
      }
   }
}

