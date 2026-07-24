package mx.effects.effectClasses
{
   import mx.core.mx_internal;
   import mx.effects.EffectTargetFilter;
   
   use namespace mx_internal;
   
   public class HideShowEffectTargetFilter extends EffectTargetFilter
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      public var show:Boolean = true;
      
      public function HideShowEffectTargetFilter()
      {
         super();
         filterProperties = ["visible"];
      }
      
      override protected function defaultFilterFunction(propChanges:Array, instanceTarget:Object) : Boolean
      {
         var props:PropertyChanges = null;
         var n:int = int(propChanges.length);
         for(var i:int = 0; i < n; i++)
         {
            props = propChanges[i];
            if(props.target == instanceTarget)
            {
               return props.end["visible"] == this.show;
            }
         }
         return false;
      }
   }
}

