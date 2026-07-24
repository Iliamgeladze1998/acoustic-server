package soul.view.toolTip
{
   import flash.events.Event;
   import soul.view.AlignPosition;
   import soul.view.ui.BorderedContainer;
   
   public class ToolTipBase extends BorderedContainer
   {
      
      public var data:Object;
      
      public var position:AlignPosition;
      
      protected var prepared:Boolean;
      
      public function ToolTipBase()
      {
         super();
         mouseEnabled = false;
         mouseChildren = false;
         addEventListener(Event.ADDED_TO_STAGE,this.onAdded);
      }
      
      public function prepare() : void
      {
      }
      
      protected function onAdded(e:Event) : void
      {
      }
   }
}

