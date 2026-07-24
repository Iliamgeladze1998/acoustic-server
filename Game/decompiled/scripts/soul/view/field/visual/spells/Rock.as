package soul.view.field.visual.spells
{
   import flash.display.Bitmap;
   import flash.geom.Point;
   import soul.model.field.LibraryManager;
   
   public class Rock extends Shoot
   {
      
      private var spriteCenter:Point = new Point(-8,-8);
      
      public function Rock()
      {
         super();
      }
      
      override public function shoot(x:int, y:int, duration:int = 0) : void
      {
         var bmp:Bitmap = LibraryManager.getObject("rock_01",LIBRARY) as Bitmap;
         addChild(bmp);
         bmp.x += this.spriteCenter.x;
         bmp.y += this.spriteCenter.y;
         super.shoot(x,y,duration);
      }
   }
}

