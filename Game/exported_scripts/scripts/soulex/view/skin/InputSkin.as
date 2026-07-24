package soulex.view.skin
{
   import flash.filters.GlowFilter;
   import mx.core.UIComponent;
   
   public class InputSkin extends UIComponent
   {
      
      public function InputSkin()
      {
         super();
         filters = [new GlowFilter(0,1,1.2,1.2,6,2),new GlowFilter(0,1,6,6,1)];
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         graphics.clear();
         graphics.lineStyle(1.4,15189659,1,true,"normal",null,null,10);
         graphics.drawRoundRect(0,0,unscaledWidth,unscaledHeight,8,8);
      }
   }
}

