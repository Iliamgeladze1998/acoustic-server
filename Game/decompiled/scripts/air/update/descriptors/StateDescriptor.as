package air.update.descriptors
{
   import air.update.logging.Logger;
   import air.update.utils.Constants;
   import flash.filesystem.File;
   
   [ExcludeClass]
   public class StateDescriptor
   {
      
      private static var logger:Logger = Logger.getLogger("air.update.descriptors.StateDescriptor");
      
      public static const NAMESPACE_STATE_1_0:Namespace = new Namespace("http://ns.adobe.com/air/framework/update/state/1.0");
      
      private var defaultNS:Namespace;
      
      private var xml:XML;
      
      public function StateDescriptor(xml:XML)
      {
         super();
         this.xml = xml;
         this.defaultNS = xml.namespace();
      }
      
      public static function isThisVersion(ns:Namespace) : Boolean
      {
         return Boolean(ns) && ns.uri == NAMESPACE_STATE_1_0.uri;
      }
      
      public static function defaultState() : StateDescriptor
      {
         default xml namespace = StateDescriptor.NAMESPACE_STATE_1_0;
         var initialXML:XML = <state>
					<lastCheck>{new Date()}</lastCheck>
				</state>;
         return new StateDescriptor(initialXML);
      }
      
      public function set lastCheckDate(value:Date) : void
      {
         default xml namespace = StateDescriptor.NAMESPACE_STATE_1_0;
         this.xml.lastCheck = value.toString();
      }
      
      public function set previousVersion(value:String) : void
      {
         default xml namespace = StateDescriptor.NAMESPACE_STATE_1_0;
         this.xml.previousVersion = value;
      }
      
      private function fileToString_defaultEmpty(file:File) : String
      {
         default xml namespace = this.defaultNS;
         if(Boolean(file) && Boolean(file.nativePath))
         {
            return file.nativePath;
         }
         return "";
      }
      
      public function get storage() : File
      {
         default xml namespace = StateDescriptor.NAMESPACE_STATE_1_0;
         return this.stringToFile_defaultNull(this.xml.storage.toString());
      }
      
      public function get failedUpdates() : Array
      {
         var version:XML = null;
         default xml namespace = StateDescriptor.NAMESPACE_STATE_1_0;
         var updates:Array = new Array();
         for each(version in this.xml.failed.*)
         {
            updates.push(version);
         }
         return updates;
      }
      
      public function removeAllFailedUpdates() : void
      {
         default xml namespace = StateDescriptor.NAMESPACE_STATE_1_0;
         this.xml.failed = <failed/>;
      }
      
      public function validate() : void
      {
         default xml namespace = this.defaultNS;
         if(!isThisVersion(this.defaultNS))
         {
            throw new Error("unknown state version",Constants.ERROR_STATE_UNKNOWN);
         }
         if(this.xml.lastCheck.toString() == "")
         {
            throw new Error("lastCheck must have a non-empty value",Constants.ERROR_LAST_CHECK_MISSING);
         }
         if(!this.validateDate(this.xml.lastCheck.toString()))
         {
            throw new Error("Invalid date format for state/lastCheck",Constants.ERROR_LAST_CHECK_INVALID);
         }
         if(this.xml.previousVersion.toString() != "" && !this.validateText(this.xml.previousVersion))
         {
            throw new Error("Illegal value for state/previousVersion",Constants.ERROR_PREV_VERSION_INVALID);
         }
         if(this.xml.currentVersion.toString() != "" && !this.validateText(this.xml.currentVersion))
         {
            throw new Error("Illegal value for state/currentVersion",Constants.ERROR_CURRENT_VERSION_INVALID);
         }
         if(this.xml.storage.toString() != "" && (!this.validateText(this.xml.storage) || !this.validateFile(this.xml.storage.toString())))
         {
            throw new Error("Illegal value for state/storage",Constants.ERROR_STORAGE_INVALID);
         }
         if(["","true","false"].indexOf(this.xml.updaterLaunched.toString()) == -1)
         {
            throw new Error("Illegal value \"" + this.xml.updaterLaunched.toString() + "\" for state/updaterLaunched.",Constants.ERROR_LAUNCHED_INVALID);
         }
         if(!this.validateFailed(this.xml.failed))
         {
            throw new Error("Illegal values for state/failed",Constants.ERROR_FAILED_INVALID);
         }
         var count:int = 0;
         if(this.previousVersion != "")
         {
            count++;
         }
         if(this.currentVersion != "")
         {
            count++;
         }
         if(Boolean(this.storage))
         {
            count++;
         }
         if(count > 0 && count != 3)
         {
            throw new Error("All state/previousVersion, state/currentVersion, state/storage, state/updaterLaunched  must be set",Constants.ERROR_VERSIONS_INVALID);
         }
      }
      
      public function get currentVersion() : String
      {
         default xml namespace = StateDescriptor.NAMESPACE_STATE_1_0;
         return this.xml.currentVersion.toString();
      }
      
      public function get lastCheckDate() : Date
      {
         default xml namespace = StateDescriptor.NAMESPACE_STATE_1_0;
         return this.stringToDate_defaultNull(this.xml.lastCheck.toString());
      }
      
      public function getXML() : XML
      {
         default xml namespace = StateDescriptor.NAMESPACE_STATE_1_0;
         return this.xml;
      }
      
      private function validateText(elem:XMLList) : Boolean
      {
         default xml namespace = this.defaultNS;
         if(!elem.hasSimpleContent())
         {
            return false;
         }
         if(elem.length() > 1)
         {
            return false;
         }
         return true;
      }
      
      private function validateDate(dateString:String) : Boolean
      {
         var result:Boolean;
         var n:Number = NaN;
         default xml namespace = this.defaultNS;
         result = false;
         try
         {
            n = Date.parse(dateString);
            if(!isNaN(n))
            {
               result = true;
            }
         }
         catch(err:Error)
         {
            result = false;
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
      
      public function addFailedUpdate(value:String) : void
      {
         default xml namespace = StateDescriptor.NAMESPACE_STATE_1_0;
         if(this.xml.failed.length() == 0)
         {
            this.xml.failed = <failed/>;
         }
         this.xml.failed.appendChild(<version>{value}</version>);
      }
      
      public function get previousVersion() : String
      {
         default xml namespace = StateDescriptor.NAMESPACE_STATE_1_0;
         return this.xml.previousVersion.toString();
      }
      
      private function stringToDate_defaultNull(dateString:String) : Date
      {
         default xml namespace = this.defaultNS;
         var date:Date = null;
         if(Boolean(dateString))
         {
            date = new Date(dateString);
         }
         return date;
      }
      
      private function stringToFile_defaultNull(str:String) : File
      {
         default xml namespace = this.defaultNS;
         if(!str)
         {
            return null;
         }
         return new File(str);
      }
      
      private function validateFile(fileString:String) : Boolean
      {
         var result:Boolean;
         var file:File = null;
         default xml namespace = this.defaultNS;
         result = false;
         try
         {
            file = new File(fileString);
            result = true;
         }
         catch(err:Error)
         {
            result = false;
         }
         return result;
      }
      
      public function set storage(value:File) : void
      {
         default xml namespace = StateDescriptor.NAMESPACE_STATE_1_0;
         this.xml.storage = this.fileToString_defaultEmpty(value);
      }
      
      private function validateFailed(elem:XMLList) : Boolean
      {
         var child:XML = null;
         default xml namespace = this.defaultNS;
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
            if(child.name().localName != "version")
            {
               return false;
            }
            if(!child.hasSimpleContent())
            {
               return false;
            }
         }
         return true;
      }
      
      public function get updaterLaunched() : Boolean
      {
         default xml namespace = StateDescriptor.NAMESPACE_STATE_1_0;
         return this.stringToBoolean_defaultFalse(this.xml.updaterLaunched.toString());
      }
      
      public function set updaterLaunched(value:Boolean) : void
      {
         default xml namespace = StateDescriptor.NAMESPACE_STATE_1_0;
         this.xml.updaterLaunched = value.toString();
      }
      
      public function set currentVersion(value:String) : void
      {
         default xml namespace = StateDescriptor.NAMESPACE_STATE_1_0;
         this.xml.currentVersion = value;
      }
   }
}

