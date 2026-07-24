package soul.view.ui
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import soul.view.ui.layout.TileLayout;
   
   public class Tile extends Container
   {
      
      public var gap:int = 0;
      
      public function Tile()
      {
         super();
         layout = new TileLayout(this);
         width = 10;
         height = 10;
      }
      
      override protected function childResized(e:Event) : void
      {
         layout.layoutOne(e.currentTarget as DisplayObject);
      }
      
      override protected function childAdded(child:DisplayObject) : void
      {
         super.childAdded(child);
         layout.layoutOne(child);
      }
      
      override protected function childRemoved(child:DisplayObject) : void
      {
         callLater(layout.layout);
      }
   }
}

