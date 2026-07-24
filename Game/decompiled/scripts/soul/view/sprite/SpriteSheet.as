package soul.view.sprite
{
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.net.registerClassAlias;
   import flash.utils.ByteArray;
   import soul.utils.Thread2;
   
   public class SpriteSheet extends EventDispatcher
   {
      
      private static const ANGLES:uint = 8;
      
      registerClassAlias("SpriteSheet",SpriteSheet);
      
      public var loaded:Boolean;
      
      public var index:int = -1;
      
      private var sprites:Vector.<Vector.<SpriteEntry>>;
      
      private var thread:Thread2;
      
      private var billBoard:Boolean;
      
      private var src:BitmapData;
      
      private var frameWidth:uint;
      
      private var frameHeight:uint;
      
      private var frameCount:uint;
      
      private var frame:BitmapData;
      
      private var rect:Rectangle;
      
      private var matrix:Matrix;
      
      private var mirror:Matrix;
      
      private var transparent:Boolean;
      
      private var i:uint;
      
      private var j:uint;
      
      private var _angles:uint;
      
      public function SpriteSheet()
      {
         super();
      }
      
      private static function createCroppedFrame(frame:BitmapData, transparent:Boolean) : SpriteEntry
      {
         var cropFrame:BitmapData = null;
         var cropMatrix:Matrix = null;
         var cropRect:Rectangle = frame.getColorBoundsRect(4294967295,0,false);
         if(cropRect.width > 0 && cropRect.height > 0)
         {
            cropMatrix = new Matrix();
            cropMatrix.tx = -cropRect.x;
            cropMatrix.ty = -cropRect.y;
            cropFrame = new BitmapData(cropRect.width,cropRect.height,transparent,0);
            cropFrame.draw(frame,cropMatrix);
            frame.dispose();
         }
         else
         {
            cropFrame = frame;
         }
         return new SpriteEntry(cropFrame,cropRect.x,cropRect.y);
      }
      
      public function load(src:BitmapData, frameWidth:uint, frameHeight:uint, billBoard:Boolean = false) : void
      {
         if(!src)
         {
            return;
         }
         this.prepare(src,frameWidth,frameHeight,billBoard);
         while(!this.chunk())
         {
         }
         this.loadComplete(null);
      }
      
      public function loadAsync(src:BitmapData, frameWidth:uint, frameHeight:uint, billBoard:Boolean = false) : void
      {
         if(!src)
         {
            return this.loadComplete(null);
         }
         this.prepare(src,frameWidth,frameHeight,billBoard);
         this.thread = new Thread2();
         this.thread.addEventListener(Event.COMPLETE,this.loadComplete);
         this.thread.start(this.chunk);
      }
      
      private function prepare(src:BitmapData, frameWidth:uint, frameHeight:uint, billBoard:Boolean = false) : void
      {
         this._angles = billBoard ? 1 : ANGLES;
         this.src = src;
         this.frameWidth = frameWidth;
         this.frameHeight = frameHeight;
         this.billBoard = billBoard;
         this.frameCount = src.width / frameWidth;
         src.lock();
         this.sprites = new Vector.<Vector.<SpriteEntry>>(this.frameCount,true);
         this.rect = new Rectangle(0,0,frameWidth,frameHeight);
         this.matrix = new Matrix();
         this.mirror = new Matrix(-1);
         this.transparent = src.transparent;
         this.i = 0;
         for(this.j = 0; this.j < this.frameCount; ++this.j)
         {
            this.sprites[this.j] = new Vector.<SpriteEntry>(this._angles,true);
         }
      }
      
      private function chunk() : Boolean
      {
         this.matrix.tx = -this.frameWidth * this.i;
         if(this.billBoard)
         {
            this.frame = new BitmapData(this.frameWidth,this.frameHeight,this.transparent,0);
            this.frame.draw(this.src,this.matrix,null,null,this.rect);
            this.sprites[this.i][0] = createCroppedFrame(this.frame,this.transparent);
         }
         else
         {
            for(this.j = 0; this.j < 5; ++this.j)
            {
               this.matrix.ty = -this.frameHeight * this.j;
               this.frame = new BitmapData(this.frameWidth,this.frameHeight,this.transparent,0);
               this.frame.draw(this.src,this.matrix,null,null,this.rect);
               this.sprites[this.i][this.j] = createCroppedFrame(this.frame,this.transparent);
            }
            this.mirror.tx = this.frameWidth * (this.i + 1);
            for(this.j = 5; this.j < this.angles; ++this.j)
            {
               this.mirror.ty = -this.frameHeight * (8 - this.j);
               this.frame = new BitmapData(this.frameWidth,this.frameHeight,this.transparent,0);
               this.frame.draw(this.src,this.mirror);
               this.sprites[this.i][this.j] = createCroppedFrame(this.frame,this.transparent);
            }
         }
         ++this.i;
         return this.i >= this.frameCount;
      }
      
      private function loadComplete(e:Event) : void
      {
         if(Boolean(this.thread))
         {
            this.thread.removeEventListener(Event.COMPLETE,this.loadComplete);
            this.thread = null;
         }
         this.src.dispose();
         this.src = null;
         this.frame = null;
         this.rect = null;
         this.matrix = null;
         this.mirror = null;
         this.loaded = true;
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      public function get angles() : uint
      {
         return this._angles;
      }
      
      public function get frames() : uint
      {
         return Boolean(this.sprites) ? this.sprites.length : 0;
      }
      
      public function getAnglesByFrame(frame:uint) : Vector.<SpriteEntry>
      {
         return frame < this.sprites.length ? this.sprites[frame] : null;
      }
      
      public function setBytes(input:ByteArray) : void
      {
         var j:uint = 0;
         var se:SpriteEntry = null;
         this._angles = input.readUnsignedInt();
         var frames:uint = input.readUnsignedInt();
         this.sprites = new Vector.<Vector.<SpriteEntry>>(frames,true);
         for(var i:uint = 0; i < frames; i++)
         {
            this.sprites[i] = new Vector.<SpriteEntry>(this._angles,true);
            for(j = 0; j < this._angles; j++)
            {
               se = new SpriteEntry();
               se.setBytes(input);
               this.sprites[i][j] = se;
            }
         }
         this.loaded = true;
      }
      
      public function getBytes() : ByteArray
      {
         var j:uint = 0;
         var out:ByteArray = new ByteArray();
         out.writeUnsignedInt(this._angles);
         var frames:uint = this.sprites.length;
         out.writeUnsignedInt(frames);
         for(var i:uint = 0; i < frames; i++)
         {
            for(j = 0; j < this._angles; j++)
            {
               out.writeBytes(this.sprites[i][j].getBytes());
            }
         }
         return out;
      }
   }
}

