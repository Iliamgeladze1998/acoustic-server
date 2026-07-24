package soul.utils
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.IBitmapDrawable;
   import flash.display.Sprite;
   import flash.filters.BlurFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import soul.model.field.LibraryManager;
   import soul.model.field.OnionLayer;
   import soul.view.filters.HslFilter;
   
   public class BitmapUtils
   {
      
      private static var fullBmpCache:Dictionary = new Dictionary(true);
      
      public static const zeroPoint:Point = new Point();
      
      public function BitmapUtils()
      {
         super();
      }
      
      public static function makeHitArea(o:DisplayObject, grainSize:uint = 1) : Sprite
      {
         var x:int = 0;
         var s:Sprite = new Sprite();
         var g:Graphics = s.graphics;
         var rect:Rectangle = o.getBounds(o);
         if(rect.width < 1 || rect.height < 1)
         {
            return null;
         }
         var matr:Matrix = new Matrix();
         matr.tx = -rect.x;
         matr.ty = -rect.y;
         var bmpd:BitmapData = new BitmapData(rect.width,rect.height,true,0);
         bmpd.draw(o,matr);
         g.beginFill(16777215);
         for(var y:int = 0; y < rect.height; y++)
         {
            for(x = 0; x < rect.width; x++)
            {
               if((bmpd.getPixel32(x,y) >> 24 & 0xFF) > 0)
               {
                  g.drawRect(x + rect.x,y + rect.y,1,1);
               }
            }
         }
         g.endFill();
         bmpd.dispose();
         return s;
      }
      
      public static function createSnapshot(o:IBitmapDrawable, srcW:Number, srcH:Number, scale:Number) : BitmapData
      {
         var m:Matrix = null;
         var bmpSrc:BitmapData = null;
         var bmpDst:BitmapData = null;
         m = new Matrix(scale,0,0,scale);
         bmpDst = new BitmapData(Math.round(srcW * scale),Math.round(srcH * scale),true,0);
         try
         {
            bmpSrc = new BitmapData(srcW,srcH,true,0);
            bmpSrc.draw(o);
            bmpSrc.applyFilter(bmpSrc,bmpSrc.rect,zeroPoint,new BlurFilter(1 / scale / 2,1 / scale / 2));
            bmpDst.draw(bmpSrc,m);
            bmpSrc.dispose();
         }
         catch(e:ArgumentError)
         {
            bmpDst.draw(o,m);
         }
         return bmpDst;
      }
      
      public static function makeFullBitmaps(imageIds:Array, library:String, frameWidth:int, frameHeight:int, hsl:String = "") : Vector.<BitmapData>
      {
         var srcImage:String = null;
         var fullBitmaps:Vector.<BitmapData> = new Vector.<BitmapData>();
         for each(srcImage in imageIds)
         {
            fullBitmaps.push(makeFullBitmap(srcImage,library,frameWidth,frameHeight,hsl));
         }
         return fullBitmaps;
      }
      
      public static function makeFullBitmap(imageId:String, library:String, frameWidth:int, frameHeight:int, hsl:String = "") : BitmapData
      {
         var sourceBitmap:BitmapData = null;
         var key:String = library + "_" + imageId + "_" + hsl;
         if(fullBmpCache[key] == null)
         {
            sourceBitmap = getOriginalBitmap(imageId,library,hsl,false);
            if(!sourceBitmap)
            {
               return null;
            }
            fullBmpCache[key] = expandBitmap(sourceBitmap,frameWidth,frameHeight);
         }
         return fullBmpCache[key];
      }
      
      public static function expandBitmap(sourceBitmap:BitmapData, frameWidth:int, frameHeight:int) : BitmapData
      {
         var shiftX:int = 0;
         var j:int = 0;
         if(!sourceBitmap)
         {
            return null;
         }
         var fullBitmap:BitmapData = new BitmapData(sourceBitmap.width,sourceBitmap.height / 5 * 8,true);
         fullBitmap.lock();
         var p:Point = new Point(0,0);
         var frames:int = sourceBitmap.width / frameWidth;
         fullBitmap.copyPixels(sourceBitmap,new Rectangle(0,0,sourceBitmap.width,sourceBitmap.height),p);
         var r:Rectangle = new Rectangle();
         var fh2:int = frameHeight << 1;
         var fh3:int = frameHeight * 3;
         var fh5:int = frameHeight * 5;
         var fh6:int = frameHeight * 6;
         var fh7:int = frameHeight * 7;
         r.width = 1;
         r.height = frameHeight;
         for(var i:int = 0; i < frames; i++)
         {
            shiftX = i * frameWidth;
            for(j = 0; j < frameWidth; j++)
            {
               r.x = shiftX + frameWidth - j - 1;
               p.x = shiftX + j;
               r.y = frameHeight;
               p.y = fh7;
               fullBitmap.copyPixels(sourceBitmap,r,p);
               r.y = fh2;
               p.y = fh6;
               fullBitmap.copyPixels(sourceBitmap,r,p);
               r.y = fh3;
               p.y = fh5;
               fullBitmap.copyPixels(sourceBitmap,r,p);
            }
         }
         fullBitmap.unlock();
         return fullBitmap;
      }
      
      public static function makeLayeredBitmap(library:String, frameWidth:int, frameHeight:int, wardrobes:Object, hsls:Object) : BitmapData
      {
         var ret:BitmapData = null;
         var rect:Rectangle = null;
         var layerName:String = null;
         var garmentId:int = 0;
         var layerId:String = null;
         var layerBmp:BitmapData = null;
         var hsl:Object = null;
         var f:HslFilter = null;
         for each(layerName in OnionLayer.sortedLayers)
         {
            if(Boolean(wardrobes) && wardrobes[layerName] != null)
            {
               garmentId = int(wardrobes[layerName]);
               layerId = layerName + garmentId;
               layerBmp = LibraryManager.getBitmapData(layerId,library);
               if(!layerBmp && garmentId > 0)
               {
                  layerId = layerName + 0;
                  layerBmp = LibraryManager.getBitmapData(layerId,library);
               }
               if(layerBmp)
               {
                  if(Boolean(hsls))
                  {
                     hsl = hsls[layerName];
                     if(Boolean(hsl))
                     {
                        f = new HslFilter();
                        f.hue = hsl["h"];
                        f.saturation = hsl["s"];
                        f.lightness = hsl["l"];
                        layerBmp.applyFilter(layerBmp,layerBmp.rect,zeroPoint,f);
                     }
                  }
                  if(!ret)
                  {
                     ret = layerBmp;
                  }
                  else
                  {
                     ret.copyPixels(layerBmp,layerBmp.rect,zeroPoint,null,null,true);
                  }
               }
            }
         }
         return expandBitmap(ret,frameWidth,frameHeight);
      }
      
      public static function getOriginalBitmap(imageId:String, library:String, hsl:String = "", cache:Boolean = true) : BitmapData
      {
         var bmp:BitmapData = null;
         var f:HslFilter = null;
         var key:String = library + "_" + imageId + "_" + hsl;
         if(cache)
         {
            bmp = fullBmpCache[key];
            if(Boolean(bmp))
            {
               return bmp;
            }
         }
         bmp = LibraryManager.getBitmapData(imageId,library);
         if(!bmp)
         {
            return null;
         }
         var p:Point = new Point(0,0);
         var r:Rectangle = new Rectangle(0,0,bmp.width,bmp.height);
         if(hsl.length > 0)
         {
            f = new HslFilter();
            f.hsl = hsl;
            bmp.applyFilter(bmp,r,p,f);
         }
         if(cache)
         {
            fullBmpCache[key] = bmp;
         }
         return bmp;
      }
      
      public static function clearCache() : void
      {
         var key:String = null;
         for(key in fullBmpCache)
         {
            if(int(key.split("_")[1]) > 0)
            {
               delete fullBmpCache[key];
            }
         }
      }
   }
}

