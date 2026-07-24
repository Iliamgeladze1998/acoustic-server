package air.update.descriptors
{
   import air.update.utils.Constants;
   
   [ExcludeClass]
   public class ConfigurationDescriptor
   {
      
      public static const NAMESPACE_CONFIGURATION_1_0:Namespace = new Namespace("http://ns.adobe.com/air/framework/update/configuration/1.0");
      
      public static const DIALOG_CHECK_FOR_UPDATE:String = "checkforupdate";
      
      public static const DIALOG_DOWNLOAD_UPDATE:String = "downloadupdate";
      
      public static const DIALOG_DOWNLOAD_PROGRESS:String = "downloadprogress";
      
      public static const DIALOG_INSTALL_UPDATE:String = "installupdate";
      
      public static const DIALOG_FILE_UPDATE:String = "fileupdate";
      
      public static const DIALOG_UNEXPECTED_ERROR:String = "unexpectederror";
      
      private var defaultNS:Namespace;
      
      private var xml:XML;
      
      public function ConfigurationDescriptor(xml:XML)
      {
         super();
         this.xml = xml;
         this.defaultNS = xml.namespace();
      }
      
      private static function validateDefaultUI(elem:XMLList) : Boolean
      {
         var child:XML = null;
         default xml namespace = elemChildren;
         if(elem.length() > 1)
         {
            return false;
         }
         var elemChildren:XMLList = elem.*;
         for each(child in elemChildren)
         {
            if(child.name() == null)
            {
               return false;
            }
            if(child.name().localName != "dialog")
            {
               return false;
            }
            if([DIALOG_CHECK_FOR_UPDATE,DIALOG_DOWNLOAD_UPDATE,DIALOG_DOWNLOAD_PROGRESS,DIALOG_INSTALL_UPDATE,DIALOG_FILE_UPDATE,DIALOG_UNEXPECTED_ERROR].indexOf(child.@name.toString().toLowerCase()) == -1)
            {
               return false;
            }
            if(["true","false"].indexOf(child.@visible.toString()) == -1)
            {
               return false;
            }
            if(child.hasComplexContent())
            {
               return false;
            }
         }
         return true;
      }
      
      public static function isThisVersion(ns:Namespace) : Boolean
      {
         return Boolean(ns) && ns.uri == NAMESPACE_CONFIGURATION_1_0.uri;
      }
      
      private static function validateInterval(intervalString:String) : Boolean
      {
         var result:Boolean;
         var intervalNumber:Number = NaN;
         default xml namespace = result;
         result = false;
         if(intervalString.length > 0)
         {
            try
            {
               intervalNumber = Number(intervalString);
               if(intervalNumber >= 0)
               {
                  result = true;
               }
            }
            catch(theException:*)
            {
               result = false;
            }
         }
         else
         {
            result = true;
         }
         return result;
      }
      
      private static function convertInterval(intervalString:String) : Number
      {
         default xml namespace = result;
         var result:Number = -1;
         if(intervalString.length > 0)
         {
            result = Number(intervalString);
         }
         return result;
      }
      
      private function stringToBoolean_defaultFalse(str:String) : Boolean
      {
         default xml namespace = this.defaultNS;
         switch(str)
         {
            case "true":
            case "1":
               return true;
            case "":
            case "false":
            case "0":
               return false;
            default:
               return false;
         }
      }
      
      public function get defaultUI() : Array
      {
         var elem:XML = null;
         var dlg:Object = null;
         default xml namespace = this.defaultNS;
         var dialogs:Array = new Array();
         for each(elem in this.xml.defaultUI.*)
         {
            dlg = {
               "name":elem.@name,
               "visible":this.stringToBoolean_defaultFalse(elem.@visible)
            };
            dialogs.push(dlg);
         }
         return dialogs;
      }
      
      public function validate() : void
      {
         default xml namespace = this.defaultNS;
         if(!isThisVersion(this.defaultNS))
         {
            throw new Error("unknown configuration version",Constants.ERROR_CONFIGURATION_UNKNOWN);
         }
         if(this.url == "")
         {
            throw new Error("configuration url must have a non-empty value",Constants.ERROR_URL_MISSING);
         }
         if(!validateInterval(this.xml.delay.toString()))
         {
            throw new Error("Illegal value \"" + this.xml.delay.toString() + "\" for configuration/delay",Constants.ERROR_DELAY_INVALID);
         }
         if(!validateDefaultUI(this.xml.defaultUI))
         {
            throw new Error("Illegal values for configuration/defaultUI",Constants.ERROR_DEFAULTUI_INVALID);
         }
      }
      
      public function get checkInterval() : Number
      {
         default xml namespace = this.defaultNS;
         return convertInterval(this.xml.delay.toString());
      }
      
      public function get url() : String
      {
         default xml namespace = this.defaultNS;
         return this.xml.url.toString();
      }
   }
}

