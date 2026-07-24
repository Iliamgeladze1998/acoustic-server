package soul.view.ui
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import soul.view.ui.layout.BoxLayout;
   
   public class Box extends Container
   {
      
      public var gap:int = 0;
      
      [Inspectable(category="General",enumeration="left,center,right",defaultValue="left")]
      public var horizontalAlign:String;
      
      [Inspectable(category="General",enumeration="top,middle,bottom",defaultValue="top")]
      public var verticalAlign:String;
      
      private var _direction:String = "horizontal";
      
      public function Box()
      {
         super();
         layout = new BoxLayout(this);
      }
      
      [Inspectable(category="General",enumeration="vertical,horizontal",defaultValue="horizontal")]
      public function set direction(value:String) : void
      {
         this._direction = value;
         layout.layout();
      }
      
      public function get direction() : String
      {
         return this._direction;
      }
      
      override protected function childAdded(child:DisplayObject) : void
      {
         super.childAdded(child);
         updateLater();
      }
      
      override protected function childRemoved(child:DisplayObject) : void
      {
         super.childRemoved(child);
         updateLater();
      }
      
      override protected function childResized(e:Event) : void
      {
         if(layoutInProgress)
         {
            callLater(makeLayout);
         }
         else
         {
            makeLayout();
         }
      }
   }
}

