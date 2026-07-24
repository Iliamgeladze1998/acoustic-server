package air.update.utils
{
   [ExcludeClass]
   public class StringUtils
   {
      
      public function StringUtils()
      {
         super();
      }
      
      public static function isDigit(ch:String) : Boolean
      {
         return ch >= "0" && ch <= "9";
      }
   }
}

