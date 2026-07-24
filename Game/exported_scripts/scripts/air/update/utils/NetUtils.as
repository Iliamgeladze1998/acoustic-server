package air.update.utils
{
   [ExcludeClass]
   public class NetUtils
   {
      
      public static const ACCEPTABLE_STATUSES:Array = [0,200];
      
      public function NetUtils()
      {
         super();
      }
      
      public static function isHTTPStatusAcceptable(httpStatus:int) : Boolean
      {
         if(ACCEPTABLE_STATUSES.indexOf(httpStatus) == -1)
         {
            return false;
         }
         return true;
      }
   }
}

