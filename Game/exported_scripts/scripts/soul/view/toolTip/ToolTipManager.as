package soul.view.toolTip
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.Dictionary;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   import soul.controller.mouse.SimpleDragManager;
   import soul.view.AlignPosition;
   
   public class ToolTipManager
   {
      
      private static var interval:uint;
      
      private static var currentTip:ToolTipBase;
      
      public static var toolTipClass:Class = TextTip;
      
      private static const DELAY:uint = 300;
      
      private static var tips:Dictionary = new Dictionary(true);
      
      public function ToolTipManager()
      {
         super();
      }
      
      public static function register(object:DisplayObject, data:Object, tipClass:Class = null, tipPosition:AlignPosition = null) : void
      {
         tipClass ||= toolTipClass;
         if(Boolean(tips[object]))
         {
            unregister(object);
         }
         var tip:ToolTipBase = new tipClass();
         tip.data = data;
         tip.position = tipPosition;
         tips[object] = tip;
         object.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver,false,0,true);
         object.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut,false,0,true);
         object.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown,false,0,true);
         object.addEventListener(Event.REMOVED_FROM_STAGE,onMouseOut,false,0,true);
      }
      
      public static function unregister(object:DisplayObject) : void
      {
         if(!tips[object])
         {
            return;
         }
         hideTip(object);
         delete tips[object];
         object.removeEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
         object.removeEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
         object.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);
      }
      
      public static function hideCurrent() : void
      {
         clearTimeout(interval);
         if(Boolean(currentTip) && Boolean(currentTip.stage))
         {
            currentTip.parent.removeChild(currentTip);
            currentTip = null;
         }
      }
      
      private static function onMouseOver(e:MouseEvent) : void
      {
         e.stopPropagation();
         hideCurrent();
         if(SimpleDragManager.isDragging)
         {
            return;
         }
         var object:DisplayObject = e.currentTarget as DisplayObject;
         var tip:ToolTipBase = tips[object];
         if(!tip)
         {
            return;
         }
         clearTimeout(interval);
         tip.prepare();
         interval = setTimeout(showObjectTip,DELAY,object);
      }
      
      private static function showObjectTip(object:DisplayObject) : void
      {
         var posX:Number = NaN;
         var posY:Number = NaN;
         var position:AlignPosition = null;
         var tip:ToolTipBase = tips[object];
         if(Boolean(object.stage) && Boolean(tip))
         {
            position = tip.position;
            if(Boolean(position))
            {
               if(!isNaN(position.left))
               {
                  posX = position.left;
               }
               else if(!isNaN(position.right))
               {
                  posX = object.stage.stageWidth - position.right - tip.width;
               }
               if(!isNaN(position.top))
               {
                  posY = position.top;
               }
               else if(!isNaN(position.bottom))
               {
                  posY = object.stage.stageHeight - position.bottom - tip.height;
               }
            }
            tip.x = isNaN(posX) ? Math.min(object.stage.mouseX + 10,object.stage.stageWidth - tip.width) : posX;
            tip.y = isNaN(posY) ? Math.min(object.stage.mouseY + 10,object.stage.stageHeight - tip.height) : posY;
            object.stage.addChild(tip);
            currentTip = tip;
         }
      }
      
      private static function onMouseOut(e:Event) : void
      {
         clearTimeout(interval);
         hideTip(e.currentTarget as DisplayObject);
      }
      
      private static function hideTip(object:DisplayObject) : void
      {
         var tip:ToolTipBase = tips[object];
         if(!tip || !tip.parent)
         {
            return;
         }
         if(Boolean(object.stage))
         {
            object.stage.removeChild(tip);
         }
         else
         {
            tip.parent.removeChild(tip);
         }
      }
      
      private static function onMouseDown(e:Event) : void
      {
         hideCurrent();
      }
   }
}

