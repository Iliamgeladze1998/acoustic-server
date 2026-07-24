package soul.model.field.mapconfig
{
   import soul.model.field.spriteconfig.SpritePoint;
   
   public class ContourPoint extends SpritePoint
   {
      
      public var controlX:int;
      
      public var controlY:int;
      
      public function ContourPoint(x:int = 0, y:int = 0, controlX:int = 0, controlY:int = 0)
      {
         super(x,y);
         this.controlX = controlX;
         this.controlY = controlY;
      }
      
      override public function applyAspectRatio() : void
      {
         super.applyAspectRatio();
         this.controlX /= AspectRatio.x;
         this.controlY /= AspectRatio.y;
      }
      
      override public function removeAspectRatio() : void
      {
         super.removeAspectRatio();
         this.controlX *= AspectRatio.x;
         this.controlY *= AspectRatio.y;
      }
   }
}

