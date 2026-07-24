package spark.utils
{
   import mx.core.DPIClassification;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class MultiDPIBitmapSource
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      public var source160dpi:Object;
      
      public var source240dpi:Object;
      
      public var source320dpi:Object;
      
      public function MultiDPIBitmapSource()
      {
         super();
      }
      
      public function getSource(desiredDPI:Number) : Object
      {
         var source:Object = this.source160dpi;
         switch(desiredDPI)
         {
            case DPIClassification.DPI_160:
               source = this.source160dpi;
               if(!source || source == "")
               {
                  source = this.source240dpi;
               }
               if(!source || source == "")
               {
                  source = this.source320dpi;
               }
               break;
            case DPIClassification.DPI_240:
               source = this.source240dpi;
               if(!source || source == "")
               {
                  source = this.source320dpi;
               }
               if(!source || source == "")
               {
                  source = this.source160dpi;
               }
               break;
            case DPIClassification.DPI_320:
               source = this.source320dpi;
               if(!source || source == "")
               {
                  source = this.source240dpi;
               }
               if(!source || source == "")
               {
                  source = this.source160dpi;
               }
         }
         return source;
      }
   }
}

