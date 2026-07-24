package soul.view.assets
{
   import flash.display.MovieClip;
   import soul.view.ui.CachedImage;
   
   public class GlitterImage extends CachedImage
   {
      
      private var border:MovieClip = new Assets.barterItemGlow();
      
      public function GlitterImage()
      {
         super();
         addChild(this.border);
         this.animated = false;
      }
      
      override protected function applySize() : void
      {
         super.applySize();
         setChildIndex(this.border,numChildren - 1);
         this.border.width = width;
         this.border.height = height;
      }
      
      override public function set visible(value:Boolean) : void
      {
         scaleX = value ? 1 : 0;
         super.visible = value;
         if(value)
         {
            this.border.gotoAndPlay(1);
         }
         else
         {
            this.border.gotoAndStop(1);
         }
      }
      
      public function set animated(value:Boolean) : void
      {
         this.border.visible = value;
      }
   }
}

