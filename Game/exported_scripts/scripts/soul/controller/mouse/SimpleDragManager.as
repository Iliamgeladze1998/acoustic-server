package soul.controller.mouse
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import mx.core.DragSource;
   
   public class SimpleDragManager
   {
      
      private static var _instance:Impl;
      
      public function SimpleDragManager()
      {
         super();
      }
      
      private static function get instance() : Impl
      {
         if(!_instance)
         {
            _instance = new Impl();
         }
         return _instance;
      }
      
      public static function doDrag(initiator:DisplayObject, data:DragSource, mouseEvent:MouseEvent, image:Sprite, dx:int = 0, dy:int = 0, alpha:Number = 1) : void
      {
         instance.doDrag(initiator,data,mouseEvent,image,dx,dy,alpha);
      }
      
      public static function acceptDragDrop(target:Sprite) : void
      {
         instance.acceptDragDrop(target);
      }
      
      public static function get isDragging() : Boolean
      {
         return instance.isDragging;
      }
   }
}

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import mx.core.DragSource;
import soul.event.DragEvent;
import soul.view.toolTip.ToolTipManager;

class Impl
{
   
   private static const ACCEPTED:Array = [new GlowFilter(65280)];
   
   public var isDragging:Boolean;
   
   private var initiator:DisplayObject;
   
   private var data:DragSource;
   
   private var image:Sprite;
   
   private var stage:Stage;
   
   private var acceptedTarget:Sprite;
   
   private var _currentTarget:DisplayObject;
   
   public function Impl()
   {
      super();
   }
   
   public function doDrag(initiator:DisplayObject, data:DragSource, mouseEvent:MouseEvent, image:Sprite, dx:int, dy:int, alpha:Number) : void
   {
      this.initiator = initiator;
      this.stage = initiator.stage;
      if(!this.stage || Boolean(this.isDragging))
      {
         return;
      }
      ToolTipManager.hideCurrent();
      this.isDragging = true;
      this.data = data;
      this.image = image;
      image.mouseEnabled = false;
      image.alpha = alpha;
      image.x = mouseEvent.stageX + dx;
      image.y = mouseEvent.stageY + dy;
      this.stage.addChild(image);
      image.startDrag(true);
      this.stage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
      this.stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
   }
   
   public function acceptDragDrop(target:Sprite) : void
   {
      this.acceptedTarget = target;
      this.image.filters = ACCEPTED;
   }
   
   private function onMouseMove(e:MouseEvent) : void
   {
      var target:DisplayObject = null;
      var ne:DragEvent = null;
      var found:Boolean = false;
      target = this.image.dropTarget;
      if(Boolean(target))
      {
         ne = new DragEvent(DragEvent.DRAG_ENTER);
         ne.dragSource = this.data;
         while(target.parent != null)
         {
            if(target.hasEventListener(DragEvent.DRAG_ENTER))
            {
               if(this._currentTarget != target)
               {
                  target.dispatchEvent(ne);
               }
               if(this.acceptedTarget == target)
               {
                  this.currentTarget = target;
                  found = true;
                  break;
               }
            }
            target = target.parent;
         }
      }
      if(!found)
      {
         this.acceptedTarget = null;
         this.currentTarget = null;
         this.image.filters = [];
      }
   }
   
   private function onMouseUp(e:MouseEvent) : void
   {
      var ne2:DragEvent = null;
      this.image.stopDrag();
      this.stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
      this.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      this.stage.removeChild(this.image);
      this.isDragging = false;
      var ne:DragEvent = new DragEvent(DragEvent.DRAG_COMPLETE);
      if(Boolean(this.acceptedTarget) && Boolean(this.acceptedTarget.hasEventListener(DragEvent.DRAG_DROP)))
      {
         ne.action = DragAction.MOVE;
         ne2 = new DragEvent(DragEvent.DRAG_DROP);
         ne2.dragSource = this.data;
         ne2.shiftKey = e.shiftKey;
         this.acceptedTarget.dispatchEvent(ne2);
      }
      else
      {
         ne.action = DragAction.NONE;
      }
      this.initiator.dispatchEvent(ne);
      this.acceptedTarget = null;
      this.currentTarget = null;
   }
   
   private function set currentTarget(value:DisplayObject) : void
   {
      if(this._currentTarget == value)
      {
         return;
      }
      if(Boolean(this._currentTarget) && Boolean(this._currentTarget.hasEventListener(DragEvent.DRAG_EXIT)))
      {
         this._currentTarget.dispatchEvent(new DragEvent(DragEvent.DRAG_EXIT));
      }
      this._currentTarget = value;
   }
}
