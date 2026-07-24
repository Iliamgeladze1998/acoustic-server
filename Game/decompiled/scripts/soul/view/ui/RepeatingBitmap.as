package soul.view.ui
{
   import flash.display.BitmapData;
   
   public class RepeatingBitmap extends Component
   {
      
      private var _bitmapData:BitmapData;
      
      public function RepeatingBitmap()
      {
         super();
         cacheAsBitmap = true;
      }
      
      public function set bitmapData(value:BitmapData) : void
      {
         if(this._bitmapData == value)
         {
            return;
         }
         this._bitmapData = value;
         this.redraw();
      }
      
      override protected function redraw() : void
      {
         graphics.clear();
         if(!this._bitmapData)
         {
            return;
         }
         graphics.beginBitmapFill(this._bitmapData,null,true);
         graphics.drawRect(0,0,width,height);
         graphics.endFill();
      }
   }
}

