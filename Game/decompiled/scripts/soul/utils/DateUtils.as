package soul.utils
{
   import soul.controller.locale.BundleName;
   import soul.controller.locale.LocaleManager;
   
   public class DateUtils
   {
      
      private static const SECOND:int = 1000;
      
      private static const MINUTE:int = SECOND * 60;
      
      private static const HOUR:int = MINUTE * 60;
      
      private static const DAY:int = HOUR * 24;
      
      private static const MONTH:Number = DAY * 30;
      
      private static const YEAR:Number = DAY * 365;
      
      private static const _Y:RegExp = /Y/g;
      
      private static const _m:RegExp = /m/g;
      
      private static const _d:RegExp = /d/g;
      
      private static const _HH:RegExp = /HH/g;
      
      private static const _i:RegExp = /i/g;
      
      public function DateUtils()
      {
         super();
      }
      
      public static function getTimeLeft(timeLeft:Number) : String
      {
         var expiresString:String = "";
         var years:int = Boolean(int(timeLeft / YEAR)) ? int(Math.round(timeLeft / YEAR)) : 0;
         timeLeft -= years * YEAR;
         var months:int = Boolean(int(timeLeft / MONTH)) ? int(Math.round(timeLeft / MONTH)) : 0;
         timeLeft -= months * MONTH;
         var days:int = Boolean(int(timeLeft / DAY)) ? int(Math.round(timeLeft / DAY)) : 0;
         timeLeft -= days * DAY;
         var hours:int = Boolean(int(timeLeft / HOUR)) ? int(Math.round(timeLeft / HOUR)) : 0;
         timeLeft -= hours * HOUR;
         var minutes:int = Boolean(int(timeLeft / MINUTE)) ? int(Math.round(timeLeft / MINUTE)) : 0;
         timeLeft -= minutes * MINUTE;
         var seconds:int = Math.max(0,Math.round(timeLeft / SECOND));
         if(years > 0)
         {
            expiresString += years + " " + getString("years");
         }
         else if(months > 0)
         {
            expiresString += months + " " + getString("months");
         }
         else if(days > 0)
         {
            expiresString += days + " " + getString("days");
         }
         else if(hours > 0)
         {
            expiresString += hours + " " + getString("hours");
         }
         else if(minutes > 0)
         {
            expiresString += minutes + " " + getString("minutes");
         }
         else if(seconds > 0)
         {
            expiresString += seconds + " " + getString("seconds");
         }
         return expiresString;
      }
      
      public static function getTime(timeLeft:uint) : String
      {
         var hours:int = int(timeLeft / HOUR);
         timeLeft -= hours * HOUR;
         var minutes:int = int(timeLeft / MINUTE);
         timeLeft -= minutes * MINUTE;
         var seconds:int = int(uint(timeLeft / SECOND));
         var sh:String = NumberUtils.addZero(hours);
         var sm:String = NumberUtils.addZero(minutes);
         var ss:String = NumberUtils.addZero(seconds);
         return sh + ":" + sm + ":" + ss;
      }
      
      public static function getBuffTimeLeft(value:int) : String
      {
         var totalSeconds:int = value / 1000;
         var days:int = int(totalSeconds / (60 * 60 * 24));
         if(days > 0)
         {
            return days + "d";
         }
         var hours:int = int(totalSeconds / (60 * 60));
         if(hours > 0)
         {
            return hours + "h";
         }
         var minutes:int = int(totalSeconds / 60);
         if(minutes > 0)
         {
            return minutes + "m";
         }
         return totalSeconds + "s";
      }
      
      public static function formatDate(format:String, date:Date) : String
      {
         var Y:String = date.getFullYear().toString();
         var m:String = NumberUtils.addZero(date.getMonth() + 1);
         var d:String = NumberUtils.addZero(date.getDate());
         var HH:String = NumberUtils.addZero(date.getHours());
         var i:String = NumberUtils.addZero(date.getMinutes());
         format = format.replace(_Y,Y);
         format = format.replace(_m,m);
         format = format.replace(_d,d);
         format = format.replace(_HH,HH);
         return format.replace(_i,i);
      }
      
      private static function getString(key:String) : String
      {
         return LocaleManager.getString(BundleName.INTERFACE,key);
      }
   }
}

