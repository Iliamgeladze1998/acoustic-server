package soul.view.assets
{
   import flash.events.MouseEvent;
   import flash.filters.ColorMatrixFilter;
   import soul.view.ui.CachedImage;
   
   public class GlowIcon extends CachedImage
   {
      
      private static const OVER_FILTERS:Array = [new ColorMatrixFilter([1,0,0,0.1,1,0,1,0,0.1,1,0,0,1,0.05,1,0,0,0,1,1])];
      
      public function GlowIcon()
      {
         super();
         addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
      }
      
      private function mouseOver(e:MouseEvent) : void
      {
         filters = OVER_FILTERS;
      }
      
      private function mouseOut(e:MouseEvent) : void
      {
         filters = [];
      }
   }
}

