package soul.view.field.visual.players.models
{
   import flash.display.BitmapData;
   import flash.display.ShaderJob;
   import flash.events.Event;
   import flash.events.ShaderEvent;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import soul.model.field.LibraryManager;
   import soul.model.field.OnionLayer;
   import soul.utils.BitmapUtils;
   import soul.utils.ShaderJobQueue;
   import soul.view.field.visual.RotatingBitmap;
   import soul.view.filters.HslFilter;
   
   public class LayeredUnitBitmap extends RotatingBitmap
   {
      
      private static const cache:Dictionary = new Dictionary(true);
      
      private var cacheKeys:Array = [];
      
      public function LayeredUnitBitmap()
      {
         super();
      }
      
      public function initLayered(wardrobes:Object, hsls:Object) : void
      {
         var layerName:String = null;
         var garmentId:int = 0;
         var layerId:String = null;
         var hsl:Object = null;
         var layerBmp:BitmapData = null;
         var cacheKey:String = null;
         var cached:Object = null;
         var f:HslFilter = null;
         var job:ShaderJob = null;
         for each(layerName in OnionLayer.sortedLayers)
         {
            if(Boolean(wardrobes) && wardrobes[layerName] != null)
            {
               garmentId = int(wardrobes[layerName]);
               layerId = layerName + garmentId;
               hsl = Boolean(hsls) ? hsls[layerName] : null;
               cacheKey = library + "/" + layerId + "/" + this.hslToString(hsl);
               cached = cache[cacheKey];
               if(!cached)
               {
                  layerBmp = LibraryManager.getBitmapData(layerId,library);
                  if(!layerBmp && garmentId > 0)
                  {
                     layerId = layerName + 0;
                     layerBmp = LibraryManager.getBitmapData(layerId,library);
                  }
                  if(layerBmp)
                  {
                     this.cacheKeys.push(cacheKey);
                     if(Boolean(hsl))
                     {
                        f = new HslFilter();
                        f.hue = hsl["h"];
                        f.saturation = hsl["s"];
                        f.lightness = hsl["l"];
                        job = new ShaderJob(f.shader,layerBmp);
                        f.shader.data.src.input = layerBmp;
                        job.addEventListener(ShaderEvent.COMPLETE,this.jobDone,false,1);
                        job.addEventListener(ShaderEvent.COMPLETE,this.jobProcessed);
                        cache[cacheKey] = job;
                        ShaderJobQueue.addToQueue(job);
                     }
                     else
                     {
                        cache[cacheKey] = layerBmp;
                     }
                  }
               }
               else if(cached is ShaderJob)
               {
                  this.cacheKeys.push(cacheKey);
                  ShaderJob(cached).addEventListener(ShaderEvent.COMPLETE,this.jobProcessed);
               }
               else if(cached is BitmapData)
               {
                  this.cacheKeys.push(cacheKey);
               }
            }
         }
         this.jobProcessed(null);
      }
      
      private function jobDone(e:ShaderEvent) : void
      {
         var key:String = null;
         var job:ShaderJob = e.target as ShaderJob;
         for(key in cache)
         {
            if(cache[key] == job)
            {
               cache[key] = e.bitmapData;
               break;
            }
         }
      }
      
      private function jobProcessed(e:Event) : void
      {
         var key:String = null;
         var ret:BitmapData = null;
         var layerBmp:BitmapData = null;
         for each(key in this.cacheKeys)
         {
            if(!(cache[key] is BitmapData))
            {
               return;
            }
         }
         trace("LUB start ",getTimer());
         for each(key in this.cacheKeys)
         {
            layerBmp = cache[key];
            if(!ret)
            {
               ret = layerBmp;
            }
            else
            {
               ret.copyPixels(layerBmp,layerBmp.rect,BitmapUtils.zeroPoint,null,null,true);
            }
         }
         trace("LUB mid ",getTimer());
         fullBitmaps = Vector.<BitmapData>([BitmapUtils.expandBitmap(ret,frameWidth,frameHeight)]);
         trace("LUB end ",getTimer());
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function hslToString(hsl:Object) : String
      {
         if(!hsl)
         {
            return null;
         }
         return hsl.h + "_" + hsl.s + "_" + hsl.l;
      }
   }
}

