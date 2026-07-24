package soul.view.ui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import mx.core.BitmapAsset;
   
   public class BorderedContainer extends Box
   {
      
      protected var border:DisplayObject;
      
      private var _backgroundImage:BitmapData;
      
      public function BorderedContainer()
      {
         super();
      }
      
      public function set backgroundImage(value:Object) : void
      {
         if(Boolean(this._backgroundImage))
         {
            this._backgroundImage.dispose();
         }
         if(value is BitmapData)
         {
            this._backgroundImage = (value as BitmapData).clone();
         }
         if(value is Bitmap)
         {
            this._backgroundImage = (value as Bitmap).bitmapData;
         }
         if(value is Class)
         {
            try
            {
               value = new value(0,0);
            }
            catch(e:Error)
            {
               value = new value();
            }
            if(value is BitmapAsset)
            {
               this._backgroundImage = (value as BitmapAsset).bitmapData;
            }
         }
         if(!value)
         {
            this._backgroundImage = null;
         }
         updateLater();
      }
      
      public function set borderSkin(value:Object) : void
      {
         var bmp:BitmapData = null;
         if(Boolean(this.border) && background.contains(this.border))
         {
            background.removeChild(this.border);
            this.border = null;
         }
         if(!value)
         {
            return;
         }
         if(value is Class)
         {
            try
            {
               bmp = new value(0,0);
               this.border = new Bitmap(BitmapData(value));
            }
            catch(e:Error)
            {
               border = new value();
            }
         }
         this.border.width = width;
         this.border.height = height;
         background.addChildAt(this.border,0);
      }
      
      override protected function redraw() : void
      {
         var p2:int = 0;
         if(Boolean(this.border) && background.contains(this.border))
         {
            background.removeChild(this.border);
         }
         super.redraw();
         if(Boolean(this.border))
         {
            background.addChildAt(this.border,0);
            this.border.width = width;
            this.border.height = height;
         }
         if(backgroundColor > -1 || Boolean(this._backgroundImage))
         {
            p2 = backgroundPadding * 2;
            background.graphics.clear();
            if(Boolean(this._backgroundImage))
            {
               background.graphics.beginBitmapFill(this._backgroundImage);
            }
            else
            {
               background.graphics.beginFill(backgroundColor,backgroundAlpha);
            }
            background.graphics.drawRect(backgroundPadding,backgroundPadding,width - p2,height - p2);
            background.graphics.endFill();
         }
         else
         {
            background.graphics.clear();
         }
      }
   }
}

