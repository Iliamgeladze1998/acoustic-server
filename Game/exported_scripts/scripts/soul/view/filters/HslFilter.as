package soul.view.filters
{
   import flash.display.Shader;
   import flash.filters.ShaderFilter;
   import flash.utils.ByteArray;
   
   public class HslFilter extends ShaderFilter
   {
      
      private static var Filter:Class = HslFilter_Filter;
      
      private static var filter:ByteArray = new Filter() as ByteArray;
      
      public function HslFilter(hue:int = 0, saturation:int = 100, lightness:int = 100)
      {
         super();
         shader = new Shader(filter);
         this.hue = hue;
         this.saturation = saturation;
         this.lightness = lightness;
      }
      
      public function set hue(value:int) : void
      {
         value = (value % 360 + 360) % 360;
         shader.data.hue.value[0] = value;
      }
      
      public function set saturation(value:int) : void
      {
         shader.data.saturation.value[0] = value;
      }
      
      public function set lightness(value:int) : void
      {
         shader.data.lightness.value[0] = value;
      }
      
      public function set hsl(value:String) : void
      {
         var arr:Array = value.split("_");
         trace("HslFilter.hsl()",arr);
         this.hue = int(arr[0]);
         this.saturation = int(arr[1]);
         this.lightness = int(arr[2]);
      }
   }
}

