package soul.view.interaction.quest
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   import soul.model.interaction.dialog.MetaItem;
   import soul.model.interaction.dialog.MetaItemType;
   import soul.view.ui.Label;
   
   public class MetaItemRenderer extends Label
   {
      
      public function MetaItemRenderer()
      {
         super();
         color = 0;
         fontSize = 11;
         bold = true;
      }
      
      public function set item(value:MetaItem) : void
      {
         var bundle:String = null;
         if(!value)
         {
            text = "";
            return;
         }
         var key:String = value.subType;
         switch(value.type)
         {
            case MetaItemType.XP:
               bundle = BundleName.ITEMS;
               key = value.type;
               break;
            case MetaItemType.PARAM:
               bundle = BundleName.INTERFACE;
               break;
            case MetaItemType.CURRENCY:
               bundle = BundleName.ITEMS;
               break;
            case MetaItemType.REPUTATION:
               bundle = BundleName.REPUTATION;
               break;
            default:
               bundle = value.type;
         }
         text = LocaleManager.getString(bundle,key) + ": " + value.count;
      }
   }
}

