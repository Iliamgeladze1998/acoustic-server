package air.update.utils
{
   import flash.desktop.NativeApplication;
   
   [ExcludeClass]
   public class VersionUtils
   {
      
      private static const SPECIALS:Array = ["alpha","beta","rc"];
      
      public function VersionUtils()
      {
         super();
      }
      
      public static function isNewerVersion(currentVersion:String, newVersion:String) : Boolean
      {
         var p1:String = null;
         var p2:String = null;
         var isDigit1:Boolean = false;
         var isDigit2:Boolean = false;
         var n1:uint = 0;
         var n2:uint = 0;
         var index1:int = 0;
         var index2:int = 0;
         var p1l:String = null;
         var p2l:String = null;
         var v1:String = currentVersion.replace(/[+\-_ ]/g,".").replace(/\.(\.)+/g,".").replace(/([^\d\.])([^\D\.])/g,"$1.$2").replace(/([^\D\.])([^\d\.])/g,"$1.$2");
         var v2:String = newVersion.replace(/[+\-_ ]/g,".").replace(/\.(\.)+/g,".").replace(/([^\d\.])([^\D\.])/g,"$1.$2").replace(/([^\D\.])([^\d\.])/g,"$1.$2");
         var parts1:Array = v1.split(".");
         var parts2:Array = v2.split(".");
         var minLen:int = Math.min(parts1.length,parts2.length);
         for(var i:int = 0; i < minLen; i++)
         {
            p1 = parts1[i];
            p2 = parts2[i];
            isDigit1 = StringUtils.isDigit(p1.charAt(0));
            isDigit2 = StringUtils.isDigit(p2.charAt(0));
            if(isDigit1 && isDigit2)
            {
               n1 = uint(p1);
               n2 = uint(p2);
               if(n2 != n1)
               {
                  return n2 > n1;
               }
            }
            else
            {
               if(!(!isDigit1 && !isDigit2))
               {
                  if(isDigit1)
                  {
                     return false;
                  }
                  return true;
               }
               index1 = SPECIALS.indexOf(p1.toLowerCase());
               index2 = SPECIALS.indexOf(p2.toLowerCase());
               if(index1 != -1 && index2 != -1)
               {
                  if(index1 != index2)
                  {
                     return index2 > index1;
                  }
               }
               else
               {
                  p1l = p1.toLowerCase();
                  p2l = p2.toLowerCase();
                  if(p2l != p1l)
                  {
                     return p2l > p1l;
                  }
               }
            }
         }
         if(parts1.length == parts2.length)
         {
            return false;
         }
         if(parts1.length > parts2.length)
         {
            if(StringUtils.isDigit(parts1[minLen].charAt(0)))
            {
               return false;
            }
            return true;
         }
         if(StringUtils.isDigit(parts2[minLen].charAt(0)))
         {
            return true;
         }
         return false;
      }
      
      public static function applicationHasVersionNumber() : Boolean
      {
         var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var ns:Namespace = appXML.namespace();
         return appXML.ns::versionNumber != undefined;
      }
      
      public static function getApplicationID() : String
      {
         return NativeApplication.nativeApplication.applicationID;
      }
      
      public static function getApplicationVersion() : String
      {
         var appXML:XML = NativeApplication.nativeApplication.applicationDescriptor;
         var ns:Namespace = appXML.namespace();
         return appXML.ns::version == undefined ? appXML.ns::versionNumber : appXML.ns::version;
      }
   }
}

