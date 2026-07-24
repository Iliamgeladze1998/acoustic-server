package soul.view.assets
{
   import flash.display.GradientType;
   import flash.geom.Matrix;
   import soul.view.ui.Canvas;
   
   public class GradientBox extends Canvas
   {
      
      private var _gradient:Array = [[1996488704,127],0];
      
      private var _bgPaddingLeft:int = 0;
      
      public function GradientBox()
      {
         super();
      }
      
      public function set gradient(value:Array) : void
      {
         this._gradient = value;
         this.draw();
      }
      
      public function set bgPaddingLeft(value:int) : void
      {
         this._bgPaddingLeft = value;
         this.redraw();
      }
      
      public function draw() : void
      {
         this.redraw();
      }
      
      override protected function redraw() : void
      {
         var color:uint = 0;
         var ratio:uint = 0;
         var entry:Object = null;
         var a:Number = NaN;
         super.redraw();
         graphics.clear();
         var width:int = this.width - this._bgPaddingLeft;
         if(width < 1 || height < 1)
         {
            return;
         }
         var m:Matrix = new Matrix();
         m.createGradientBox(width,height);
         var alphas:Array = [];
         var ratios:Array = [];
         var colors:Array = [];
         for(var i:int = 0; i < this._gradient.length; i++)
         {
            ratio = 0;
            entry = this._gradient[i];
            if(entry is Array)
            {
               color = uint(entry[0]);
               ratio = uint(entry[1]);
            }
            else
            {
               color = uint(entry);
            }
            a = (color >> 24 & 0xFF) / 255;
            colors.push(color & 0xFFFFFF);
            alphas.push(a);
            ratios.push(ratio > 0 ? ratio : uint(255 * i / (this._gradient.length - 1)));
         }
         graphics.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,m);
         graphics.drawRect(this._bgPaddingLeft,0,width,height);
         graphics.endFill();
      }
   }
}

