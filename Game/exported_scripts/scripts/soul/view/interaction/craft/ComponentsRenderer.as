package soul.view.interaction.craft
{
   import soul.model.interaction.craft.Component;
   import soul.view.ui.Tile;
   
   public class ComponentsRenderer extends Tile
   {
      
      private var _dataProvider:Array;
      
      public function ComponentsRenderer()
      {
         super();
         percentWidth = 100;
      }
      
      public function set dataProvider(value:Array) : void
      {
         var component:Component = null;
         var child:ComponentRenderer = null;
         if(value == this._dataProvider)
         {
            return;
         }
         this._dataProvider = value;
         removeAllChildren();
         for each(component in value)
         {
            child = new ComponentRenderer();
            child.component = component;
            addChild(child);
         }
      }
   }
}

