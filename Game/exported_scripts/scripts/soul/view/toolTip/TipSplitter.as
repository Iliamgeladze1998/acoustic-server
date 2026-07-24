package soul.view.toolTip
{
   import flash.display.BitmapData;
   import soul.view.ui.RepeatingBitmap;
   
   public class TipSplitter extends RepeatingBitmap
   {
      
      private static const srcBmp:Class = TipSplitter_srcBmp;
      
      private static const src:BitmapData = new srcBmp().bitmapData;
      
      public function TipSplitter()
      {
         super();
         bitmapData = src;
      }
   }
}

