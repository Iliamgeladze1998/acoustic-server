package soul.view.astral
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import mx.binding.BindingManager;
   import mx.events.PropertyChangeEvent;
   import soul.event.AstralEvent;
   import soul.event.SimpleUIEvent;
   import soul.model.astral.AstralCircle;
   import soul.model.astral.AstralModel;
   import soul.model.system.Configuration;
   import soul.view.ui.CachedImage;
   import soul.view.ui.Canvas;
   import soul.view.ui.Component;
   
   public class AstralMinimap extends Canvas
   {
      
      private static const BORDER_COLOR:uint = 16777215;
      
      private static const PADDING:uint = 1;
      
      private static const BLUR_FIX:Number = 0.5;
      
      private var _288868133circlesCanvas:Component;
      
      private var _100313435image:CachedImage;
      
      private var _2106220098viewPortCanvas:Component;
      
      public var model:AstralModel;
      
      private var viewPortPositionX:int;
      
      private var viewPortPositionY:int;
      
      private var miniMapViewPortHeight:int;
      
      private var miniMapViewPortWidth:int;
      
      public function AstralMinimap()
      {
         super();
         this.width = 223;
         this.height = 156;
         this.children = [this._AstralMinimap_CachedImage1_i(),this._AstralMinimap_Component1_i(),this._AstralMinimap_Component2_i()];
         this.addEventListener("creationComplete",this.___AstralMinimap_Canvas1_creationComplete);
      }
      
      public function creationComplete() : void
      {
         this.model.addEventListener(AstralEvent.INIT,this.modelUpdated,false,0,true);
         this.model.addEventListener(AstralEvent.IMAGE_LOADED,this.modelUpdated,false,0,true);
         this.model.addEventListener(AstralEvent.FOCUS_COMLETED,this.setViewPortPosition,false,0,true);
         this.model.addEventListener(AstralEvent.DRAG,this.setViewPortPosition,false,0,true);
         this.model.addEventListener(AstralEvent.RESIZE,this.onResize);
         this.image.addEventListener(MouseEvent.MOUSE_DOWN,this.onImageDown);
         if(this.model.enabled)
         {
            this.modelUpdated(null);
         }
      }
      
      private function onResize(e:Event) : void
      {
         this.drawViewPort();
      }
      
      private function modelUpdated(e:AstralEvent) : void
      {
         this.image.source = Configuration.getImage(this.model.image);
         this.redrawMiniMap();
      }
      
      private function setViewPortPosition(e:AstralEvent) : void
      {
         this.viewPortPositionX = Math.abs(this.model.x / this.model.globalMapHeight * height) + PADDING;
         this.viewPortPositionY = Math.abs(this.model.y / this.model.globalMapWidth * width) + PADDING;
         this.redrawMiniMap();
      }
      
      private function onImageDown(e:MouseEvent) : void
      {
         stage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.image.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
      }
      
      private function onMouseUp(e:MouseEvent) : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.image.removeEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         this.onMouseMove(e);
      }
      
      private function onMouseMove(e:MouseEvent) : void
      {
         var mouseX:int = int(e.localX);
         var mouseY:int = int(e.localY);
         this.viewPortPositionX = mouseX - this.miniMapViewPortWidth / 2;
         this.viewPortPositionY = mouseY - this.miniMapViewPortHeight / 2;
         this.redrawMiniMap();
         this.model.x = this.viewPortPositionX * this.model.globalMapHeight / height;
         this.model.y = this.viewPortPositionY * this.model.globalMapWidth / width;
         this.model.dispatchEvent(new AstralEvent(AstralEvent.INSTANT_FOCUS));
      }
      
      private function redrawMiniMap() : void
      {
         this.drawViewPort();
         this.drawCircle();
      }
      
      private function drawViewPort() : void
      {
         this.miniMapViewPortHeight = this.model.screenHeight / this.model.globalMapHeight * height - PADDING * 2;
         this.miniMapViewPortWidth = this.model.screenWidth / this.model.globalMapWidth * width - PADDING;
         var maxX:Number = width - this.miniMapViewPortWidth - PADDING * 3;
         var maxY:Number = height - this.miniMapViewPortHeight - PADDING * 4;
         if(this.viewPortPositionX < PADDING)
         {
            this.viewPortPositionX = PADDING;
         }
         if(this.viewPortPositionY < PADDING)
         {
            this.viewPortPositionY = PADDING;
         }
         if(this.viewPortPositionX > maxX)
         {
            this.viewPortPositionX = maxX;
         }
         if(this.viewPortPositionY > maxY)
         {
            this.viewPortPositionY = maxY;
         }
         this.viewPortCanvas.graphics.clear();
         this.viewPortCanvas.graphics.lineStyle(1,BORDER_COLOR);
         this.viewPortCanvas.graphics.drawRect(this.viewPortPositionX + BLUR_FIX,this.viewPortPositionY + BLUR_FIX,this.miniMapViewPortWidth,this.miniMapViewPortHeight);
      }
      
      private function drawCircle() : void
      {
         var circle:AstralCircle = null;
         var circlePositionX:int = 0;
         var circlePositionY:int = 0;
         var color:uint = 0;
         this.circlesCanvas.graphics.clear();
         for each(circle in this.model.circles)
         {
            circlePositionX = circle.x / this.model.globalMapHeight * height;
            circlePositionY = circle.y / this.model.globalMapWidth * width;
            color = circle.accessible ? 65280 : 13421772;
            this.circlesCanvas.graphics.lineStyle(1,color);
            this.circlesCanvas.graphics.drawCircle(circlePositionX,circlePositionY,3);
         }
      }
      
      private function _AstralMinimap_CachedImage1_i() : CachedImage
      {
         var _loc1_:CachedImage = new CachedImage();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         this.image = _loc1_;
         BindingManager.executeBindings(this,"image",this.image);
         return _loc1_;
      }
      
      private function _AstralMinimap_Component1_i() : Component
      {
         var _loc1_:Component = null;
         _loc1_ = new Component();
         _loc1_.mouseEnabled = false;
         this.circlesCanvas = _loc1_;
         BindingManager.executeBindings(this,"circlesCanvas",this.circlesCanvas);
         return _loc1_;
      }
      
      private function _AstralMinimap_Component2_i() : Component
      {
         var _loc1_:Component = new Component();
         _loc1_.mouseEnabled = false;
         this.viewPortCanvas = _loc1_;
         BindingManager.executeBindings(this,"viewPortCanvas",this.viewPortCanvas);
         return _loc1_;
      }
      
      public function ___AstralMinimap_Canvas1_creationComplete(event:SimpleUIEvent) : void
      {
         this.creationComplete();
      }
      
      [Bindable(event="propertyChange")]
      public function get circlesCanvas() : Component
      {
         return this._288868133circlesCanvas;
      }
      
      public function set circlesCanvas(param1:Component) : void
      {
         var _loc2_:Object = this._288868133circlesCanvas;
         if(_loc2_ !== param1)
         {
            this._288868133circlesCanvas = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"circlesCanvas",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get image() : CachedImage
      {
         return this._100313435image;
      }
      
      public function set image(param1:CachedImage) : void
      {
         var _loc2_:Object = this._100313435image;
         if(_loc2_ !== param1)
         {
            this._100313435image = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"image",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get viewPortCanvas() : Component
      {
         return this._2106220098viewPortCanvas;
      }
      
      public function set viewPortCanvas(param1:Component) : void
      {
         var _loc2_:Object = this._2106220098viewPortCanvas;
         if(_loc2_ !== param1)
         {
            this._2106220098viewPortCanvas = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"viewPortCanvas",_loc2_,param1));
            }
         }
      }
   }
}

