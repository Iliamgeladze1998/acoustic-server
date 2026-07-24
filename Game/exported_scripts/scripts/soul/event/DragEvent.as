package soul.event
{
   import flash.events.Event;
   import mx.core.DragSource;
   
   public class DragEvent extends Event
   {
      
      public static const DRAG_ENTER:String = "dragEnter";
      
      public static const DRAG_EXIT:String = "dragExit";
      
      public static const DRAG_DROP:String = "dragDrop";
      
      public static const DRAG_COMPLETE:String = "dragComplete";
      
      public var dragSource:DragSource;
      
      public var action:String;
      
      public var shiftKey:Boolean;
      
      public function DragEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      override public function clone() : Event
      {
         var ne:DragEvent = new DragEvent(type,bubbles,cancelable);
         ne.dragSource = this.dragSource;
         ne.action = this.action;
         return ne;
      }
   }
}

