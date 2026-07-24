package soul.view.field
{
   import flash.display.GradientType;
   import flash.display.Shape;
   import flash.filters.BlurFilter;
   import flash.geom.Matrix;
   import soul.model.interaction.settings.FowDisplay;
   
   public class Fov extends Shape
   {
      
      public static const COLOR:uint = 8947848;
      
      private static const MIN_SIZE:uint = 20;
      
      private static const BLUR:Array = [new BlurFilter(20,20)];
      
      private var _size:int = -1;
      
      private var _displayMode:uint = 0;
      
      public function Fov(size:int = 0)
      {
         super();
         cacheAsBitmap = true;
         this.updateSize(size);
      }
      
      public function updateSize(size:int) : void
      {
         if(size == this._size)
         {
            return;
         }
         this._size = size;
         this.redraw();
      }
      
      public function set displayMode(value:uint) : void
      {
         if(this._displayMode == value)
         {
            return;
         }
         this._displayMode = value;
         this.redraw();
      }
      
      private function redraw() : void
      {
         var m:Matrix = null;
         graphics.clear();
         if(this._size < MIN_SIZE)
         {
            visible = false;
            return;
         }
         visible = true;
         var r2:uint = uint(this._size >> 1);
         if(this._displayMode == FowDisplay.NORMAL)
         {
            m = new Matrix();
            m.createGradientBox(this._size << 1,this._size,0,-this._size,-r2);
            graphics.beginGradientFill(GradientType.RADIAL,[16777215,16777215,16777215],[1,0.7,0],[0,204,255],m);
            filters = [];
         }
         else
         {
            graphics.lineStyle(10,16777130,0.3);
            filters = BLUR;
         }
         graphics.drawEllipse(-this._size,-r2,this._size << 1,this._size);
         graphics.endFill();
      }
   }
}

