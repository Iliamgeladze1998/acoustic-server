package spark.layouts.supportClasses
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class LayoutElementHelper
   {
      
      mx_internal static const VERSION:String = "4.5.1.21328";
      
      public function LayoutElementHelper()
      {
         super();
      }
      
      public static function pinBetween(val:Number, min:Number, max:Number) : Number
      {
         return Math.min(max,Math.max(min,val));
      }
      
      public static function parseConstraintValue(value:Object) : Number
      {
         if(value is Number)
         {
            return Number(value);
         }
         var str:String = value as String;
         if(!str)
         {
            return NaN;
         }
         var result:Array = parseConstraintExp(str);
         return result[0];
      }
      
      public static function parseConstraintExp(val:Object) : Array
      {
         if(val is Number)
         {
            return [Number(val),null];
         }
         if(!val)
         {
            return [NaN,null];
         }
         var temp:String = String(val).replace(/:/g," ");
         var args:Array = temp.split(/\s+/);
         if(args.length == 1)
         {
            return args;
         }
         return [args[1],args[0]];
      }
   }
}

