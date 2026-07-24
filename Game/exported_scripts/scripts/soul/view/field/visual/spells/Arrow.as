package soul.view.field.visual.spells
{
   import flash.display.Bitmap;
   import flash.geom.Point;
   import soul.view.field.visual.AnimatedSprite;
   import soul.view.field.visual.AnimationType;
   import soul.view.field.visual.RotatingBitmap;
   import soul.view.sprite.SpriteEntry;
   
   public class Arrow extends Shoot
   {
      
      private var rbmp:RotatingBitmap;
      
      public function Arrow(linkage:String = "arrow_01", width:int = 35, height:int = 25)
      {
         super();
         this.rbmp = new RotatingBitmap();
         this.rbmp.frameWidth = width;
         this.rbmp.frameHeight = height;
         this.rbmp.frameList[AnimationType.IDLE] = [0,[0]];
         this.rbmp.linkages = [linkage];
         this.rbmp.initSprite();
         this.rbmp.spriteCenter = new Point(-width / 2,-height / 2);
         this.rbmp.setAnimation(AnimationType.IDLE);
      }
      
      override public function shoot(x:int, y:int, duration:int = 0) : void
      {
         var angle:int = AnimatedSprite.getAngle(x,y);
         var spriteEntry:SpriteEntry = this.rbmp.getCurrentFrame(0,angle);
         var bmp:Bitmap = new Bitmap(spriteEntry.bitmapData);
         addChild(bmp);
         bmp.x += this.rbmp.spriteCenter.x;
         bmp.y += this.rbmp.spriteCenter.y;
         super.shoot(x,y,duration);
      }
   }
}

