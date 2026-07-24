package soul.controller.mouse
{
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import soul.event.DragEvent;
   
   public class DragProxy
   {
      
      private static const DRAG_TRESHOLD:uint = 4;
      
      private var target:Sprite;
      
      private var downPoint:Point;
      
      public var dragStartHandler:Function;
      
      public var dragEnterHandler:Function;
      
      public var dragDropHandler:Function;
      
      public var dragCompleteHandler:Function;
      
      public var dragExitHandler:Function;
      
      public function DragProxy(target:Sprite, dragStartHandler:Function = null, dragEnterHandler:Function = null, dragDropHandler:Function = null, dragCompleteHandler:Function = null, dragExitHandler:Function = null)
      {
         super();
         this.target = target;
         this.dragStartHandler = dragStartHandler;
         this.dragEnterHandler = dragEnterHandler;
         this.dragDropHandler = dragDropHandler;
         this.dragCompleteHandler = dragCompleteHandler;
         this.dragExitHandler = dragExitHandler;
         target.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         target.addEventListener(DragEvent.DRAG_ENTER,this.dragEnter);
         target.addEventListener(DragEvent.DRAG_DROP,this.dragDrop);
         target.addEventListener(DragEvent.DRAG_COMPLETE,this.dragComplete);
         target.addEventListener(DragEvent.DRAG_EXIT,this.dragExit);
      }
      
      protected function mouseDown(e:MouseEvent) : void
      {
         trace("DragProxy.mouseDown()");
         this.downPoint = new Point(e.localX,e.localY);
         var stage:Stage = this.target.stage;
         stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         this.target.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
      }
      
      private function mouseMove(e:MouseEvent) : void
      {
         if(!this.downPoint)
         {
            return;
         }
         var dx:uint = Math.abs(e.localX - this.downPoint.x);
         var dy:uint = Math.abs(e.localY - this.downPoint.y);
         if(dx > DRAG_TRESHOLD || dy > DRAG_TRESHOLD)
         {
            this.dragStart(e);
         }
      }
      
      private function mouseUp(e:MouseEvent) : void
      {
         this.downPoint = null;
         var stage:Stage = this.target.stage;
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         this.target.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
      }
      
      private function dragStart(e:MouseEvent) : void
      {
         this.mouseUp(null);
         if(this.dragStartHandler != null)
         {
            this.dragStartHandler(e);
         }
      }
      
      private function dragEnter(e:DragEvent) : void
      {
         if(this.dragEnterHandler != null)
         {
            this.dragEnterHandler(e);
         }
      }
      
      private function dragDrop(e:DragEvent) : void
      {
         if(this.dragDropHandler != null)
         {
            this.dragDropHandler(e);
         }
      }
      
      private function dragComplete(e:DragEvent) : void
      {
         if(this.dragCompleteHandler != null)
         {
            this.dragCompleteHandler(e);
         }
      }
      
      private function dragExit(e:DragEvent) : void
      {
         if(this.dragExitHandler != null)
         {
            this.dragExitHandler(e);
         }
      }
   }
}

