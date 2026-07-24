package soul.view.interaction.lfg
{
   import soul.view.assets.Colors;
   import soul.view.ui.Checkbox;
   
   public class SubCategoryRenderer extends Checkbox
   {
      
      public var id:String;
      
      public var disabled:Boolean;
      
      public function SubCategoryRenderer()
      {
         super();
         styleName = "checkBox";
      }
      
      override public function set enabled(value:Boolean) : void
      {
         _enabled = value;
         filters = value ? [] : Colors.DISABLED_FILTER;
      }
   }
}

