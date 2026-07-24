package soul.view.ui
{
   public interface IListItemRenderer extends IDataRenderer
   {
      
      function set selected(param1:Boolean) : void;
      
      function get selected() : Boolean;
   }
}

