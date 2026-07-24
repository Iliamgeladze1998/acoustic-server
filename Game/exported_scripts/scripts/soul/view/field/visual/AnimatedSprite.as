package soul.view.field.visual
{
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.utils.getTimer;
   import soul.model.field.mapconfig.AspectRatio;
   import soul.view.sprite.SpriteEntry;
   
   public class AnimatedSprite extends Sprite implements IBitmapSprite
   {
      
      private static const L:Number = Math.PI / 4;
      
      protected var playing:Boolean;
      
      private var lastPlayedTime:uint;
      
      protected var currentFrame:uint;
      
      protected var currentAnimationLooped:Boolean;
      
      protected var currentAnimationType:String;
      
      protected var defaultAnimation:Function;
      
      private var _angle:int;
      
      protected var frameBmp:Bitmap;
      
      protected var spriteEntry:SpriteEntry;
      
      private var offsetX:int;
      
      private var offsetY:int;
      
      private var _unitBitmap:RotatingBitmap;
      
      private var frameDirty:Boolean = true;
      
      public function AnimatedSprite()
      {
         super();
      }
      
      public static function getAngle(dx:int, dy:int) : int
      {
         var rad:Number = Math.atan2(dy,dx);
         return (rad / L + 10.5) % 8;
      }
      
      public function dispose() : void
      {
      }
      
      protected function set unitBitmap(value:RotatingBitmap) : void
      {
         this.dispose();
         this._unitBitmap = value;
         if(Boolean(this.frameBmp))
         {
            removeChild(this.frameBmp);
         }
         if(Boolean(value))
         {
            this.frameBmp = new Bitmap();
            this.offsetX = value.spriteCenter.x;
            this.offsetY = value.spriteCenter.y;
            addChild(this.frameBmp);
         }
      }
      
      protected function get unitBitmap() : RotatingBitmap
      {
         return this._unitBitmap;
      }
      
      public function turnTo(x:Number, y:Number) : uint
      {
         var dx:Number = x - this.x;
         var dy:Number = y - this.y;
         this.angle = getAngle(dx,dy);
         dy *= AspectRatio.y;
         return Math.sqrt(dx * dx + dy * dy);
      }
      
      protected function startAnimation() : void
      {
         this.playing = true;
         this.animate();
      }
      
      protected function stopAnimation() : void
      {
         this.playing = false;
      }
      
      public function animate() : void
      {
         var frameToDisplay:uint = 0;
         var timePassed:uint = 0;
         var framesPassed:uint = 0;
         if(!this.playing || !visible || !this.unitBitmap.currentSprites)
         {
            return;
         }
         var fpms:Number = this.unitBitmap.fps / 1000;
         var now:uint = uint(getTimer());
         var needsRedraw:Boolean = false;
         if(this.lastPlayedTime == 0)
         {
            frameToDisplay = 0;
            this.lastPlayedTime = now;
            needsRedraw = true;
         }
         else
         {
            timePassed = now - this.lastPlayedTime;
            framesPassed = timePassed * fpms;
            if(framesPassed > 0)
            {
               frameToDisplay = this.currentFrame + framesPassed;
               this.lastPlayedTime += framesPassed / fpms;
               needsRedraw = true;
            }
         }
         if(!needsRedraw)
         {
            return;
         }
         var frameNumber:uint = this.unitBitmap.currentSprites.length;
         if(frameToDisplay >= frameNumber)
         {
            if(this.currentAnimationLooped)
            {
               frameToDisplay %= frameNumber;
            }
            else
            {
               frameToDisplay = 0;
               if(this.defaultAnimation != null)
               {
                  this.defaultAnimation();
               }
               else
               {
                  this.idle();
               }
            }
         }
         this.currentFrame = frameToDisplay;
         this.frameDirty = true;
         this.showFrame();
      }
      
      public function idle() : void
      {
         this.defaultAnimation = null;
         this.changeAnimation(AnimationType.IDLE);
      }
      
      protected function changeAnimation(type:String, looped:Boolean = false, defaultAnimation:Function = null) : void
      {
         this.unitBitmap.setAnimation(type);
         this.currentAnimationLooped = looped;
         if(defaultAnimation != null)
         {
            this.defaultAnimation = defaultAnimation;
         }
         if(looped && this.currentAnimationType == type)
         {
            return;
         }
         this.currentAnimationType = type;
         this.currentFrame = 0;
         this.frameDirty = true;
         this.startAnimation();
      }
      
      protected function set angle(a:int) : void
      {
         if(a < 0 || a > 7)
         {
            a = 3;
         }
         this._angle = a;
      }
      
      protected function get angle() : int
      {
         return this._angle;
      }
      
      protected function showFrame() : void
      {
         if(!this.frameDirty)
         {
            return;
         }
         if(!this.unitBitmap)
         {
            return;
         }
         this.spriteEntry = this.unitBitmap.getCurrentFrame(this.currentFrame,this.angle);
         if(!this.spriteEntry)
         {
            return;
         }
         this.frameDirty = false;
         this.frameBmp.bitmapData = this.spriteEntry.bitmapData;
         this.frameBmp.x = this.offsetX + this.spriteEntry.x;
         this.frameBmp.y = this.offsetY + this.spriteEntry.y;
      }
   }
}

