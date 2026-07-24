package soul.utils
{
   public class NumberUtils
   {
      
      public function NumberUtils()
      {
         super();
      }
      
      public static function addZero(value:uint) : String
      {
         return (value < 10 ? "0" : "") + value;
      }
   }
}

