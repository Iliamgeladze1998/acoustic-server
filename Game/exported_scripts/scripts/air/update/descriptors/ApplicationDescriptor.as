package air.update.descriptors
{
   import flash.display.NativeWindowSystemChrome;
   import flash.geom.Point;
   
   [ExcludeClass]
   public class ApplicationDescriptor
   {
      
      public static const ICON_IMAGES:Object = {
         "image16x16":16,
         "image32x32":32,
         "image48x48":48,
         "image128x128":128
      };
      
      private var m_defaultNs:Namespace;
      
      private var m_xml:XML;
      
      private var m_name:String;
      
      private var m_description:String;
      
      public function ApplicationDescriptor(xml:XML)
      {
         super();
         this.m_xml = xml;
         this.m_defaultNs = this.m_xml.namespace();
      }
      
      private static function validateDimension(dimensionString:String) : Boolean
      {
         var result:Boolean;
         var dimensionNumber:Number = NaN;
         default xml namespace = result;
         result = false;
         if(dimensionString.length > 0)
         {
            try
            {
               dimensionNumber = Number(dimensionString);
               if(dimensionNumber >= 0)
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
      
      private static function convertDimension(dimensionString:String) : Number
      {
         var dimensionUINT:uint = 0;
         default xml namespace = result;
         var result:Number = -1;
         if(dimensionString.length > 0)
         {
            dimensionUINT = uint(dimensionString);
            result = Number(dimensionUINT);
         }
         return result;
      }
      
      private static function convertLocation(locationString:String) : Number
      {
         var locationINT:int = 0;
         default xml namespace = result;
         var result:Number = -1;
         if(locationString.length > 0)
         {
            locationINT = int(locationString);
            result = Number(locationINT);
         }
         return result;
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
            if(child.name() == null || child.name().localName != "text")
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
      
      private static function validateDimensionPair(inputString:String) : Boolean
      {
         var pt:Point = null;
         default xml namespace = result;
         var result:Boolean = false;
         if(inputString.length > 0)
         {
            pt = convertDimensionPoint(inputString);
            if(pt != null && pt.x != -1 && pt.y != -1)
            {
               result = true;
            }
         }
         else
         {
            result = true;
         }
         return result;
      }
      
      private static function validateLocation(inputString:String) : Boolean
      {
         var result:Boolean;
         var dimensionNumber:Number = NaN;
         default xml namespace = result;
         result = false;
         if(inputString.length > 0)
         {
            try
            {
               dimensionNumber = Number(inputString);
               if(!isNaN(dimensionNumber))
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
      
      private static function convertDimensionPoint(dimensionString:String) : Point
      {
         var result:Point;
         var list:Array = null;
         var x:Number = NaN;
         var y:Number = NaN;
         var pt:Point = null;
         default xml namespace = result;
         result = null;
         if(dimensionString.length > 0)
         {
            try
            {
               list = dimensionString.split(/ +/);
               if(list.length == 2)
               {
                  x = convertDimension(String(list[0]));
                  y = convertDimension(String(list[1]));
                  pt = new Point();
                  pt.x = x;
                  pt.y = y;
                  result = pt;
               }
            }
            catch(e:Error)
            {
               result = null;
            }
         }
         return result;
      }
      
      public function get description() : String
      {
         default xml namespace = this.m_defaultNs;
         return this.m_description;
      }
      
      public function get initialWindowX() : Number
      {
         default xml namespace = this.m_defaultNs;
         return convertLocation(this.m_xml.initialWindow.x.toString());
      }
      
      public function get initialWindowContent() : String
      {
         default xml namespace = this.m_defaultNs;
         return this.m_xml.initialWindow.content;
      }
      
      public function get filename() : String
      {
         default xml namespace = this.m_defaultNs;
         return this.m_xml.filename.toString();
      }
      
      public function get minimumPatchLevel() : int
      {
         default xml namespace = this.m_defaultNs;
         return this.m_xml.@minimumPatchLevel;
      }
      
      public function get name() : String
      {
         default xml namespace = this.m_defaultNs;
         return this.m_name == "" ? this.filename : this.m_name;
      }
      
      private function stringToBoolean_defaultTrue(str:String) : Boolean
      {
         default xml namespace = this.m_defaultNs;
         switch(str)
         {
            case "":
            case "true":
            case "1":
               return true;
            case "false":
            case "0":
               return false;
            default:
               return true;
         }
      }
      
      public function get initialWindowMinimizable() : Boolean
      {
         default xml namespace = this.m_defaultNs;
         return this.stringToBoolean_defaultTrue(this.m_xml.initialWindow.minimizable.toString());
      }
      
      public function get copyright() : String
      {
         default xml namespace = this.m_defaultNs;
         return this.m_xml.copyright.toString();
      }
      
      public function get initialWindowMaxSize() : Point
      {
         default xml namespace = this.m_defaultNs;
         return convertDimensionPoint(this.m_xml.initialWindow.maxSize.toString());
      }
      
      public function get initialWindowWidth() : Number
      {
         default xml namespace = this.m_defaultNs;
         return convertDimension(this.m_xml.initialWindow.width.toString());
      }
      
      public function get initialWindowY() : Number
      {
         default xml namespace = this.m_defaultNs;
         return convertLocation(this.m_xml.initialWindow.y.toString());
      }
      
      public function validate() : void
      {
         default xml namespace = this.m_defaultNs;
         if(this.filename == "")
         {
            throw new Error("application filename must have a non-empty value.");
         }
         if(this.m_xml.versionNumber != undefined)
         {
            if(this.version == "")
            {
               throw new Error("versionNumber must have a non-empty value.");
            }
            if(!/^[0-9]{1,3}(\.[0-9]{1,3}){0,2}$/.test(this.version))
            {
               throw new Error("versionNumber contains an invalid value.");
            }
         }
         else if(this.version == "")
         {
            throw new Error("version must have a non-empty value.");
         }
         if(!/^([^\*\"\/:<>\?\\\|\. ]|[^\*\"\/:<>\?\\\| ][^\*\"\/:<>\?\\\|]*[^\*\"\/:<>\?\\\|\. ])$/.test(this.filename))
         {
            throw new Error("invalid application filename");
         }
         if(this.m_xml.initialWindow.content.toString() == "")
         {
            throw new Error("initialWindow/content must have a non-empty value.");
         }
         if(this.installFolder != "" && !/^([^\*\"\/:<>\?\\\|\. ]|[^\*\"\/:<>\?\\\| ][^\*\":<>\?\\\|]*[^\*\":<>\?\\\|\. ])$/.test(this.installFolder))
         {
            throw new Error("invalid install folder");
         }
         if(this.programMenuFolder != "" && !/^([^\*\"\/:<>\?\\\|\. ]|[^\*\"\/:<>\?\\\| ][^\*\":<>\?\\\|]*[^\*\":<>\?\\\|\. ])$/.test(this.programMenuFolder))
         {
            throw new Error("invalid program menu folder");
         }
         if(["",NativeWindowSystemChrome.NONE,NativeWindowSystemChrome.STANDARD].indexOf(this.m_xml.initialWindow.systemChrome.toString()) == -1)
         {
            throw new Error("Illegal value \"" + this.m_xml.initialWindow.systemChrome.toString() + "\" for application/initialWindow/systemChrome.");
         }
         if(["","true","false","1","0"].indexOf(this.m_xml.initialWindow.transparent.toString()) == -1)
         {
            throw new Error("Illegal value \"" + this.m_xml.initialWindow.transparent.toString() + "\" for application/initialWindow/transparent.");
         }
         if(["","true","false","1","0"].indexOf(this.m_xml.initialWindow.visible.toString()) == -1)
         {
            throw new Error("Illegal value \"" + this.m_xml.initialWindow.visible.toString() + "\" for application/initialWindow/visible.");
         }
         if(["","true","false","1","0"].indexOf(this.m_xml.initialWindow.minimizable.toString()) == -1)
         {
            throw new Error("Illegal value \"" + this.m_xml.initialWindow.minimizable.toString() + "\" for application/initialWindow/minimizable.");
         }
         if(["","true","false","1","0"].indexOf(this.m_xml.initialWindow.maximizable.toString()) == -1)
         {
            throw new Error("Illegal value \"" + this.m_xml.initialWindow.maximizable.toString() + "\" for application/initialWindow/maximizable.");
         }
         if(["","true","false","1","0"].indexOf(this.m_xml.initialWindow.resizable.toString()) == -1)
         {
            throw new Error("Illegal value \"" + this.m_xml.initialWindow.resizable.toString() + "\" for application/initialWindow/resizeable.");
         }
         if(["","true","false","1","0"].indexOf(this.m_xml.initialWindow.closeable.toString()) == -1)
         {
            throw new Error("Illegal value \"" + this.m_xml.initialWindow.closeable.toString() + "\" for application/initialWindow/closeable.");
         }
         if(this.initialWindowTransparent && this.initialWindowSystemChrome != NativeWindowSystemChrome.NONE)
         {
            throw new Error("Illegal window settings.  Transparent windows are only supported when systemChrome is set to \"none\".");
         }
         if(!validateDimension(this.m_xml.initialWindow.width.toString()))
         {
            throw new Error("Illegal value \"" + this.m_xml.initialWindow.width.toString() + "\" for application/initialWindow/width.");
         }
         if(!validateDimension(this.m_xml.initialWindow.height.toString()))
         {
            throw new Error("Illegal value \"" + this.m_xml.initialWindow.height.toString() + "\" for application/initialWindow/height.");
         }
         if(!validateLocation(this.m_xml.initialWindow.x.toString()))
         {
            throw new Error("Illegal value \"" + this.m_xml.initialWindow.x.toString() + "\" for application/initialWindow/x.");
         }
         if(!validateLocation(this.m_xml.initialWindow.y.toString()))
         {
            throw new Error("Illegal value \"" + this.m_xml.initialWindow.y.toString() + "\" for application/initialWindow/y.");
         }
         if(!validateDimensionPair(this.m_xml.initialWindow.minSize.toString()))
         {
            throw new Error("Illegal value \"" + this.m_xml.initialWindow.minSize.toString() + "\" for application/initialWindow/minSize.");
         }
         if(!validateDimensionPair(this.m_xml.initialWindow.maxSize.toString()))
         {
            throw new Error("Illegal value \"" + this.m_xml.initialWindow.maxSize.toString() + "\" for application/initialWindow/maxSize.");
         }
         if(!validateLocalizedText(this.m_xml.name,this.m_defaultNs))
         {
            throw new Error("Illegal values for application/name.");
         }
         if(!validateLocalizedText(this.m_xml.description,this.m_defaultNs))
         {
            throw new Error("Illegal values for application/description.");
         }
         if(!/^[A-Za-z0-9\-\.]{1,212}$/.test(this.id))
         {
            throw new Error("invalid application identifier");
         }
      }
      
      public function get version() : String
      {
         default xml namespace = this.m_defaultNs;
         if(this.m_xml.version == undefined && this.m_xml.versionNumber == undefined)
         {
            throw new Error("cannot get version (backwards incompatible application namespace change?)");
         }
         if(this.m_xml.version == undefined)
         {
            return this.m_xml.versionNumber.toString();
         }
         return this.m_xml.version.toString();
      }
      
      public function get namespace() : Namespace
      {
         default xml namespace = this.m_defaultNs;
         return this.m_xml.namespace();
      }
      
      public function get fileTypes() : XMLList
      {
         default xml namespace = this.m_defaultNs;
         return this.m_xml.fileTypes.elements();
      }
      
      public function get initialWindowCloseable() : Boolean
      {
         default xml namespace = this.m_defaultNs;
         return this.stringToBoolean_defaultTrue(this.m_xml.initialWindow.closeable.toString());
      }
      
      public function get initialWindowMaximizable() : Boolean
      {
         default xml namespace = this.m_defaultNs;
         return this.stringToBoolean_defaultTrue(this.m_xml.initialWindow.maximizable.toString());
      }
      
      public function get programMenuFolder() : String
      {
         default xml namespace = this.m_defaultNs;
         return this.m_xml.programMenuFolder.toString();
      }
      
      public function get initialWindowHeight() : Number
      {
         default xml namespace = this.m_defaultNs;
         return convertDimension(this.m_xml.initialWindow.height.toString());
      }
      
      public function get initialWindowTitle() : String
      {
         default xml namespace = this.m_defaultNs;
         var result:String = this.m_xml.initialWindow.title.toString();
         if(result == "")
         {
            result = this.name;
         }
         return result;
      }
      
      private function stringToBoolean_defaultFalse(str:String) : Boolean
      {
         default xml namespace = this.m_defaultNs;
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
      
      public function hasCustomUpdateUI() : Boolean
      {
         default xml namespace = this.m_defaultNs;
         return this.stringToBoolean_defaultFalse(this.m_xml.customUpdateUI.toString());
      }
      
      public function get installFolder() : String
      {
         default xml namespace = this.m_defaultNs;
         return this.m_xml.installFolder.toString();
      }
      
      public function get id() : String
      {
         default xml namespace = this.m_defaultNs;
         return this.m_xml.id.toString();
      }
      
      public function get initialWindowTransparent() : Boolean
      {
         default xml namespace = this.m_defaultNs;
         return this.stringToBoolean_defaultFalse(this.m_xml.initialWindow.transparent.toString());
      }
      
      public function getIcon(size:String) : String
      {
         default xml namespace = this.m_defaultNs;
         return this.m_xml.icon.elements(new QName(this.m_defaultNs,size)).toString();
      }
      
      public function get initialWindowResizable() : Boolean
      {
         default xml namespace = this.m_defaultNs;
         return this.stringToBoolean_defaultTrue(this.m_xml.initialWindow.resizable.toString());
      }
      
      public function get versionLabel() : String
      {
         default xml namespace = this.m_defaultNs;
         if(this.m_xml.nsversion == undefined && this.m_xml.versionNumber == undefined)
         {
            throw new Error("cannot get version (backwards incompatible application namespace change?)");
         }
         if(this.m_xml.version != undefined)
         {
            return this.m_xml.version.toString();
         }
         return this.m_xml.versionLabel == undefined ? this.m_xml.versionNumber.toString() : this.m_xml.versionLabel.toString();
      }
      
      public function get initialWindowSystemChrome() : String
      {
         default xml namespace = this.m_defaultNs;
         var systemChromeString:String = this.m_xml.initialWindow.systemChrome.toString();
         var result:String = NativeWindowSystemChrome.STANDARD;
         switch(systemChromeString)
         {
            case NativeWindowSystemChrome.STANDARD:
            case NativeWindowSystemChrome.NONE:
               result = systemChromeString;
         }
         return result;
      }
      
      public function get initialWindowVisible() : Boolean
      {
         default xml namespace = this.m_defaultNs;
         return this.stringToBoolean_defaultFalse(this.m_xml.initialWindow.visible.toString());
      }
      
      public function get initialWindowMinSize() : Point
      {
         default xml namespace = this.m_defaultNs;
         return convertDimensionPoint(this.m_xml.initialWindow.minSize.toString());
      }
   }
}

