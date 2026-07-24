package soul.view.filters
{
   import flash.display.Shader;
   
   public class ColorShader extends Shader
   {
      
      public static const BLEND_MODE:String = "COLOR";
      
      private static var shaderClass:Class = ColorShader_shaderClass;
      
      public function ColorShader()
      {
         super(new shaderClass());
      }
   }
}

