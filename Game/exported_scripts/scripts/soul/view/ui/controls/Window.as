package soul.view.ui.controls
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import soul.view.ui.BorderedContainer;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Label;
   import soul.view.ui.UIAssets;
   
   public class Window extends BorderedContainer
   {
      
      public static const DIALOG_CLOSE:String = "DIALOG_CLOSE";
      
      private static const LABEL_FILTERS:Array = [new GlowFilter(0,1,4,4)];
      
      private var titleBar:Canvas = new Canvas();
      
      protected var windowLabel:Label = new Label();
      
      public var closeButton:CachedImage = new CachedImage();
      
      private var isDragging:Boolean;
      
      public function Window()
      {
         super();
         direction = "vertical";
         focusRect = false;
         padding = 3;
         gap = 3;
         borderSkin = UIAssets.windowFrame;
         backgroundImage = UIAssets.pattern_05;
         this.titleBar.backgroundColor = 0;
         this.titleBar.backgroundAlpha = 0;
         this.titleBar.percentWidth = 100;
         this.titleBar.height = 23;
         this.closeButton.top = 6;
         this.closeButton.right = 14;
         this.closeButton.source = UIAssets.closeIcon01;
         this.titleBar.addChild(this.closeButton);
         this.windowLabel.horizontalCenter = 0;
         this.windowLabel.verticalCenter = 0;
         this.windowLabel.fontSize = 12;
         this.windowLabel.filters = LABEL_FILTERS;
         this.titleBar.addChild(this.windowLabel);
         addChild(this.titleBar);
         addEventListener(Event.ADDED_TO_STAGE,this.added);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
         this.titleBar.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.closeButton.addEventListener(MouseEvent.CLICK,this.exit);
      }
      
      public function tryToClose(e:Event) : void
      {
         if(this.closeButton.visible)
         {
            e.stopImmediatePropagation();
            e.stopPropagation();
            this.exit(e);
         }
      }
      
      public function tryToConfirm(e:Event) : void
      {
      }
      
      protected function added(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
      }
      
      protected function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         this.closeButton.removeEventListener(MouseEvent.CLICK,this.exit);
         this.titleBar.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.mouseUp(e);
      }
      
      private function mouseDown(e:Event) : void
      {
         if(e.target == this.closeButton)
         {
            return;
         }
         stage.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         startDrag();
         this.isDragging = true;
      }
      
      private function mouseUp(e:Event) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         if(this.isDragging)
         {
            stopDrag();
         }
      }
      
      protected function exit(e:Event) : void
      {
         PopupManager.removePopup(this);
      }
      
      public function set label(value:String) : void
      {
         this.windowLabel.text = value;
      }
      
      public function set closeVisible(value:Boolean) : void
      {
         this.closeButton.visible = value;
      }
      
      public function set titleColor(value:uint) : void
      {
         this.windowLabel.color = value;
      }
   }
}

