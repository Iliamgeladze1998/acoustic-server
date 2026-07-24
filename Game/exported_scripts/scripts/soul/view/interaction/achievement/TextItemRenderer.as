package soul.view.interaction.achievement
{
   import soul.controller.locale.LocaleManager;
   import soul.model.item.Item;
   import soul.view.toolTip.ItemTipComparable;
   import soul.view.toolTip.ToolTipManager;
   import soul.view.ui.Label;
   
   public class TextItemRenderer extends Label
   {
      
      public function TextItemRenderer()
      {
         super();
         color = 0;
         fontSize = 11;
         bold = true;
      }
      
      public function set item(value:Item) : void
      {
         if(Boolean(value))
         {
            ToolTipManager.register(this,value,ItemTipComparable);
         }
         else
         {
            ToolTipManager.unregister(this);
         }
         text = Boolean(value) ? LocaleManager.getItemName(value.templateId,value.suffixId,value.locId) : "";
      }
   }
}

