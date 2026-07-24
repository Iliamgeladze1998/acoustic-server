package soul.view.assets
{
   import flash.text.TextFormat;
   import soul.view.ui.Label;
   
   public class GradientLabel extends Label
   {
      
      private var box:GradientBox = new GradientBox();
      
      public function GradientLabel(format:TextFormat = null)
      {
         format ||= Label.TEXT_TOOLTIP;
         super(format);
         addChildAt(this.box,0);
      }
      
      public function set gradient(value:Array) : void
      {
         this.box.gradient = value;
         this.redraw();
      }
      
      public function set bgPaddingLeft(value:int) : void
      {
         this.box.bgPaddingLeft = value;
      }
      
      override protected function redraw() : void
      {
         super.redraw();
         this.box.width = width;
         this.box.height = height;
      }
   }
}

