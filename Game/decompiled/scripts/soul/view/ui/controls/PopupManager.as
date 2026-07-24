package soul.view.ui.controls
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import flash.ui.Keyboard;
   import soul.view.AlignPosition;
   
   public class PopupManager
   {
      
      private static var impl:PopupManagerImpl;
      
      public static var CANCEL:uint = Keyboard.ESCAPE;
      
      public function PopupManager()
      {
         super();
      }
      
      public static function init(stage:Stage) : void
      {
         if(Boolean(impl))
         {
            throw new Error("PopupManager is already initialized");
         }
         impl = new PopupManagerImpl(stage);
      }
      
      public static function addPopup(popup:DisplayObject, parent:DisplayObjectContainer = null, modal:Boolean = false) : void
      {
         impl.addPopup(popup,parent,modal);
      }
      
      public static function removePopup(popup:DisplayObject) : void
      {
         impl.removePopup(popup);
      }
      
      public static function align(popup:DisplayObject, align:AlignPosition) : void
      {
         impl.align(popup,align);
      }
      
      public static function centerPopup(popup:DisplayObject) : void
      {
         impl.centerPopup(popup);
      }
      
      public static function getCurrentPopup() : DisplayObject
      {
         return impl.getCurrentPopup();
      }
      
      public static function get stage() : Stage
      {
         return impl.stage;
      }
   }
}

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.Sprite;
import flash.display.Stage;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.ui.Keyboard;
import soul.event.SimpleUIEvent;
import soul.view.AlignPosition;
import soul.view.ui.Component;
import soul.view.ui.Container;

class PopupManagerImpl
{
   
   public var stage:Stage;
   
   private var popups:Vector.<DisplayObject> = new Vector.<DisplayObject>();
   
   public function PopupManagerImpl(stage:Stage)
   {
      super();
      this.stage = stage;
      stage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyUp,false,100);
   }
   
   public function addPopup(popup:DisplayObject, parent:DisplayObjectContainer = null, modal:Boolean = false) : void
   {
      var container:DisplayObjectContainer = Boolean(parent) ? parent : this.stage;
      if(modal)
      {
         container.addChild(new ModalShield(popup));
      }
      container.addChild(popup);
      popup.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
      popup.addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStage);
      this.popups.push(popup);
   }
   
   public function removePopup(popup:DisplayObject) : void
   {
      if(Boolean(popup.parent))
      {
         popup.parent.removeChild(popup);
      }
   }
   
   public function align(popup:DisplayObject, position:AlignPosition) : void
   {
      var posX:Number = NaN;
      var posY:Number = NaN;
      if(!popup.parent)
      {
         return;
      }
      var stage:Stage = popup.parent is Stage ? this.stage : null;
      var w:Number = Boolean(stage) ? stage.stageWidth : popup.parent.width;
      var h:Number = Boolean(stage) ? stage.stageHeight : popup.parent.height;
      if(!isNaN(position.left))
      {
         posX = position.left;
      }
      else if(!isNaN(position.right))
      {
         posX = w - position.right - popup.width;
      }
      if(!isNaN(position.top))
      {
         posY = position.top;
      }
      else if(!isNaN(position.bottom))
      {
         posY = h - position.bottom - popup.height;
      }
      popup.x = posX;
      popup.y = posY;
   }
   
   public function centerPopup(popup:DisplayObject) : void
   {
      if(popup is Container)
      {
         if(Container(popup).initialized)
         {
            this.centerNow(popup);
         }
         else
         {
            popup.addEventListener(SimpleUIEvent.CREATION_COMPLETE,this.centerLater);
         }
      }
      else
      {
         this.centerNow(popup);
      }
   }
   
   private function centerNow(popup:DisplayObject) : void
   {
      var stage:Stage = null;
      var w2:Number = NaN;
      var h2:Number = NaN;
      if(Boolean(popup.parent))
      {
         stage = popup.parent is Stage ? this.stage : null;
         w2 = (Boolean(stage) ? stage.stageWidth : popup.parent.width) / 2;
         h2 = (Boolean(stage) ? stage.stageHeight : popup.parent.height) / 2;
         popup.x = int(w2 - popup.width / 2);
         popup.y = int(h2 - popup.height / 2);
      }
   }
   
   private function onMouseDown(e:MouseEvent) : void
   {
      var popup:DisplayObject = e.currentTarget as DisplayObject;
      popup.parent.setChildIndex(popup,popup.parent.numChildren - 1);
      var index:int = int(this.popups.indexOf(popup));
      if(index == -1)
      {
         return;
      }
      this.popups.splice(index,1);
      this.popups.push(popup);
   }
   
   private function removedFromStage(e:Event) : void
   {
      var popup:DisplayObject = e.currentTarget as DisplayObject;
      var index:int = int(this.popups.indexOf(popup));
      if(index == -1)
      {
         return;
      }
      this.popups.splice(index,1);
   }
   
   private function centerLater(e:SimpleUIEvent) : void
   {
      var popup:DisplayObject = e.target as DisplayObject;
      popup.removeEventListener(SimpleUIEvent.CREATION_COMPLETE,this.centerLater);
      this.centerNow(popup);
   }
   
   private function onKeyUp(e:KeyboardEvent) : void
   {
      if(this.stage.focus is TextField && TextField(this.stage.focus).type == TextFieldType.INPUT)
      {
         return;
      }
      var last:Window = this.getCurrentPopup() as Window;
      if(!last)
      {
         return;
      }
      if(e.keyCode == PopupManager.CANCEL)
      {
         last.tryToClose(e);
      }
      else if(e.keyCode == Keyboard.ENTER)
      {
         last.tryToConfirm(e);
      }
   }
   
   public function getCurrentPopup() : DisplayObject
   {
      if(this.popups.length > 0)
      {
         return this.popups[this.popups.length - 1];
      }
      return null;
   }
}

class ModalShield extends Component
{
   
   private var popup:DisplayObject;
   
   public function ModalShield(popup:DisplayObject)
   {
      super();
      this.popup = popup;
      addEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
      popup.addEventListener(Event.REMOVED_FROM_STAGE,this.popupRemoved);
   }
   
   override protected function redraw() : void
   {
      if(!parent)
      {
         return;
      }
      var width:uint = parent is Stage ? uint(Stage(parent).stageWidth) : uint(parent.width);
      var height:uint = parent is Stage ? uint(Stage(parent).stageHeight) : uint(parent.height);
      graphics.clear();
      graphics.beginFill(0,0.4);
      graphics.drawRect(0,0,width,height);
      graphics.endFill();
   }
   
   private function addedToStage(e:Event) : void
   {
      parent.addEventListener(Event.RESIZE,this.onResize);
      this.redraw();
   }
   
   private function onResize(e:Event) : void
   {
      this.redraw();
   }
   
   private function popupRemoved(e:Event) : void
   {
      if(e.target != this.popup)
      {
         return;
      }
      this.popup.removeEventListener(Event.REMOVED,this.popupRemoved);
      parent.removeEventListener(Event.RESIZE,this.onResize);
      parent.removeChild(this);
   }
}
