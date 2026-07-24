package soul.view.ui
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import soul.view.ui.layout.Layout;
   
   public class Canvas extends Container
   {
      
      public function Canvas()
      {
         super();
         layout = new Layout(this);
      }
      
      override protected function childAdded(child:DisplayObject) : void
      {
         super.childAdded(child);
         layout.layoutOne(child);
      }
      
      override protected function childResized(e:Event) : void
      {
         layout.layoutOne(e.currentTarget as DisplayObject);
      }
   }
}

