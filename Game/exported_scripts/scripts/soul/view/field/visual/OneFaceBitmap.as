package soul.view.field.visual
{
   import soul.view.sprite.SpriteEntry;
   
   public class OneFaceBitmap extends RotatingBitmap
   {
      
      public function OneFaceBitmap()
      {
         super();
      }
      
      override public function getCurrentFrame(frameNo:uint, angle:uint) : SpriteEntry
      {
         return super.getCurrentFrame(frameNo,0);
      }
   }
}

