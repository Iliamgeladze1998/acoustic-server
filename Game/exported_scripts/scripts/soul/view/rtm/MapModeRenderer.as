package soul.view.rtm
{
   import soul.model.field.mapconfig.PvpState;
   import soul.view.ui.Component;
   
   public class MapModeRenderer extends Component
   {
      
      public function MapModeRenderer()
      {
         super();
      }
      
      public function set status(value:String) : void
      {
         backgroundColor = PvpState.getMapColor(value);
         redraw();
      }
   }
}

