package air.update.descriptors
{
   import air.update.utils.Constants;
   
   [ExcludeClass]
   public class UpdateDescriptor
   {
      
      public static const NAMESPACE_UPDATE_1_0:Namespace = new Namespace("http://ns.adobe.com/air/framework/update/description/1.0");
      
      public static const NAMESPACE_UPDATE_2_5:Namespace = new Namespace("http://ns.adobe.com/air/framework/update/description/2.5");
      
      private var defaultNS:Namespace;
      
      private var xml:XML;
      
      public function UpdateDescriptor(xml:XML)
      {
         super();
         this.xml = xml;
         this.defaultNS = xml.namespace();
      }
      
      private static function validateLocalizedText(elem:XMLList, ns:Namespace) : Boolean
      {
         var child:XML = null;
         default xml namespace = ns;
         var xmlNS:Namespace = new Namespace("http://www.w3.org/XML/1998/namespace");
         if(elem.hasSimpleContent())
         {
            return true;
         }
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
            if(child.name().localName != "text")
            {
               return false;
            }
            if(child.xmlNS::@lang.length() == 0)
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
      
      public static function getLocalizedText(elem:XMLList, ns:Namespace) : Array
      {
         var elemChildren:XMLList = null;
         var child:XML = null;
         default xml namespace = ns;
         var xmlNS:Namespace = new Namespace("http://www.w3.org/XML/1998/namespace");
         var result:Array = [];
         if(elem.hasSimpleContent())
         {
            result = [["",elem.toString()]];
         }
         else
         {
            elemChildren = elem.ns::text;
            for each(child in elemChildren)
            {
               result.push([child.xmlNS::@lang.toString(),child[0].toString()]);
            }
         }
         return result;
      }
      
      public static function isKnownVersion(ns:Namespace) : Boolean
      {
         if(!ns)
         {
            return false;
         }
         switch(ns.uri)
         {
            case NAMESPACE_UPDATE_1_0.uri:
            case NAMESPACE_UPDATE_2_5.uri:
               return true;
            default:
               return false;
         }
      }
      
      public function getXML() : XML
      {
         default xml namespace = this.defaultNS;
         return this.xml;
      }
      
      public function get versionLabel() : String
      {
         default xml namespace = this.defaultNS;
         if(this.xml.version != undefined)
         {
            return this.xml.version.toString();
         }
         return this.xml.versionLabel != undefined ? this.xml.versionLabel.toString() : this.xml.versionNumber.toString();
      }
      
      public function get version() : String
      {
         default xml namespace = this.defaultNS;
         return this.xml.version != undefined ? this.xml.version.toString() : this.xml.versionNumber.toString();
      }
      
      public function get description() : Array
      {
         default xml namespace = this.defaultNS;
         return UpdateDescriptor.getLocalizedText(this.xml.description,this.defaultNS);
      }
      
      public function isCompatibleWithApplicationDescriptor(appHasVersionNumber:Boolean) : Boolean
      {
         default xml namespace = this.defaultNS;
         var updateHasVersionNumber:Boolean = this.xml.versionNumber != undefined;
         return updateHasVersionNumber == appHasVersionNumber;
      }
      
      public function validate() : void
      {
         default xml namespace = this.defaultNS;
         if(!isKnownVersion(this.defaultNS))
         {
            throw new Error("unknown update descriptor namespace",Constants.ERROR_UPDATE_UNKNOWN);
         }
         if(this.xml.versionNumber != undefined)
         {
            if(this.version == "")
            {
               throw new Error("update versionNumber must have a non-empty value",Constants.ERROR_VERSION_MISSING);
            }
            if(!/^[0-9]{1,3}(\.[0-9]{1,3}){0,2}$/.test(this.version))
            {
               throw new Error("update versionNumber contains an invalid value",Constants.ERROR_VERSION_INVALID);
            }
         }
         else if(this.version == "")
         {
            throw new Error("update version must have a non-empty value",Constants.ERROR_VERSION_MISSING);
         }
         if(this.url == "")
         {
            throw new Error("update url must have a non-empty value",Constants.ERROR_URL_MISSING);
         }
         if(!validateLocalizedText(this.xml.description,this.defaultNS))
         {
            throw new Error("Illegal values for update/description",Constants.ERROR_DESCRIPTION_INVALID);
         }
      }
      
      public function get url() : String
      {
         default xml namespace = this.defaultNS;
         return this.xml.url.toString();
      }
   }
}

