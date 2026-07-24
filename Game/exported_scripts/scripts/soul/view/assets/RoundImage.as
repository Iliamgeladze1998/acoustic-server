package soul.view.assets
{
   import flash.display.Shape;
   import soul.view.ui.CachedImage;
   
   public class RoundImage extends CachedImage
   {
      
      private var roundMask:Shape = new Shape();
      
      public function RoundImage()
      {
         super();
         addChild(this.roundMask);
         mask = this.roundMask;
      }
      
      override protected function applySize() : void
      {
         super.applySize();
         this.redraw();
      }
      
      override protected function redraw() : void
      {
         super.redraw();
         this.roundMask.graphics.clear();
         this.roundMask.graphics.beginFill(0);
         this.roundMask.graphics.drawEllipse(0,0,_width,_height);
         this.roundMask.graphics.endFill();
      }
   }
}

