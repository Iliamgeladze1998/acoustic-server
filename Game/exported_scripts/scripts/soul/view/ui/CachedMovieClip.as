package soul.view.ui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.Timer;
   import flash.utils.getQualifiedClassName;
   import soul.utils.ClassUtils;
   
   public class CachedMovieClip extends Sprite
   {
      
      private static const timer:Timer = new Timer(1000 / 24);
      
      private static const cache:Object = {};
      
      timer.start();
      
      private var info:CachedInfo;
      
      private var _currentFrame:int = 0;
      
      private var bitmap:Bitmap;
      
      private var playing:Boolean = true;
      
      public function CachedMovieClip(info:CachedInfo)
      {
         super();
         mouseChildren = false;
         if(!info)
         {
            return;
         }
         this.info = info;
         this.bitmap = new Bitmap(info.bitmaps[this._currentFrame]);
         this.bitmap.x = info.x;
         this.bitmap.y = info.y;
         addChild(this.bitmap);
         addEventListener(Event.ADDED_TO_STAGE,this.added);
         addEventListener(Event.REMOVED_FROM_STAGE,this.removed);
      }
      
      private static function create(mc:MovieClip) : CachedInfo
      {
         var rect:Rectangle = null;
         var bd:BitmapData = null;
         var info:CachedInfo = new CachedInfo();
         if(!mc)
         {
            return null;
         }
         var m:Matrix = new Matrix();
         var frames:uint = uint(mc.totalFrames);
         info.bitmaps = new Vector.<BitmapData>(frames,true);
         info.points = new Vector.<Point>(frames,true);
         for(var i:uint = 1; i <= frames; i++)
         {
            mc.gotoAndStop(i);
            rect = mc.getBounds(mc);
            rect.x = Math.round(rect.x - 1);
            rect.y = Math.round(rect.y - 1);
            m.tx = -rect.x;
            m.ty = -rect.y;
            bd = new BitmapData(Math.round(rect.width) + 1,Math.round(rect.height) + 1,true,0);
            bd.draw(mc,m);
            info.bitmaps[i - 1] = bd;
            info.points[i - 1] = new Point(rect.x,rect.y);
         }
         info.totalFrames = frames;
         return info;
      }
      
      public static function wrap(source:Object) : DisplayObject
      {
         var mc:MovieClip = null;
         var superClass:Class = ClassUtils.getSuperclass(source);
         if(superClass != MovieClip)
         {
            if(source is Class)
            {
               if(superClass == BitmapData)
               {
                  return new source(1,1);
               }
               return new source();
            }
            return source as DisplayObject;
         }
         var className:String = getQualifiedClassName(source);
         var info:CachedInfo = cache[className];
         if(!info)
         {
            mc = (source is Class ? new source() : source) as MovieClip;
            if(mc.totalFrames < 2)
            {
               mc.cacheAsBitmap = true;
               return mc;
            }
            info = create(mc);
            cache[className] = info;
         }
         return new CachedMovieClip(info);
      }
      
      private function added(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         timer.addEventListener(TimerEvent.TIMER,this.tick);
      }
      
      private function removed(e:Event) : void
      {
         if(e.target != this)
         {
            return;
         }
         timer.removeEventListener(TimerEvent.TIMER,this.tick);
      }
      
      private function tick(e:TimerEvent) : void
      {
         if(!this.playing)
         {
            return;
         }
         if(hasEventListener(Event.ENTER_FRAME))
         {
            dispatchEvent(new Event(Event.ENTER_FRAME));
         }
         ++this._currentFrame;
         if(this._currentFrame >= this.totalFrames)
         {
            this._currentFrame = 0;
         }
         this.bitmap.bitmapData = this.info.bitmaps[this._currentFrame];
         var p:Point = this.info.points[this._currentFrame];
         this.bitmap.x = p.x;
         this.bitmap.y = p.y;
         if(hasEventListener(Event.EXIT_FRAME))
         {
            dispatchEvent(new Event(Event.EXIT_FRAME));
         }
      }
      
      public function get totalFrames() : uint
      {
         return this.info.totalFrames;
      }
      
      public function get currentFrame() : uint
      {
         return this._currentFrame + 1;
      }
      
      public function gotoAndPlay(frame:uint) : void
      {
         this.playing = true;
         this._currentFrame = (frame >= this.totalFrames ? this.totalFrames - 1 : frame) - 1;
         this.tick(null);
      }
      
      public function stop() : void
      {
         this.playing = false;
      }
   }
}

import flash.display.BitmapData;
import flash.geom.Point;

class CachedInfo
{
   
   public var x:int;
   
   public var y:int;
   
   public var totalFrames:uint;
   
   public var bitmaps:Vector.<BitmapData>;
   
   public var points:Vector.<Point>;
   
   public function CachedInfo()
   {
      super();
   }
}
